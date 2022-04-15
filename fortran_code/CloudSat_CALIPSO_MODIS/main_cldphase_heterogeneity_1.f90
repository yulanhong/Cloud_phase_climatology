	program main_cldphase_heterogeneity

	use global

	implicit none

	include 'mpif.h'

	!*********** initialze *****************
	character(len=200) :: classdir,mod02dir,mod03dir,mod06dir
	character(len=250) :: classfname,mod02fname,wfname
	character(len=3) :: strday
	character(len=4) :: yrindex
	character(len=5) :: swath_num
	character(len=6) :: cld_date
	character(len=62) :: myday
	character(len=62), allocatable :: file_list(:)
	character(len=97), allocatable :: mod02_list(:)
	character(len=91), allocatable :: mod03_list(:)
	character(len=94), allocatable :: mod06_list(:)
	character(len=91) :: mod03fname
	character(len=94) :: mod06fname

 	integer (kind=2) :: Nfname,mod02_nfname,mod03_nfname,mod06_nfname
    integer (kind=4) :: status
	logical :: mod03flag,mod04flag
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
	integer :: modlat_scp, modlon_scp, rowi, colj
	real :: Rsigma, spectral_rad(7)
	integer ::sigmai, Hsigma_scp,sigmaind(1),sza_scp,match_startflag,instant_matchfileflag
	real :: hetero_index(Ninterval),diff_sigma(Ninterval)
	real :: tpcldfra,tpliqfra
	integer :: collowres,colupres,rowlowres,rowupres

	!=================== modis-cloudsat =======================
	real, allocatable :: difflat(:,:),difflon(:,:),dismodcld(:,:)
	integer :: minloc_res(2)
	!************ initalize for output *****************
	integer (kind=4) :: spa_reflect645_num(dimx,dimy,6),&!modis_spi_orignum(360,180),&
		Tspa_BT11_num(dimx,dimy,6),&
		spectral_rad_sza_num(6,70,6)

	real (kind=4) :: spa_reflect645(dimx,dimy,6), Tspa_BT11(dimx,dimy,6),&
		spectral_rad_sza(6,70,6),&
		spectral_rad_sza_square(6,70,6)

	!************* initalize data to send ************
	integer (kind=4),allocatable :: back_spa_reflect645_num(:,:,:,:),&
		back_spa_BT11_num(:,:,:,:),&
		back_spectral_rad_sza_num(:,:,:,:)
		
	real (kind=4),allocatable :: back_spa_reflect645(:,:,:,:), &
		back_spa_BT11(:,:,:,:),&
		back_spectral_rad_sza(:,:,:,:),&
		back_spectral_rad_sza_square(:,:,:,:)

 	!****** initialize for mpi *************************
	integer :: mpi_err, numnodes, myid, Nodes
	integer, parameter :: my_root=0

	call MPI_INIT( mpi_err )
	call MPI_COMM_SIZE( MPI_COMM_WORLD, numnodes, mpi_err )
   	call MPI_Comm_rank(MPI_COMM_WORLD, myid, mpi_err)
	!************************************************

	IF (myid == my_root) Then
	
	read(*,*) cld_date
	print *,cld_date

	yrindex=cld_date(1:4)

	classdir="/u/sciteam/yulanh/scratch/CLDCLASS/"//yrindex//"/"//cld_date//"/"

	call system("ls "//trim(classdir)//" > inputfile"//cld_date,status)
    call system("cat inputfile"//cld_date//" | wc -l > count"//cld_date)
 
    open(100,file="count"//cld_date)
    read(100,*) Nodes
    close(100)
    print *,'number of file', Nodes
    allocate(file_list(Nodes))
    open(200,file="inputfile"//cld_date)
    read(200,fmt="(a62)",iostat=status) file_list
    close(200)

	allocate(back_spa_reflect645_num(dimx,dimy,6,Nodes))
	allocate(back_spa_reflect645(dimx,dimy,6,Nodes))
	allocate(back_spa_BT11_num(dimx,dimy,6,Nodes))
	allocate(back_spa_BT11(dimx,dimy,6,Nodes))

	allocate(back_spectral_rad_sza_num(6,70,6,Nodes))
	allocate(back_spectral_rad_sza(6,70,6,Nodes))
	allocate(back_spectral_rad_sza_square(6,70,6,Nodes))

	EndIf

	call MPI_SCATTER(file_list,62,MPI_CHARACTER,myday,&
    62,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_BCAST(cld_date,6,MPI_CHARACTER,&
        my_root,MPI_COMM_WORLD,mpi_err)

	yrindex=cld_date(1:4)

	spa_reflect645_num=0
	spa_reflect645=0.0
	spa_BT11_num=0
	spa_BT11=0.0

	spectral_rad_sza_num=0
	spectral_rad_sza=0.0
	spectral_rad_sza_square=0.0

	classdir="/u/sciteam/yulanh/scratch/CLDCLASS/"//yrindex//"/"//cld_date//"/"
	mod02dir="/u/sciteam/yulanh/scratch/MODIS/MYD021KM/"//yrindex//"/"//cld_date//"/"
	mod03dir="/u/sciteam/yulanh/scratch/MODIS/MYD03/"//yrindex//"/"//cld_date//"/"
	mod06dir="/u/sciteam/yulanh/scratch/MODIS/MYD06/"//yrindex//"/"//cld_date//"/"

	classfname=trim(classdir)//myday
	!print *,myid,classfname
	call read_cldclass(classfname)	
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

	!print *, myid,mod06_nfname,mod03_nfname,mod02_nfname

	IF (mod06_nfname == mod03_nfname  .and. mod06_nfname == mod02_nfname) Then 

	!=========== start to go over the cloudsat swath ==================
	read(myday(8:9),'(f2.0)') cld_start_hh
	read(myday(10:11),'(f2.0)') cld_start_min
	read(myday(12:13),'(f2.0)') cld_start_sec

	cld_start_utc=cld_start_hh*3600+cld_start_min*60+cld_start_sec
	
	mod02fname=mod02_list(mod02_nfname)
	read(mod02fname(72:73),'(f2.0)') mod_maxhh
!	print *,cld_start_hh,cld_start_min,cld_start_sec,mod_maxhh

	si=1
	match_startflag=-1	
	instant_matchfileflag=-1
	modfi=1
	
	include 'read_modis_module.file'

	Do While (si .le. NROW .and. cld_start_hh .le. mod_maxhh)
		tpcldtime=cldtime(si)+cld_start_utc			
		cld_start_hh=floor(tpcldtime/3600.0)
		cld_start_min=floor((tpcldtime/3600.0-cld_start_hh)*60)		
		!IF hour doesn't match at the begining, go to next modis file
		IF (cld_start_hh > mod_hh .and. modfi < mod02_nfname .and. match_startflag == -1) THEN
			print *,'second read modis',NROW, mod02fname
			instant_matchfileflag=-1 ! when start reading a file, assign the instant_matchfileflag -1
			include 'deallocate_array_modis.file'
			modfi=modfi+1
			if (si .ge. 2) si=si-1
			include 'read_modis_module.file'	
		EndIf

		! if the cloudtime falls in the modis time, start location match
		tpcldlat=lat(si)
		tpcldlon=lon(si)
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

           IF (tp_layer == 1) Then 
	            if (tp_phase(1) == 1) phaseflag=1
	            if (tp_phase(1) == 2) phaseflag=2
	            if (tp_phase(1) == 3) phaseflag=3
	       EndIf ! end if layer ==1
           IF (tp_layer > 1) Then 
           Do hi=1, tp_layer  
           if (tp_phase(hi) == 1) ifice=ifice+1
           if (tp_phase(hi) == 2) ifmix=ifmix+1
           if (tp_phase(hi) == 3) ifliq=ifliq+1
           Enddo
           if (ifice > 0 .and. (ifmix+ifliq) == 0)  phaseflag=1
           if ((ifice + ifliq) == 0 .and. ifmix > 0) phaseflag=2
		   if ((ifice + ifmix) == 0 .and. ifliq > 0)  phaseflag=3
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

		   IF (dismodcld(minloc_res(1),minloc_res(2)) .le. 0.008) Then ! if le around 700m

			match_startflag=1
			instant_matchfileflag=1 

	!		print *,si,phaseflag,cld_start_hh,cld_start_min,mod_hh,mod_min,tpcldlat,tpcldlon,modlat(minloc_res(1),minloc_res(2))&
	!				,modlon(minloc_res(1),minloc_res(2)),&
!					minloc_res(1),minloc_res(2),dismodcld(minloc_res(1),minloc_res(2))
					
            tpsza=solarzenith(minloc_res(1),minloc_res(2))
            sza_scp=nint(tpsza)

            !spectral_rad !1: 0.645(1), 2: 1.375(26), 3: 1.6 (6), 4. 2.1 (7), 4: 8.5 (29), 5: 11.03 (31)
            if (rad_250(minloc_res(1),minloc_res(2),1) > 0.0) spectral_rad(1)= rad_250(minloc_res(1),minloc_res(2),1)  
            if (rad_1000(minloc_res(1),minloc_res(2),15) > 0.0) spectral_rad(2)= rad_1000(minloc_res(1),minloc_res(2),15) 
            if (rad_500(minloc_res(1),minloc_res(2),4) > 0.0) spectral_rad(3)= rad_500(minloc_res(1),minloc_res(2),4)
            if (rad_500(minloc_res(1),minloc_res(2),5) > 0.0) spectral_rad(4)= rad_500(minloc_res(1),minloc_res(2),5)
            if (rad_1000emis(minloc_res(1),minloc_res(2),9) > 0.0) spectral_rad(5)= rad_1000emis(minloc_res(1),minloc_res(2),9)
            if (rad_1000emis(minloc_res(1),minloc_res(2),11) > 0.0) spectral_rad(6)= rad_1000emis(minloc_res(1),minloc_res(2),11)

			tplandsea=landsea(minloc_res(1),minloc_res(2))

	        spa_reflect645_num(lon_scp,lat_scp,phaseflag)=spa_reflect645_num(lon_scp,lat_scp,phaseflag)+1
			
			IF (tplandsea == 0 .or. tplandsea ==2 .or. tplandsea == 6 .or.tplandsea ==7) Then
	        	spa_reflect645(lon_scp,lat_scp,phaseflag)=spa_reflect645(lon_scp,lat_scp,phaseflag)+reflect645
	        	spa_BT11(lon_scp,lat_scp,phaseflag)=spa_BT11(lon_scp,lat_scp,phaseflag)+BT11
				IF ((tpcldlat .ge. 0 .and. tpcldlat .le. 20) .and. (tpcldlon .ge. 105 .and. tpcldlon .le. 135)) Then
	            spectral_rad_sza(:,sza_scp,phaseflag)= spectral_rad_sza(:,sza_scp,phaseflag)+spectral_rad
	            spectral_rad_sza_square(:,sza_scp,phaseflag)= spectral_rad_sza_square(:,sza_scp,phaseflag)+spectral_rad*spectral_rad
	            spectral_rad_sza_num(:,sza_scp,phaseflag)= spectral_rad_sza_num(:,sza_scp,phaseflag)+1
				EndIf
			EndIF
			
			!====== for all situations ===============
	        spa_reflect645_num(lon_scp,lat_scp,7)=spa_reflect645_num(lon_scp,lat_scp,7)+1
			
			IF (tplandsea == 0 .or. tplandsea ==2 .or. tplandsea == 6 .or.tplandsea ==7) Then
	        	spa_reflect645(lon_scp,lat_scp,7)=spa_reflect645(lon_scp,lat_scp,7)+reflect645
	        	spa_BT11(lon_scp,lat_scp,7)=spa_BT11(lon_scp,lat_scp,7)+BT11
				IF ((tpcldlat .ge. 0 .and. tpcldlat .le. 20) .and. (tpcldlon .ge. 105 .and. tpcldlon .le. 135)) Then
	            spectral_rad_sza(:,sza_scp,7)= spectral_rad_sza(:,sza_scp,7)+spectral_rad
	            spectral_rad_sza_square(:,sza_scp,7)= spectral_rad_sza_square(:,sza_scp,7)+spectral_rad*spectral_rad
	            spectral_rad_sza_num(:,sza_scp,7)= spectral_rad_sza_num(:,sza_scp,7)+1
				EndIf
			EndIF

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
             !if not match at the current cldsat pixel, may match later pixel
             !IF (match_startflag == 1 .and. modfi < mod02_nfname) Then
             !	modfi=modfi+1
			 !	if (si .ge. 2) si=si-1
			 !	include 'deallocate_array_modis.file'
             !	include 'read_modis_module.file' ! if already start matching,and no matched pixel, go to next file    
			!	print *,'fourth read modis',NROW
			 !EndIf
       	    End If ! end if location match(minimum distance < 0.008)

			! ********* deal with the end of match file
			IF (minloc_res(1) .ge. modNcol .or. minloc_res(2) .ge. modNrow) Then
				modfi=modfi+1
				!if (si .ge. 2) si=si-1
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
	!================================================================

	!======= send back data to root ======
   	call MPI_Gather(spa_reflect645_num,dimx*dimy*7,MPI_INTEGER,back_spa_reflect645_num,dimx*dimy*7,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_reflect645,dimx*dimy*7,MPI_REAL,back_spa_reflect645,dimx*dimy*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_BT11,dimx*dimy*7,MPI_REAL,back_spa_BT11,dimx*dimy*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(spectral_rad_sza_num,6*70*7,MPI_INTEGER,back_spectral_rad_sza_num,6*70*7,&
		 MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spectral_rad_sza,6*70*7,MPI_REAL,back_spectral_rad_sza,6*70*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spectral_rad_sza_square,6*70*7,MPI_REAL,back_spectral_rad_sza_square,6*70*7,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	
  IF (myid == my_root) Then
	
	Tspa_reflect645_num=sum(back_spa_reflect645_num,4)
	Tspa_reflect645=sum(back_spa_reflect645,4)
	Tspa_BT11=sum(back_spa_BT11,4)

	Tspectral_rad_sza_num=sum(back_spectral_rad_sza_num,4)
	Tspectral_rad_sza=sum(back_spectral_rad_sza,4)
	Tspectral_rad_sza_square=sum(back_spectral_rad_sza_square,4)

	wfname="cldphase_heterogeneity_"//cld_date//".hdf"
	call write_cldphase_heter(wfname)	

	deallocate(back_spa_reflect645_num)
	deallocate(back_spa_reflect645)
	deallocate(back_spa_BT11)
	deallocate(back_spectral_rad_sza_num)
	deallocate(back_spectral_rad_sza)
	deallocate(back_spectral_rad_sza_square)

	deallocate(file_list)
	call system("rm -rf count*")
	call system("rm -rf mod02*")
	call system("rm -rf mod03*")
	call system("rm -rf mod06*")
	include 'deallocate_array.file'
	call date_and_time(values=values)
  EndIf

    call MPI_FINALIZE(mpi_err)	
	
 end
