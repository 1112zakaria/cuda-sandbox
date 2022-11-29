#include <stdlib.h>
#include <stdio.h>
//#include <inttypes.h>
#include <stdint.h>
#include <time.h>

// Structure definitions
typedef struct matrix_ {
    uint16_t     rows;
    uint16_t     columns;
    uint16_t**   data; // data 2D-array will be [row][column]
} matrix_t;

int validate_matrices(matrix_t* a, matrix_t* b) {
    if (a->columns == b->rows) {
        return 0;
    }
    return -1;
}

int set_result_matrix_dimensions(matrix_t* a, matrix_t* b, matrix_t* result) {
    if (validate_matrices(a, b) == 0) {
        result->rows = a->rows;
        result->columns = b->columns;
        return 0;
    }
    return -1;
}

int allocate_matrix_memory(matrix_t* matrix) {
    // FIXME: malloc check? i don't feel like it....
    matrix->data = (uint16_t**) malloc(sizeof(uint16_t*) * matrix->rows);
    for (uint16_t i=0; i<matrix->rows; i++) {
        matrix->data[i] = (uint16_t*) malloc(sizeof(uint16_t) * matrix->columns);
    }
    return 0;
}

int generate_matrix(matrix_t* matrix) {
    allocate_matrix_memory(matrix);
    for (uint16_t i=0; i<matrix->rows; i++) {
        for (uint16_t j=0; j<matrix->columns; j++) {
            matrix->data[i][j] = i+j;   // I just picked some arbitrary number
        }
    }
    return 0;
}

int generate_result_matrix(matrix_t* a, matrix_t* b, matrix_t* result) {
    set_result_matrix_dimensions(a, b, result);
    allocate_matrix_memory(result);
    return 0;
}

int print_matrix(matrix_t* matrix) {
    for (uint16_t i=0; i<matrix->rows; i++) {
        printf("[ ");
        for (uint16_t j=0; j<matrix->columns; j++) {
            printf("%d ", matrix->data[i][j]);
        }
        printf("]\n");
    }

    return 0;
}

uint16_t calculate_result_element(uint16_t row, uint16_t column, matrix_t* a, matrix_t* b) {
    uint16_t max = a->columns;
    uint16_t sum = 0;
    for (uint16_t count=0; count<max; count++) {
        sum += a->data[row][count] * b->data[count][column];
    }
    return sum;
}

int single_thread_matrix_multiply(matrix_t* a, matrix_t* b, matrix_t* result) {
    for (uint16_t i=0; i<result->rows; i++) {
        for (uint16_t j=0; j<result->columns; j++) {
            result->data[i][j] = calculate_result_element(i, j, a, b);
        }
    }
    return 0;
}

int main() {
    /*
    TODO: perform matrix multplication using
        - single thread
        - multiprocessing
        - multithreading
        - GPU (figure out techniques?)
    */
    matrix_t a, b, result;
    time_t start, end;

    a.rows = 100;
    a.columns = 100;

    b.rows = 100;
    b.columns = 100;

    generate_matrix(&a);
    generate_matrix(&b);

    generate_result_matrix(&a, &b, &result);
    
    // print_matrix(&a);
    // printf("\n");
    // print_matrix(&b);
    // printf("\n");

    printf("single_thread_matrix_multiply()\n");
    time(&start);
    single_thread_matrix_multiply(&a, &b, &result);
    time(&end);
    // print_matrix(&result);

    // FIXME: it no work...
    printf("Time to perform: %f seconds\n", difftime(end, start));

    return 0;
}
