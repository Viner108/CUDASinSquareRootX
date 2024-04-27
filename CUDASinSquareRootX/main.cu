#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "kernel.h" // �������� ������������ ���� � ����������� �������

#define N (1024*1024)

// ������� ����������� �� host 
int main(int argc, char* argv[])
{
    //��������� ��� ���������� ���������� h = Host
    float* hA;

    //��������� ��� ������� ������ �� ���������� d = Device
    float* dA;

    // ��������� ������ �� host
    hA = (float*)malloc(N * sizeof(float));

    // ��������� ������ �� device � �������� �� ������
    cudaError_t err;
    err = cudaMalloc((void**)&dA, N * sizeof(float));
    if (err != cudaSuccess) {
        fprintf(stderr, "Cannot allocate GPU memory: &s\n", cudaGetErrorString(err));
        return 1;
    }

    // ����� ������� ���� GPU � �������� ����������� ������ � ����������� ����� � �����
    sinSquareRootX <<< N / 512, 512 >>> (dA);
    //cudaDeviceSynchronize();
    err = cudaGetLastError();
    if (err != cudaSuccess) {
    fprintf(stderr, "Cannot launch CUDA kernel: %s\n", cudaGetErrorString(err));
    return 1;
    }


    // ������������ ������ �� GPU �� CPU � �������� �� ������
    err = cudaMemcpy(hA, dA, N * sizeof(float), cudaMemcpyDeviceToHost);
    if (err != cudaSuccess) {
        fprintf(stderr, "Cannot copy data device/host : &s\n", cudaGetErrorString(err));
        return 1;
    }

    //���������� �������� � ���������
    for (int idx = 0; idx < N; idx++) {
        printf("a[%d] = %.5f\n", idx, hA[idx]);
    }

    // ����������� ������ �� host � device
    free(hA);
    cudaFree(dA);

    return 0;
}
