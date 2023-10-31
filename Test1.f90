

        program complex_run
        include 'mpif.h'
        !implicit none
        integer numtasks, ierr
        integer taskid, cellpercore, dummy, first
        integer nx, ny, nz, n;
        integer ngx, ngy,  ngz;
        real(8) xg(8+1), yg(8+1), zg(8+1)
        real(8) mm1X(512), mm1Y(512), mm1Z(512)
        real(8) Lx, Ly, Lz
        real(8) gridth_width_x, gridth_width_y, gridth_width_z
        complex(8), dimension(512) :: complex_values
        complex(8), dimension(512) :: fcomplex_values
        !complex complex_values(256)
        parameter(ngx = 8)
        parameter(ngy = 8)
        parameter(ngz = 8)
        parameter(Lx = 10.0)
        parameter(Ly = 10.0)
        parameter(Lz = 10.0)
        parameter(cellpercore = 16)



        call MPI_INIT(ierr)
        call MPI_COMM_RANK(MPI_COMM_WORLD, taskid, ierr)
        call MPI_COMM_SIZE(MPI_COMM_WORLD, numtasks, ierr)

        if (taskid .eq. 0) then
        open(10,file='The_data_real',status='unknown')
        open(20,file='The_data_imaginary',status='unknown')
        endif


        gridth_width_x = Lx/ngx;
        gridth_width_y = Ly/ngy;
        gridth_width_z = Lz/ngz;


        do nx = 1, ngx
        xg(nx) = (nx-0.5)*gridth_width_x - 0.5*Lx;
        end do

        do ny = 1, ngy
        yg(ny) = (ny-0.5)*gridth_width_y - 0.5*Ly;
        end do

        do nz = 1, ngz
        zg(nz) = (nz-0.5)*gridth_width_z - 0.5*Lz;
        end do

        c = 0
        cc = 0
 

      do i = 1, numtasks -1

        do nz = 1, ngz

          do ny = 1, ngy

           do nx = 1, ngx

             cc = cc+1

             if(cc .eq. (taskid*cellpercore+1)) then

               first = ((nz-1)*ngy + ny-1)*ngx + nx;
        
             end if

           end do

          end do

        end do
       
      end do


       do nz = 1, ngz

         do ny = 1, ngy

           do nx = 1, ngx

           i = ((nz-1)*ngy + ny-1)*ngx + nx;
              
           mm1Z(i) = nz
           mm1Y(i) = ny
           mm1X(i) = nx

           end do

        end do
       
      end do


! for(dummy = first ; dummy < first + cellpercore; dummy ++){
      do dummy = first, first + cellpercore -1

      fcomplex_values(dummy) & 
      = dcmplx(xg(mm1X(dummy))*yg(mm1Y(dummy))*zg(mm1Z(dummy)),&
      0.5*xg(mm1X(dummy)))

      end do


        call MPI_Reduce(fcomplex_values, complex_values, 512,&
         MPI_DOUBLE_COMPLEX, MPI_SUM, 0, MPI_COMM_WORLD, ierr)

      


        if (taskid .eq. 0) then


         do nx = 1, ngx

           do ny = 1, ngy

            do nz = 1, ngz

             n = ((nz - 1 )*ngy + (ny - 1 ))*ngx + nx;

                if(nx .eq. (0.5*ngx)) then

                   if(ny .eq. (0.5*ngy)) then

        write(10, *) real(complex_values(n)) ,zg(nz)
        write(20, *) aimag(complex_values(n)), zg(nz)

                   end if

                end if

            end do

           end do

         end do


       end if



       call MPI_Bcast(complex_values, 512, MPI_DOUBLE_COMPLEX, 0, &
        MPI_COMM_WORLD, ierr)

      call MPI_FINALIZE(ierr)
      end program complex_run


