# CMake installs the bindings without Python distribution metadata. Keep this
# independent of the target interpreter so it also works when cross compiling.
if(NOT DEFINED USDEX_PACKAGE_VERSION OR "$ENV{SP_DIR}" STREQUAL "")
    message(FATAL_ERROR "USDEX_PACKAGE_VERSION and SP_DIR are required")
endif()
file(TO_CMAKE_PATH "$ENV{SP_DIR}" _site_packages)
set(_dist_info "${_site_packages}/usd_exchange-${USDEX_PACKAGE_VERSION}.dist-info")
file(MAKE_DIRECTORY "${_dist_info}")
file(WRITE "${_dist_info}/METADATA"
"Metadata-Version: 2.1\nName: usd-exchange\nVersion: ${USDEX_PACKAGE_VERSION}\nSummary: OpenUSD Exchange SDK\nHome-page: https://github.com/NVIDIA-Omniverse/usd-exchange\nLicense: Apache-2.0\n\n")
file(WRITE "${_dist_info}/INSTALLER" "conda\n")
# Conda owns file tracking; omit RECORD so pip does not uninstall these files.
