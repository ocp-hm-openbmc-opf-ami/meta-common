/*
// Copyright (c) 2022 Intel Corporation
//
// This software and the related documents are Intel copyrighted
// materials, and your use of them is governed by the express license
// under which they were provided to you ("License"). Unless the
// License provides otherwise, you may not use, modify, copy, publish,
// distribute, disclose or transmit this software or the related
// documents without Intel's prior written permission.
//
// This software and the related documents are provided as is, with no
// express or implied warranties, other than those that are expressly
// stated in the License.
*/
#include <unistd.h>

#include <boost/asio/io_service.hpp>
#include <boost/asio/steady_timer.hpp>
#include <boost/container/flat_map.hpp>
#include <boost/date_time/posix_time/posix_time.hpp>
#include <boost/process.hpp>
#include <iostream>
#include <phosphor-logging/lg2.hpp>
#include <sdbusplus/asio/connection.hpp>
#include <variant>

using DbusVariant = std::variant<std::string, bool, uint8_t, uint16_t, int16_t,
                                 uint32_t, int32_t, uint64_t, int64_t, double>;
using ObjectType = boost::container::flat_map<
    std::string, boost::container::flat_map<std::string, DbusVariant>>;
using ManagedObjectType =
    boost::container::flat_map<sdbusplus::message::object_path, ObjectType>;
static boost::asio::io_service io;
auto conn = std::make_shared<sdbusplus::asio::connection>(io);
constexpr int waitTime = 5;

void checkFRU(uint64_t &fruBus, uint64_t &fruAddress, uint64_t &macFruOffset,
              boost::asio::steady_timer &timer)
{
    // GetAll the objects under service FruDevice
    conn->async_method_call(
        [&fruBus, &fruAddress, &macFruOffset,
         &timer](boost::system::error_code &ec,
                 const ManagedObjectType &managedObj) {
            if (ec)
            {
                lg2::error("Error calling entity manager");
                timer.expires_from_now(std::chrono::seconds(waitTime));
                timer.async_wait([&](const boost::system::error_code &ec) {
                    if (ec)
                    {
                        lg2::error("Line: {LINE} - Error restarting FRU check.",
                                   "LINE", __LINE__);
                        return;
                    }
                    checkFRU(fruBus, fruAddress, macFruOffset, timer);
                });
                return;
            }
            bool foundIntf = false;
            for (const auto &[path, fru] : managedObj)
            {
                for (const auto &[intf, propMap] : fru)
                {
                    if (intf ==
                        "xyz.openbmc_project.Inventory.Item.Board.Motherboard")
                    {
                        foundIntf = true;
                        auto findBus = propMap.find("FruBus");
                        if (findBus == propMap.end() ||
                            !std::get_if<uint64_t>(&findBus->second))
                            break;
                        auto findAddress = propMap.find("FruAddress");
                        if (findAddress == propMap.end() ||
                            !std::get_if<uint64_t>(&findAddress->second))
                            break;
                        auto findMacOffset = propMap.find("MacOffset");
                        if (findMacOffset == propMap.end() ||
                            !std::get_if<uint64_t>(&findMacOffset->second))
                            break;
                        fruBus = *(std::get_if<uint64_t>(&findBus->second));
                        fruAddress =
                            *(std::get_if<uint64_t>(&findAddress->second));
                        macFruOffset =
                            *(std::get_if<uint64_t>(&findMacOffset->second));
                        std::stringstream cmd;
                        cmd << "/usr/bin/mac-check -b " << fruBus << " -a"
                            << fruAddress << " -o" << macFruOffset;
                        boost::process::system(cmd.str());
                        break;
                    }
                }
                if (foundIntf)
                    break;
            }
            if (!foundIntf)
            {
                timer.expires_from_now(std::chrono::seconds(waitTime));
                timer.async_wait([&](const boost::system::error_code &ec) {
                    if (ec)
                    {
                        lg2::error("Line: {LINE} - Error restarting FRU check.",
                                   "LINE", __LINE__);
                        return;
                    }
                    checkFRU(fruBus, fruAddress, macFruOffset, timer);
                });
            }
            else
            {
                // If we have found the Motherboard interface, then we have
                // either re-run mac-check and are done, or we failed to find
                // the bus/addr/offset, so this platform does not have a DC-SCM
                // FRU.
                io.stop();
            }
        },
        "xyz.openbmc_project.EntityManager", "/xyz/openbmc_project/inventory",
        "org.freedesktop.DBus.ObjectManager", "GetManagedObjects");
}
int main()
{
    uint64_t fruBus = 0;
    uint64_t fruAddress = 0;
    uint64_t macFruOffset = 0;
    boost::process::system("/usr/bin/mac-check");
    boost::asio::steady_timer timer(io);
    timer.expires_after(std::chrono::seconds(waitTime));
    io.post([&]() { checkFRU(fruBus, fruAddress, macFruOffset, timer); });
    io.run();
    return 0;
}
