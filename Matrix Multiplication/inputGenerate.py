import numpy as np

# Function to print a matrix
def print_for_dude(matrix):
    for row in matrix:
        print(" ".join(f"{num:.3f}" for num in row))  # Print each row


def generate_random_matrices(n):
    # Generate random n by n float matrices
    matrix1 = np.random.rand(n, n) 
    matrix2 = np.random.rand(n, n) 
    return matrix1, matrix2

def main():
    # Get user input for n
    try:
        n = int(input())
    except ValueError:
        print("Invalid input! Please enter a valid integer.")
        exit()

    if n > 256:
        print("Too big n! Please enter a n below 256.")
        exit()
    if n < 0:
        print("Negative n! Please enter a positive number.")
        exit()
    if n == 0:
        print("n can not be zero!")
        exit()

    # Generate random matrices
    matrix1, matrix2 = generate_random_matrices(n)

    # Print the generated matrices
    print(n)
    print_for_dude(matrix1)
    print()
    print_for_dude(matrix2)

if __name__ == "__main__":
    main()
