import numpy as np
import pycuda.driver as cuda
import pycuda.autoinit
import tensorrt as trt
import time
import torch

class TensorRTInference:
    def __init__(self, engine_path):
        self.logger = trt.Logger(trt.Logger.ERROR)
        self.runtime = trt.Runtime(self.logger)
        self.engine = self.load_engine(engine_path)
        self.context = self.engine.create_execution_context()

        # Allocate buffers
        self.inputs, self.outputs, self.bindings, self.stream = self.allocate_buffers(self.engine)

    def load_engine(self, engine_path):
        with open(engine_path, "rb") as f:
            engine = self.runtime.deserialize_cuda_engine(f.read())
        return engine

    class HostDeviceMem:
        def __init__(self, host_mem, device_mem):
            self.host = host_mem
            self.device = device_mem

    def allocate_buffers(self, engine):
        inputs, outputs, bindings = [], [], []
        stream = cuda.Stream()

        for i in range(engine.num_io_tensors):
            tensor_name = engine.get_tensor_name(i)
            size = trt.volume(engine.get_tensor_shape(tensor_name))
            dtype = trt.nptype(engine.get_tensor_dtype(tensor_name))

            # Allocate host and device buffers
            host_mem = cuda.pagelocked_empty(size, dtype)
            device_mem = cuda.mem_alloc(host_mem.nbytes)

            # Append the device buffer address to device bindings
            bindings.append(int(device_mem))

            # Append to the appropriate input/output list
            if engine.get_tensor_mode(tensor_name) == trt.TensorIOMode.INPUT:
                inputs.append(self.HostDeviceMem(host_mem, device_mem))
            else:
                outputs.append(self.HostDeviceMem(host_mem, device_mem))

        return inputs, outputs, bindings, stream

    def infer(self, input_data):
        # Transfer input data to device
        for i, inp in enumerate(input_data):
            np.copyto(self.inputs[i].host, inp.ravel())
            cuda.memcpy_htod_async(self.inputs[i].device, self.inputs[i].host, self.stream)

        # Set tensor address
        for i in range(self.engine.num_io_tensors):
            self.context.set_tensor_address(self.engine.get_tensor_name(i), self.bindings[i])

        # Run inference
        self.context.execute_async_v3(stream_handle=self.stream.handle)

        # Transfer predictions back
        for out in self.outputs:
            cuda.memcpy_dtoh_async(out.host, out.device, self.stream)

        # Synchronize the stream
        self.stream.synchronize()

        return [out.host for out in self.outputs]

if __name__ == "__main__":
    engine_path = "/home/ygl/code/SGMNet/model_weight.trt"
    trt_inference = TensorRTInference(engine_path)

    # Prepare input data
    test_data = {
        'x1': torch.ones(1, 4000, 2).cuda() - 0.5,
        'x2': torch.ones(1, 4000, 2).cuda() - 0.5,
        'desc1': torch.ones(1, 4000, 128).cuda(),
        'desc2': torch.ones(1, 4000, 128).cuda()
    }
    x1 = test_data['x1'].cpu().numpy()
    x2 = test_data['x2'].cpu().numpy()
    desc1 = test_data['desc1'].cpu().numpy()
    desc2 = test_data['desc2'].cpu().numpy()

    inputs = [x1, x2, desc1, desc2]

    # Run inference and measure time
    start_time = time.time()
    output_data = trt_inference.infer(inputs)
    print(output_data)
    end_time = time.time()

    print(f"Inference time: {end_time - start_time} seconds")