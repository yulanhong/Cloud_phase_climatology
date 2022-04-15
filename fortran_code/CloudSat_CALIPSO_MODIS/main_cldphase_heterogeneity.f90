	program main_cldphase_heterogeneity

	use global

	implicit none

	include 'mpif.h'

	!*********** initialze *****************
	character(len=200) :: classdir,mod02dir,mod03dir,mod06dir
	character(len=250) :: classfname,c2icefname,wfname
	character(len=3) :: strday
	character(len=4) :: yrindex
	character(len=5) :: swath_num
	character(len=6) :: cld_date
	character(len=67) :: myday
	character(len=67), allocatable :: file_list(:)
	character(len=97), allocatable :: mod02_list(:)
	character(len=91), allocatable :: mod03_list(:)
	character(len=94), allocatable :: mod06_list(:)
	character(len=91) :: mod03fname
	character(len=94) :: mod06fname
	character(len=97) :: mod02fname

 	integer (kind=2) :: Nfname,mod02_nfname,mod03_nfname,mod06_nfname
    integer (kind=4) :: status
	logical :: mod03flag,mod04flag,c2ice_flag
    integer :: values(8)

	!*********** initalize for cloudsat and calipso match*******
	!================== cloudsat =========================
	integer :: si,modfi,nsize
	real :: cld_start_utc,cld_start_hh,cld_start_min,cld_start_sec	
	real :: tpcldtime,tpcldlat,tpcldlon
	integer :: lat_scp, lon_scp 
	integer (kind=1) :: tp_layer,phaseflag,tp_phase(10),tplandsea
	integer ::hi,ifice,ifmix,ifliq

	!=================== modis ================================
	real :: mod_maxhh,mod_hh,mod_min,tpsza
	integer :: modlat_scp, modlon_scp, rowi, colj, spectral_num(6)
	real :: Rsigma, spectral_rad(6)
	integer ::sigmai,Hsigma_scp,sigmaind(1),sza_scp,reflect_scp,BT11_scp,&
		BTD_scp,ratio_scp,reflect13_scp,reflect21_scp
    integer :: match_startflag,instant_matchfileflag
	real :: tpcldfra,tpliqfra,reflect645,reflect21,BT11,BT85,reflect16,reflect13
	integer :: collowres,colupres,rowlowres,rowupres
    real, parameter :: planck_c1=1.191042e8, planck_c2=1.4387752e4 
        ! note that c1=2hc**2: W/m2-sr-um-4, c2=hc/k: K um
	!=================== modis-cloudsat =======================
	real, allocatable :: difflat(:,:),difflon(:,:),dismodcld(:,:)
	integer :: minloc_res(2)
	!************ initalize for output *****************
	integer (kind=4) :: spa_reflect645_num(dimx,dimy,7),&!modis_spi_orignum(360,180),&
	spectral_rad_sza_num(6,70,7),spa_BT11_num(dimx,dimy,7),&
    reflect645_pdf(N645,7),BT11_pdf(NBT11,7),BTD_pdf(NBTD,7),&
	reflect213_pdf(N213,7),R645_213_2dpdf_clr(N645,N213,7),&
	ratio_645_21(Nratio,7),BT11_BTD_2dpdf(NBT11,NBTD,7),&
 	tau_reflect645_iceonly(Ntau,N645),tau_reflect13_iceonly(Ntau,N645),&
	tau_BT11_iceonly(Ntau,NBT11),tau_BTD_iceonly(Ntau,NBTD) 	

	real (kind=4) :: spa_reflect645(dimx,dimy,7), spa_BT11(dimx,dimy,7),&
		hetero_ratio(Nratio,7),modcldfraction_ratio(Nratio,7),modliqfraction_ratio(Nratio,7),&
		hetero_reflect645(N645,7),modcldfraction_reflect645(N645,7),&
		modliqfraction_reflect645(N645,7),&
		hetero_BT11(NBT11,7),modcldfraction_BT11(NBT11,7),&
		modliqfraction_BT11(NBT11,7),&
		hetero_BTD(NBTD,7),modcldfraction_BTD(NBTD,7),&
		modliqfraction_BTD(NBTD,7),&
		spectral_rad_sza(6,70,7),&
		spectral_rad_sza_square(6,70,7),&
		R645_213_ratio_clr(N645,N213,7)

	!************ for tau interval ************************
	integer :: i,tau_scp,tauind(1)
	real :: tptau,diff_tau(Ntau)

	!************* initalize data to send ************
	integer (kind=4),allocatable :: back_spa_reflect645_num(:,:,:,:),&
		back_spa_BT11_num(:,:,:,:),&
		back_spectral_rad_sza_num(:,:,:,:),&
        back_reflect645_pdf(:,:,:),&
        back_BT11_pdf(:,:,:),&
        back_BTD_pdf(:,:,:),&
		back_ratio_645_21(:,:,:),&
		back_BT11_BTD_2dpdf(:,:,:,:),&
 		back_tau_reflect645_iceonly(:,:,:),&
 		back_tau_reflect13_iceonly(:,:,:),&
		back_tau_BT11_iceonly(:,:,:),&
 		back_tau_BTD_iceonly(:,:,:),&
		back_reflect213_pdf(:,:,:),&
		back_R645_213_2dpdf_clr(:,:,:,:) 	
		
	real (kind=4),allocatable :: back_spa_reflect645(:,:,:,:), &
		back_hetero_ratio(:,:,:),&
		back_modcldfraction_ratio(:,:,:),&
		back_modliqfraction_ratio(:,:,:),&
		back_hetero_reflect645(:,:,:),&
		back_modcldfraction_reflect645(:,:,:),&
		back_modliqfraction_reflect645(:,:,:),&
		back_hetero_BT11(:,:,:),&
		back_modcldfraction_BT11(:,:,:),&
		back_modliqfraction_BT11(:,:,:),&
		back_hetero_BTD(:,:,:),&
		back_modcldfraction_BTD(:,:,:),&
		back_modliqfraction_BTD(:,:,:),&
		back_spa_BT11(:,:,:,:),&
		back_spectral_rad_sza(:,:,:,:),&
		back_spectral_rad_sza_square(:,:,:,:),&
		back_R645_213_ratio_clr(:,:,:,:)

    !****** initialize for mpi *************************
	integer :: mpi_err, numnodes, myid, Nodes
	integer, parameter :: my_root=0

	call MPI_INIT( mpi_err )
	call MPI_COMM_SIZE( MPI_COMM_WORLD, numnodes, mpi_err )
   	call MPI_Comm_rank(MPI_COMM_WORLD, myid, mpi_err)
	!************************************************

	IF (myid == my_root) Then
	
	call date_and_time(values=values)
	print *,values

	read(*,*) cld_date
	print *,cld_date

	yrindex=cld_date(1:4)

	classdir="/u/sciteam/yulanh/scratch/CLDCLASS/R05/"//yrindex//"/"//cld_date//"/"

	call system("ls "//trim(classdir)//" > inputfile"//cld_date,status)
        call system("cat inputfile"//cld_date//" | wc -l > count"//cld_date)
 
    open(100,file="count"//cld_date)
    read(100,*) Nodes
    close(100)
    print *,'number of file', Nodes
    allocate(file_list(Nodes))
    open(200,file="inputfile"//cld_date)
    read(200,fmt="(a67)",iostat=status) file_list
    close(200)

    allocate(back_spa_reflect645_num(dimx,dimy,7,Nodes))
	allocate(back_spa_reflect645(dimx,dimy,7,Nodes))

	allocate(back_spa_BT11_num(dimx,dimy,7,Nodes))
	allocate(back_spa_BT11(dimx,dimy,7,Nodes))

	allocate(back_spectral_rad_sza_num(6,70,7,Nodes))
	allocate(back_spectral_rad_sza(6,70,7,Nodes))
	allocate(back_spectral_rad_sza_square(6,70,7,Nodes))

    allocate(back_reflect645_pdf(N645,7,Nodes))
	allocate(back_hetero_reflect645(N645,7,Nodes))
	allocate(back_modcldfraction_reflect645(N645,7,Nodes))
	allocate(back_modliqfraction_reflect645(N645,7,Nodes))

    allocate(back_BT11_pdf(NBT11,7,Nodes))
	allocate(back_hetero_BT11(NBT11,7,Nodes))
	allocate(back_modcldfraction_BT11(NBT11,7,Nodes))
	allocate(back_modliqfraction_BT11(NBT11,7,Nodes))

    allocate(back_BTD_pdf(NBTD,7,Nodes))
	allocate(back_hetero_BTD(NBTD,7,Nodes))
	allocate(back_modcldfraction_BTD(NBTD,7,Nodes))
	allocate(back_modliqfraction_BTD(NBTD,7,Nodes))

	allocate(back_ratio_645_21(Nratio,7,Nodes))
	allocate(back_hetero_ratio(Nratio,7,Nodes))
	allocate(back_modcldfraction_ratio(Nratio,7,Nodes))
	allocate(back_modliqfraction_ratio(Nratio,7,Nodes))
	allocate(back_BT11_BTD_2dpdf(NBT11,NBTD,7,Nodes))

 	allocate(back_tau_reflect645_iceonly(Ntau,N645,Nodes))
 	allocate(back_tau_reflect13_iceonly(Ntau,N645,Nodes))
	allocate(back_tau_BT11_iceonly(Ntau,NBT11,Nodes))
 	allocate(back_tau_BTD_iceonly(Ntau,NBTD,Nodes)) 	

	allocate(back_reflect213_pdf(N213,7,Nodes))
	allocate(back_R645_213_2dpdf_clr(N645,N213,7,Nodes)) 	
	allocate(back_R645_213_ratio_clr(N645,N213,7,Nodes)) 	

	EndIf

	call MPI_SCATTER(file_list,67,MPI_CHARACTER,myday,&
        67,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_BCAST(cld_date,6,MPI_CHARACTER,&
        my_root,MPI_COMM_WORLD,mpi_err)

   ! print *,myid,myday

	Do i=1, Ntau
       tau_interval(i)=i*0.1-4.5
    EndDo

	yrindex=cld_date(1:4)

	spa_reflect645_num=0
	spa_reflect645=0.0
    spa_BT11_num=0
	spa_BT11=0.0

	spectral_rad_sza_num=0
	spectral_rad_sza=0.0
	spectral_rad_sza_square=0.0

    reflect645_pdf=0
    BT11_pdf=0
    BTD_pdf=0
	ratio_645_21=0

	reflect213_pdf=0
	R645_213_2dpdf_clr=0
	R645_213_ratio_clr=0.0

	hetero_ratio=0.0
	modcldfraction_ratio=0.0
	modliqfraction_ratio=0.0

	hetero_reflect645=0.0
	modcldfraction_reflect645=0.0
	modliqfraction_reflect645=0.0

	hetero_BT11=0.0
	modcldfraction_BT11=0.0
	modliqfraction_BT11=0.0

	hetero_BTD=0.0
	modcldfraction_BTD=0.0
	modliqfraction_BTD=0.0

	BT11_BTD_2dpdf=0
 	tau_reflect645_iceonly=0
	tau_BT11_iceonly=0
 	tau_BTD_iceonly=0

	classdir="/u/sciteam/yulanh/scratch/CLDCLASS/R05/"//yrindex//"/"//cld_date//"/"
	mod02dir="/u/sciteam/yulanh/scratch/MODIS/MYD021KM/"//yrindex//"/"//cld_date//"/"
	mod03dir="/u/sciteam/yulanh/scratch/MODIS/MYD03/"//yrindex//"/"//cld_date//"/"
	mod06dir="/u/sciteam/yulanh/scratch/MODIS/MYD06/"//yrindex//"/"//cld_date//"/"

    c2icefname="/u/sciteam/yulanh/scratch/2C-ICE/R05/"//yrindex//"/"//cld_date&
         //"/"//myday(1:20)//"CS_2C-ICE_GRANULE_P1_R05_E03_F00.hdf"

	classfname=trim(classdir)//myday
	
	INQUIRE (file=c2icefname,exist=c2ice_flag)
	!print *,myid,c2icefname,c2ice_flag

	IF (c2ice_flag) THEN 		

	call read_cldclass(classfname)	
	call read_2cice(c2icefname)

    !=========== read modis file ===========================================
    !======== search modis file in the same day as cldclass file ============
	strday=myday(5:7)
	swath_num=myday(15:19)
	call system("ls "//trim(mod02dir)//"MYD021KM.A"//yrindex//strday//"*"//" > mod02file"//swath_num,status)
	call system("cat mod02file"//swath_num//" | wc -l > countmod02"//swath_num)
	open(300,file="countmod02"//swath_num)
	read(300,*) mod02_nfname
	close(300)
	allocate(mod02_list(mod02_nfname)) 
	open(400,file="mod02file"//swath_num)
	read(400,fmt="(a97)",iostat=status) mod02_list
	close(400)

	call system("ls "//trim(mod03dir)//"MYD03.A"//yrindex//strday//"*"//" > mod03file"//swath_num,status)
	call system("cat mod03file"//swath_num//" | wc -l > countmod03"//swath_num)
	open(350,file="countmod03"//swath_num)
	read(350,*) mod03_nfname
	close(350)
	allocate(mod03_list(mod03_nfname)) 
	open(500,file="mod03file"//swath_num)
	read(500,fmt="(a91)",iostat=status) mod03_list
	close(500)

	call system("ls "//trim(mod06dir)//"MYD06_L2.A"//yrindex//strday//"*"//" > mod06file"//swath_num,status)
	call system("cat mod06file"//swath_num//" | wc -l > countmod06"//swath_num)
	open(450,file="countmod06"//swath_num)
	read(450,*) mod06_nfname
	close(450)
	allocate(mod06_list(mod06_nfname)) 
	open(600,file="mod06file"//swath_num)
	read(600,fmt="(a94)",iostat=status) mod06_list
	close(600)
	!print *, myid,mod06_nfname, mod06_list(1)
      
	!print *, myid,mod06_nfname,mod03_nfname,mod02_nfname

	IF (mod06_nfname == mod03_nfname  .and. mod06_nfname == mod02_nfname) Then 

	!=========== start to go over the cloudsat swath ==================
	read(myday(8:9),'(f2.0)') cld_start_hh
	read(myday(10:11),'(f2.0)') cld_start_min
	read(myday(12:13),'(f2.0)') cld_start_sec

    cld_start_utc=cld_start_hh*3600+cld_start_min*60+cld_start_sec

    mod02fname=mod02_list(mod02_nfname)
    read(mod02fname(72:73),'(f2.0)') mod_maxhh
    !print *, mod02fname
	!print *,cld_start_hh,cld_start_min,cld_start_sec,mod_maxhh
        
	si=1
	match_startflag=-1 ! to judge whether a cldsat file start
	instant_matchfileflag=-1 ! to judge wheather a modis file  start
	modfi=1
	
	include 'read_modis_module.file'

	Do While (si .le. NROW .and. cld_start_hh .le. mod_maxhh)
	    tpcldtime=cldtime(si)+cld_start_utc
	    cld_start_hh=floor(tpcldtime/3600.0)
	    cld_start_min=floor((tpcldtime/3600.0-cld_start_hh)*60)
                !IF hour doesn't match at the begining, go to next modis file
        IF (cld_start_hh > mod_hh .and. modfi < mod02_nfname .and. match_startflag == -1) THEN
           ! print *,'second read modis',NROW, mod02fname
	        instant_matchfileflag=-1 ! when start reading a file, assign the instant_matchfileflag -1
			include 'deallocate_array_modis.file'
			modfi=modfi+1
			if (si .ge. 2) si=si-1
	        include 'read_modis_module.file'	
		EndIf

		! if the cloudtime falls in the modis time, start location match
		tpcldlat=lat(si)
		tpcldlon=lon(si)
		tptau = vis_tau(si)

		lat_scp=nint((tpcldlat+90)/latbin_res)
        lon_scp=nint((tpcldlon+180)/lonbin_res)
        if (lat_scp < 1) lat_scp=1
        if (lon_scp < 1) lon_scp=1
        if (lat_scp > dimy) lat_scp=dimy
        if (lon_scp > dimx) lon_scp=dimx

		!in the target area, start match
	    ! even the hour doesn't match, there still be matched pixels	
		IF ((tpcldlat .ge. -30 .and. tpcldlat .le. 40) .and. (tpcldlon .ge. 70 .and. tpcldlon .le. 150) &
		 )Then!.and. (landsea(colj,rowi) == 0 .or. landsea(colj,rowi) ==2 .or. landsea(colj,rowi) == 6 .or.landsea(colj,rowi) ==7))Then!		.and. dem_hgt(si) .eq. -9999 ) Then 

        !********************* Deal with cloudy sky *********************
	   		phaseflag=6 ! for clear sky
	   		ifice=0
	   		ifmix=0
           	ifliq=0
      	   	tp_layer=clayer(si)
	   		tp_phase=cphase(:,si)
           	spectral_rad=0.0
			spectral_num=0
           	BT11=0.0
           	BT85=0.0
           	reflect645=0.0
           	reflect21=0.0
			reflect13=0.0

           	IF (tp_layer == 1) Then 
	            if (tp_phase(1) == 1) phaseflag=1 !ice 
	            if (tp_phase(1) == 2) phaseflag=2 ! mixed
	            if (tp_phase(1) == 3) phaseflag=3 ! water
	       	EndIf ! end if layer ==1
           IF (tp_layer > 1) Then 
           Do hi=1, tp_layer  
           if (tp_phase(hi) == 1) ifice=ifice+1
           if (tp_phase(hi) == 2) ifmix=ifmix+1
           if (tp_phase(hi) == 3) ifliq=ifliq+1
           Enddo
           if (ifice > 0 .and. (ifmix+ifliq) == 0)  phaseflag=1
           if ((ifice + ifliq) == 0 .and. ifmix > 0) phaseflag=2
		   if ((ifice + ifmix) == 0 .and. ifliq > 0) phaseflag=3
           if (ifice > 0 .and. ifmix == 0 .and. ifliq > 0) phaseflag=4
		   if (ifice > 0 .and. ifmix > 0) phaseflag=5
	       if (ifice == 0 .and. ifmix > 0 .and. ifliq > 0) phaseflag=2
		   EndIf ! end if layer > 1
		   !***************************************
		   !****** colocate *************************
		   difflat=abs(tpcldlat-modlat)
		   difflon=abs(tpcldlon-modlon)
		   dismodcld=sqrt(difflat*difflat+difflon*difflon)
		   minloc_res=minloc(dismodcld)
	     
          !print *,si,phaseflag,tpcldlat,tpcldlon,modlat(minloc_res(1),minloc_res(2)),modlon(minloc_res(1),minloc_res(2)),&
	      !	 minloc_res(1),minloc_res(2),dismodcld(minloc_res(1),minloc_res(2))

	      IF (dismodcld(minloc_res(1),minloc_res(2)) .le. 0.008) Then ! if le around 700m

			match_startflag=1
			instant_matchfileflag=1 

            tpsza=solarzenith(minloc_res(1),minloc_res(2))
            sza_scp=nint(tpsza)
                
            !spectral_rad !1: 0.645(1), 2: 1.375(26), 3: 1.6 (6), 4. 2.1 (7), 4: 8.5 (29), 5: 11.03 (31)
            if (rad_250(minloc_res(1),minloc_res(2),1) > 0.0) then
                 spectral_rad(1)= rad_250(minloc_res(1),minloc_res(2),1)  
				 spectral_num(1)=1
                 reflect645=rad_250(minloc_res(1),minloc_res(2),1)
            endif
            if (rad_1000(minloc_res(1),minloc_res(2),15) > 0.0) then
				spectral_rad(2)= rad_1000(minloc_res(1),minloc_res(2),15) 
				spectral_num(2)=1
				reflect13 = rad_1000(minloc_res(1),minloc_res(2),15) 
			endif
            if (rad_500(minloc_res(1),minloc_res(2),4) > 0.0) then
			 	spectral_rad(3)= rad_500(minloc_res(1),minloc_res(2),4)
				spectral_num(3)=1
				reflect16=rad_500(minloc_res(1),minloc_res(2),4)
			endif
            if (rad_500(minloc_res(1),minloc_res(2),5) > 0.0) then
				spectral_rad(4)= rad_500(minloc_res(1),minloc_res(2),5)
				spectral_num(4)=1
				reflect21=rad_500(minloc_res(1),minloc_res(2),5)
			endif
            if (rad_1000emis(minloc_res(1),minloc_res(2),9) > 0.0) then
                BT85=planck_c2/(8.55*log(planck_c1/(rad_1000emis(minloc_res(1),minloc_res(2),9)*8.55**5)+1))
				spectral_num(5)=1
                spectral_rad(5)=BT85
            endif
            if (rad_1000emis(minloc_res(1),minloc_res(2),11) > 0.0) then
                BT11=planck_c2/(11.03*log(planck_c1/(rad_1000emis(minloc_res(1),minloc_res(2),11)*11.03**5)+1))
                spectral_rad(6)= BT11 
				spectral_num(6)=1
                !print *,rad_1000emis(minloc_res(1),minloc_res(2),11),BT11
            endif

	        tplandsea=landsea(minloc_res(1),minloc_res(2))
			collowres=minloc_res(1)-2
            colupres=minloc_res(1)+2
		    rowlowres=minloc_res(2)-2
	        rowupres=minloc_res(2)+2
		
		 	IF (minloc_res(1) < 2) collowres=1
		    IF (minloc_res(1) > modNcol-2) colupres=modNcol
	        IF (minloc_res(2) < 2) rowlowres=1
	        IF (minloc_res(2) > modNrow-2) rowupres=modNrow
            tpcldfra=count(modcldphase(collowres:colupres,rowlowres:rowupres) .ge. 1)&
	           /((rowupres-rowlowres+1.0)*(colupres-collowres+1.0))

	        tpliqfra=count(modcldphase(collowres:colupres,rowlowres:rowupres) .eq. 1)&
                /((rowupres-rowlowres+1.0)*(colupres-collowres+1.0))

			Rsigma=cld_spi(1,minloc_res(1),minloc_res(2))/100.0


	        IF (reflect645 .ne. 0) then 
                    spa_reflect645_num(lon_scp,lat_scp,phaseflag)=spa_reflect645_num(lon_scp,lat_scp,phaseflag)+1
                    spa_reflect645_num(lon_scp,lat_scp,7)=spa_reflect645_num(lon_scp,lat_scp,7)+1	
                EndIf
	        IF (BT11 .ne. 0) then
                    spa_BT11_num(lon_scp,lat_scp,phaseflag)=spa_BT11_num(lon_scp,lat_scp,phaseflag)+1
                    spa_BT11_num(lon_scp,lat_scp,7)=spa_BT11_num(lon_scp,lat_scp,7)+1
			EndIf
		    IF (tplandsea == 0 .or. tplandsea == 6 .or.tplandsea ==7) Then
	            spa_reflect645(lon_scp,lat_scp,phaseflag)=spa_reflect645(lon_scp,lat_scp,phaseflag)+reflect645
	            spa_BT11(lon_scp,lat_scp,phaseflag)=spa_BT11(lon_scp,lat_scp,phaseflag)+BT11
	        !for all situations	
                spa_reflect645(lon_scp,lat_scp,7)=spa_reflect645(lon_scp,lat_scp,7)+reflect645
	            spa_BT11(lon_scp,lat_scp,7)=spa_BT11(lon_scp,lat_scp,7)+BT11
			! in the subarea
		    IF ((tpcldlat .ge. -10 .and. tpcldlat .le. 30) .and. (tpcldlon .ge. 80 .and. tpcldlon .le. 150)) Then
	            spectral_rad_sza(:,sza_scp,phaseflag)= spectral_rad_sza(:,sza_scp,phaseflag)+spectral_rad
	            spectral_rad_sza_square(:,sza_scp,phaseflag)= spectral_rad_sza_square(:,sza_scp,phaseflag)+spectral_rad*spectral_rad
	            spectral_rad_sza_num(:,sza_scp,phaseflag)= spectral_rad_sza_num(:,sza_scp,phaseflag)+spectral_num
                    !for all situations
	            spectral_rad_sza(:,sza_scp,7)= spectral_rad_sza(:,sza_scp,7)+spectral_rad
	            spectral_rad_sza_square(:,sza_scp,7)= spectral_rad_sza_square(:,sza_scp,7)+spectral_rad*spectral_rad
	            spectral_rad_sza_num(:,sza_scp,7)= spectral_rad_sza_num(:,sza_scp,7)+spectral_num
                                    
                reflect_scp=nint(reflect645*100)    
                reflect13_scp=nint(reflect13*100)    
                reflect21_scp=nint(reflect21*1000)
			    
                BT11_scp=nint(BT11-150)
                BTD_scp=nint(((BT85-BT11)+8.5)/0.1)
				ratio_scp=nint(reflect21*100/reflect645)

				diff_tau=abs(log10(tptau)-tau_interval)
                tauind=minloc(diff_tau)
                tau_scp=tauind(1)
	
			    if (reflect_scp < 0 .or. reflect_scp > N645) print *, '0.645', reflect645,reflect_scp
			    if (BT11_scp < 0 .or. BT11_scp > NBT11) print *, 'BT11', BT11,BT11_scp
			    if (BTD_scp < 0 .or. BTD_scp > NBTD) print *, 'BTD', BTD_scp
			    if (ratio_scp < 0 .or. ratio_scp > Nratio) print *, 'ratio', ratio_scp,reflect21,reflect645
		
				if (ratio_scp > 0) then
					ratio_645_21(ratio_scp,phaseflag)=ratio_645_21(ratio_scp,phaseflag)+1
					hetero_ratio(ratio_scp,phaseflag)=hetero_ratio(ratio_scp,phaseflag)+Rsigma
					modcldfraction_ratio(ratio_scp,phaseflag)=&
						modcldfraction_ratio(ratio_scp,phaseflag)+tpcldfra
					modliqfraction_ratio(ratio_scp,phaseflag)=&
						modliqfraction_ratio(ratio_scp,phaseflag)+tpliqfra

					reflect213_pdf(reflect21_scp,phaseflag)=reflect213_pdf(reflect21_scp,phaseflag) +1
					R645_213_2dpdf_clr(reflect_scp,reflect21_scp,phaseflag)=&
					R645_213_2dpdf_clr(reflect_scp,reflect21_scp,phaseflag)+1
					R645_213_ratio_clr(reflect_scp,reflect21_scp,phaseflag)=&
					R645_213_ratio_clr(reflect_scp,reflect21_scp,phaseflag)+reflect21/reflect645
			!		print *, reflect21,reflect21_scp,reflect645,reflect_scp,reflect21/reflect645,ratio_scp
			!		print *, Rsigma, tpcldfra,tpliqfra, reflect21,reflect645,ratio_scp/100.0
				endif
                if (reflect_scp > 0) then 
					reflect645_pdf(reflect_scp,phaseflag)=reflect645_pdf(reflect_scp,phaseflag)+1
					hetero_reflect645(reflect_scp,phaseflag)=hetero_reflect645(reflect_scp,phaseflag)+Rsigma
					modcldfraction_reflect645(reflect_scp,phaseflag)=&
						modcldfraction_reflect645(reflect_scp,phaseflag)+tpcldfra
					modliqfraction_reflect645(reflect_scp,phaseflag)=&
						modliqfraction_reflect645(reflect_scp,phaseflag)+tpliqfra
					if (tptau > 0 .and. phaseflag == 1)&
					tau_reflect645_iceonly(tau_scp,reflect_scp)=tau_reflect645_iceonly(tau_scp,reflect_scp)+1
				endif
				if (reflect13_scp > 0 .and. tptau > 0 .and. phaseflag ==1)&
					tau_reflect13_iceonly(tau_scp,reflect_scp)=tau_reflect13_iceonly(tau_scp,reflect_scp)+1

                if (BT11_scp > 0) then
					BT11_pdf(BT11_scp,phaseflag)=BT11_pdf(BT11_scp,phaseflag)+1
					hetero_BT11(BT11_scp,phaseflag)=hetero_BT11(BT11_scp,phaseflag)+Rsigma
					modcldfraction_BT11(BT11_scp,phaseflag)=&
						modcldfraction_BT11(BT11_scp,phaseflag)+tpcldfra
					modliqfraction_BT11(BT11_scp,phaseflag)=&
						modliqfraction_BT11(BT11_scp,phaseflag)+tpliqfra
					if (tptau > 0 .and. phaseflag == 1)&
					tau_BT11_iceonly(tau_scp,BT11_scp)=tau_BT11_iceonly(tau_scp,BT11_scp)+1
				endif
                if (BTD_scp > 0) then
					BTD_pdf(BTD_scp,phaseflag)=BTD_pdf(BTD_scp,phaseflag)+1
					hetero_BTD(BTD_scp,phaseflag)=hetero_BTD(BTD_scp,phaseflag)+Rsigma
					modcldfraction_BTD(BTD_scp,phaseflag)=&
						modcldfraction_BTD(BTD_scp,phaseflag)+tpcldfra
					modliqfraction_BTD(BTD_scp,phaseflag)=&
						modliqfraction_BTD(BTD_scp,phaseflag)+tpliqfra
					if (tptau > 0 .and. phaseflag == 1)&
					tau_BTD_iceonly(tau_scp,BTD_scp)=tau_BTD_iceonly(tau_scp,BTD_scp)+1
				endif
				if (BT11_scp > 0 .and. BTD_scp > 0) BT11_BTD_2dpdf(BT11_scp,BTD_scp,phaseflag)=BT11_BTD_2dpdf(BT11_scp,BTD_scp,phaseflag)+1			

				if (ratio_scp > 0) ratio_645_21(ratio_scp,7)=ratio_645_21(ratio_scp,7)+1
                if (reflect_scp > 0) reflect645_pdf(reflect_scp,7)=reflect645_pdf(reflect_scp,7)+1
                if (BT11_scp > 0) BT11_pdf(BT11_scp,7)=BT11_pdf(BT11_scp,7)+1
                if (BTD_scp > 0) BTD_pdf(BTD_scp,7)=BTD_pdf(BTD_scp,7)+1
				if (BT11_scp > 0 .and. BTD_scp > 0) BT11_BTD_2dpdf(BT11_scp,BTD_scp,7)=BT11_BTD_2dpdf(BT11_scp,BTD_scp,7)+1			
		    EndIf ! endif subarea
	        EndIF ! endif over ocean


        	Else ! end if case match (location)
				! may not match in the middle of the file, hour may not be equal as well	
			!	IF ((cld_start_min - mod_min) .gt. 5 .and. modfi < mod02_nfname) Then
			IF (instant_matchfileflag ==1 .and. modfi < mod02_nfname) Then
				modfi=modfi+1
				instant_matchfileflag=-1 
				if (si .ge. 2) si=si-1
				print *,'third read modis',NROW, mod02fname
				include 'deallocate_array_modis.file'
				include 'read_modis_module.file'	
			Endif
       	    End If ! end if location match(minimum distance < 0.008)

			! ********* deal with the end of match file
	  	 	IF (minloc_res(1) .ge. modNcol .or. minloc_res(2) .ge. modNrow) Then
				modfi=modfi+1
	   			!if (si .ge. 2 .and. match_startflag == -1) si=si-1
				IF (modfi .le. mod02_nfname) Then
				instant_matchfileflag=-1 
				print *,'fourth read modis',NROW, mod02fname
				include 'deallocate_array_modis.file'
				include 'read_modis_module.file'
				EndIf	
				!print *,lat(30000)
			Endif

			EndIf ! endif lat,lon, and time in the modis image(tplon,tplat,hh) 
		!*******************************************************
	    si=si+1
		!print *,si,cld_start_hh,cld_start_min,match_startflag,dismodcld(minloc_res(1),minloc_res(2)),mod02fname
	END DO ! end search cloudsat file
	
	EndIf ! end if mod03, mod06 files exist
	EndIf ! end if 2cice file exists
	!================================================================
	!======= send back data to root ======

   	call MPI_Gather(spa_reflect645_num,dimx*dimy*7,MPI_INTEGER,back_spa_reflect645_num,dimx*dimy*7,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_reflect645,dimx*dimy*7,MPI_REAL,back_spa_reflect645,dimx*dimy*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	
   	call MPI_Gather(spa_BT11_num,dimx*dimy*7,MPI_INTEGER,back_spa_BT11_num,dimx*dimy*7,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_BT11,dimx*dimy*7,MPI_REAL,back_spa_BT11,dimx*dimy*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(spectral_rad_sza_num,6*70*7,MPI_INTEGER,back_spectral_rad_sza_num,6*70*7,&
		 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spectral_rad_sza,6*70*7,MPI_REAL,back_spectral_rad_sza,6*70*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spectral_rad_sza_square,6*70*7,MPI_REAL,back_spectral_rad_sza_square,6*70*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(reflect645_pdf,N645*7,MPI_INTEGER,back_reflect645_pdf,N645*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(hetero_reflect645,N645*7,MPI_REAL,back_hetero_reflect645,N645*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modcldfraction_reflect645,N645*7,MPI_REAL,back_modcldfraction_reflect645,N645*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modliqfraction_reflect645,N645*7,MPI_REAL,back_modliqfraction_reflect645,N645*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(BT11_pdf,NBT11*7,MPI_INTEGER,back_BT11_pdf,NBT11*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(hetero_BT11,NBT11*7,MPI_REAL,back_hetero_BT11,NBT11*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modcldfraction_BT11,NBT11*7,MPI_REAL,back_modcldfraction_BT11,NBT11*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modliqfraction_BT11,NBT11*7,MPI_REAL,back_modliqfraction_BT11,NBT11*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(BTD_pdf,NBTD*7,MPI_INTEGER,back_BTD_pdf,NBTD*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(hetero_BTD,NBTD*7,MPI_REAL,back_hetero_BTD,NBTD*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modcldfraction_BTD,NBTD*7,MPI_REAL,back_modcldfraction_BTD,NBTD*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modliqfraction_BTD,NBTD*7,MPI_REAL,back_modliqfraction_BTD,NBTD*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(ratio_645_21,Nratio*7,MPI_INTEGER,back_ratio_645_21,Nratio*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(hetero_ratio,Nratio*7,MPI_REAL,back_hetero_ratio,Nratio*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modcldfraction_ratio,Nratio*7,MPI_REAL,back_modcldfraction_ratio,Nratio*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	call MPI_Gather(modliqfraction_ratio,Nratio*7,MPI_REAL,back_modliqfraction_ratio,Nratio*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)


	call MPI_Gather(BT11_BTD_2dpdf,NBT11*NBTD*7,MPI_INTEGER,back_BT11_BTD_2dpdf,NBT11*NBTD*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(tau_reflect645_iceonly,Ntau*N645,MPI_INTEGER,back_tau_reflect645_iceonly,Ntau*N645,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(tau_reflect13_iceonly,Ntau*N645,MPI_INTEGER,back_tau_reflect13_iceonly,Ntau*N645,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(tau_BT11_iceonly,Ntau*NBT11,MPI_INTEGER,back_tau_BT11_iceonly,Ntau*NBT11,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(tau_BTD_iceonly,Ntau*NBTD,MPI_INTEGER,back_tau_BTD_iceonly,Ntau*NBTD,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(reflect213_pdf,N213*7,MPI_INTEGER,back_reflect213_pdf,N213*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(R645_213_2dpdf_clr,N645*N213*7,MPI_INTEGER,back_R645_213_2dpdf_clr,N645*N213*7,&
                 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(R645_213_ratio_clr,N645*N213*7,MPI_REAL,back_R645_213_ratio_clr,N645*N213*7,&
                 MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

  IF (myid == my_root) Then
	
	Tspa_reflect645_num=sum(back_spa_reflect645_num,4)
	print *,'total number',sum(Tspa_reflect645_num)

	Tspa_reflect645=sum(back_spa_reflect645,4)
    Tspa_BT11_num=sum(back_spa_BT11_num,4)
	Tspa_BT11=sum(back_spa_BT11,4)

	Tspectral_rad_sza_num=sum(back_spectral_rad_sza_num,4)
	Tspectral_rad_sza=sum(back_spectral_rad_sza,4)
	Tspectral_rad_sza_square=sum(back_spectral_rad_sza_square,4)

    Treflect645_pdf=sum(back_reflect645_pdf,3)
    TBT11_pdf=sum(back_BT11_pdf,3)
    TBTD_pdf=sum(back_BTD_pdf,3)
	Tratio_645_21=sum(back_ratio_645_21,3)

	Thetero_ratio=sum(back_hetero_ratio,3)
	Tmodcldfraction_ratio=sum(back_modcldfraction_ratio,3)
	Tmodliqfraction_ratio=sum(back_modliqfraction_ratio,3)

	Thetero_reflect645=sum(back_hetero_reflect645,3)
	Tmodcldfraction_reflect645=sum(back_modcldfraction_reflect645,3)
	Tmodliqfraction_reflect645=sum(back_modliqfraction_reflect645,3)

	Thetero_BT11=sum(back_hetero_BT11,3)
	Tmodcldfraction_BT11=sum(back_modcldfraction_BT11,3)
	Tmodliqfraction_BT11=sum(back_modliqfraction_BT11,3)

	Thetero_BTD=sum(back_hetero_BTD,3)
	Tmodcldfraction_BTD=sum(back_modcldfraction_BTD,3)
	Tmodliqfraction_BTD=sum(back_modliqfraction_BTD,3)

	TBT11_BTD_2dpdf=sum(back_BT11_BTD_2dpdf,4)	

	Ttau_reflect645_iceonly=sum(back_tau_reflect645_iceonly,3)
	Ttau_reflect13_iceonly=sum(back_tau_reflect13_iceonly,3)
	Ttau_BT11_iceonly=sum(back_tau_BT11_iceonly,3)
	Ttau_BTD_iceonly=sum(back_tau_BTD_iceonly,3)
	!print *,sum(Tratio_645_16),sum(Treflect645_pdf)

	Treflect213_pdf=sum(back_reflect213_pdf,3)
	TR645_213_ratio_clr=sum(back_R645_213_ratio_clr,4)
	TR645_213_2dpdf_clr=sum(back_R645_213_2dpdf_clr,4)

	wfname="cldphase_radiation_wholedomain_R05_"//cld_date//".hdf"
	call write_cldphase_heter(wfname)

	deallocate(back_spa_reflect645_num)
	deallocate(back_spa_reflect645)
	deallocate(back_spa_BT11)
	deallocate(back_spectral_rad_sza_num)
	deallocate(back_spectral_rad_sza)
	deallocate(back_spectral_rad_sza_square)
    deallocate(back_reflect645_pdf)
    deallocate(back_BT11_pdf)
	deallocate(back_hetero_ratio)
	deallocate(back_modcldfraction_ratio)
	deallocate(back_modliqfraction_ratio)
	deallocate(back_hetero_reflect645)
	deallocate(back_modcldfraction_reflect645)
	deallocate(back_modliqfraction_reflect645)
	deallocate(back_hetero_BT11)
	deallocate(back_modcldfraction_BT11)
	deallocate(back_modliqfraction_BT11)
	deallocate(back_hetero_BTD)
	deallocate(back_modcldfraction_BTD)
	deallocate(back_modliqfraction_BTD)

    deallocate(back_BTD_pdf)
	deallocate(back_ratio_645_21)
	deallocate(back_BT11_BTD_2dpdf)
	deallocate(back_tau_reflect645_iceonly)
	deallocate(back_tau_reflect13_iceonly)
	deallocate(back_tau_BT11_iceonly)
	deallocate(back_tau_BTD_iceonly)
	deallocate(back_reflect213_pdf)
	deallocate(back_R645_213_ratio_clr)
	deallocate(back_R645_213_2dpdf_clr)

	deallocate(file_list)
	call system("rm -rf count*")
	call system("rm -rf mod02*")
	call system("rm -rf mod03*")
	call system("rm -rf mod06*")

	include 'deallocate_array.file'
	call date_and_time(values=values)
	print *,values
  EndIf

    call MPI_FINALIZE(mpi_err)	
	
 end
