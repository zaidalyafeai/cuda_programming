#include<stdio.h>
#define N 10000

__global__ void add(float *a, float *w , float *z){
  int i;

  for (i=0 ; i < N; i++){
    a[i] = w[i] + z[i];
  }
}

int main(){
  float *x, *y;
  float *w, *z;
  float *a;
  float *b;

  int i;

  x = (float*)malloc(sizeof(float)*N);
  y = (float*)malloc(sizeof(float)*N);
  b = (float*)malloc(sizeof(float)*N);

  for (i=0 ; i < N; i++)
    x[i] = i;
  
  for (i=0 ; i < N; i++)
    y[i] = 2 * i;

  cudaMalloc((float**)&w, sizeof(float)*N);
  cudaMemcpy(w, x, sizeof(float)*N, cudaMemcpyHostToDevice);

  cudaMalloc((float**)&z, sizeof(float)*N);
  cudaMemcpy(z, y, sizeof(float)*N, cudaMemcpyHostToDevice);

  cudaMalloc((float**)&a, sizeof(float)*N);

  add<<<1,1>>>(a, w, z);
  cudaMemcpy(b, a, sizeof(float)*N, cudaMemcpyDeviceToHost);

  // for (i=0 ; i < N; i++)
  //   printf("b = %f \n", b[i]);

  return 0;

}