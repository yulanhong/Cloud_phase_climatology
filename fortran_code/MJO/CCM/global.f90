	module global
	implicit none
	!==== cloudsat 2BCLDCLASS =================
	real(kind=4),allocatable :: lon(:), lat(:),cldtime(:)
	real :: cldutc_start
	integer(kind=2),allocatable :: dem_hgt(:)
	integer(kind=1),allocatable :: clayer(:),cphase(:,:)

	integer :: NROW, NCOL_S

	!=== MODIS ========================
	!=== mod02=====================
	integer :: modNrow, modNcol
	real (kind=4),allocatable :: rad_250(:,:,:),rad_500(:,:,:),&
		rad_1000(:,:,:),rad_1000emis(:,:,:)	
	!=== mod03 ==============
	real (kind=4), allocatable :: modlat(:,:), modlon(:,:)
	real (kind=4), allocatable :: solarzenith(:,:)
	integer (kind=1), allocatable :: landsea(:,:)
	!==== mod06 ======================
	real (kind=4), allocatable :: cld_spi(:,:,:)
	integer (kind=1), allocatable :: modcldphase(:,:)
	!=====output=================================
    integer, parameter :: latbin_res=2.0,lonbin_res=5.0,&
    dimx=360/lonbin_res,dimy=180/latbin_res,Nmon=12,dimh=125


	integer, parameter :: Ninterval=800

	integer (kind=4) :: Tspa_heteronum(dimx,dimy,8,6),&  ! for 8 MJO phase
         Tcldphase_fre(6,8),Thetero_pdf(Ninterval,8) ! in the subarea,clr+5cldphase, 8 MJO phase
	real (kind=4) :: Tspa_hetero(dimx,dimy,8,6)

	real :: hetero_x(Ninterval)

	end
