!==============================================================================!
  subroutine Grid_Mod_Save_Cns(grid,        &
                               sub,         &  ! subdomain
                               nn_sub,      &  ! number of nodes in the sub. 
                               nc_sub,      &  ! number of cells in the sub. 
                               nf_sub,      &  ! number of faces in the sub.
                               ns_sub,      &  ! number of shadow faces
                               nbc_sub)
!------------------------------------------------------------------------------!
!   Writes file with connectivity data: name.cns                               !
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  type(Grid_Type) :: grid
  integer         :: sub, nn_sub, nc_sub, nf_sub, ns_sub, nbc_sub
!-----------------------------------[Locals]-----------------------------------!
  integer           :: b, c, s, n, lev, item, fu, subo, c1, c2
  character(len=80) :: name_out
!==============================================================================!

  !----------------------!
  !                      !
  !   Create .cns file   !
  !                      !
  !----------------------!
  call File_Mod_Set_Name(name_out, processor=sub, extension='.cns')
  call File_Mod_Open_File_For_Writing_Binary(name_out, fu)

  !-----------------------------------------------!
  !   Number of cells, boundary cells and faces   !
  !-----------------------------------------------!
  write(fu) nn_sub
  write(fu) nc_sub              ! new way: add buffer cells to cells
  write(fu) nbc_sub             ! number of boundary cells
  write(fu) nf_sub
  write(fu) ns_sub
  write(fu) grid % n_bnd_cond  ! number of bounary conditions
  write(fu) grid % n_levels    ! number of multigrid levels

  !------------------------!
  !   Domain (grid) name   !
  !------------------------!
  write(fu) grid % name

  !------------------------------!
  !   Boundary conditions list   !
  !------------------------------!
  do n = 1, grid % n_bnd_cond
    write(fu) grid % bnd_cond % name(n)
  end do

  !--------------------------!
  !   Nodes global numbers   !
  !--------------------------!
  do n = 1, grid % n_nodes
    if(grid % new_n(n) > 0) then
      write(fu) grid % comm % node_glo(n)
    end if
  end do

  !-----------!
  !   Cells   !  (including buffer cells)
  !-----------!

  ! Number of nodes for each cell
  do c = -grid % n_bnd_cells, grid % n_cells
    if(grid % comm % cell_proc(c) .eq. sub .or. c .eq. 0) then
      write(fu) grid % cells_n_nodes(c)
    end if
  end do
  do subo = 1, maxval(grid % comm % cell_proc(:))
    if(subo .ne. sub) then
      do c = 1, grid % n_cells
        if(grid % comm % cell_proc(c) .eq. subo .and. grid % new_c(c) > 0) then
          write(fu) grid % cells_n_nodes(c)
        end if
      end do
    end if
  end do

  ! Cells' nodes
  do c = -grid % n_bnd_cells, grid % n_cells
    if(grid % comm % cell_proc(c) .eq. sub .or. c .eq. 0) then
      do n = 1, grid % cells_n_nodes(c)
        write(fu) grid % new_n(grid % cells_n(n,c))
      end do
    end if
  end do
  do subo = 1, maxval(grid % comm % cell_proc(:))
    if(subo .ne. sub) then
      do c = 1, grid % n_cells
        if(grid % comm % cell_proc(c) .eq. subo .and. grid % new_c(c) > 0) then
          do n = 1, grid % cells_n_nodes(c)
            write(fu) grid % new_n(grid % cells_n(n,c))
          end do
        end if
      end do
    end if
  end do

  ! Cells' processor ids
  do c = -grid % n_bnd_cells, grid % n_cells
    if(grid % comm % cell_proc(c) .eq. sub .or. c .eq. 0) then
      write(fu) grid % comm % cell_proc(c)
    end if
  end do
  do subo = 1, maxval(grid % comm % cell_proc(:))
    if(subo .ne. sub) then
      do c = 1, grid % n_cells
        if(grid % comm % cell_proc(c) .eq. subo .and. grid % new_c(c) > 0) then
          write(fu) grid % comm % cell_proc(c)
        end if
      end do
    end if
  end do

  ! Cells' global indices
  do c = -grid % n_bnd_cells, grid % n_cells
    if(grid % comm % cell_proc(c) .eq. sub .or. c .eq. 0) then
      write(fu) grid % comm % cell_glo(c)
    end if
  end do
  do subo = 1, maxval(grid % comm % cell_proc(:))
    if(subo .ne. sub) then
      do c = 1, grid % n_cells
        if(grid % comm % cell_proc(c) .eq. subo .and. grid % new_c(c) > 0) then
          write(fu) grid % comm % cell_glo(c)
        end if
      end do
    end if
  end do

  !-----------!
  !   Faces   !
  !-----------!

  ! Number of nodes for each face
  do s = 1, grid % n_faces + grid % n_shadows
    if(grid % new_f(s) .ne. 0) then
      write(fu) grid % faces_n_nodes(s)
    end if
  end do

  ! Faces' nodes
  do s = 1, grid % n_faces + grid % n_shadows
    if(grid % new_f(s) .ne. 0) then
      do n = 1, grid % faces_n_nodes(s)
        write(fu) grid % new_n(grid % faces_n(n,s))
      end do
    end if
  end do

  ! Faces' cells
  do s = 1, grid % n_faces + grid % n_shadows
    c1 = grid % faces_c(1,s)
    c2 = grid % faces_c(2,s)
    if(grid % new_f(s) .ne. 0) then
      if(grid % new_c(c2) < 0 .or. grid % new_c(c1) < grid % new_c(c2)) then
        write(fu) grid % new_c(grid % faces_c(1,s)),  &
                  grid % new_c(grid % faces_c(2,s))
      else
        write(fu) grid % new_c(grid % faces_c(2,s)),  &
                  grid % new_c(grid % faces_c(1,s))
      end if
    end if
  end do

  ! Faces' shadows
  do s = 1, grid % n_faces + grid % n_shadows
    if(grid % new_f(s) .ne. 0) then
      if(grid % faces_s(s) .eq. 0) then   ! there is no shadow for this face
        write(fu) 0
      else
        write(fu) grid % new_f(grid % faces_s(s))
      end if
    end if
  end do

  !--------------!
  !   Boundary   !
  !--------------!

  ! Physical boundary cells
  do c = -grid % n_bnd_cells, -1
    if(grid % comm % cell_proc(c) .eq. sub) then
      write(fu) grid % bnd_cond % color(c)
    end if
  end do

  !----------------------!
  !   Multigrid levels   !
  !----------------------!
  do lev = 1, grid % n_levels
    write(fu) grid % level(lev) % n_cells
    write(fu) grid % level(lev) % n_faces
  end do
  do lev = 1, grid % n_levels
    write(fu) (grid % level(lev) % cell(c),     c=1,grid % n_cells)
    write(fu) (grid % level(lev) % face(s),     s=1,grid % n_faces)
    write(fu) (grid % level(lev) % coarser_c(c),c=1,grid % level(lev) % n_cells)
    write(fu) (grid % level(lev) % faces_c(1,s),s=1,grid % level(lev) % n_faces)
    write(fu) (grid % level(lev) % faces_c(2,s),s=1,grid % level(lev) % n_faces)
  end do

  close(fu)

  end subroutine
