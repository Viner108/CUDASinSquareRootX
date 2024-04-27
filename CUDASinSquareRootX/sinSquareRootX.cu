#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h> 
#include <math.h> 

#define N (1024*1024)

// фунцкция ядра выполняемая на GPU и множно вызвать из CPU
__global__ void sinSquareRootX(float* dA)
{
    // глобальный номер нити в сети, то есть номер индекса элемента массива
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    // вычисление функции для каждого элемента
    float x = 2.0f * 3.1415926f * (float)idx / (float)N;
    dA[idx] = sinf(sqrtf(x));
    // каждый поток сохраняет полученное значение в свою ячейку памяти
}
 
// функция выполняемая на host 
int main(int argc, char* argv[])
{
    //указатель для сохранения результата h = Host
    float* hA;
    //указатель для массива данных на видеокарте d = Device
    float* dA;
    // выделение памяти на host
    hA = (float*)malloc(N * sizeof(float));
    // выделение памяти на device
    cudaMalloc((void**)&dA, N * sizeof(float)); 
    // вызов функции ядра GPU с заданным количеством блоков и количеством нитей в блоке
    sinSquareRootX <<< N / 512, 512 >>> (dA);
    // копированние данных из GPU на CPU
    cudaMemcpy(hA, dA, N * sizeof(float), cudaMemcpyDeviceToHost);
    //распечатка значений в терминале
    for (int idx = 0; idx < N; idx++) {
        printf("a[%d] = %.5f\n", idx, hA[idx]);
    }
    // освобожение памяти на host и device
    free(hA);
    cudaFree(dA);
    return 0;
}

