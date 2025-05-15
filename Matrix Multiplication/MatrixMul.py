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

def print_for_dude(matrix):
    print(matrix.shape[0])
    for row in matrix:
        print(" ".join(f"{num:.3f}" for num in row))  # Print each row

def matrix_mul(matrix1, matrix2):
    n = len(matrix1)
    result = [[0]*n for _ in range(n)]
    
    for i in range(n):
        for j in range(n):
            for k in range(n):
                result[i][j] += matrix1[i][k] * matrix2[k][j]
    
    return np.array(result)




def main(): 
    n = int(input())
    matrix1 = read_matrix_input(n)
    input()
    matrix2 = read_matrix_input(n)

    result = matrix_mul(matrix1, matrix2)

    print_for_dude(result)

if __name__ == "__main__":
    main()

