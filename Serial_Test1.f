

        program complex_run
        implicit none

        integer nx, ny, nz, n;
        integer ngx, ngy,  ngz, first, dummy;
        real(8) xg(8+1), yg(8+1), zg(8+1)
        real(8) Lx, Ly, Lz
        real(8) gridth_width_x, gridth_width_y, gridth_width_z
        complex(8), dimension(512) :: complex_values 
        !complex complex_values(256)
        parameter(ngx = 8)
        parameter(ngy = 8)
        parameter(ngz = 8)
        parameter(Lx = 10.0)
        parameter(Ly = 10.0)
        parameter(Lz = 10.0)

        gridth_width_x = Lx/ngx;
        gridth_width_y = Ly/ngy;
        gridth_width_z = Lz/ngz;

        open(10,file='The_data_real_serial',status='unknown')
        open(20,file='The_data_imaginary_serial',status='unknown')
        
        write(*,*)  gridth_width_x

        do nx = 1, ngx
        xg(nx) = (nx-0.5)*gridth_width_x - 0.5*Lx;
        end do

        do ny = 1, ngy
        yg(ny) = (ny-0.5)*gridth_width_y - 0.5*Ly;
        end do

        do nz = 1, ngz
        zg(nz) = (nz-0.5)*gridth_width_z - 0.5*Lz;
        end do


        do nx = 1, ngx

          do ny = 1, ngy

           do nz = 1, ngz

            n = ((nz - 1 )*ngy + (ny - 1 ))*ngx + nx;

        complex_values(n) = dcmplx(xg(nx)*yg(ny)*zg(nz),0.5*xg(nx))

           end do

          end do

        end do



        do nx = 1, ngx

          do ny = 1, ngy

           do nz = 1, ngz

            n = ((nz - 1 )*ngy + (ny - 1 ))*ngx + nx;

                if(nx .eq. (0.5*ngx)) then

                   if(ny .eq. (0.5*ngy)) then

        write(10, *) real(complex_values(n)) ,zg(nz)
        write(20, *) aimag(complex_values(n)), zg(nz)
                !write(*,*)       zg(nz)
        
                   end if

                end if

           end do

          end do

        end do


        !stop
        end program complex_run
