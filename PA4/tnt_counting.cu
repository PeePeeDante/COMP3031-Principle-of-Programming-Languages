#include <iostream>
#include "helpers.h"
using namespace std;

/* you can define data structures and helper functions here */

__device__ void c6ring_dfs(int vertex_id, int depth, int* dcc, int c_c_size, int visited[], 
						   int neighbors[], int num_neighbors, int** &results, int &num_results){

	visited[depth]=vertex_id;
	depth++;

	if (depth<6){

		for (int i=0; i<num_neighbors; i++){

			int next_vertex_id = neighbors[i];

			// Check if visited
			bool visit = 0;
			for (int j=0; j<6; j++){
				if (visited[j]==next_vertex_id){
					visit = 1;
					break;
				}
			}
			if (visit) continue;

			// Initialize neighbor info
			int num_next_neighbors = 0;
			for (int j=0; j<c_c_size; j++){
				if (dcc[j]==next_vertex_id) num_next_neighbors++;
			}

			//const int NUM_NEXT_NEIGHBORS = num_next_neighbors;
			//int next_neighbors[NUM_NEXT_NEIGHBORS];
			int next_neighbors[10];
			int p = 0;
			for (int j=0; j<c_c_size; j++){
				if (dcc[j]==next_vertex_id){
					next_neighbors[p] = dcc[j+c_c_size];
					p++;
				}
			}

			// Next dfs
			c6ring_dfs(next_vertex_id, depth, dcc, c_c_size, visited, 
					   next_neighbors, num_next_neighbors, results, num_results);
		}
	}

	// Check if c6ring is found
	else if (depth == 6) {

		bool found = 0;

		// Check if visited[0] is in neighbors
		for (int i=0; i<num_neighbors; i++){
			if (neighbors[i]==visited[0]){
				found = 1;
				break;
			}
		} 

		// Update result, found
		if (found == 1){

			int** temp = new int* [num_results+1];

			for (int i=0; i<num_results; i++){
				temp[i] = new int [6];
				for (int j = 0; j<6; j++){
					temp[i][j] = results[i][j];
				}
				delete[] results[i];
			}

			temp[num_results] = new int [6];
			for (int i=0; i<6; i++){
				temp[num_results][i] = visited[i]; 
			}

			if (results!=nullptr) delete[] results;
			
			results = temp;
			num_results++;
		}
	}

	// Backtrack
	visited[depth-1] = -1;

	// Depth is pbv no need update
}

__device__ void no2_search(int* dcn, int c_n_size, int* dno, int n_o_size, 
						   int** results, int num_results, int** &tnt_results, int& num_tnt_results){
	
	// Traverse each c6ring results
	for (int i=0; i<num_results; i++){

		// Store n vertex id if exists
		int cn[3] = {-1,-1,-1};

		// Find cn of c6ring[0], c6ring[2], c6ring[4]
		for (int j=0; j<3; j++){

			int c_vertex = results[i][2*j];
			for (int k=0; k<c_n_size; k++){

				if (c_vertex==dcn[k]){
					cn[j] = dcn[k+c_n_size];
					break;
				}
			}
		}

		// Check if all cn[3] not -1
		bool valid = 1;
		for (int j=0; j<3; j++){
			if (cn[j]==-1){
				valid = 0;
				break;
			}
		}

		// Check no2
		if (valid){

			// Find 2 os for each n in cn
			int no2[3][2] = {-1,-1,-1,-1,-1,-1};
			for (int j=0; j<3; j++){

				int l = 0;
				for (int k=0; k<n_o_size; k++){

					if (cn[j]==dno[k]){
						no2[j][l] = dno[k+n_o_size];
						l++;
					}
					if (l==2) break;
				}
			}

			// Check if no2 all not -1
			bool valid2 = 1;
			for (int j=0; j<3; j++){
				for (int k=0; k<2; k++){
					if (no2[j][k]==-1){
						valid2 = 0;
						break;
					}
				}
				if (valid2==0) break;
			}

			if (valid2){
				int** temp = new int* [8*(num_tnt_results+1)];

				for (int j=0; j<8*num_tnt_results; j++){
					temp[j] = new int [15];
					for (int k = 0; k<15; k++){
						temp[j][k] = tnt_results[j][k];
					}
					delete[] tnt_results[j];
				}

				for (int j=0; j<8; j++){
					temp[8*(num_tnt_results)+j] = new int [15];
					for (int k=0; k<6; k++) temp[j][k] = results[i][k];
					for (int k=0; k<3; k++) temp[j][k+6] = cn[k];
					for (int k=0; k<3; k++){
						for (int l=0; l<2; l++){
							temp[j][2*k+l+9] = no2[k][l];
						}
					}

					// For each cno2, write 2 different combination
					// ab ba ab ba ab ba ab ba
					// cd cd dc dc cd cd dc dc
					// ef ef ef ef fe fe fe fe 
					int temp1 = no2[0][0];
					no2[0][0] = no2[0][1];
					no2[0][1] = temp1;

					if (j%2==0){
						int temp2 = no2[1][0];
						no2[1][0] = no2[1][1];
						no2[1][1] = temp2;
					}

					if (j%4==0){
						int temp3 = no2[2][0];
						no2[2][0] = no2[2][1];
						no2[2][1] = temp3;
					}
				}

				if (tnt_results!=nullptr) delete[] tnt_results;

				tnt_results = temp;
				num_tnt_results = num_tnt_results + 8;
			}
		}
	}
}

