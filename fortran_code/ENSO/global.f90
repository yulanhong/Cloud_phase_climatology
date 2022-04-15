	module global
	implicit none
	!=== MODIS ========================
	!=== mod03=====================
	integer :: modNrow, modNcol
	real (kind=4), allocatable :: modlat(:,:), modlon(:,:)
	real (kind=4), allocatable :: solarzenith(:,:)
	integer (kind=1), allocatable :: landsea(:,:)
	!==== mod02 ======================
	real (kind=4), allocatable :: rad_250(:,:,:),rad_1000emis(:,:,:)
	!===== output =========================

	integer (kind=4) :: Tmodis_obsnum(360,180)

	real (kind=4) :: Tmodis_r645(360,180),Tmodis_bt11(360,180)

	end
