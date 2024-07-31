#include <cublas_v2.h>
#include <cuda_runtime.h>
#include <iostream>

const int WIDTH = 64;
const int HEIGHT = 4096;

// 检查CUDA错误
#define CHECK_CUDA(call) \
    do { \
        cudaError_t err = call; \
        if (err != cudaSuccess) { \
            std::cerr << "CUDA error at " << __FILE__ << ":" << __LINE__ << " - " << cudaGetErrorString(err) << std::endl; \
            std::exit(EXIT_FAILURE); \
        } \
    } while (0)

// 检查cuBLAS错误
#define CHECK_CUBLAS(call) \
    do { \
        cublasStatus_t status = call; \
        if (status != CUBLAS_STATUS_SUCCESS) { \
            std::cerr << "cuBLAS error at " << __FILE__ << ":" << __LINE__ << std::endl; \
            std::exit(EXIT_FAILURE); \
        } \
    } while (0)

int main() {
    float* h_base_image;
    float* h_noise_image;
    float* h_output_image;

    float* d_base_image;
    float* d_noise_image;
    float* d_output_image;

    size_t image_size = WIDTH * HEIGHT * sizeof(float);

    // 分配主机内存
    CHECK_CUDA(cudaMallocHost(&h_base_image, image_size));
    CHECK_CUDA(cudaMallocHost(&h_noise_image, image_size));
    CHECK_CUDA(cudaMallocHost(&h_output_image, image_size));

    // 分配设备内存
    CHECK_CUDA(cudaMalloc(&d_base_image, image_size));
    CHECK_CUDA(cudaMalloc(&d_noise_image, image_size));
    CHECK_CUDA(cudaMalloc(&d_output_image, image_size));

    // 初始化图像数据
    for (int i = 0; i < WIDTH * HEIGHT; ++i) {
        h_base_image[i] = static_cast<float>(rand()) / RAND_MAX;
        h_noise_image[i] = static_cast<float>(rand()) / RAND_MAX;
    }

    // 复制数据到设备
    CHECK_CUDA(cudaMemcpy(d_base_image, h_base_image, image_size, cudaMemcpyHostToDevice));
    CHECK_CUDA(cudaMemcpy(d_noise_image, h_noise_image, image_size, cudaMemcpyHostToDevice));

    // 创建cuBLAS句柄
    cublasHandle_t handle;
    CHECK_CUBLAS(cublasCreate(&handle));

    // 创建CUDA事件
    cudaEvent_t start, stop;
    CHECK_CUDA(cudaEventCreate(&start));
    CHECK_CUDA(cudaEventCreate(&stop));

    // 设置加法系数
    const float alpha = 1.0f;

    // 记录开始事件
    CHECK_CUDA(cudaEventRecord(start, 0));

    // 使用cuBLAS进行矢量加法 y = alpha * x + y (base_image + noise_image)
    CHECK_CUBLAS(cublasSaxpy(handle, WIDTH * HEIGHT, &alpha, d_base_image, 1, d_noise_image, 1));

    // 记录结束事件
    CHECK_CUDA(cudaEventRecord(stop, 0));
    CHECK_CUDA(cudaEventSynchronize(stop));

    // 计算执行时间
    float milliseconds = 0;
    CHECK_CUDA(cudaEventElapsedTime(&milliseconds, start, stop));
    float fps = 1000.0f / milliseconds;

    std::cout << "Processed at " << fps << " frames per second." << std::endl;

    // 复制结果回主机
    CHECK_CUDA(cudaMemcpy(h_output_image, d_noise_image, image_size, cudaMemcpyDeviceToHost));

    // 清理资源
    CHECK_CUBLAS(cublasDestroy(handle));
    CHECK_CUDA(cudaFreeHost(h_base_image));
    CHECK_CUDA(cudaFreeHost(h_noise_image));
    CHECK_CUDA(cudaFreeHost(h_output_image));
    CHECK_CUDA(cudaFree(d_base_image));
    CHECK_CUDA(cudaFree(d_noise_image));
    CHECK_CUDA(cudaFree(d_output_image));
    CHECK_CUDA(cudaEventDestroy(start));
    CHECK_CUDA(cudaEventDestroy(stop));

    return 0;
}
