/*
Joshua Stough
Washington and Lee University
Mergesort a random list of size given by the argument (default 1M)
Time both sequential mergesort and parallel (using Pthreads).
See https://computing.llnl.gov/tutorials/pthreads/#Designing

$ gcc -pthread -std=c99 -o mergesort parallelMergesort.c
$ ./mergesort [1000000]
*/


#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <sys/time.h>
#include <sys/mman.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>

#define DNUM 1000000
#define THREAD_LEVEL 3

//for sequential and parallel implementation
void merge(long lyst[], long back[], int low, int mid, int high);
void mergesortHelper(long lyst[], long back[], int low, int high);
void mergesort(long lyst[], int size);
int isSorted(long lyst[], int size);

//for parallel implementation
void parallelMergesort(long lyst[], int size, int tlevel);
void *parallelMergesortHelper(void *threadarg);
struct thread_data{
	long *lyst;
	long *back;
	int low;
	int high;
	int level;
};
//thread_data should be thread-safe, since while lyst and 
//back are shared, [low, high] will not overlap among threads.

//for the builtin qsort, for fun:
int compare_longs (const void *a, const void *b);

/*
Main method:
-generate random list
-time sequential mergesort
-time parallel mergesort
*/
int main (int argc, char *argv[])
{
	struct timeval start, end;
	double diff;

	srand(time(NULL)); //seed random
	
	int NUM = DNUM;
	
	if (argc < 2) {
		printf("usage: mergesort <infile> <num records>\n");
		exit(1);
	}

        char* in_file = argv[1];
        int fd = open(argv[1], O_RDONLY);

	if (argc == 3) //user specified list size.
	{
		NUM = atoi(argv[2]);
	}

	//Want to compare sorting on the same list,
	//so backup.
	//long *lystbck = (long *) malloc(NUM*sizeof(long));
	long *lystbck = (long *)mmap(NULL, NUM*sizeof(long),
                                     (PROT_READ | PROT_WRITE), MAP_PRIVATE, fd, 0);
	long *lyst = (long *) malloc(NUM*sizeof(long));
	if (lystbck == -1) {
		perror("Failed to mmap");
		exit(1);
	}
	printf("lystbck: %p, lyst: %p, size: %jd\n", lystbck, lyst, NUM*sizeof(long));
	
	//Populate random original/backup list.
	//for(int i = 0; i < NUM; i ++)
	//{
	//	lystbck[i] = 1.0*rand()/RAND_MAX;
	//}

	//copy list.
	printf("copying list...\n");
	memcpy(lyst, lystbck, NUM*sizeof(long));



	//Sequential mergesort, and timing.
	gettimeofday(&start, NULL);
	mergesort(lyst, NUM);
	gettimeofday(&end, NULL);

	if (!isSorted(lyst, NUM))
	{
		printf("Oops, lyst did not get sorted by mergesort.\n");
	}
	
	//Compute time difference.
	diff = ((end.tv_sec * 1000000 + end.tv_usec)
		  - (start.tv_sec * 1000000 + start.tv_usec))/1000000.0;
	printf("Sequential mergesort took: %lf sec.\n", diff);



	//Now, parallel mergesort.
	
	//copy list.
	memcpy(lyst, lystbck, NUM*sizeof(long));

	gettimeofday(&start, NULL);
	parallelMergesort(lyst, NUM, THREAD_LEVEL);
	gettimeofday(&end, NULL);

	if (!isSorted(lyst, NUM))
	{
		printf("Oops, lyst did not get sorted by parallelMergesort.\n");
	}
	
	//Compute time difference.
	diff = ((end.tv_sec * 1000000 + end.tv_usec)
		  - (start.tv_sec * 1000000 + start.tv_usec))/1000000.0;
	printf("Parallel mergesort took: %lf sec.\n", diff);
	

	
	//Finally, built-in for reference:
	memcpy(lyst, lystbck, NUM*sizeof(long));
	gettimeofday(&start, NULL);
	qsort(lyst, NUM, sizeof(long), compare_longs);
	gettimeofday(&end, NULL);

	if (!isSorted(lyst, NUM))
	{
		printf("Oops, lyst did not get sorted by qsort.\n");
	}
	
	//Compute time difference.
	diff = ((end.tv_sec * 1000000 + end.tv_usec)
		  - (start.tv_sec * 1000000 + start.tv_usec))/1000000.0;
	printf("Built-in qsort took: %lf sec.\n", diff);



	free(lyst);
	//free(lystbck);
	munmap(lystbck, NUM*sizeof(long));
	pthread_exit(NULL);
}


//top level sequential mergesort
void mergesort(long lyst[], int size)
{
	long *back = (long *) malloc(size*sizeof(long));
	mergesortHelper(lyst, back, 0, size-1);
	free(back);
}

//the actual C mergesort method, with back list to avoid 
//NlogN memory (2N instead).
void mergesortHelper(long lyst[], long back[], int low, int high)
{
	if (low == high) return;
	int mid = (low + high)/2;
	mergesortHelper(lyst, back, low, mid);
	mergesortHelper(lyst, back, mid+1, high);
	merge(lyst, back, low, mid, high);
}

