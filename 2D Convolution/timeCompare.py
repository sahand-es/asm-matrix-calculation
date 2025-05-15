from matplotlib import pyplot as plt
import cv2
import numpy as np
from scipy.signal import convolve2d

def apply_2d_convolution(image, kernel, scale_percent):
    # Read the image
    img = cv2.imread(image, cv2.IMREAD_GRAYSCALE)
    
    # Crop the image to a square
    size = min(img.shape[:2])
    left = (img.shape[1] - size) // 2
    top = (img.shape[0] - size) // 2
    img = img[top:top+size, left:left+size]
    
    # Resize the image
    width = int(img.shape[1] * scale_percent / 100)
    height = int(img.shape[0] * scale_percent / 100)
    dim = (width, height)
    resized_img = cv2.resize(img, dim, interpolation=cv2.INTER_AREA)
    
    # Apply 2D convolution
    result = convolve2d(resized_img, kernel, mode='same', boundary='fill', fillvalue=0)
    return result

def print_for_dude(matrix):
    # Print the shape of the matrix
    print(matrix.shape[0])
    
    # Print the elements of the matrix
    for row in matrix:
        print(*row)

def select_kernel(kernel_input):
    # Select the appropriate kernel based on input
    if kernel_input == 'sharpen':
        return np.array([[0, -1, 0], 
                         [-1, 5, -1], 
                         [0, -1, 0]])
    elif kernel_input == 'gaussian_blur_3':
        return np.ones((3, 3)) / 9
    elif kernel_input == 'gaussian_blur_5':
        return np.ones((5, 5)) / 25
    elif kernel_input == 'laplacian':
        return np.array([[0, 1, 0], 
                         [1, -4, 1], 
                         [0, 1, 0]])
    elif kernel_input == 'emboss':
        return np.array([[-2, -1, 0], 
                         [-1, 1, 1], 
                         [0, 1, 2]])
    elif kernel_input == 'outline':
        return np.array([[-1, -1, -1], 
                         [-1, 8, -1], 
                         [-1, -1, -1]])
    else:
        print("Invalid kernel type.")
        exit()

def main():
    # Get image path and kernel type from user
    image_path = input()
    kernel_input = input()
    scale = 100
    
    # Select the kernel
    kernel = select_kernel(kernel_input)
    
    # Apply 2D convolution and print the result
    result = apply_2d_convolution(image_path, kernel, scale)
    print_for_dude(result)

if __name__ == "__main__":
    main()
