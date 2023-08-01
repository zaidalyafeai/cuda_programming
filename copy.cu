#include <iostream>
#include <stdio.h>
#include <unistd.h>
#include <stdio.h>
#define DSIZE 5

__global__ void Print(int *A)
{
    printf("Printing from GPU\n");
    for(int i=0;i<DSIZE;i++) 
      printf("d_A[%d]=%d\n",i,A[i]);
}
int main()
{
    int *d_A, *h_A, *h_B;
    int i;

    h_A=(int*)malloc(DSIZE*sizeof(int));
    h_B=(int*)malloc(DSIZE*sizeof(int));

    for(i=0;i<DSIZE;i++) 
      h_A[i]=i;
    
    //copy from host to device
    cudaMalloc((int**)&d_A,DSIZE*sizeof(int));
    cudaMemcpy(d_A,h_A,DSIZE*sizeof(int), cudaMemcpyHostToDevice);

    Print<<<1,1>>>(d_A);

    //copy from device to host
    cudaMemcpy(h_B,d_A,DSIZE*sizeof(int),cudaMemcpyDeviceToHost);

    printf("Printing from CPU\n");
    for(i=0;i<DSIZE;i++) 
      printf("h_B[%d]=%d\n",i,h_B[i]);
      
    cudaFree(d_A); \
    cudaDeviceReset();
    return 0;
}