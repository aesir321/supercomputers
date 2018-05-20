#define _GNU_SOURCE // Needed to use asprintf for easier string formatting

#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mpi.h"

int main (int argc, char **argv) {
	FILE *fp;
	double **A = NULL, **B = NULL, **C = NULL, *A_array = NULL, *B_array = NULL, *C_array = NULL;
	double *A_local_block = NULL, *B_local_block = NULL, *C_local_block = NULL;
	int A_rows, A_columns, A_local_block_rows, A_local_block_columns, A_local_block_size;
	int B_rows, B_columns, B_local_block_rows, B_local_block_columns, B_local_block_size;
	int rank, size, sqrt_size, matrices_a_b_dimensions[4];
	MPI_Comm cartesian_grid_communicator, row_communicator, column_communicator;
	MPI_Status status; 
	int rowsource, rowdest, columnsource, columndest;
	// used to manage the cartesian grid
	int dimensions[2], periods[2], coordinates[2], remain_dims[2];
	double output, start;

	MPI_Init(&argc, &argv);
	MPI_Comm_size(MPI_COMM_WORLD, &size);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);

	/* For square mesh */
	sqrt_size = (int)sqrt((double) size);             
	if(sqrt_size * sqrt_size != size){
		if( rank == 0 ) perror("need to run mpiexec with a perfect square number of processes\n");
		MPI_Abort(MPI_COMM_WORLD, -1);
	}

	// create a 2D cartesian grid 
	dimensions[0] = dimensions[1] = sqrt_size;
	periods[0] = periods[1] = 1;    
	MPI_Cart_create(MPI_COMM_WORLD, 2, dimensions, periods, 1, &cartesian_grid_communicator);
	MPI_Cart_coords(cartesian_grid_communicator, rank, 2, coordinates);

	// create a row communicator
	remain_dims[0] = 0;            
	remain_dims[1] = 1; 
	MPI_Cart_sub(cartesian_grid_communicator, remain_dims, &row_communicator);

	// create a column communicator
	remain_dims[0] = 1;
	remain_dims[1] = 0;
	MPI_Cart_sub(cartesian_grid_communicator, remain_dims, &column_communicator);

	// MPI_IO Implementation starts here
	start = MPI_Wtime();
	// Now open the files so we can set the views up
	MPI_File AFileHeader, BFileHeader;
	MPI_File_open(MPI_COMM_WORLD, argv[1], MPI_MODE_RDONLY, MPI_INFO_NULL, &AFileHeader);

	/* Remember the first two entries are actually the matrix dimensions so we want to
	 * extract the dims and 'fast-forward' to actual data
	 * I thought that by setting MPI_INT here we would extract the actual value instead of the binary number?
	 */
	MPI_File_read(AFileHeader, &matrices_a_b_dimensions[0], 1, MPI_INT, MPI_STATUS_IGNORE);
	MPI_File_read(AFileHeader, &matrices_a_b_dimensions[1], 1, MPI_INT, MPI_STATUS_IGNORE);
	int ndims = 2;
	MPI_Offset dataStart = ndims * sizeof(int); // Our dims are just 2 ints

	A_rows = matrices_a_b_dimensions[0];
	A_columns = matrices_a_b_dimensions[1];

	/* These variables will have weird values as they are computed with A_rows and A_columns
	 * which at the moment contain encoded values and 
	 * not the "normal" dimensions i.e they are set to be something like 
	 * (3459890849, 23847982374) instead of (16, 16) for example.
	 */
	
	// local metadata for A
	A_local_block_rows = A_rows / sqrt_size;
	A_local_block_columns = A_columns / sqrt_size;
	A_local_block_size = A_local_block_rows * A_local_block_columns;
	A_local_block = (double *) malloc(A_local_block_size * sizeof(double));
	
	// MPI has a built in array splitter, see here for good example:
	// https://stackoverflow.com/questions/13345147/how-to-use-mpi-type-create-subarray#13345768
	// We will use a similar strategy
	int A_dim[2] = {A_rows, A_columns};
	int A_local_dim[2] = {A_local_block_rows, A_local_block_columns};
	int A_start[2] = {coordinates[0] * A_local_dim[0], coordinates[1] * A_local_dim[1]};

	MPI_Datatype A_local, B_local;
	//MPI_ORDER_C for row major ordering
	MPI_Type_create_subarray(ndims, A_dim, A_local_dim, A_start, MPI_ORDER_C, MPI_DOUBLE, &A_local);
	MPI_Type_commit(&A_local);  // Custom datatypes need to be committed before able to use
	// NULL takes default data type or so the docu said.  Turned out we needed to set it
	// to "native" to actually set the view correctly.  Still not sure why.
	MPI_File_set_view(AFileHeader, dataStart, MPI_DOUBLE, A_local, "native", MPI_INFO_NULL);
	MPI_File_read_all(AFileHeader, A_local_block, A_local_block_size, MPI_DOUBLE, MPI_STATUS_IGNORE);
	MPI_File_close(&AFileHeader);

	// Do the same for B
	MPI_File_open(MPI_COMM_WORLD, argv[2], MPI_MODE_RDONLY, MPI_INFO_NULL, &BFileHeader);
	MPI_File_read(BFileHeader, &matrices_a_b_dimensions[2], 1, MPI_INT, MPI_STATUS_IGNORE);
	MPI_File_read(BFileHeader, &matrices_a_b_dimensions[3], 1, MPI_INT, MPI_STATUS_IGNORE);

	B_rows = matrices_a_b_dimensions[2];
	B_columns = matrices_a_b_dimensions[3];

	// local metadata for B
	B_local_block_rows = B_rows / sqrt_size;
	B_local_block_columns = B_columns / sqrt_size;
	B_local_block_size = B_local_block_rows * B_local_block_columns;
	B_local_block = (double *) malloc(B_local_block_size * sizeof(double));

	int B_dim[2] = {B_rows, B_columns};
	int B_local_dim[2] = {B_local_block_rows, B_local_block_columns };
	int B_start[2] = {coordinates[0] * B_local_dim[0], coordinates[1] * B_local_dim[1]};
	
	MPI_Type_create_subarray(ndims, B_dim, B_local_dim, B_start, MPI_ORDER_C, MPI_DOUBLE, &B_local);
	MPI_Type_commit(&B_local);
	MPI_File_set_view(BFileHeader, dataStart, MPI_DOUBLE, B_local, "native", MPI_INFO_NULL); // NULL takes default data type
	MPI_File_read_all(BFileHeader, B_local_block, B_local_block_size, MPI_DOUBLE, MPI_STATUS_IGNORE);
	MPI_File_close(&BFileHeader);

	// local metadata for C
	C_local_block = (double *) malloc(A_local_block_rows * B_local_block_columns * sizeof(double));
	// C needs to be initialised at 0 (accumulates partial dot-products)
	int i;
	for(i=0; i < A_local_block_rows * B_local_block_columns; i++){
		C_local_block[i] = 0;
	}
	double init_time = MPI_Wtime() - start;
	//initial alignment
	MPI_Cart_shift(row_communicator, 0, -coordinates[0], &rowsource, &rowdest);

	// Debugging
	//printf("------------\n rank %d\n", rank);
	//printf("A_rows: %d, A_columns: %d\n", A_rows, A_columns);
	//printf("A_dim: (%d, %d)\nA_local_dim: (%d, %d)\nA_start: (%d, %d)\n",
	  //     A_dim[0], A_dim[1], A_local_dim[0], A_local_dim[1], A_start[0], A_start[1]);
	//printf("A_local_block_rows: %d\nA_local_block_columns: %d\n", A_local_block_rows, A_local_block_columns);
	//printf("A_local_block_size: %d\n\n", A_local_block_size);
	
	//printf("B_rows: %d, B_columns: %d\n", B_rows, B_columns);
	//printf("B_dim: (%d, %d)\nB_local_dim: (%d, %d)\nB_start: (%d, %d)\n",
	   //    B_dim[0], B_dim[1], B_local_dim[0], B_local_dim[1], B_start[0], B_start[1]);
	//printf("B_local_block_rows: %d\nB_local_block_columns: %d\n", B_local_block_rows, B_local_block_columns);
	//printf("B_local_block_size: %d\n\n", B_local_block_size);


	MPI_Sendrecv_replace(A_local_block, A_local_block_size, MPI_DOUBLE, rowdest, 1, rowsource, 1, row_communicator, &status);
	MPI_Cart_shift(column_communicator, 0, -coordinates[1], &columnsource, &columndest);
	MPI_Sendrecv_replace(B_local_block, B_local_block_size, MPI_DOUBLE, columndest, 2, columnsource, 2, column_communicator, &status);
		
	// cannon's algorithm
	int cannon_block_cycle;
	double compute_time = 0, mpi_time = 0;
	int C_index, A_row, A_column, B_column;
	for(cannon_block_cycle = 0; cannon_block_cycle < sqrt_size; cannon_block_cycle++){
		// compute partial result for this block cycle
		start = MPI_Wtime();
		for(C_index = 0, A_row = 0; A_row < A_local_block_rows; A_row++){
			for(B_column = 0; B_column < B_local_block_columns; B_column++, C_index++){
				for(A_column = 0; A_column < A_local_block_columns; A_column++){
					C_local_block[C_index] += A_local_block[A_row * A_local_block_columns + A_column] *
						B_local_block[A_column * B_local_block_columns + B_column];
				}
			}
		}
		compute_time += MPI_Wtime() - start;
		start = MPI_Wtime();
		// rotate blocks horizontally
		MPI_Sendrecv_replace(A_local_block, A_local_block_size, MPI_DOUBLE, 
				(coordinates[1] + sqrt_size - 1) % sqrt_size, 0, 
				(coordinates[1] + 1) % sqrt_size, 0, row_communicator, &status);
		// rotate blocks vertically
		MPI_Sendrecv_replace(B_local_block, B_local_block_size, MPI_DOUBLE, 
				(coordinates[0] + sqrt_size - 1) % sqrt_size, 0, 
				(coordinates[0] + 1) % sqrt_size, 0, column_communicator, &status);
		mpi_time += MPI_Wtime() - start;
	}
	start = MPI_Wtime();
	MPI_File CFileHeader;
	char *filename;
	asprintf(&filename, "c_%dx%d.dat", A_rows, B_columns);
	MPI_File_open(MPI_COMM_WORLD, filename, MPI_MODE_CREATE|MPI_MODE_WRONLY, MPI_INFO_NULL, &CFileHeader);

	if (rank == 0) // Only 1st rank should write the header dimensions
	  {
	    MPI_File_write(CFileHeader, &A_rows, 1, MPI_INT, MPI_STATUS_IGNORE);
	    MPI_File_write(BFileHeader, &B_columns, 1, MPI_INT, MPI_STATUS_IGNORE);
	  }

	int C_dim[2] = {A_rows, B_columns};
	int C_local_dim[2] = {A_local_block_rows, B_local_block_columns };
	int C_start[2] = {coordinates[0] * C_local_dim[0], coordinates[1] * C_local_dim[1]};
	int C_local_block_size = A_local_block_rows * B_local_block_columns;

	MPI_Datatype C_local;
	MPI_Type_create_subarray(ndims, C_dim, C_local_dim, C_start, MPI_ORDER_C, MPI_DOUBLE, &C_local);
	MPI_Type_commit(&C_local);

	MPI_File_set_view(CFileHeader, dataStart, MPI_DOUBLE, C_local, "native", MPI_INFO_NULL);
	MPI_File_write_all(CFileHeader, C_local_block, C_local_block_size, MPI_DOUBLE, MPI_STATUS_IGNORE);
	MPI_File_close(&CFileHeader);
	output = MPI_Wtime() - start;
	
	if (rank == 0)
	  {
		printf("(%d,%d)x(%d,%d)=(%d,%d)\n", A_rows, A_columns, B_rows, B_columns, A_rows, B_columns);
		printf("Computation time: %lf\n", compute_time);
		printf("MPI time:         %lf\n", mpi_time);
		printf("Initialisation time: %lf\n", init_time);
		printf("Output timeL %lf\n", output);
	  }
	
	/*
	if (argc == 4) {
	  // present results on the screen
	  printf("\nA( %d x %d ):\n", A_rows, A_columns);
	  for (int row = 0; row < A_rows; row++) {
	    for(int column = 0; column < A_columns; column++) {
	      printf ("%7.3f ", A[row][column]);
	    }
	    printf ("\n");
	  }

	  printf("\nB( %d x %d ):\n", B_rows, B_columns);
	  for(int row = 0; row < B_rows; row++) {
	    for(int column = 0; column < B_columns; column++) {
	      printf("%7.3f ", B[row][column]);
	    }
	    printf("\n");
	  }

	  printf("\nC( %d x %d ) = AxB:\n", A_rows, B_columns);
	  for (int row = 0; row < A_rows; row++) {
	    for (int column = 0; column < B_columns; column++) {
	      printf("%7.3f ",C[row][column]);
	    }
	    printf("\n");
	  }

	 // printf("\nPerforming serial consistency check. Be patient...\n");
	  fflush(stdout);
	  int pass = 1;
	  double temp;

	  for (i = 0; i < A_rows; i++) {
	    for (int j = 0; j < B_columns; j++) {
	      temp = 0;
	      for (int k = 0; k < B_rows; k++) {
		temp += A[i][k] * B[k][j];
	      }
	      printf("%7.3f ", temp);
	      if (temp != C[i][j]) {
		pass = 0;
	      }
	    }
	    printf("\n");
	  }

	  if (pass) {
	 //   printf("Consistency check: PASS\n");
	  }
	  else {
	  //  printf("Consistency check: FAIL\n");
	  }
	}
	*/

	// free all memory
	if (rank == 0) {
	  

	  free(A);
	  free(B);
	  free(C);
	  free(A_array);
	  free(B_array);
	  free(C_array);
	}
	
	free(A_local_block);
	free(B_local_block);
	free(C_local_block);

	
	// finalize MPI
	MPI_Finalize();
}
