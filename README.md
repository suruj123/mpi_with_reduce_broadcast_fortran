# mpi_with_reduce_broadcast_fortran
This code explains how to use MPI with "reduce" and "broadcast" operations for complex numbers in Fortran 90/95.
<br>
There are two codes in this repository. The serial one is "Serial_Test1.f" and the MPI one is "Test1.f90".
<br>
To compile the serial one, the commands are: F95 Serial_Test1.f and run the executable "./a.out".
<br>
The output files are "The_data_real_serial", "The_data_imaginary_serial".
<br>
To compile the MPI code, the commands are: mpif90 -Wall -o main Test1.f90 and submit the job by the "job.sh" file
<br>
To submit a job in our ANTYA Cluster at IPR, Gandhinagar, we use qsub job.sh
<br>
The output files are "The_data_real", "The_data_imaginary".
<br>
One can make a comparison in between the files obtained from the serial code and MPI parallel code.
