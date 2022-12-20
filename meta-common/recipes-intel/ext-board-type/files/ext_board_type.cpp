/*
// Copyright (c) 2021-2022 Intel Corporation
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

#include <filesystem>
#include <fstream>
#include <sdbusplus/asio/object_server.hpp>
#include <string>
#include <unordered_map>

static std::unordered_map<std::string, std::string> fileDirectory = {
    {"/var/cache/private/PartitionBootFlag", "partition"},
    {"/var/cache/private/R1SPresentFlag", "R1S"}};

const std::string& getExtBoardType()
{

    static const std::string noneStr = "none";
    
    for (const auto& file : fileDirectory)
    {
        if (std::filesystem::exists(file.first))
        {
            return file.second;
        }
    }
    return noneStr;
}

int main()
{
    constexpr const char* extBoardTypeService =
        "com.intel.extBoardType";
    constexpr const char* extBoardTypePath = "/com/intel/extBoardType";
    constexpr const char* extBoardTypeIntf = "com.intel.extBoardType";

    auto ioc = std::make_shared<boost::asio::io_context>();
    auto connection = std::make_shared<sdbusplus::asio::connection>(*ioc);
    auto objectServer =
        std::make_shared<sdbusplus::asio::object_server>(connection);
    connection->request_name(extBoardTypeService);

    auto objManager = std::make_shared<sdbusplus::server::manager::manager>(
        *connection, extBoardTypePath);

    auto extBoardTypeInterface =
        objectServer->add_unique_interface(extBoardTypePath, extBoardTypeIntf);

    extBoardTypeInterface->register_property_r(
        "extBoardType", getExtBoardType(), sdbusplus::vtable::property_::const_,
        [](const auto& r) { return r; });

    extBoardTypeInterface->initialize();

    ioc->run();
    return 0;
}
