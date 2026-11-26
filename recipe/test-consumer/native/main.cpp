#include <usdex/core/Core.h>
#include <usdex/rtx/MaterialAlgo.h>
#include <cstring>

int main()
{
    return std::strcmp(usdex::core::version(), "3.0.1");
}
