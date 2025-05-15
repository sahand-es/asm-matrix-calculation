from matplotlib import pyplot as plt
import cv2
import numpy as np

# Function to convert input string to matrix
def input_to_matrix(input_str):
    lines = input_str.strip().split('\n')
    matrix = []
    for line in lines:
        row = [float(num) for num in line.strip().split()]
        matrix.append(row)
    return np.array(matrix)

# Function to read image and resize it
def image_to_matrix(image_path, scale_percent):
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height)
    resized_img = cv2.resize(img, dim, interpolation=cv2.INTER_AREA)
    return resized_img

# Function to read input data
def read_input():
    time_asm, time_py = map(float, input().split(' '))
    kernel_name = input()
    image_path = input()
    return time_asm, time_py, kernel_name, image_path

# Function to read matrix input
def read_matrix_input():
    input_str = ""
    n = int(input())
    for i in range(n):
        line = input()
        if not line:
            break
        input_str += line + "\n"
    return input_to_matrix(input_str)

# Function to display results
def display_results(img, result_from_asm, result_from_python, time_asm, time_py, kernel_name, image_path):
    scale = 100
    img = image_to_matrix(image_path, scale)
    
    # Plotting
    fig, axes = plt.subplots(1, 3, figsize=(10, 5))
    axes[0].imshow(img, cmap='gray')
    axes[0].set_title('Original Image')
    axes[0].axis('off')

    axes[1].imshow(result_from_asm, cmap='gray')
    axes[1].set_title('Convolved Using Assembly')
    axes[1].text(0.5,-0.1, f"time: {time_asm}", size=12, ha="center", 
                 transform=axes[1].transAxes)
    axes[1].axis('off')

    axes[2].imshow(result_from_python, cmap='gray')
    axes[2].set_title('Convolved Using Python')
    axes[2].axis('off')
    axes[2].text(0.5,-0.1, f"time: {time_py}", size=12, ha="center", 
                 transform=axes[2].transAxes)

    fig.suptitle(f"kernel: {kernel_name}", size=16)

    name = image_path.split("/")[-1].split(".")[0]
    # plt.savefig(f'./Outputs/{name}_{kernel_name}.jpg')
    plt.show()

# Main function
def main():
    time_asm, time_py, kernel_name, image_path = read_input()
    result_from_asm = read_matrix_input()
    input() # skip empty input
    result_from_python = read_matrix_input()
    img = image_to_matrix(image_path, 100)
    display_results(img, result_from_asm, result_from_python, time_asm, time_py, kernel_name, image_path)

if __name__ == "__main__":
    main()
