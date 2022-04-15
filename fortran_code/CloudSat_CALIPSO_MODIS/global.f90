	module global

	implicit none
	!==== cloudsat 2BCLDCLASS =================
    real(kind=4),allocatable :: lon(:), lat(:),cldtime(:)
	integer(kind=2), allocatable :: dem_hgt(:)
	integer(kind=1),allocatable :: clayer(:),cphase(:,:)

	integer :: NROW

	real (kind=4), allocatable :: vis_tau(:)
 
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
        dimx=360/lonbin_res,dimy=180/latbin_res

    integer, parameter :: N645=121,N213=1200,NBT11=201,NBTD=300,Nratio=500,&
		Ntau=76
	
        !N645,ranging 0-1 with 0.01, NT11,150-350 with 1, NBTD 8.5-11 start from -5,with
        !0.1 
	real :: tau_interval(Ntau)

    integer (kind=4) :: Tspa_reflect645_num(dimx,dimy,7),& ! for reflectance
        Tspectral_rad_sza_num(6,70,7),Tspa_BT11_num(dimx,dimy,7),&
        Treflect645_pdf(N645,7),TBT11_pdf(NBT11,7),TBTD_pdf(NBTD,7),&
		Tratio_645_21(Nratio,7),TBT11_BTD_2dpdf(NBT11,NBTD,7),&
		Treflect213_pdf(N213,7),TR645_213_2dpdf_clr(N645,N213,7),&
		Ttau_reflect645_iceonly(Ntau,N645),Ttau_reflect13_iceonly(Ntau,N645),&
		Ttau_BT11_iceonly(Ntau,NBT11),Ttau_BTD_iceonly(Ntau,NBTD) ! for iceonly 2dpdf

    real (kind=4) :: Tspa_reflect645(dimx,dimy,7),& 
        Tspa_BT11(dimx,dimy,7),&
        Tspectral_rad_sza(6,70,7),&
        Tspectral_rad_sza_square(6,70,7),&
		Thetero_ratio(Nratio,7),Tmodcldfraction_ratio(Nratio,7),&
		Tmodliqfraction_ratio(Nratio,7),& ! to get the H_sigma and enviroment for the 2.1/0.645 ratio
		Thetero_reflect645(N645,7),Tmodcldfraction_reflect645(N645,7),&
		Tmodliqfraction_reflect645(N645,7),& ! to get the H_sigma and enviroment for the R_0.645 
		Thetero_BT11(NBT11,7),Tmodcldfraction_BT11(NBT11,7),&
		Tmodliqfraction_BT11(NBT11,7),& ! to get the H_sigma and enviroment for the BT11 
		Thetero_BTD(NBTD,7),Tmodcldfraction_BTD(NBTD,7),&
		Tmodliqfraction_BTD(NBTD,7),& ! to get the H_sigma and enviroment for the BTD
		TR645_213_ratio_clr(N645,N213,7)

     end
