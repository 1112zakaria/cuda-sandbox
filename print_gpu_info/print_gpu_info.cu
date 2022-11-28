#include <stdlib.h>
#include <stdio.h>

void print_num_gpus() {
    int count;
    if (cudaGetDeviceCount(&count) == 0) {
        printf("Num GPUs: %d\n", count);
    }
}

void print_current_device() {
    int device;

    if (cudaGetDevice(&device) == 0) {
        printf("Current Device: %d\n", device);
    }
}

void print_device_properties(int device_index) {
    // FIXME: use macro for printing device prop w/ \t and \n
    cudaDeviceProp device_properties;
    if (cudaGetDeviceProperties(&device_properties, device_index) == 0) {
        printf("\tDevice ID %d Info:\n", device_index);
        printf("\tName: %s\n", device_properties.name);
        printf("\tTotal Global Memory: %ld bytes\n", device_properties.totalGlobalMem);
        printf("\tClock Rate: %d kHz\n", device_properties.clockRate);
        printf("\tMultiprocessor Count: %d\n", device_properties.multiProcessorCount);
        printf("\tL2 Cache Size: %d bytes\n", device_properties.l2CacheSize);
        printf("\n");
    }
}

void print_all_device_properties() {
    int device_count;

    if (cudaGetDeviceCount(&device_count) == 0) {
        printf("Device Properties:\n");
        for (int i=0; i<device_count; i++) {
            print_device_properties(i);
            printf("\n");
        }
    }
}

int main() {

    printf("--DISPLAY GPU INFO--\n");
    print_num_gpus();
    print_current_device();
    print_all_device_properties();
    
    return 0;

}