cmake_minimum_required(VERSION 4.1)
project(yaml-tool)

set(CMAKE_CXX_STANDARD 17)
# debug版本导出库带d后缀
set(CMAKE_DEBUG_POSTFIX d)

option(YAML_TOOL_BUILD_SHARED_LIBS "Build yaml-tool shared library" ON)
option(YAML_TOOL_INSTALL "Install yaml-tool" ON)

if (YAML_TOOL_BUILD_SHARED_LIBS)
    set(yaml-tool-type SHARED)
    set(yaml-tool-label-postfix "shared")
else()
    set(yaml-tool-type STATIC)
    set(yaml-tool-label-postfix "static")
endif()

add_library(yaml-tool ${yaml-tool-type} "")

# 只有动态库的时候才需要导出宏
if(YAML_TOOL_BUILD_SHARED_LIBS)
target_compile_definitions(yaml-tool
        PRIVATE YAML_TOOL_BUILDING_LIBRARY
) # 定义导出宏
endif ()

file(GLOB_RECURSE srcs CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.hpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")

file(GLOB_RECURSE srcs_p CONFIGURE_DEPENDS
        "${CMAKE_CURRENT_SOURCE_DIR}/private/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/private/*.h")

target_sources(yaml-tool PRIVATE ${srcs} ${srcs_p})

target_include_directories(yaml-tool
        PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
)
target_include_directories(yaml-tool PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/private)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/3rd.cmake)

# 链接第三方库
# 这里用PRIVATE明确私有化
target_link_libraries(yaml-tool PRIVATE yaml-cpp)

set_target_properties(yaml-tool
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)


# 发布/安装脚本
if(YAML_TOOL_INSTALL)
install(TARGETS yaml-tool
        EXPORT yaml-toolTargets
        RUNTIME DESTINATION bin      # Windows DLL
        LIBRARY DESTINATION lib      # .so / .dylib
        ARCHIVE DESTINATION lib      # static lib / import lib
)
install(
        DIRECTORY include/
        DESTINATION include
)

# 生成Config文件，确保调用方可以使用find_package
install(EXPORT yaml-toolTargets
        FILE yaml-toolTargets.cmake
        NAMESPACE yaml-tool::
        DESTINATION lib/cmake/yaml-tool
)

# 如果第三方库导出作为动态库，那么install的时候需要附带
#install(TARGETS yaml-cpp
#        EXPORT yaml-toolTargets
#)
endif()



