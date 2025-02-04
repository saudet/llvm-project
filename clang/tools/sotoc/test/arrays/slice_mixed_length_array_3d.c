// RUN: %sotoc-transform-compile
// RUN: %run-on-host | %filecheck %s

#include <stdio.h>

int main(){
  int j;
  int sizeX=512;
  int sizeY=512;
  int sizeZ = 4;
  float A[512][512][4];

  #pragma omp target map(tofrom:A[:sizeX][:sizeY][:2])
  {
    int i;
    int j;
    int k;
    for(i=0; i< sizeX; i++){
      for(j=0 ; j< sizeY-1; j++){
        for(k=0; k < (sizeZ - 3); ++k) {
          A[i][j][k]=i-j;
        }
      }
    }
  }

  for (j = 0; j < sizeX; j+=64) {
    printf("%.2f ",A[j][j][0]);
  }

  printf("%.2f ",A[0][1][0]);

  return 0;
}

// CHECK: 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 -1.00
