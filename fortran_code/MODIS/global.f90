	module global
	implicit none
	!=== MODIS ========================
	!=== mod03=====================
	integer :: modNrow, modNcol
	real (kind=4), allocatable :: modlat(:,:), modlon(:,:)
	real (kind=4), allocatable :: solarzenith(:,:),sensorzenith(:,:)
	integer (kind=1), allocatable :: landsea(:,:)
	!==== mod06 ======================
	real (kind=4), allocatable :: cld_spi(:,:,:)
	integer (kind=1), allocatable :: modcldphase(:,:)
	!===== output =========================
	integer,parameter :: Ninterval=800
	real :: hetero_x(Ninterval)

	integer (kind=4) :: Tmodis_clrnum(360,180), Tmodis_liqnum(360,180),&
		Tmodis_icenum(360,180), Tmodis_undernum(360,180),&
		Tmodis_obsnum(360,180),Thetero_pdf(Ninterval,6) 

	real (kind=4) :: Tmodcldfraction(Ninterval,6),Tmodliqfraction(Ninterval,6) ! dimension means same as Thetero_pdf
	real (kind=4) :: Tmodis_clrhetero(360,180), Tmodis_liqhetero(360,180),&
		Tmodis_icehetero(360,180), Tmodis_underhetero(360,180),Tmodis_obshetero(360,180) 

	end
