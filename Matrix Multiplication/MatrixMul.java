import java.util.Scanner;

public class MatrixMul {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);

        // Input matrix size
        int n = scanner.nextInt();

        // Input matrices
        float[][] matrix1 = new float[n][n];
        float[][] matrix2 = new float[n][n];

        inputMatrix(matrix1, scanner);
        inputMatrix(matrix2, scanner);

        // Perform matrix multiplication
        float[][] resultMatrix = multiplyMatrices(matrix1, matrix2, n);

        displayMatrix(resultMatrix);

        scanner.close();
    }

    private static void inputMatrix(float[][] matrix, Scanner scanner) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++) {
                matrix[i][j] = scanner.nextFloat();
            }
        }
    }

    private static float[][] multiplyMatrices(float[][] matrix1, float[][] matrix2, int n) {
        float[][] resultMatrix = new float[n][n];

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                for (int k = 0; k < n; k++) {
                    resultMatrix[i][j] += matrix1[i][k] * matrix2[k][j];
                }
            }
        }

        return resultMatrix;
    }

    private static void displayMatrix(float[][] matrix) {
        System.out.println(matrix.length);
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[0].length; j++) {
                    System.out.print(String.format("%.3f ", matrix[i][j]));
            }
            System.out.println();
        }
    }
}
