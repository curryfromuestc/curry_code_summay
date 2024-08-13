import random

def generate_weights(num_weights=80):
    weights = [random.choice([1, -1]) for _ in range(num_weights)]
    return weights

#从pth文件中读取权重
# def read_weights_from_pth(pth_file):
#     weights = []
#     with open(pth_file, 'r') as file:
#         for line in file:
#             if line.startswith('weight'):
#                 weight = float(line.split('=')[1].strip())
#                 weight = 1 if weight > 0 else -1
#                 weights.append(weight)
#     return

def write_coe_file(weights, filename="weights.coe"):
    with open(filename, 'w') as file:
        file.write("memory_initialization_radix=2;\n")
        file.write("memory_initialization_vector=\n")
        
        for weight in weights:
            binary_rep = '1' if weight == 1 else '0'
            file.write(f"{binary_rep},\n")
        
        file.write(";")

if __name__ == "__main__":
    weights = generate_weights()
    write_coe_file(weights)
    print(f"COE file with {len(weights)} weights has been generated.")
