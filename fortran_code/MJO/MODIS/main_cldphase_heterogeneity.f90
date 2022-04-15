	program main_cldphase_heterogeneity

	use global

	implicit none

	include 'mpif.h'

	!*********** initialze *****************
	character(len=200) :: mod02dir,mod03dir,mod06dir
	character(len=250) :: wfname
	character(len=12) :: strday
	character(len=4) :: yrindex
	character(len=6) :: cld_date
	character(len=41) :: myday
	character(len=41), allocatable :: mod03_list(:)
	character(len=91) :: mod03fname
	character(len=94) :: mod06fname
	character(len=98) :: mod02fname

 	integer (kind=2) :: Nfname,mod02_nfname,mod03_nfname,mod06_nfname
		
    integer (kind=4) :: status
	logical :: mod03flag,mod04flag
    integer :: values(8)

	!=================== modis ================================
	real :: tpsza,tplon,tplat,cld_day,cld_year
	integer :: lat_scp, lon_scp, rowi, colj,phaseflag
	real (kind=4) :: Rsigma!, spectral_rad(7)
	integer ::sigmai, Hsigma_scp,sigmaind(1),sza_scp,match_startflag,instant_matchfileflag
	real :: hetero_index(Ninterval),diff_sigma(Ninterval)
	integer (kind=1) :: tplandsea,tpmodphase

	!================= MJO =====================
	real :: MJO_info(1461,8)
	real :: mjo_yr,mjo_mon,mjo_day,rmm1,rmm2,mjo_phase
	integer ::li, mjo_phase1
	!************ initalize for output *****************
	integer (kind=4) :: spa_heteronum(dimx,dimy,8),&
		cldphase_fre(5,8),hetero_pdf(Ninterval,8)
	real (kind=4) :: spa_hetero(dimx,dimy,8),spa_reflect645(dimx,dimy,8),&
		spa_BT11(dimx,dimy,8)
	!*********** for plank function ********************
	real, parameter :: planck_c1=1.191042e8, planck_c2=1.4387752e4
    ! note that c1=2hc**2: W/m2-sr-um-4, c2=hc/k: K um
	real :: reflect645,tpbt11

	!************* initalize data to send ************
	integer (kind=4),allocatable :: back_spa_heteronum(:,:,:,:),&
		back_cldphase_fre(:,:,:),back_hetero_pdf(:,:,:)
	real (kind=4), allocatable :: back_spa_hetero(:,:,:,:),&
		back_spa_reflect645(:,:,:,:),back_spa_BT11(:,:,:,:)
		
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

    mod03dir="/u/sciteam/yulanh/scratch/MODIS/MYD03/"//yrindex//"/"//cld_date//"/"
 
    call system("ls "//trim(mod03dir)//" > inputfile"//cld_date,status)
    call system("cat inputfile"//cld_date//" | wc -l > count"//cld_date)
 
    open(100,file="count"//cld_date)
    read(100,*) Nodes
    close(100)
    print *,'number of file', Nodes
    allocate(mod03_list(Nodes))
    open(200,file="inputfile"//cld_date)
    read(200,fmt="(a41)",iostat=status) mod03_list
    close(200)

	allocate(back_spa_heteronum(dimx,dimy,8,Nodes))
	allocate(back_cldphase_fre(5,8,Nodes))
	allocate(back_hetero_pdf(Ninterval,8,Nodes))
	allocate(back_spa_hetero(dimx,dimy,8,Nodes))
	allocate(back_spa_reflect645(dimx,dimy,8,Nodes))
	allocate(back_spa_bt11(dimx,dimy,8,Nodes))

	back_spa_heteronum=0.0
	back_cldphase_fre=0.0
	back_hetero_pdf=0.0
	back_spa_hetero=0.0
	back_spa_reflect645=0.0
	back_spa_bt11=0.0

	!======= read MJO ================	
	open(300, file='RMM_MJO1.txt')
	Do li=1, 1461
		read(300,fmt='(f11.5,2(2x,f11.8),2x,f11.6,4(2x,f11.8))',iostat=status) MJO_info(li,:)
	Enddo
	close(300)

	EndIf

	call MPI_SCATTER(mod03_list,41,MPI_CHARACTER,myday,&
    41,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

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

	mod02dir="/u/sciteam/yulanh/scratch/MODIS/MYD021KM/"//yrindex//"/"//cld_date//"/"
	mod03dir="/u/sciteam/yulanh/scratch/MODIS/MYD03/"//yrindex//"/"//cld_date//"/"
	mod06dir="/u/sciteam/yulanh/scratch/MODIS/MYD06/"//yrindex//"/"//cld_date//"/"

	!=========== read modis file ===========================================
	!======== search modis file in the same day as cldclass file ============
	strday=myday(8:19)

	call system("ls "//trim(mod06dir)//"MYD06_L2.A"//strday//"*"//" > mod06file"//strday,status)
	call system("cat mod06file"//strday//" | wc -l > countmod06"//strday)
	open(450,file="countmod06"//strday)
	read(450,*) mod06_nfname
	close(450)
	open(600,file="mod06file"//strday)
	read(600,fmt="(a94)",iostat=status) mod06fname
	close(600)

	call system("ls "//trim(mod02dir)//"MYD021KM.A"//strday//"*"//" > mod02file"//strday,status)
	call system("cat mod02file"//strday//" | wc -l > countmod02"//strday)
	open(460,file="countmod02"//strday)
	read(460,*) mod02_nfname
	close(460)
	open(610,file="mod02file"//strday)
	read(610,fmt="(a98)",iostat=status) mod02fname
	close(610)

	mod03fname=trim(mod03dir)//myday

	!======== read MJO================
	!======== get MJO phase and rmm ==========
	read(strday(5:7),'(f3.0)') cld_day
	read(yrindex,'(f4.0)') cld_year
!	print *,cld_day,cld_year
!	print *,myday,' ', strday,' ',mod03fname

	Do li=1, 1461
		IF (MJO_info(li,1) == cld_year .and. MJO_info(li,4) == cld_day ) Then
			rmm1=MJO_info(li,5)
			rmm2=MJO_info(li,6)
			mjo_phase=MJO_info(li,7)
			mjo_phase1=int(mjo_phase)
		EndIf
	Enddo

	!print *,myid,myday,cld_year,cld_day,rmm1,rmm2,mjo_phase,mjo_phase1

	!=== only for MJO is strong
	IF ((rmm1*rmm1 + rmm2*rmm2) >= 1) Then
	print *,mod02fname
	print *,mod03fname
	print *,mod06fname
	call read_modis03(mod03fname)
	call read_modis06(mod06fname)	
	call read_modis02(mod02fname)

	reflect645=0.0
	tpbt11 = 0.0

	Do colj=1, modNcol
			Do rowi=1, modNrow
			IF (solarzenith(colj,rowi) > 0.0 .and. solarzenith(colj,rowi) < 90.0 ) Then

			tplat=modlat(colj,rowi)

			tplon=modlon(colj,rowi)

			reflect645=rad_250(colj,rowi,1)
			tpbt11=planck_c2/(11.03*log(planck_c1/(rad_1000emis(colj,rowi,11)*11.03**5)+1))
		!	print *,colj,rowi,reflect645,tpbt11,(rad_1000emis(colj,rowi,11))

    	    lat_scp=nint(modlat(colj,rowi)+90)
	        lon_scp=nint(modlon(colj,rowi)+180)

		    Rsigma=cld_spi(1,colj,rowi)/100.0 ! no unit

            diff_sigma=abs(log10(Rsigma)-hetero_x)
            sigmaind=minloc(diff_sigma)
			Hsigma_scp=sigmaind(1)
			tpmodphase=modcldphase(colj,rowi)
			phaseflag=tpmodphase
			IF (tpmodphase == 0) phaseflag=5
			IF (tpmodphase == 6) phaseflag=4			

			tplandsea=landsea(colj,rowi)
	        
	        spa_heteronum(lon_scp,lat_scp,mjo_phase1)=spa_heteronum(lon_scp,lat_scp,mjo_phase1)+1
			!print *,si,3,shape(mod06_list),tplandsea,lat_scp,lon_scp,tpcldlat,tpcldlon,mjo_phase1,Hsigma_scp
			! for over ocean only
			IF (tplandsea == 0 .or. tplandsea ==2 .or. tplandsea == 6 .or.tplandsea ==7) Then
	        	spa_hetero(lon_scp,lat_scp,mjo_phase1)=spa_hetero(lon_scp,lat_scp,mjo_phase1)+Rsigma
	        	spa_reflect645(lon_scp,lat_scp,mjo_phase1)=spa_reflect645(lon_scp,lat_scp,mjo_phase1)+ reflect645
	        	spa_BT11(lon_scp,lat_scp,mjo_phase1)=spa_BT11(lon_scp,lat_scp,mjo_phase1)+ tpbt11
				
			! in the subarea, in new subarea [-10,100,10,140]
				IF ((tplat .ge. -10 .and. tplat .le. 10) .and. (tplon .ge. 100 .and. tplon .le. 140)) Then
				cldphase_fre(phaseflag,mjo_phase1)=cldphase_fre(phaseflag,mjo_phase1)+1
           		hetero_pdf(Hsigma_scp,mjo_phase1)=hetero_pdf(Hsigma_scp,mjo_phase1)+1
				EndIf
			EndIf
		
		EndIf ! end SZA	
		EndDo
		EndDo
		!*******************************************************
	EndIf ! endif MJO is strong
	!================================================================

	!======= send back data to root ======
   	call MPI_Gather(spa_heteronum,dimx*dimy*8,MPI_INTEGER,back_spa_heteronum,dimx*dimy*8,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(cldphase_fre,5*8,MPI_INTEGER,back_cldphase_fre,5*8,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(hetero_pdf,Ninterval*8,MPI_INTEGER,back_hetero_pdf,Ninterval*8,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_hetero,dimx*dimy*8,MPI_REAL,back_spa_hetero,dimx*dimy*8,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_BT11,dimx*dimy*8,MPI_REAL,back_spa_BT11,dimx*dimy*8,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(spa_reflect645,dimx*dimy*8,MPI_REAL,back_spa_reflect645,dimx*dimy*8,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

  IF (myid == my_root) Then
	
	Tspa_heteronum=sum(back_spa_heteronum,4)
	Tcldphase_fre=sum(back_cldphase_fre,3)
	Thetero_pdf=sum(back_hetero_pdf,3)
	Tspa_hetero=sum(back_spa_hetero,4)
	Tspa_BT11=sum(back_spa_BT11,4)
	Tspa_reflect645=sum(back_spa_reflect645,4)

!	print *,sum(cldphase_fre),sum(back_cldphase_fre),sum(Tcldphase_fre)	
	print *,'start to write'
	wfname="modphase_MJO_heterogeneity_newdomain_"//cld_date//"_strongmjo.hdf"
	call write_cldphase_heter(wfname)	

	deallocate(back_spa_heteronum)
	deallocate(back_cldphase_fre)
	deallocate(back_hetero_pdf)
	deallocate(back_spa_hetero)
	deallocate(back_spa_BT11)
	deallocate(back_spa_reflect645)

	deallocate(mod03_list)

	call system("rm -rf count*")
	call system("rm -rf mod06*")
	call system("rm -rf mod02*")
	call date_and_time(values=values)
	print *,'finish time',values
  EndIf

    call MPI_FINALIZE(mpi_err)	
	
 end
