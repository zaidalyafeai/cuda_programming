#include<stdio.h>
#define R 4
#define C 4

__global__ void addMat(int *d){
  int r = threadIdx.x + blockDim.x * blockIdx.x;
  int c = threadIdx.y + blockDim.y * blockIdx.y;

  printf("(%d, %d) \n", r, c);
  if (r<R && c<C){
    d[r*R+c] = 2 * d[r*R+c]; 
  } 
}

int main(){

  int *h;
  int *d;
  int i, j;

  h = (int*)malloc(R*C*sizeof(int));

  for(i=0 ; i < R; i++){
    for(j=0 ; j < C; j++){
      h[i*R+j] = i * j;
    }
  }

  for(i=0 ; i < R; i++){
    for(j=0 ; j < C; j++){
      printf("%d ", h[i*R+j]);
    }
    printf("\n");
  }

  if(cudaMalloc(&d, R*C*sizeof(int)) != cudaSuccess){
    printf("Cuda Allocation FAiled");
  }
  if(cudaMemcpy(d, h, R*C*sizeof(int), cudaMemcpyHostToDevice) != cudaSuccess){
    printf("Cuda Copying Failed");
  };

  dim3 blocks(2,2);
  dim3 threads(2,2);

  addMat<<<blocks, threads>>>(d);

  if(cudaMemcpy(h, d, R*C*sizeof(int), cudaMemcpyDeviceToHost) != cudaSuccess){
    printf("Cuda Copying Failed here \n");
  };

  for(i=0 ; i < R; i++){
    for(j=0 ; j < C; j++){
      printf("%d ", h[i*R+j]);
    }
    printf("\n");
  }
}