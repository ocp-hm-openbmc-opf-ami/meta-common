#include <boost/asio.hpp>
#include <phosphor-logging/log.hpp>
#include <sdbusplus/asio/connection.hpp>
#include <sdbusplus/asio/object_server.hpp>
#include <sdbusplus/asio/sd_event.hpp>
#include <sdbusplus/bus.hpp>
#include <sdbusplus/exception.hpp>
#include <sdbusplus/sdbus.hpp>
#include <sdbusplus/server.hpp>

#include <fstream>
#include <iostream>

constexpr const char* partBootFlagfile = "/var/cache/private/PartitionBootFlag";
bool getPartitionBootFlag(void)
{
    std::fstream partbootflagfile;
    partbootflagfile.open(partBootFlagfile);
    if (partbootflagfile.is_open())
    {
        phosphor::logging::log<phosphor::logging::level::INFO>(
            "Partition boot flag: true");
        partbootflagfile.close();
        return true;
    }
    else
    {
        phosphor::logging::log<phosphor::logging::level::INFO>(
            "Partition boot flag: false");
        return false;
    }
}

int main()
{
    boost::asio::io_context io;
    auto conn = std::make_shared<sdbusplus::asio::connection>(io);
    conn->request_name("xyz.openbmc_project.PartitionBoot");
    auto server = std::make_shared<sdbusplus::asio::object_server>(conn, true);
    server->add_manager("/xyz/openbmc_project/partitionboot");

    std::shared_ptr<sdbusplus::asio::dbus_interface> iface =
        server->add_interface("/xyz/openbmc_project/partitionboot",
                              "xyz.openbmc_project.PartitionBoot");
    iface->register_property("Enabled", getPartitionBootFlag(),
		    sdbusplus::asio::PropertyPermission::readOnly);
    iface->initialize();
    io.run();
    return (1);
}
