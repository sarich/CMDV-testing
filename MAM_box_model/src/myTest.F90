program myTest

  use driver

  use shr_kind_mod,            only: r8 => shr_kind_r8
  use abortutils,              only: endrun
  use cam_history,             only: ncol_for_outfld
  use cam_logfile,             only: iulog
  use ppgrid,                  only: pcols, pver
  use wv_saturation,           only: ncol_for_qsat
  use modal_aero_data,         only: ntot_amode


  ! from run
  use shr_kind_mod, only: r8 => shr_kind_r8
  use abortutils, only: endrun
  use cam_logfile, only: iulog
  use chem_mods, only: adv_mass, gas_pcnst, imozart
  use physconst, only: mwdry
  use ppgrid, only: pcols, pver
  use physics_types, only: physics_state, physics_ptend
  use physics_buffer, only: physics_buffer_desc

  use modal_aero_data
  use modal_aero_calcsize, only: modal_aero_calcsize_sub
  use modal_aero_amicphys, only: modal_aero_amicphys_intr, &
      gaexch_h2so4_uptake_optaa, newnuc_h2so4_conc_optaa, mosaic
  use modal_aero_wateruptake, only: modal_aero_wateruptake_dr
  use gaschem_simple, only: gaschem_simple_sub
  use cloudchem_simple, only: cloudchem_simple_sub

!     implicit none

  integer, parameter :: ncolxx = min( pcols, 10 )
  integer  :: ncol
  integer  :: nstop

  real(r8) :: deltat
  real(r8) :: t(pcols,pver)      ! Temperature in Kelvin
  real(r8) :: pmid(pcols,pver)   ! pressure at model levels (Pa)
  real(r8) :: pdel(pcols,pver)   ! pressure thickness of levels
  real(r8) :: zm(pcols,pver)     ! midpoint height above surface (m)
  real(r8) :: pblh(pcols)        ! pbl height (m)
  real(r8) :: relhum(pcols,pver) ! layer relative humidity
  real(r8) :: qv(pcols,pver)     ! layer specific humidity
  real(r8) :: cld(pcols,pver)    ! stratiform cloud fraction

  real(r8) :: q(pcols,pver,pcnst)     ! Tracer MR array
  real(r8) :: qqcw(pcols,pver,pcnst)  ! Cloudborne aerosol MR array
  real(r8) :: dgncur_a(pcols,pver,ntot_amode)
  real(r8) :: dgncur_awet(pcols,pver,ntot_amode)
  real(r8) :: qaerwat(pcols,pver,ntot_amode)
  real(r8) :: wetdens(pcols,pver,ntot_amode)

  ! my dec
  type(physics_state)                        :: state       ! Physics state variables
  type(physics_ptend)                        :: ptend       ! indivdual parameterization tendencies
  type(physics_buffer_desc),   pointer       :: pbuf(:)     ! physics buffer
  logical :: dotend(pcnst)   
  real(r8) :: dqdt(pcols,pver,pcnst)   
  
  real :: a = 1
  real :: b = 2

  ! Set values
  

  ncol = ncolxx
  ncol_for_outfld = ncol
  ncol_for_qsat = ncol

      write(lun_outfld,'(/a,i5)') 'istep = ', -1

      iulog = 91
      write(*,'(/a)') '*** myTest ***'

      write(*,'(/a)') '*** main init'
      call cambox_init_basics( ncol )

      iulog = 92
      write(*,'(/a)') '*** main calling cambox_init_run'
      call cambox_init_run( &
         ncol, nstop, deltat, t, pmid, pdel, zm, pblh, cld, relhum, qv, &
         q, qqcw, dgncur_a, dgncur_awet, qaerwat, wetdens        )
         
         
    ! my part

      dotend = .false.
    
      state%lchnk = lchnk
      state%ncol = ncol
      state%t = t
      state%pmid = pmid
      state%pdel = pdel
      state%q = q
      ! load ptend
      ptend%lq = dotend
      ptend%q = dqdt
      ! load pbuf
      call load_pbuf( &
         ncol, nstop, deltat, t, pmid, pdel, zm, pblh, cld, relhum, qv, &
         q, qqcw, dgncur_a, dgncur_awet, qaerwat, wetdens        )

         ! call calcsize
         !     subr modal_aero_calcsize_sub( state, ptend, deltat, pbuf, &
         !        do_adjust_in, do_aitacc_transfer_in )
      write(*,'(/a)') '*** main calling modal_aero_calcsize'   
      call modal_aero_calcsize_sub( state, ptend, deltat, pbuf, &
         do_adjust_in=.true., do_aitacc_transfer_in=.true. )

         ! unload ptend
      dotend = ptend%lq
      dqdt = ptend%q
      ! unload pbuf
      call unload_pbuf( &
         ncol, nstop, deltat, t, pmid, pdel, zm, pblh, cld, relhum, qv, &
         q, qqcw, dgncur_a, dgncur_awet, qaerwat, wetdens        )
    
    ! end my part     
         
    write(*,'(/a)') '*** main dump data ***'

    write(*,'(/a)') '*** main read data ***'
    write(*,'(/a)') '*** main compare data ***'
