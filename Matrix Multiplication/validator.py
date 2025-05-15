import numpy as np

def read_matrix_input(n):
    input_str = ""
    for i in range(n):
        line = input()
        if not line:
            break
        input_str += line + "\n"
    return input_to_matrix(input_str)

def input_to_matrix(input_str):
    lines = input_str.strip().split('\n')
    matrix = []
    for line in lines:
        row = [float(num) for num in line.strip().split()]
        matrix.append(row)
    return np.array(matrix)

def check_identical_matrices(matrix1, matrix2):
    n = len(matrix1)
    # Round each element in the matrices to two decimal places
    matrix1 = [[round(matrix1[i][j], -1) for j in range(n)] for i in range(n)]
    matrix2 = [[round(matrix2[i][j], -1) for j in range(n)] for i in range(n)]
    
    # Check if the rounded matrices are identical
    return matrix1 == matrix2

def print_validation_result(name,result):
    if result:
        print(f"\033[92m{name}......PASSED\033[0m")
    else:
        print(f"\033[91m{name}......FAILED\033[0m")


def main(): 
    n = int(input())
    matrix1 = read_matrix_input(n)
    n = int(input())
    matrix2 = read_matrix_input(n)

    input()

    name = input()

    print_validation_result(name,check_identical_matrices(matrix1, matrix2))
if __name__ == "__main__":
    main()

