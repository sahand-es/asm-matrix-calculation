#include <stdio.h>
#define SIZE 512
float in[SIZE][SIZE], kernel[SIZE][SIZE], out[SIZE][SIZE];

int main() {
    int n, m;
    scanf("%u\n", &n);
    for (int i = 0; i < n; i++)
        for (int j = 0; j < n; j++)
            scanf("%f",  &in[i][j]);

    scanf("%u\n", &m);
    for (int i = 0; i < m; i++)
        for (int j = 0; j < m; j++)
            scanf("%f",  &kernel[i][j]);

// find center position of kernel (half of kernel size)
int Center = m / 2;

for(int i=0; i < n; ++i)              // rows
{
    for(int j=0; j < n; ++j)          // columns
    {
        for(int k=0; k < m; ++k)     // kernel rows
        {
            int k_row = m - 1 - k;      // row index of flipped kernel

            for(int l=0; l < m; ++l) // kernel columns
            {
                int k_col = m - 1 - l;  // column index of flipped kernel

                // index of input signal, used for checking boundary
                int mat_row = i + (Center - k_row);
                int mat_col = j + (Center - k_col);


                // ignore input samples which are out of bound
                if( mat_row >= 0 && mat_row < n && mat_col >= 0 && mat_col < n )
                    out[i][j] += in[mat_row][mat_col] * kernel[k_row][k_col];
            }
        }
    }
}

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            printf("%f ", out[i][j]);
        }
        printf("\n");
    }

}