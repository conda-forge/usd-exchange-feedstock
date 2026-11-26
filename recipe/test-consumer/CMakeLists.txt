cmake_minimum_required(VERSION 3.20)
project(usdex_consumer LANGUAGES CXX)
enable_testing()
# Exercise package discovery from sibling scopes, and both native/Python hosts.
add_subdirectory(native)
add_subdirectory(plugin)
