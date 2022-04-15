	module global
	implicit none


	!=== MODIS ========================
	integer :: modNrow, modNcol
	!=== mod02 ==============
	real (kind=4), allocatable :: rad_250(:,:,:),rad_1000emis(:,:,:)
	!=== mod03 ==============
	real (kind=4), allocatable :: modlat(:,:), modlon(:,:)
	real (kind=4), allocatable :: solarzenith(:,:),sensorzenith(:,:)
	integer (kind=1), allocatable :: landsea(:,:)
	!==== mod06 ======================
	real (kind=4), allocatable :: cld_spi(:,:,:)
	integer (kind=1), allocatable :: modcldphase(:,:)
	!=====output=================================
    integer, parameter :: latbin_res=1.0,lonbin_res=1.0,&
    dimx=360/lonbin_res,dimy=180/latbin_res


	integer, parameter :: Ninterval=800

	integer (kind=4) :: Tspa_heteronum(dimx,dimy,8),&  ! for 8 MJO phase
         Tcldphase_fre(5,8),Thetero_pdf(Ninterval,8) ! in the subarea,clr+5cldphase, 8 MJO phase
	real (kind=4) :: Tspa_hetero(dimx,dimy,8),Tspa_reflect645(dimx,dimy,8),&
		Tspa_BT11(dimx,dimy,8)

	real :: hetero_x(Ninterval)

	end