__device__ void no2_count(int* dcn, int c_n_size, int* dno, int n_o_size, 
						  int** results, int num_results, int& num_tnt_results){
	
	// Traverse each c6ring results
	for (int i=0; i<num_results; i++){

		// Store n vertex id if exists
		int cn[3] = {-1,-1,-1};

		// Find cn of c6ring[0], c6ring[2], c6ring[4]
		for (int j=0; j<3; j++){

			int c_vertex = results[i][2*j];
			for (int k=0; k<c_n_size; k++){

				if (c_vertex==dcn[k]){
					cn[j] = dcn[k+c_n_size];
					break;
				}
			}
		}

		// Check if all cn[3] not -1
		bool valid = 1;
		for (int j=0; j<3; j++){
			if (cn[j]==-1){
				valid = 0;
				break;
			}
		}

		// Check no2
		if (valid){

			//printf("debug4: valid!\t");

			// Find 2 os for each n in cn
			int no2[3][2] = {-1,-1,-1,-1,-1,-1};
			for (int j=0; j<3; j++){

				int l = 0;
				for (int k=0; k<n_o_size; k++){

					if (cn[j]==dno[k]){
						no2[j][l] = dno[k+n_o_size];
						l++;
					}
					if (l==2) break;
				}
			}

			// Check if no2 all not -1
			bool valid2 = 1;
			for (int j=0; j<3; j++){
				for (int k=0; k<2; k++){
					if (no2[j][k]==-1){
						valid2 = 0;
						break;
					}
				}
				if (valid2==0) break;
			}

			if (valid2){
				num_tnt_results = num_tnt_results+8;
				//printf("debug5: %d\n", num_tnt_results);
			} 
		}
	}
}

