	program main_cldphase_radiation

	use global

	implicit none

	include 'mpif.h'

	!*********** initialze *****************
	character(len=200) :: mod03dir,mod02dir,wfname
	character(len=12) :: strday
	character(len=4) :: yrindex
	character(len=6) :: cld_date
	character(len=41) :: myday
	character(len=41), allocatable :: mod03_list(:)

	character(len=200) :: mod02fname
	character(len=200) :: mod03fname

 	integer (kind=2) :: mod03_nfname,mod06_nfname
    integer (kind=4) :: status
    integer :: values(8)

	!================ for plank function =================
	real, parameter :: planck_c1=1.191042e8, planck_c2=1.4387752e4
	real :: reflect645,tpbt11

	!=================== modis ================================
	integer :: modlat_scp, modlon_scp,colj,rowi
	real :: tplon,tplat 
	integer (kind=1) :: tplandsea
	!=================== modis-cloudsat =======================
	integer (kind=4) :: modis_obsnum(360,180)

    real (kind=4) :: modis_r645(360,180), modis_bt11(360,180)

	!************* initalize data to send ************
	integer (kind=4), allocatable :: back_modis_obsnum(:,:,:)

	real (kind=4), allocatable :: back_modis_r645(:,:,:),back_modis_bt11(:,:,:) 

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

	allocate(back_modis_obsnum(360,180,nodes))
	allocate(back_modis_r645(360,180,nodes))
	allocate(back_modis_bt11(360,180,nodes))

	EndIf

	call MPI_SCATTER(mod03_list,41,MPI_CHARACTER,myday,&
    41,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_BCAST(cld_date,6,MPI_CHARACTER,&
        my_root,MPI_COMM_WORLD,mpi_err)

	yrindex=cld_date(1:4)
	
	mod03dir="/u/sciteam/yulanh/scratch/MODIS/MYD03/"//yrindex//"/"//cld_date//"/"
	mod02dir="/u/sciteam/yulanh/scratch/MODIS/MYD021KM/"//yrindex//"/"//cld_date//"/"

	!=========== read modis file ===========================================
	!======== search modis file in the same day as cldclass file ============
	strday=myday(8:19)
	print *,myid,strday
	call system("ls "//trim(mod02dir)//"MYD021KM.A"//strday//"*"//" > mod02file"//strday,status)
	
	call system("cat mod02file"//strday//" | wc -l > countmod02"//strday)
	open(450,file="countmod02"//strday)
	read(450,*) mod06_nfname
	close(450)
	open(500,file="mod02file"//strday)
	read(500,fmt="(a98)",iostat=status) mod02fname
    close(500)
	
	mod03fname=trim(mod03dir)//myday
 	
	call read_modis03(mod03fname)
    call read_modis02(mod02fname)
  
	Do colj=1,modNcol
		Do rowi=1, modNrow
		
		IF (solarzenith(colj,rowi) > 0.0 .and. solarzenith(colj,rowi) < 90.0) Then
		
		tplat=modlat(colj,rowi)
		tplon=modlon(colj,rowi)
	
		modlat_scp=nint(modlat(colj,rowi)+90)
   		modlon_scp=nint(modlon(colj,rowi)+180)

		reflect645=rad_250(colj,rowi,1)
		tpbt11=planck_c2/(11.03*log(planck_c1/(rad_1000emis(colj,rowi,11)*11.03**5)+1))
!		print *, tplat,tplon,modlat_scp,modlon_scp
!		print *, reflect645, tpbt11, rad_1000emis(colj,rowi,11)
	
		tplandsea=landsea(colj,rowi)

		IF (tplandsea == 0 .or.  tplandsea == 6 .or.tplandsea ==7) Then
			modis_obsnum(modlon_scp,modlat_scp) = modis_obsnum(modlon_scp,modlat_scp) + 1
			modis_r645(modlon_scp,modlat_scp) = modis_r645(modlon_scp,modlat_scp) + reflect645
			modis_bt11(modlon_scp,modlat_scp) = modis_bt11(modlon_scp,modlat_scp) + tpbt11	
		EndIf

		EndIf ! if daytime
		EndDo
	EndDo 

	call MPI_Gather(modis_obsnum,360*180,MPI_INTEGER,back_modis_obsnum,360*180,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_r645,360*180,MPI_REAL,back_modis_r645,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
	
	call MPI_Gather(modis_bt11,360*180,MPI_REAL,back_modis_bt11,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	include 'deallocate_array.file'
 IF (myid == my_root) Then
	Tmodis_obsnum=sum(back_modis_obsnum,3)
	Tmodis_r645 = sum(back_modis_r645,3)
	Tmodis_bt11 = sum(back_modis_bt11,3)

	wfname=trim("modisphase_radiation_"//cld_date//".hdf")
	call write_cldphase_heter(wfname)	
	print *,'finish writing'
	deallocate(mod03_list)
	call system("rm -rf count*")
	call system("rm -rf mod02*")
	call date_and_time(values=values)
  EndIf

    call MPI_FINALIZE(mpi_err)	
	
 end
