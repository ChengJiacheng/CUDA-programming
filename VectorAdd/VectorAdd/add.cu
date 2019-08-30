#include <stdio.h>

#define SIZE	1024


//__global__ 告诉编译器这个函数将在GPU上执行
__global__ void VectorAdd(int *a, int *b, int *c, int n)
{
	int i = threadIdx.x;

	if (i < n)
		c[i] = a[i] + b[i];
}

//void  VectorAdd(int *a, int *b, int *c, int n)
//{
//	int i;
//	for (i = 0; i < n; ++i)
//		c[i] = a[i] + b[i];
//}

//int main()
//{
//	//定义指针
//	int *a, *b, *c;
//
//	//为指针分配内存空间
//	a = (int *)malloc(SIZE * sizeof(int));
//	b = (int *)malloc(SIZE * sizeof(int));
//	c = (int *)malloc(SIZE * sizeof(int));
//
//	for (int i = 0; i < SIZE; ++i)
//	{
//		a[i] = i;
//		b[i] = i;
//		c[i] = 0;
//	}
//
//	VectorAdd(a, b, c, SIZE);
//	for (int i = 0; i < 10; ++i)
//		printf("c[%d] = %d\n", i, c[i]);
//
//	free(a);
//	free(b);
//	free(c);
//
//}

int main()
{
	int *a, *b, *c;
	int *d_a, *d_b, *d_c;

	a = (int *)malloc(SIZE * sizeof(int));
	b = (int *)malloc(SIZE * sizeof(int));
	c = (int *)malloc(SIZE * sizeof(int));

	//d_a：一个指针型变量，他的值是一个地址变量，； &d_a： d_a的地址（指针的指针）; *d_a: 返回地址d_a处的变量
	cudaMalloc(&d_a, SIZE * sizeof(int));
	cudaMalloc(&d_b, SIZE * sizeof(int));
	cudaMalloc(&d_c, SIZE * sizeof(int));

	for (int i = 0; i < SIZE; ++i)
	{
		a[i] = i;
		b[i] = i;
		c[i] = 0;
	}

	cudaMemcpy(d_a, a, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, SIZE * sizeof(int), cudaMemcpyHostToDevice);
	cudaMemcpy(d_c, c, SIZE * sizeof(int), cudaMemcpyHostToDevice);

	VectorAdd << < 1, SIZE >> > (d_a, d_b, d_c, SIZE);

	cudaMemcpy(c, d_c, SIZE * sizeof(int), cudaMemcpyDeviceToHost);

	for (int i = 0; i < 10; ++i)
		printf("c[%d] = %d\n", i, c[i]);

	free(a);
	free(b);
	free(c);

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	printf("123\n");

	return 0;
}