__global__ void tnt_search(int* dcc, int* dcn, int* dno, int c_c_size, int c_n_size, int n_o_size, 
						   int* d_thread_results, int gridSize){
	
	//const int SHARED_DCC_SIZE = 2*c_c_size;
	//const int SHARED_DCN_SIZE = 2*c_n_size;
	//const int SHARED_DNO_SIZE = 2*n_o_size;
	//__shared__ int shared_dcc[SHARED_DCC_SIZE];
	//__shared__ int shared_dcn[SHARED_DCN_SIZE];
	//__shared__ int shared_dno[SHARED_DNO_SIZE];
	
	/*
	__shared__ int shared_dcc[16384];
	__shared__ int shared_dcn[16384];
	__shared__ int shared_dno[16384];

	for (int i=0; i<2*c_c_size; i++){
		shared_dcc[i] = dcc[i];
	}
	for (int i=0; i<2*c_n_size; i++){
		shared_dcn[i] = dcn[i];
	}
	for (int i=0; i<2*n_o_size; i++){
		shared_dno[i] = dno[i];
	}

	__syncthreads();
	*/

	int tid = blockIdx.x*blockDim.x + threadIdx.x;
	int i = 0;

	// Some threads have to take multiple tasks
	while (i*gridSize+tid < c_c_size){

		int idx = i*gridSize + tid;

		// Initialize visited array
		int visited[6] = {-1,-1,-1,-1,-1,-1};

		// Starting C only visits direct neighbor to avoid duplicates
		int cc_start = dcc[idx];
		int neighbors[1] = { dcc[idx+c_c_size] };

		// Call c6ring_dfs()
		int** results = nullptr;
		int num_results = 0;

		c6ring_dfs(cc_start, 0, dcc, c_c_size, visited, neighbors, 1, results, num_results);
		// Return results -> arrays of c6rings
		// Return num_results
		// printf("debug3: %d", num_results);

		// Call no2_search() on c6ring results
		int num_tnt_results = 0;

		if (results!=nullptr){
			no2_count(dcn, c_n_size, dno, n_o_size, results, num_results, num_tnt_results);
		}
		// Return num_tnt_results

		// printf("debug2: %d", num_tnt_results);
		d_thread_results[idx] = num_tnt_results;

		i++;
	}
}

__global__ void tnt_results(int* dcc, int* dcn, int* dno, int c_c_size, int c_n_size, int n_o_size, 
						    int* d_thread_results, int* d_thread_tnt_map, int thread_tnt_map_size, 
						    int* d_final_results, int final_result_size, int gridSize){

	//const int SHARED_DCC_SIZE = 2*c_c_size;
	//const int SHARED_DCN_SIZE = 2*c_n_size;
	//const int SHARED_DNO_SIZE = 2*n_o_size;
	//__shared__ int shared_dcc[SHARED_DCC_SIZE];
	//__shared__ int shared_dcn[SHARED_DCN_SIZE];
	//__shared__ int shared_dno[SHARED_DNO_SIZE];

	/*
	__shared__ int shared_dcc[16384];
	__shared__ int shared_dcn[];
	__shared__ int shared_dno[16384];

	for (int i=0; i<2*c_c_size; i++){
		shared_dcc[i] = dcc[i];
	}
	for (int i=0; i<2*c_n_size; i++){
		shared_dcn[i] = dcn[i];
	}
	for (int i=0; i<2*n_o_size; i++){
		shared_dno[i] = dno[i];
	}

	__syncthreads();
	*/

	int tid = blockIdx.x*blockDim.x + threadIdx.x;
	int i = 0;

	// Some threads have to take multiple tasks
	while (i*gridSize+tid < thread_tnt_map_size){

		int idx = i*gridSize + tid;

		// Find what C should this thread access
		int matching_c = d_thread_tnt_map[idx];

		// int preserve_space = d_thread_results[matching_c];
		int start = 0;
		for (int j=0; j<idx; j++){
			start = start + d_thread_results[d_thread_tnt_map[j]];
			// j=0~idx 				-> go through previous threads
			// d_thread_tnt_map[] 	-> find pos on c_c[] that has tnt
			// d_thread_results[]	-> find how many tnts for that C (~ preserved space)
		}
		// Want to write results between final_results[start : start+preserve_space]

		// Initialize visited array
		int visited[6] = {-1,-1,-1,-1,-1,-1};

		// Starting C only visits direct neighbor to avoid duplicates
		int cc_start = dcc[matching_c];
		int neighbors[1] = { dcc[matching_c+c_c_size] };

		// Call c6ring_dfs()
		int** results = nullptr;
		int num_results = 0;

		c6ring_dfs(cc_start, 0, dcc, c_c_size, visited, neighbors, 1, results, num_results);
		// Return results -> arrays of c6rings
		// Return num_results

		// printf("debug8: %d", num_results);

		// Call no2_search() on c6ring results
		int** tnt_results = nullptr;
		int num_tnt_results = 0;

		if (results!=nullptr){
			no2_search(dcn, c_n_size, dno, n_o_size, results, num_results, tnt_results, num_tnt_results);
		}
		// Return tnt_results -> arrays of tnt
		// Return num_tnt_results
		// printf("debug7: %d", num_tnt_results);

		for (int j=0; j<num_tnt_results; j++){
			for(int k=0; k<15; k++){
				d_final_results[start+j+k*final_result_size] = tnt_results[j][k];
			}
			//printf("debug \n");
		}

		i++;
	}

}

