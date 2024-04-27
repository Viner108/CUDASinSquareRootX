#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "kernel.h" // ¬ключаем заголовочный файл с объ€влением функции

#define N (1024*1024)

// функци€ выполн€ема€ на host 
int main(int argc, char* argv[])
{
    //указатель дл€ сохранени€ результата h = Host
    float* hA;

    //указатель дл€ массива данных на видеокарте d = Device
    float* dA;

    // выделение пам€ти на host
    hA = (float*)malloc(N * sizeof(float));

    // выделение пам€ти на device и проверка на ошибки
    cudaError_t err;
    err = cudaMalloc((void**)&dA, N * sizeof(float));
    if (err != cudaSuccess) {
        fprintf(stderr, "Cannot allocate GPU memory: &s\n", cudaGetErrorString(err));
        return 1;
    }

    // вызов функции €дра GPU с заданным количеством блоков и количеством нитей в блоке
    sinSquareRootX <<< N / 512, 512 >>> (dA);
    //cudaDeviceSynchronize();
    err = cudaGetLastError();
    if (err != cudaSuccess) {
    fprintf(stderr, "Cannot launch CUDA kernel: %s\n", cudaGetErrorString(err));
    return 1;
    }


    // копированние данных из GPU на CPU и проверка на ошибки
    err = cudaMemcpy(hA, dA, N * sizeof(float), cudaMemcpyDeviceToHost);
    if (err != cudaSuccess) {
        fprintf(stderr, "Cannot copy data device/host : &s\n", cudaGetErrorString(err));
        return 1;
    }

    //распечатка значений в терминале
    for (int idx = 0; idx < N; idx++) {
        printf("a[%d] = %.5f\n", idx, hA[idx]);
    }

    // освобожение пам€ти на host и device
    free(hA);
    cudaFree(dA);

    return 0;
}
