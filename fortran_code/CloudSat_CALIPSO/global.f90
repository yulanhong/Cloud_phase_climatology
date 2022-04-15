        module global

        implicit none

        !===== cloudsat  ===========================
        real(kind=4),allocatable :: cbase(:,:),ctop(:,:),wc_top(:,:)
        real(kind=4),allocatable :: lon(:), lat(:)
        integer(kind=1),allocatable :: clayer(:),cphase(:,:)
              !  preci_flag(:,:)
	integer(kind=2),allocatable :: map_hgt(:)
	real(kind=4), allocatable :: uwind(:,:),vwind(:,:),surf_t(:),&
		prof_p(:,:),surf_p(:),prof_t(:,:)

        integer :: NROW,NCOL_S
        integer :: year,month,Julday,mon_scp
!        common /file_info/ NROW,NCOL_S

        !=====output=================================
        integer, parameter :: latbin_res=2,lonbin_res=5,dimx=360/lonbin_res,&
        dimy=180/latbin_res,Nmon=1,dimh=101,Ntemp=60

	real :: height(dimh)

        integer (kind=1) :: wmon(Nmon)
        integer (kind=4) :: obsnum(dimx,dimy,Nmon),&
       ! preci_fre(dimx,dimy,3,Nmon),
	OneLay_fre(dimx,dimy,3,Nmon),&
        MulLay_1fre(dimx,dimy,3,Nmon),MulLay_nfre(dimx,dimy,3,Nmon),&
	obsnumv(dimx,dimy,dimh,Nmon),&
	allcld_frev(dimx,dimy,dimh,Nmon),&
	onelay_frev(dimx,dimy,dimh,Nmon),&
	onelayic_frev(dimx,dimy,dimh,Ntemp,Nmon),& ! for one layer ice 
	onelaymc_frev(dimx,dimy,dimh,Ntemp,Nmon),& ! for mixed cloud
	liqnoice_frev(dimx,dimy,dimh,Ntemp,Nmon),&

	mullay_frev(dimx,dimy,dimh,Nmon),&
	mullayic_frev(dimx,dimy,dimh,Ntemp,Nmon),&
	icemix_frev(dimx,dimy,dimh,Ntemp,Nmon),&
	liqice_frev(dimx,dimy,dimh,Ntemp,Nmon),&		
	liqice_freh(dimx,dimy,2,Nmon) ! to record mult-lay liquid under ice 

        integer (kind=4) :: Tobsnum(dimx,dimy,Nmon),&
        !Tpreci_fre(dimx,dimy,3,Nmon),
	TOneLay_fre(dimx,dimy,3,Nmon),&
        TMulLay_1fre(dimx,dimy,3,Nmon),TMulLay_nfre(dimx,dimy,3,Nmon),&
	Tobsnumv(dimx,dimy,dimh,Nmon),&
	Tallcld_frev(dimx,dimy,dimh,Nmon),&
	Tonelay_frev(dimx,dimy,dimh,Nmon),&
	Tonelayic_frev(dimx,dimy,dimh,Ntemp,Nmon),&	
	Tonelaymc_frev(dimx,dimy,dimh,Ntemp,Nmon),&	

	Tmullay_frev(dimx,dimy,dimh,Nmon),&
	Tmullayic_frev(dimx,dimy,dimh,Ntemp,Nmon),&
	Tliqnoice_frev(dimx,dimy,dimh,Ntemp,Nmon),&
	Tliqice_frev(dimx,dimy,dimh,Ntemp,Nmon),&
	Ticemix_frev(dimx,dimy,dimh,Ntemp,Nmon),&	
	Tliqice_freh(dimx,dimy,2,Nmon) ! 0-one layer,1-multi-layer 

        real (kind=4) :: sum_onelaytopH(dimx,dimy,3,Nmon),&
                All_onelaytopH(dimx,dimy,3,Nmon),&
                sum_onelaybaseH(dimx,dimy,3,Nmon),&
                All_onelaybaseH(dimx,dimy,3,Nmon),&
		onelay_surf_p(dimx,dimy,3,Nmon),&
		onelay_surf_T(dimx,dimy,3,Nmon),&
		onelay_surf_u(dimx,dimy,3,Nmon),&
		onelay_surf_v(dimx,dimy,3,Nmon),&
		allonelay_surf_p(dimx,dimy,3,Nmon),&
		allonelay_surf_T(dimx,dimy,3,Nmon),&
		allonelay_surf_u(dimx,dimy,3,Nmon),&
		allonelay_surf_v(dimx,dimy,3,Nmon),&
		
                sum1_mullaytopH(dimx,dimy,3,Nmon),& ! multi layer, one phase
                All1_mullaytopH(dimx,dimy,3,Nmon),&
                sum1_mullaybaseH(dimx,dimy,3,Nmon),& ! multi layer, one phase
                All1_mullaybaseH(dimx,dimy,3,Nmon),&
		mullay_1surf_p(dimx,dimy,3,Nmon),&
		mullay_1surf_T(dimx,dimy,3,Nmon),&
		mullay_1surf_u(dimx,dimy,3,Nmon),&
		mullay_1surf_v(dimx,dimy,3,Nmon),&
		allmullay_1surf_p(dimx,dimy,3,Nmon),&
		allmullay_1surf_T(dimx,dimy,3,Nmon),&
		allmullay_1surf_u(dimx,dimy,3,Nmon),&
		allmullay_1surf_v(dimx,dimy,3,Nmon),&
       
                sumn_lowlaytopH(dimx,dimy,3,Nmon),& ! multi layer, N phases
                Alln_lowlaytopH(dimx,dimy,3,Nmon),&
                
                sumn_lowlaybaseH(dimx,dimy,3,Nmon),& ! multi layer, N phases
                Alln_lowlaybaseH(dimx,dimy,3,Nmon),&
               
                sumn_uplaytopH(dimx,dimy,3,Nmon),& ! multi layer, N phases
                Alln_uplaytopH(dimx,dimy,3,Nmon),&

                sumn_uplaybaseH(dimx,dimy,3,Nmon),& ! multi layer, N phases
                Alln_uplaybaseH(dimx,dimy,3,Nmon),&

		mullay_nsurf_p(dimx,dimy,3,Nmon),&
		mullay_nsurf_T(dimx,dimy,3,Nmon),&
		mullay_nsurf_u(dimx,dimy,3,Nmon),&
		mullay_nsurf_v(dimx,dimy,3,Nmon),&
		allmullay_nsurf_p(dimx,dimy,3,Nmon),&
		allmullay_nsurf_T(dimx,dimy,3,Nmon),&
		allmullay_nsurf_u(dimx,dimy,3,Nmon),&
		allmullay_nsurf_v(dimx,dimy,3,Nmon),&

		liqice_liqtop(dimx,dimy,2,Nmon),&
		allliqice_liqtop(dimx,dimy,2,Nmon),&
		
		mean_surf_p(dimx,dimy,Nmon),&
		mean_surf_T(dimx,dimy,Nmon),&
		mean_surf_u(dimx,dimy,Nmon),&
		mean_surf_v(dimx,dimy,Nmon),&
		allmean_surf_p(dimx,dimy,Nmon),&
		allmean_surf_T(dimx,dimy,Nmon),&
		allmean_surf_u(dimx,dimy,Nmon),&
		allmean_surf_v(dimx,dimy,Nmon),&
	
		DEM_elevation(dimx,dimy),&
		allDem_elevation(dimx,dimy)
 
	! for vertical distribution
		
       end module

