!==============================================================================!
!                                    neu_hex                                   !
!                                                                              !
!                      7-----------8             7-----------8                 !
!                     /|          /|            /|          /|                 !
!                    /           / |           /    (6)    / |                 !
!                   /  |    (3) /  |          /  |        /  |                 !
!                  5-----------6   |         5-----------6   |                 !
!                  |(4)|       |(2)|         |   |       |   |                 !
!                  |   3- - - -|- -4         |   3- - - -|- -4                 !
!                  |  / (1)    |  /          |  /        |  /                  !
!                  |           | /           |      (5)  | /                   !
!                  |/          |/            |/          |/                    !
!                  1-----------2             1-----------2                     !
!                                                                              !
!                  (3) and (4) are behind                                      !
!------------------------------------------------------------------------------!
!                                   neu_tet                                    !
!                                                                              !
!                          4-----3                   4-----3                   !
!                         / \  .'|                  / \  .'|                   !
!                        /(4)\(3)|                 /   \'  |                   !
!                       /  .' \  |                /  .' \  |                   !
!                      / .' (1)\ |               / .(2)  \ |                   !
!                     /.'       \|              /.'       \|                   !
!                    1-----------2             1-----------2                   !
!                                                                              !
!                    (1) and (4) are behind                                    !
!------------------------------------------------------------------------------!
!                                  neu_wed                                     !
!                                                                              !
!                        6.                        6.                          !
!                       /| `.                     /| `.                        !
!                      /     `.                  / (5) `.                      !
!                     /  |     `.               /  |     `.                    !
!                    4-----------5             4-----------5                   !
!                    |(3)|  (2)  |             |   |       |                   !
!                    |   3.      |             |   3.      |                   !
!                    |  / (1)    |             |  /  `.    |                   !
!                    |       `.  |             |   (4) `.  |                   !
!                    |/        `.|             |/        `.|                   !
!                    1-----------2             1-----------2                   !
!                                                                              !
!                    (2), (3) and (4) are behind                               !
!                                                                              !
!------------------------------------------------------------------------------!
!                                   neu_pyr                                    !
!                                                                              !
!                                     .5.                                      !
!                                   .'/ \`.                                    !
!                                 .' /   \ `.                                  !
!                               .'  / (4) \  `.                                !
!                             .'(5)/       \(3)`.                              !
!                           3' - -/- - - - -\- - `4                            !
!                           |    /    (2)    \    |                            !
!                           |   /             \   |                            !
!                           |  /      (1)      \  |                            !
!                           | /                 \ |                            !
!                           |/                   \|                            !
!                           1---------------------2                            !
!                                                                              !
!                           (4) is behind                                      !
!                                                                              !
!------------------------------------------------------------------------------!
!   Note:
! 
!   neu_tet, neu_pyr, neu_wed and neu_hex hold -1 where unused 
!==============================================================================!

  ! tet cell faces nodal connections
  integer, parameter, dimension(6, 4) ::      neu_tet =           &
                               transpose(reshape( (/ 1, 2, 3,-1,  &
                                                     1, 4, 2,-1,  &
                                                     2, 4, 3,-1,  &
                                                     3, 4, 1,-1,  &
                                                    -1,-1,-1,-1,  &
                                                    -1,-1,-1,-1  /), (/4, 6/) ))

  ! hex cell faces nodal connections
  integer, parameter, dimension(6, 4) ::     neu_hex =            &
                               transpose(reshape( (/ 1, 5, 6, 2,  &
                                                     2, 6, 8, 4,  &
                                                     4, 8, 7, 3,  &
                                                     3, 7, 5, 1,  &
                                                     1, 2, 4, 3,  &
                                                     5, 7, 8, 6  /), (/4, 6/) ))

  ! wed cell faces nodal connections
  integer, parameter, dimension(6, 4) ::     neu_wed =            &
                               transpose(reshape( (/ 1, 4, 5, 2,  &
                                                     2, 5, 6, 3,  &
                                                     3, 6, 4, 1,  &
                                                     1, 2, 3,-1,  &
                                                     4, 6, 5,-1,  &
                                                    -1,-1,-1,-1  /), (/4, 6/) ))

  ! pyr cell faces nodal connections
  integer, parameter, dimension(6, 4) ::     neu_pyr =            &
                               transpose(reshape( (/ 1, 2, 4, 3,  &
                                                     1, 5, 2,-1,  &
                                                     2, 5, 4,-1,  &
                                                     4, 5, 3,-1,  &
                                                     3, 5, 1,-1,  &
                                                    -1,-1,-1,-1  /), (/4, 6/) ))