//merge the elements from the sorted sublysts in [low, mid] and (mid, high]
void merge(long lyst[], long back[], int low, int mid, int high)
{
	int ai = low, bi = mid + 1, i = low;
	while (ai <= mid && bi <= high)
	{
		if (lyst[ai] <= lyst[bi])
		{
			back[i] = lyst[ai];
			ai ++;
		}else
		{
			back[i] = lyst[bi];
			bi ++;
		}
		i ++;
	}
	if (ai > mid)
	{
		memcpy(&back[i], &lyst[bi], (high-bi+1)*sizeof(long));
	}else
	{
		memcpy(&back[i], &lyst[ai], (mid-ai+1)*sizeof(long));
	}
	memcpy(&lyst[low], &back[low], (high-low+1)*sizeof(long));
}

//check if the elements of lyst are in non-decreasing order.
//one is success.
int isSorted(long lyst[], int size)
{
	for (int i = 1; i < size; i ++)
	{
		if (lyst[i] < lyst[i-1]) 
		{
			printf("%e < %e\n", lyst[i], lyst[i-1]);
			return 0;
		}
	}
	return 1;
}


/*
parallel mergesort top level:
instantiate parallelMergesortHelper thread, and that's 
basically it.
*/
void parallelMergesort(long lyst[], int size, int tlevel)
{
	int rc;
	void *status;

	long *back = (long *) malloc(size*sizeof(long));

	//Want joinable threads (usually default).
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

	//pthread function can take only one argument, so struct.
	struct thread_data td;
	td.lyst = lyst;
	td.back = back;
	td.low = 0;
	td.high = size - 1;
	td.level = tlevel;

	//The top-level thread.
	pthread_t theThread;
	rc = pthread_create(&theThread, &attr, parallelMergesortHelper,
						(void *) &td);
	if (rc) 
	{
    	printf("ERROR; return code from pthread_create() is %d\n", rc);
    	exit(-1);
    }

	//Now join the thread (wait, as joining blocks) and quit.
	pthread_attr_destroy(&attr);
	rc = pthread_join(theThread, &status);
	if (rc)
	{
		printf("ERROR; return code from pthread_join() is %d\n", rc);
		exit(-1);
	}
	//printf("Main: completed join with top thread having a status of %ld\n",
	//		(long)status);

	free(back);

}

/*
parallelMergesortHelper
-if the level is still > 0, then make 
parallelMergesortHelper threads to solve the left and 
right-hand sides, then merge results after joining
 and quit.
*/
void *parallelMergesortHelper(void *threadarg)
{
	int mid, t, rc;
	void *status;

	struct thread_data *my_data;
	my_data = (struct thread_data *) threadarg;
	
	//fyi:
	//printf("Thread responsible for [%d, %d], level %d.\n",
	//		my_data->low, my_data->high, my_data->level);
	
	if (my_data->level <= 0 || my_data->low == my_data->high)
	{
		//We have plenty of threads, finish with sequential.
		mergesortHelper(my_data->lyst, my_data->back, 
						my_data->low, my_data->high);
		pthread_exit(NULL);
	}

	//Want joinable threads (usually default).
	pthread_attr_t attr;
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);


	//At this point, we will create threads for the 
	//left and right sides.  Must create their data args.
	struct thread_data thread_data_array[2];
	mid = (my_data->low + my_data->high)/2;

	for (t = 0; t < 2; t ++)
	{
		thread_data_array[t].lyst = my_data->lyst;
		thread_data_array[t].back = my_data->back;
		thread_data_array[t].level = my_data->level - 1;
	}
	thread_data_array[0].low = my_data->low;
	thread_data_array[0].high = mid;
	thread_data_array[1].low = mid+1;
	thread_data_array[1].high = my_data->high;

	//Now, instantiate the threads.
	pthread_t threads[2];
	for (t = 0; t < 2; t ++)
	{
		rc = pthread_create(&threads[t], &attr, parallelMergesortHelper,
							(void *) &thread_data_array[t]);
		if (rc) 
		{
    		printf("ERROR; return code from pthread_create() is %d\n", rc);
    		exit(-1);
    	}
	}
	
	pthread_attr_destroy(&attr);
	//Now, join the left and right threads and merge.
	for (t = 0; t < 2; t ++)
	{
		rc = pthread_join(threads[t], &status);
		if (rc)
		{
			printf("ERROR; return code from pthread_join() is %d\n", rc);
			exit(-1);
		}
	}

	//Call the sequential merge now that the left and right
	//sides are sorted.
	merge(my_data->lyst, my_data->back, my_data->low, mid, my_data->high);
	
	pthread_exit(NULL);
}

//for the built-in qsort comparator
//from http://www.gnu.org/software/libc/manual/html_node/Comparison-Functions.html#Comparison-Functions
int compare_longs (const void *a, const void *b)
{
	const long *da = (const long *) a;
	const long *db = (const long *) b;
     
	return (*da > *db) - (*da < *db);
}