/**
 * please remember to set final_results and final_result_size 
 * before return.
 */
void tnt_counting(int num_blocks_per_grid, int num_threads_per_block,
        int* c_c, int* c_n, int* c_h, int* n_o,
        int c_c_size, int c_n_size, int c_h_size, int n_o_size,
        int* &final_results, int &final_result_size) {
    
    // Initialize
    int gridSize = num_blocks_per_grid * num_threads_per_block;
    int *dcc, *dcn, *dno;

	int *thread_results = new int[c_c_size];
	for (int i=0; i<c_c_size; i++) thread_results[i] = 0;

    int *d_thread_results;

    // Allocate vectors in device memory
    cudaMalloc((void**) &dcc, c_c_size*2*sizeof(int));
    cudaMalloc((void**) &dcn, c_n_size*2*sizeof(int));
    cudaMalloc((void**) &dno, n_o_size*2*sizeof(int));
    cudaMalloc((void**) &d_thread_results, c_c_size*sizeof(int));

    // Copy vectors from host to device global memory
    cudaMemcpy(dcc, c_c, c_c_size*2*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dcn, c_n, c_n_size*2*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dno, n_o, n_o_size*2*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_thread_results, thread_results, c_c_size*sizeof(int), cudaMemcpyHostToDevice);

    // Step1: find final_result_size, return an array of count of result among all c_c
    tnt_search <<< num_blocks_per_grid, num_threads_per_block >>> (dcc, dcn, dno, c_c_size, c_n_size, n_o_size, d_thread_results, gridSize);

    // Copy vectors from device to host
    cudaMemcpy(thread_results, d_thread_results, c_c_size*sizeof(int), cudaMemcpyDeviceToHost);

    // Set final_result_size
    for (int i=0; i<c_c_size; i++){
    	final_result_size+=thread_results[i];
    }

	// cout << "debug1: " << final_result_size << endl;

    // Initialize 
    int thread_tnt_map_size = 0;
    for (int i=0; i<c_c_size; i++){
    	if (thread_results[i]) thread_tnt_map_size++;
    }
    int thread_tnt_map[thread_tnt_map_size];
    int p=0;
    for (int i=0; i<c_c_size; i++){
    	if (thread_results[i]){
    		thread_tnt_map[p] = i;
    		p++;
    	}
    }

    final_results = new int [final_result_size*15];
    int* d_final_results, *d_thread_tnt_map;

    // Allocate vectors in device memory
    cudaMalloc((void**) &d_final_results, final_result_size*15*sizeof(int));
    cudaMalloc((void**) &d_thread_tnt_map, thread_tnt_map_size*sizeof(int));

	/* debug
	for (int i=0; i<thread_tnt_map_size; i++){
		cout << c_c[thread_tnt_map[i]] << endl;
	}*/

    // Copy vectors from host to device global memory
    cudaMemcpy(d_thread_tnt_map, thread_tnt_map, thread_tnt_map_size*sizeof(int), cudaMemcpyHostToDevice);

    // Step2: find all final_results associated with each c_c
    tnt_results <<< num_blocks_per_grid, num_threads_per_block 
    			>>> (dcc, dcn, dno, c_c_size, c_n_size, n_o_size, d_thread_results, 
					 d_thread_tnt_map, thread_tnt_map_size, d_final_results, final_result_size, gridSize);

    // Set final_results
   	// Copy vectors from device to host
    cudaMemcpy(final_results, d_final_results, final_result_size*15*sizeof(int), cudaMemcpyDeviceToHost);

	// Free host memory
	free(thread_results);

    // Free device memory
    cudaFree(dcc); 
    cudaFree(dcn);
    cudaFree(dno); 
    cudaFree(d_thread_results);
    cudaFree(d_final_results);
    cudaFree(d_thread_tnt_map);
}