#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h> 
#include <math.h> 

#define N (1024*1024)

// �������� ���� ����������� �� GPU � ������ ������� �� CPU
__global__ void sinSquareRootX(float* dA)
{
    // ���������� ����� ���� � ����, �� ���� ����� ������� �������� �������
    int idx = blockDim.x * blockIdx.x + threadIdx.x;
    // ���������� ������� ��� ������� ��������
    float x = 2.0f * 3.1415926f * (float)idx / (float)N;
    dA[idx] = sinf(sqrtf(x));
    // ������ ����� ��������� ���������� �������� � ���� ������ ������
}
 
// ������� ����������� �� host 
int main(int argc, char* argv[])
{
    //��������� ��� ���������� ���������� h = Host
    float* hA;
    //��������� ��� ������� ������ �� ���������� d = Device
    float* dA;
    // ��������� ������ �� host
    hA = (float*)malloc(N * sizeof(float));
    // ��������� ������ �� device
    cudaMalloc((void**)&dA, N * sizeof(float)); 
    // ����� ������� ���� GPU � �������� ����������� ������ � ����������� ����� � �����
    sinSquareRootX <<< N / 512, 512 >>> (dA);
    // ������������ ������ �� GPU �� CPU
    cudaMemcpy(hA, dA, N * sizeof(float), cudaMemcpyDeviceToHost);
    //���������� �������� � ���������
    for (int idx = 0; idx < N; idx++) {
        printf("a[%d] = %.5f\n", idx, hA[idx]);
    }
    // ����������� ������ �� host � device
    free(hA);
    cudaFree(dA);
    return 0;
}

