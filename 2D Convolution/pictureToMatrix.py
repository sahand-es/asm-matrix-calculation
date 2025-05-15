from matplotlib import pyplot as plt
import cv2
import numpy as np
from scipy.signal import convolve2d

# Function to read an image and resize it
def image_to_matrix(image_path, scale_percent):
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)  # Read the image in grayscale
    size = min(img.shape[:2])  # Determine the size of the square crop
    left = (img.shape[1] - size) // 2  # Calculate left coordinate for crop
    top = (img.shape[0] - size) // 2  # Calculate top coordinate for crop
    img = img[top:top+size, left:left+size]  # Crop the image
    dim = (int(img.shape[1] * scale_percent / 100), int(img.shape[0] * scale_percent / 100))  # Calculate dimensions for resizing
    resized_img = cv2.resize(img, dim, interpolation=cv2.INTER_AREA)  # Resize the image
    return resized_img

# Function to print a matrix
def print_for_dude(matrix):
    print(matrix.shape[0])  # Print the number of rows
    for row in matrix:
        print(*row)  # Print each row

# Function to apply 2D convolution
def apply_2d_convolution(image, kernel):
    result = convolve2d(image, kernel, mode='same', boundary='fill', fillvalue=0)  # Perform 2D convolution
    return result

# Function to select a kernel based on input
def select_kernel(kernel_input):
    if kernel_input == 'sharpen':
        return np.array([[0, -1, 0], 
                         [-1, 5, -1], 
                         [0, -1, 0]])  # Sharpening kernel
    elif kernel_input == 'gaussian_blur_3':
        return np.ones((3, 3)) / 9  # 3x3 Gaussian blur kernel
    elif kernel_input == 'gaussian_blur_5':
        return np.ones((5, 5)) / 25  # 5x5 Gaussian blur kernel
    elif kernel_input == 'laplacian':
        return np.array([[0, 1, 0], 
                         [1, -4, 1], 
                         [0, 1, 0]])  # Laplacian kernel
    elif kernel_input == 'emboss':
        return np.array([[-2, -1, 0], 
                         [-1, 1, 1], 
                         [0, 1, 2]])  # Emboss kernel
    elif kernel_input == 'outline':
        return np.array([[-1, -1, -1], 
                         [-1, 8, -1], 
                         [-1, -1, -1]])  # Outline kernel
    else:
        return None  # Return None for invalid input

# Main function
def main():
    image_path = input()  # Input path to the image
    kernel_input = input()  # Input type of kernel
    scale = 100  # Scale percentage for resizing
    
    image = image_to_matrix(image_path, scale)  # Read and resize the image
    kernel = select_kernel(kernel_input)  # Select the kernel based on input
    
    if kernel is None:
        print("Invalid kernel type.")  # Print error message for invalid kernel type
        return
    
    print_for_dude(image)  # Print the processed image
    print_for_dude(kernel)  # Print the selected kernel

if __name__ == "__main__":
    main()  # Call the main function
