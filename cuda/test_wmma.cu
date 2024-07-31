#include <cuda_runtime.h>
#include <mma.h>
#include <cuda_fp16.h>
#include <iostream>

using namespace nvcuda;

const int WIDTH = 64;
const int HEIGHT = 4096;

// CUDA核函数，使用wmma进行矩阵加法
__global__ void add_images(const half* base_image, const half* noise_image, half* output_image) {
    // 定义wmma矩阵片段
    wmma::fragment<wmma::matrix_a, 16, 16, 16, half, wmma::row_major> a_frag;
    wmma::fragment<wmma::matrix_b, 16, 16, 16, half, wmma::row_major> b_frag;
    wmma::fragment<wmma::accumulator, 16, 16, 16, half> c_frag;

    // 加载矩阵片段
    wmma::load_matrix_sync(a_frag, base_image, WIDTH);
    wmma::load_matrix_sync(b_frag, noise_image, WIDTH);
    wmma::fill_fragment(c_frag, 0.0f);

    // 进行矩阵加法
    wmma::mma_sync(c_frag, a_frag, b_frag, c_frag);

    // 将结果存储回全局内存
    wmma::store_matrix_sync(output_image, c_frag, WIDTH, wmma::mem_row_major);
}

int main() {
    // 分配主机和设备内存
    half* h_base_image;
    half* h_noise_image;
    half* h_output_image;

    half* d_base_image;
    half* d_noise_image;
    half* d_output_image;

    size_t image_size = WIDTH * HEIGHT * sizeof(half);

    cudaMallocHost(&h_base_image, image_size);
    cudaMallocHost(&h_noise_image, image_size);
    cudaMallocHost(&h_output_image, image_size);

    cudaMalloc(&d_base_image, image_size);
    cudaMalloc(&d_noise_image, image_size);
    cudaMalloc(&d_output_image, image_size);

    // 初始化图像数据
    for (int i = 0; i < WIDTH * HEIGHT; ++i) {
        h_base_image[i] = __float2half(static_cast<float>(rand()) / RAND_MAX);
        h_noise_image[i] = __float2half(static_cast<float>(rand()) / RAND_MAX);
    }

    // 复制数据到设备
    cudaMemcpy(d_base_image, h_base_image, image_size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_noise_image, h_noise_image, image_size, cudaMemcpyHostToDevice);

    // 创建CUDA事件
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // 启动CUDA事件记录
    cudaEventRecord(start);

    // 启动CUDA核函数
    dim3 blockDim(16, 16);
    dim3 gridDim((WIDTH + blockDim.x - 1) / blockDim.x, (HEIGHT + blockDim.y - 1) / blockDim.y);
    add_images<<<gridDim, blockDim>>>(d_base_image, d_noise_image, d_output_image);

    // 停止CUDA事件记录
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    // 计算时间差
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    // 计算每秒帧数
    float fps = 1000.0f / milliseconds; // 每秒处理的帧数
    std::cout << "Processed at " << fps << " frames per second." << std::endl;

    // 清理内存
    cudaFreeHost(h_base_image);
    cudaFreeHost(h_noise_image);
    cudaFreeHost(h_output_image);
    cudaFree(d_base_image);
    cudaFree(d_noise_image);
    cudaFree(d_output_image);

    // 销毁CUDA事件
    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
