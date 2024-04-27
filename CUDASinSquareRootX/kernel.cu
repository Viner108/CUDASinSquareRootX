#include "kernel.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h>
#define N (1024*1024)

__global__ void sinSquareRootX(float* dA)
{
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    float x = 2.0f * 3.1415926f * (float)idx / (float)N;
    dA[idx] = sinf(sqrtf(x));
}
