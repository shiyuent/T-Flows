!==============================================================================!
  subroutine User_Mod_Beginning_Of_Correct_Velocity(grid, dt, ini)
!------------------------------------------------------------------------------!
!   This function is called at the beginning of Correct_Velocity function.     !
!------------------------------------------------------------------------------!
!----------------------------------[Modules]-----------------------------------!
  use Grid_Mod
  use Flow_Mod
!------------------------------------------------------------------------------!
  implicit none
!---------------------------------[Arguments]----------------------------------!
  type(Grid_Type) :: grid
  real            :: dt    ! time step    
  integer         :: ini   ! iner itteration
!==============================================================================!

  end subroutine
