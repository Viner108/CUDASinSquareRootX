#include "cuda_runtime.h"
#ifndef KERNEL_H
#define KERNEL_H

// Объявление функции sinSquareRootX как ядра CUDA
__global__ void sinSquareRootX(float* dA);

#endif // KERNEL_H