!      iulog = 93
 !     write(*,'(/a)') '*** main calling cambox_do_run'
 !      call cambox_do_run( &
!          ncol, nstop, deltat, t, pmid, pdel, zm, pblh, cld, relhum, qv, &
!          q, qqcw, dgncur_a, dgncur_awet, qaerwat, wetdens        )

 
  call myOut(a,b)       

  write(*,'(/a)') '*** main dump ***'
  call dump(ncol, nstop, deltat, t, pmid, pdel, zm, pblh, cld, relhum, qv, &
         q, qqcw, dgncur_a, dgncur_awet, qaerwat, wetdens , pcnst, pver)
  write(*,'(/a)') '*** main done ***'
  
contains 
  
  SUBROUTINE myOut(SUM,SUMSQ)
  REAL SUM, SUMSQ
  PRINT *,'The sum of the numbers you entered are: ',SUM
  PRINT *,'And the square of the sum is:',SUMSQ
  RETURN
  END SUBROUTINE myOut   
  
  subroutine dump(ncol, nstop, deltat, t, pmid, pdel, zm, pblh, cld, relhum, qv, &
         qin, qqcw, dgncur_a, dgncur_awet, qaerwat, wetdens , pcnst , pver)
    
    integer :: itmb , i , k , l
    integer :: lun
    ! real    :: deltat ! allready declared 
    character :: tmpch80
    
    
    ! passed arguments grouped by type and sorted alphabetical
    integer , intent(in) :: pcnst , pver
    integer , intent(in) :: ncol, nstop 
         
         
    
    real(8)  , intent(in) ::  deltat
    real(r8) , intent(in) ::  cld(pcols,pver) , &
                              dgncur_a(pcols,pver,ntot_amode) , &
                              dgncur_awet(pcols,pver,ntot_amode)
    real(r8) , intent(in) ::  pblh(pcols) 
    real(r8) , intent(in) ::  pdel(pcols,pver) 
    real(r8) , intent(in) ::  pmid(pcols,pver) 
    real(r8) , intent(in) ::  qaerwat(pcols,pver,ntot_amode) , &
                              qin(pcols,pver,pcnst) , &
                              qqcw(pcols,pver,pcnst)
    real(r8) , intent(in) ::  qv(pcols,pver)
    real(r8) , intent(in) ::  relhum(pcols,pver)    
    real(r8) , intent(in) ::  t(pcols,pver)
    real(r8) , intent(in) ::  wetdens(pcols,pver,ntot_amode) , &
                              zm(pcols,pver)
           ! pbl height (m)
    
    ! make local copy - not sure how to pass it as a non returnable but changeable argument to the subroutine
    real(r8)   :: q(pcols,pver,pcnst) 
    
    
   
    !!!!! why is this not working ? 
    ! real(r8) , intent(in) :: q(:) , dgncur_a(:)
    
    ! used in this subroutine
    ! deltat
    ! istep
    ! itmpa
    ! itmpb
    ! iwrite3x_units_flagaa
    ! l
    ! lmz_so4_a1
    ! lun
    ! mwdry
    ! ncol
    ! pcnst     
    ! pver
    ! tmpa
    ! tmpch80
    
    ! copy qin to q , will be modified
    q = qin 
    ! Setting lun to 6 , lun will be channel number and 6 is STDOUT
    lun = 6
    
    ! initial variables 
    nacc = modeptr_accum
    l_num_a1 = numptr_amode(nacc)
    l_so4_a1 = lptr_so4_a_amode(nacc)
    nait = modeptr_aitken
    l_num_a2 = numptr_amode(nait)
    
    ! apply tendencies
          itmpb = 0
          do l = 1, pcnst
             itmpa = 0
             if ( .not. dotend(l) ) cycle
             do k = 1, pver
             do i = 1, ncol
                if (abs(dqdt(i,k,l)) > 1.0e-30_r8) then
    !              write(lun,'(2a,2i4,1p,2e10.2)') &
    !                 'calcsize tend > 0   ', cnst_name(l), i, k, &
    !                 q(i,k,l), dqdt(i,k,l)*deltat
                   itmpa = itmpa + 1
                end if
                q(i,k,l) = q(i,k,l) + dqdt(i,k,l)*deltat
                q(i,k,l) = max( q(i,k,l), 0.0_r8 )
             end do
             end do
             if (itmpa > 0) then
                write(lun,'(2a,i7)') &
                   'calcsize tend > 0   ', cnst_name(l), itmpa
                itmpb = itmpb + 1
             end if
          end do
          write(*,*) "Lun = " , lun
          if (itmpb > 0) then
             write(lun,'(a,i7)') 'calcsize tend > 0 for nspecies =', itmpb
          else
             write(lun,'(a,i7)') 'calcsize tend = 0 for all species'
          end if

          do i = 1, ncol
          lun = 29 + i
          write(lun,'(/a,i8)') 'cambox_do_run doing calcsize, istep=', istep
          if (itmpb > 0) then
             write(lun,'(a,i7)') 'calcsize tend > 0 for nspecies =', itmpb
          else
             write(lun,'(a,i7)') 'calcsize tend = 0 for all species'
          end if
          if (iwrite3x_units_flagaa >= 10) then
             tmpch80 = '  (#/mg,  nmol/mol,  nm)'
             tmpa = 1.0e9*mwdry/adv_mass(lmz_so4_a1)
          else
             tmpch80 = '  (#/mg,  ug/kg,  nm)'
             tmpa = 1.0e9
          end if
          write(lun,'( 2a)') &
             'k, accum num, so4, dgncur_a, same for aitken', trim(tmpch80)
          do k = 1, pver
          
  
          write(*,*) i,k,l_num_a1 , l_num_a2 , tmpa , nacc , nait , l_so4_a1 , l_so4_a2, 'yeah'
          write(*,*) k, &
              q(i,k,l_num_a1)*1.0e-6, q(i,k,l_so4_a1)*tmpa, dgncur_a(i,k,nacc)*1.0e9 , &
              q(i,k,l_num_a2)*1.0e-6 , q(i,k,l_so4_a2)*tmpa
         
          write(*,'( i3,i4,1p,4(2x,3e12.4))') lun, k, &
              q(i,k,l_num_a1)*1.0e-6, q(i,k,l_so4_a1)*tmpa, dgncur_a(i,k,nacc)*1.0e9, &
              q(i,k,l_num_a2)*1.0e-6, q(i,k,l_so4_a2)*tmpa, dgncur_a(i,k,nait)*1.0e9  
            
          write(lun,'( i4,1p,4(2x,3e12.4))') k, &
             q(i,k,l_num_a1)*1.0e-6, q(i,k,l_so4_a1)*tmpa, dgncur_a(i,k,nacc)*1.0e9, &
             q(i,k,l_num_a2)*1.0e-6, q(i,k,l_so4_a2)*tmpa, dgncur_a(i,k,nait)*1.0e9
          end do
          end do ! i

    
    
    return
  end subroutine dump  
  
end program myTest 



    