#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"


int main(int argc,char **argv){

MPI_Status status;
int size,rank;

MPI_Init (&argc, &argv);
MPI_Comm_rank(MPI_COMM_WORLD,&rank);
MPI_Comm_size(MPI_COMM_WORLD,&size);

//define filehandle, open file, read first two integers
MPI_File fh;
MPI_File_open( MPI_COMM_WORLD, "8x16-2_bin.in", MPI_MODE_RDWR, MPI_INFO_NULL, &fh );
int rowcol[2];	
MPI_File_read_at( fh, 0, &rowcol, 2, MPI_INT,&status );

//use the integers to determine matrix size
int rows = rowcol[0];
int cols = rowcol[1];
float elements[rows*cols];  // has to be defined on the heap in real life

//Read the ramaining doubles from the file
MPI_File_read_at( fh, 2*sizeof(int), &elements, rows*cols, MPI_FLOAT, &status );

//close the filehandle
MPI_File_close(&fh);

//report original matrix
if (rank == 0) {
	printf( "rows = %d\ncols =  %d\nReported from rank %d\n", rows, cols, rank );
	//Reconstitute the original matrix from the binary file
	for (int i = 0; i < rows; i++) {
            printf("\n");
            for (int j = 0; j < cols; j++) {
                printf( "%f ", elements[ rows*i + j ] );
            }
        }
}
MPI_Finalize();

return 0;

}

