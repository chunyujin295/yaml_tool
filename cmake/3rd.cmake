# YamlCpp
# 设置导出静态库，这样install脚本中不需要顺带发布
set(YAML_BUILD_SHARED_LIBS OFF CACHE BOOL "yamlCpp Build Shared Lib" FORCE) # 覆盖YAML的Option，生成静态库

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/3rd/yaml-cpp-0.8.0)

set_target_properties(yaml-cpp
        PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
        ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)