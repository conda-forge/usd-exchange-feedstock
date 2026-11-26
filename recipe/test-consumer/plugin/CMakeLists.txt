find_package(usdex 3.0.1 REQUIRED)
find_package(Python3 REQUIRED COMPONENTS Interpreter Development.Module)
Python3_add_library(consumer_plugin MODULE WITH_SOABI plugin.cpp)
target_link_libraries(consumer_plugin PRIVATE usdex::core usdex::rtx)
add_test(NAME python-consumer
    COMMAND ${Python3_EXECUTABLE} -c
    "import sys; sys.path.insert(0, r'$<TARGET_FILE_DIR:consumer_plugin>'); import consumer_plugin; assert consumer_plugin.version() == '3.0.1'")
