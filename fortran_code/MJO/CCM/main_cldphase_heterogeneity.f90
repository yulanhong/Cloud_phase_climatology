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
	!================== cloudsat ==============================
	integer :: si,modfi,nsize,li
	real :: cld_start_utc,cld_start_hh,cld_start_min,cld_start_sec	
	real :: tpcldtime,tpcldlat,tpcldlon
	integer :: lat_scp, lon_scp
	real :: cld_day,cld_year 
	integer (kind=1) :: tp_layer, phaseflag,tp_phase(10),tplandsea
	integer ::hi,ifice,ifmix,ifliq

	!=================== modis ================================
	real :: mod_maxhh,mod_hh,mod_min,tpsza
	integer :: modlat_scp, modlon_scp, rowi, colj
	real (kind=4) :: Rsigma!, spectral_rad(7)
	integer ::sigmai, Hsigma_scp,sigmaind(1),sza_scp,match_startflag,instant_matchfileflag
	real :: hetero_index(Ninterval),diff_sigma(Ninterval)
	!real :: tpcldfra,tpliqfra
	integer :: collowres,colupres,rowlowres,rowupres
	!================= MJO =====================
	real :: MJO_info(1461,8)
	real :: mjo_yr,mjo_mon,mjo_day,rmm1,rmm2,mjo_phase
	integer :: mjo_phase1
	!=================== modis-cloudsat =======================
	real, allocatable :: difflat(:,:),difflon(:,:),dismodcld(:,:)
	integer :: minloc_res(2)
	!************ initalize for output *****************
	integer (kind=4) :: spa_heteronum(dimx,dimy,8,6),&
		cldphase_fre(6,8),hetero_pdf(Ninterval,8)
	real (kind=4) :: spa_hetero(dimx,dimy,8,6)

	!************* initalize data to send ************
	integer (kind=4),allocatable :: back_spa_heteronum(:,:,:,:,:),&
		back_cldphase_fre(:,:,:),back_hetero_pdf(:,:,:)
	real (kind=4), allocatable :: back_spa_hetero(:,:,:,:,:)
		
 	!****** initialize for mpi *************************
	integer :: mpi_err, numnodes, myid, Nodes
	integer, parameter :: my_root=0

	call MPI_INIT( mpi_err )
	call MPI_COMM_SIZE( MPI_COMM_WORLD, numnodes, mpi_err )
   	call MPI_Comm_rank(MPI_COMM_WORLD, myid, mpi_err)
	!************************************************

	IF (myid == my_root) Then
	call date_and_time(values=values)
	print *,'start time',values
	
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

	allocate(back_spa_heteronum(dimx,dimy,8,6,Nodes))
	allocate(back_cldphase_fre(6,8,Nodes))
	allocate(back_hetero_pdf(Ninterval,8,Nodes))
	allocate(back_spa_hetero(dimx,dimy,8,6,Nodes))

	back_spa_heteronum=0.0
	back_cldphase_fre=0.0
	back_hetero_pdf=0.0
	back_spa_hetero=0.0
	!======= read MJO ================	
	open(300, file='RMM_MJO1.txt')
	Do li=1, 1461
		read(300,fmt='(f11.5,2(2x,f11.8),2x,f11.6,4(2x,f11.8))',iostat=status) MJO_info(li,:)
	Enddo
	close(300)

	EndIf

	call MPI_SCATTER(file_list,62,MPI_CHARACTER,myday,&
    62,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_BCAST(cld_date,6,MPI_CHARACTER,&
        my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_BCAST(MJO_info,1461*10,MPI_REAL,&
        my_root,MPI_COMM_WORLD,mpi_err)

	yrindex=cld_date(1:4)
	spa_heteronum=0
	cldphase_fre=0
	hetero_pdf=0
	spa_hetero=0.0
	
	Do sigmai=1,Ninterval
		 hetero_index(sigmai)=sigmai*0.01-6.0
	EndDo

	hetero_x=hetero_index
    !hetero_x(2:401)=10**hetero_index

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

	!======== read MJO================
	!======== get MJO phase and rmm ==========
	read(strday,'(f3.0)') cld_day
	read(yrindex,'(f4.0)') cld_year

	Do li=1, 1461
		IF (MJO_info(li,1) == cld_year .and. MJO_info(li,4) == cld_day ) Then
			rmm1=MJO_info(li,5)
			rmm2=MJO_info(li,6)
			mjo_phase=MJO_info(li,7)
			mjo_phase1=int(mjo_phase)
		EndIf
	Enddo

	print *,myid,myday,cld_year,cld_day,rmm1,rmm2,mjo_phase,mjo_phase1

	!=== only for MJO is strong
	IF ((rmm1*rmm1+rmm2*rmm2) >= 1) Then  

	!=========== start to go over the cloudsat swath ==================
	read(myday(8:9),'(f2.0)') cld_start_hh
	read(myday(10:11),'(f2.0)') cld_start_min
	read(myday(12:13),'(f2.0)') cld_start_sec

	cld_start_utc=cld_start_hh*3600+cld_start_min*60+cld_start_sec
	
	mod02fname=mod02_list(mod02_nfname)
	read(mod02fname(72:73),'(f2.0)') mod_maxhh

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
		!print *,'second read modis'!,NROW, mod02fname
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
			) Then   
		   phaseflag=6 ! clear
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

		!print *,si,Nrow,cld_start_hh,mod_min,mod_maxhh,tpcldlat,tpcldlon,dismodcld(minloc_res(1),minloc_res(2)),minloc_res
		

		 IF (dismodcld(minloc_res(1),minloc_res(2)) .le. 0.008) Then ! if le around 700m

			match_startflag=1
			instant_matchfileflag=1 

			!		,modlon(minloc_res(1),minloc_res(2)),&
			!	minloc_res(1),minloc_res(2),dismodcld(minloc_res(1),minloc_res(2))
					
            tpsza=solarzenith(minloc_res(1),minloc_res(2))
            sza_scp=nint(tpsza)

		    Rsigma=cld_spi(1,minloc_res(1),minloc_res(2))/100.0 ! no unit
			!print *,Rsigma,log10(Rsigma),log10(0.01)
            diff_sigma=abs(log10(Rsigma)-hetero_x)
            sigmaind=minloc(diff_sigma)
			Hsigma_scp=sigmaind(1)

			tplandsea=landsea(minloc_res(1),minloc_res(2))

			!print *,si,phaseflag,tpcldlat,tpcldlon,modlat(minloc_res(1),minloc_res(2)),modlon(minloc_res(1),minloc_res(2)),minloc_res
	        
	        spa_heteronum(lon_scp,lat_scp,mjo_phase1,phaseflag)=spa_heteronum(lon_scp,lat_scp,mjo_phase1,phaseflag)+1
			!print *,si,3,shape(mod06_list),tplandsea,lat_scp,lon_scp,tpcldlat,tpcldlon,mjo_phase1,Hsigma_scp
			! for over ocean only
			IF (tplandsea == 0 .or. tplandsea ==2 .or. tplandsea == 6 .or.tplandsea ==7) Then
	        	spa_hetero(lon_scp,lat_scp,mjo_phase1,phaseflag)=spa_hetero(lon_scp,lat_scp,mjo_phase1,phaseflag)+Rsigma
			! in the subarea; new subarea [-10,100,10,140]
				IF ((tpcldlat .ge. -10 .and. tpcldlat .le. 10) .and. (tpcldlon .ge. 100 .and. tpcldlon .le. 140)) Then
				cldphase_fre(phaseflag,mjo_phase1)=cldphase_fre(phaseflag,mjo_phase1)+1
           		hetero_pdf(Hsigma_scp,mjo_phase1)=hetero_pdf(Hsigma_scp,mjo_phase1)+1
				EndIf
			EndIf
			!print *,si,4,shape(mod06_list),tplandsea,lat_scp,lon_scp,tpcldlat,tpcldlon,mjo_phase1,Hsigma_scp
          Else ! end if case match (location)
				! may not match in the middle of the file, hour may not be equal as well	
			!	IF ((cld_start_min - mod_min) .gt. 5 .and. modfi < mod02_nfname) Then
			IF (instant_matchfileflag ==1 .and. modfi < mod02_nfname) Then
				modfi=modfi+1
				instant_matchfileflag=-1 
				if (si .ge. 2) si=si-1
				print *,'third read modis'!,NROW, mod02fname
				include 'deallocate_array_modis.file'
				include 'read_modis_module.file'	
			Endif
       	End If ! end if location match(minimum distance < 0.008)

			!print *,si,6,shape(mod06_list)
			! ********* deal with the end of match file
			IF (minloc_res(1) .ge. modNcol .or. minloc_res(2) .ge. modNrow) Then
				modfi=modfi+1
				!if (si .ge. 2) si=si-1
				IF (modfi .le. mod02_nfname) Then
				instant_matchfileflag=-1 
				!print *,'fourth read modis'!,NROW, mod02fname
				include 'deallocate_array_modis.file'
				include 'read_modis_module.file'
				EndIf	
				!print *,lat(30000)
			Endif
		EndIf ! endif lat and lon in the target area
		!*******************************************************
	    si=si+1
		!print *,si,cld_start_hh,cld_start_min,match_startflag,dismodcld(minloc_res(1),minloc_res(2)),mod02fname
	END DO ! end search cloudsat file
	EndIf ! endif MJO is strong
	!================================================================

	!======= send back data to root ======
   	call MPI_Gather(spa_heteronum,dimx*dimy*8*6,MPI_INTEGER,back_spa_heteronum,dimx*dimy*8*6,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(cldphase_fre,6*8,MPI_INTEGER,back_cldphase_fre,6*8,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(hetero_pdf,Ninterval*8,MPI_INTEGER,back_hetero_pdf,Ninterval*8,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_hetero,dimx*dimy*8*6,MPI_REAL,back_spa_hetero,dimx*dimy*8*6,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

  IF (myid == my_root) Then
	
	Tspa_heteronum=sum(back_spa_heteronum,5)
	Tcldphase_fre=sum(back_cldphase_fre,3)
	Thetero_pdf=sum(back_hetero_pdf,3)
	Tspa_hetero=sum(back_spa_hetero,5)
!	print *,sum(cldphase_fre),sum(back_cldphase_fre),sum(Tcldphase_fre)	
	print *,'start to write'
	wfname="cldphase_MJO_heterogeneity_newdomain_"//cld_date//"_strongmjo.hdf"
	call write_cldphase_heter(wfname)	

	deallocate(back_spa_heteronum)
	deallocate(back_cldphase_fre)
	deallocate(back_hetero_pdf)
	deallocate(back_spa_hetero)
	deallocate(file_list)

	call system("rm -rf count*")
	call system("rm -rf mod02*")
	call system("rm -rf mod03*")
	call system("rm -rf mod06*")
	include 'deallocate_array.file'
	call date_and_time(values=values)
	print *,'finish time',values
  EndIf

    call MPI_FINALIZE(mpi_err)	
	
 end
