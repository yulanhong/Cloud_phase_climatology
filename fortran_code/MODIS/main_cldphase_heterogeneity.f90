	program main_cldphase_heterogeneity

	use global

	implicit none

	include 'mpif.h'

	!*********** initialze *****************
	character(len=200) :: mod03dir,mod06dir,wfname
	character(len=12) :: strday
	character(len=4) :: yrindex
	character(len=6) :: cld_date
	character(len=41) :: myday
	character(len=41), allocatable :: mod03_list(:)

	character(len=200) :: mod03fname
	character(len=94) :: mod06fname

 	integer (kind=2) :: mod03_nfname,mod06_nfname
    integer (kind=4) :: status
    integer :: values(8)


	!=================== modis ================================
	integer :: modlat_scp, modlon_scp, rowi, colj, sigmai
	real :: Rsigma,tplon,tplat 
	integer :: Hsigma_scp,sigmaind(1),ki
	real :: hetero_index(Ninterval),diff_sigma(Ninterval)
	real :: tpmodfra,tpliqfra
	integer :: colupres,collowres,rowupres,rowlowres
	!=================== modis-cloudsat =======================
	integer (kind=4) :: modis_clrnum(360,180), modis_liqnum(360,180),&
        modis_icenum(360,180), modis_obsnum(360,180),&
		modis_undernum(360,180),hetero_pdf(Ninterval,6) 

	real (kind=4) :: modcldfraction(Ninterval,6),modliqfraction(Ninterval,6)

    real (kind=4) :: modis_clrhetero(360,180), modis_liqhetero(360,180),&
        modis_icehetero(360,180),modis_underhetero(360,180),modis_obshetero(360,180) 

	!************* initalize data to send ************
	integer (kind=4), allocatable :: back_modis_clrnum(:,:,:),back_modis_liqnum(:,:,:),&
        back_modis_icenum(:,:,:), back_modis_obsnum(:,:,:),&
		back_modis_undernum(:,:,:),back_hetero_pdf(:,:,:)

	real (kind=4), allocatable :: back_modis_clrhetero(:,:,:),back_modis_liqhetero(:,:,:),&
        back_modis_icehetero(:,:,:), back_modis_obshetero(:,:,:),back_modis_underhetero(:,:,:),&
		back_modcldfraction(:,:,:),back_modliqfraction(:,:,:) 

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

	allocate(back_modis_clrnum(360,180,nodes))
	allocate(back_modis_liqnum(360,180,nodes))
	allocate(back_modis_icenum(360,180,nodes))
	allocate(back_modis_undernum(360,180,nodes))
	allocate(back_modis_obsnum(360,180,nodes))
	allocate(back_hetero_pdf(Ninterval,6,nodes))
	allocate(back_modis_clrhetero(360,180,nodes))
	allocate(back_modis_liqhetero(360,180,nodes))
	allocate(back_modis_icehetero(360,180,nodes))
	allocate(back_modis_underhetero(360,180,nodes))
	allocate(back_modis_obshetero(360,180,nodes))
	allocate(back_modcldfraction(Ninterval,6,nodes))
	allocate(back_modliqfraction(Ninterval,6,nodes))
	EndIf

	call MPI_SCATTER(mod03_list,41,MPI_CHARACTER,myday,&
    41,MPI_CHARACTER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_BCAST(cld_date,6,MPI_CHARACTER,&
        my_root,MPI_COMM_WORLD,mpi_err)

	yrindex=cld_date(1:4)
	
	Do sigmai=1,Ninterval
		 hetero_index(sigmai)=sigmai*0.01-6.0
	EndDo

	hetero_x=hetero_index
!	hetero_x=[0.0,1.0e-4,2.0e-4,3.0e-4,4.0e-4,5.0e-4,6.0e-4,7.0e-4,8.0e-4,9.0e-4,&
!			  1.0e-3,2.0e-3,3.0e-3,4.0e-3,5.0e-3,6.0e-3,7.0e-3,8.0e-3,9.0e-3,&	
!			  1.0e-2,2.0e-2,3.0e-2,4.0e-2,5.0e-2,6.0e-2,7.0e-2,8.0e-2,9.0e-2,&	
!			  1.0e-1,2.0e-1,3.0e-1,4.0e-1,5.0e-1,6.0e-1,7.0e-1,8.0e-1,9.0e-1,&	
!			  1.0e-0,2.0e-0,3.0e-0,4.0e-0,5.0e-0,6.0e-0,7.0e-0,8.0e-0,9.0e-0,10.0]	

	hetero_pdf=0

	mod03dir="/u/sciteam/yulanh/scratch/MODIS/MYD03/"//yrindex//"/"//cld_date//"/"
	mod06dir="/u/sciteam/yulanh/scratch/MODIS/MYD06/"//yrindex//"/"//cld_date//"/"

	!=========== read modis file ===========================================
	!======== search modis file in the same day as cldclass file ============
	strday=myday(8:19)
	print *,myid,strday
	call system("ls "//trim(mod06dir)//"MYD06_L2.A"//strday//"*"//" > mod06file"//strday,status)
	
	call system("cat mod06file"//strday//" | wc -l > countmod06"//strday)
	open(450,file="countmod06"//strday)
	read(450,*) mod06_nfname
	close(450)
	open(500,file="mod06file"//strday)
	read(500,fmt="(a94)",iostat=status) mod06fname
    close(500)
	
	mod03fname=trim(mod03dir)//myday
 	
	call read_modis03(mod03fname)
    call read_modis06(mod06fname)
  
	Do colj=1,modNcol
		Do rowi=1, modNrow
		
		IF (solarzenith(colj,rowi) > 0.0 .and. solarzenith(colj,rowi) < 90.0 .and. &
	sensorzenith(colj,rowi) >= 0.0 .and. sensorzenith(colj,rowi) <= 0.5) Then
		
		tplat=modlat(colj,rowi)
		tplon=modlon(colj,rowi)
	
		modlat_scp=nint(modlat(colj,rowi)+90)
   		modlon_scp=nint(modlon(colj,rowi)+180)

		Rsigma=cld_spi(1,colj,rowi)/100.0
		diff_sigma=abs(log10(Rsigma)-hetero_x)
     	sigmaind=minloc(diff_sigma)
		Hsigma_scp=sigmaind(1)

	!	If (abs(Rsigma) > 10) then
	!		print *, Rsigma, colj,rowi, mod06fname
	!		stop
	!	Endif

		colupres=colj+2
		collowres=colj-2
		rowupres=rowi+2
		rowlowres=rowi-2

		IF (colj < 2) collowres=1
		IF (colj > modNcol-2) colupres=modNcol
		IF (rowi < 2) rowlowres=1
		IF (rowi > modNrow-2) rowupres=modNrow	

		tpmodfra=&
		count(modcldphase(collowres:colupres,rowlowres:rowupres) .ge. 1)&
		/((rowupres-rowlowres+1.0)*(colupres-collowres+1.0))
		tpliqfra=&
		count(modcldphase(collowres:colupres,rowlowres:rowupres) .eq. 1)&
		/((rowupres-rowlowres+1.0)*(colupres-collowres+1.0))
!		print *,colj,rowi,modcldphase(collowres:colupres,rowlowres:rowupres)
!		print *,tpmodfra , (rowupres-rowlowres+1)*(colupres-collowres+1)

		!==== calculate cloud fraction in 5x5 pixels 	
	
		! clear
    	IF (modcldphase(colj,rowi) == 0) Then
        	modis_clrnum(modlon_scp,modlat_scp) = modis_clrnum(modlon_scp,modlat_scp)+1
   
			IF (landsea(colj,rowi) == 0 .or. landsea(colj,rowi) == 6 .or. &
			landsea(colj,rowi) ==7 ) Then
	     	modis_clrhetero(modlon_scp,modlat_scp)= modis_clrhetero(modlon_scp,modlat_scp)+Rsigma
       		IF ((tplat .ge. -10 .and. tplat .le. 30) .and. (tplon .ge. 80 .and. tplon .le. 150)) Then
				 hetero_pdf(Hsigma_scp,1)=hetero_pdf(Hsigma_scp,1)+1 
				 modcldfraction(Hsigma_scp,1)=modcldfraction(Hsigma_scp,1)+tpmodfra
				 modliqfraction(Hsigma_scp,1)=modliqfraction(Hsigma_scp,1)+tpliqfra
			EndIf
			EndIf 
        !print *,cld_spi(1,colj,rowi)
    	EndIf
		! liquid
    	IF (modcldphase(colj,rowi) == 1) Then
        	modis_liqnum(modlon_scp,modlat_scp) = modis_liqnum(modlon_scp,modlat_scp)+1
		!	IF (landsea(colj,rowi) == 0 .or. landsea(colj,rowi) == 2 .or. landsea(colj,rowi) == 6 .or. &
	!		 landsea(colj,rowi) ==7 ) Then
    		IF (landsea(colj,rowi) .ne. 1) Then
	    	modis_liqhetero(modlon_scp,modlat_scp)= modis_liqhetero(modlon_scp,modlat_scp)+Rsigma
       		IF ((tplat .ge. -10 .and. tplat .le. 30) .and. (tplon .ge. 80 .and. tplon .le. 150)) Then
			 hetero_pdf(Hsigma_scp,2)=hetero_pdf(Hsigma_scp,2)+1 
			 modcldfraction(Hsigma_scp,2)=modcldfraction(Hsigma_scp,2)+tpmodfra
			 modliqfraction(Hsigma_scp,2)=modliqfraction(Hsigma_scp,2)+tpliqfra
			EndIf
			EndIf 
    	EndIf
		! ice
    	IF (modcldphase(colj,rowi) == 2) Then
       		modis_icenum(modlon_scp,modlat_scp)= modis_icenum(modlon_scp,modlat_scp)+1
			IF (landsea(colj,rowi) == 0 .or. landsea(colj,rowi) == 6 .or. &
			 landsea(colj,rowi) ==7 ) Then
        	modis_icehetero(modlon_scp,modlat_scp)= modis_icehetero(modlon_scp,modlat_scp)+Rsigma
       		IF ((tplat .ge. -10 .and. tplat .le. 30) .and. (tplon .ge. 80 .and. tplon .le. 150)) Then
			 hetero_pdf(Hsigma_scp,3)=hetero_pdf(Hsigma_scp,3)+1 
			 modcldfraction(Hsigma_scp,3)=modcldfraction(Hsigma_scp,3)+tpmodfra
			 modliqfraction(Hsigma_scp,3)=modliqfraction(Hsigma_scp,3)+tpliqfra
			EndIf
			EndIf 
    	EndIf
		!=== undetermined 
    	IF (modcldphase(colj,rowi) .eq. 6) Then
       		modis_undernum(modlon_scp,modlat_scp)= modis_undernum(modlon_scp,modlat_scp)+1
			IF (landsea(colj,rowi) == 0 .or. landsea(colj,rowi) == 6 .or. &
			 landsea(colj,rowi) ==7 ) Then
        	modis_underhetero(modlon_scp,modlat_scp)= modis_underhetero(modlon_scp,modlat_scp)+Rsigma
       		IF ((tplat .ge. -10 .and. tplat .le. 30) .and. (tplon .ge. 80 .and. tplon .le. 150)) Then
			 hetero_pdf(Hsigma_scp,5)=hetero_pdf(Hsigma_scp,5)+1 
			 modcldfraction(Hsigma_scp,5)=modcldfraction(Hsigma_scp,5)+tpmodfra
			 modliqfraction(Hsigma_scp,5)=modliqfraction(Hsigma_scp,5)+tpliqfra
			EndIf
			EndIf 
    	EndIf
    	IF (modcldphase(colj,rowi) .eq. 3) Then
			IF (landsea(colj,rowi) == 0 .or. landsea(colj,rowi) == 6 .or. &
			 landsea(colj,rowi) ==7) Then
       		IF ((tplat .ge. -10 .and. tplat .le. 30) .and. (tplon .ge. 80 .and. tplon .le. 150)) Then
			 hetero_pdf(Hsigma_scp,4)=hetero_pdf(Hsigma_scp,4)+1 
			 modcldfraction(Hsigma_scp,4)=modcldfraction(Hsigma_scp,4)+tpmodfra
			 modliqfraction(Hsigma_scp,4)=modliqfraction(Hsigma_scp,4)+tpliqfra
			EndIf
			EndIf 
		EndIf

    	modis_obsnum(modlon_scp,modlat_scp)=modis_obsnum(modlon_scp,modlat_scp)+1
		IF (landsea(colj,rowi) == 0 .or.  landsea(colj,rowi) == 6 .or. &
		landsea(colj,rowi) ==7 ) Then
    	modis_obshetero(modlon_scp,modlat_scp)= modis_obshetero(modlon_scp,modlat_scp)+Rsigma
       	IF ((tplat .ge. -10 .and. tplat .le. 30) .and. (tplon .ge. 80 .and. tplon .le. 150)) Then
		 hetero_pdf(Hsigma_scp,6)=hetero_pdf(Hsigma_scp,6)+1 
		 modcldfraction(Hsigma_scp,6)=modcldfraction(Hsigma_scp,6)+tpmodfra
		 modliqfraction(Hsigma_scp,6)=modliqfraction(Hsigma_scp,6)+tpliqfra
		EndIf
		EndIf
	
		EndIf ! if daytime
		EndDo
	EndDo 

	
	call MPI_Gather(modis_clrnum,360*180,MPI_INTEGER,back_modis_clrnum,360*180,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)
 
	call MPI_Gather(modis_liqnum,360*180,MPI_INTEGER,back_modis_liqnum,360*180,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_icenum,360*180,MPI_INTEGER,back_modis_icenum,360*180,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_undernum,360*180,MPI_INTEGER,back_modis_undernum,360*180,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_obsnum,360*180,MPI_INTEGER,back_modis_obsnum,360*180,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(hetero_pdf,Ninterval*6,MPI_INTEGER,back_hetero_pdf,Ninterval*6,&
         MPI_INTEGER,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modcldfraction,Ninterval*6,MPI_REAL,back_modcldfraction,Ninterval*6,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modliqfraction,Ninterval*6,MPI_REAL,back_modliqfraction,Ninterval*6,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_clrhetero,360*180,MPI_REAL,back_modis_clrhetero,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)
 
	call MPI_Gather(modis_liqhetero,360*180,MPI_REAL,back_modis_liqhetero,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_icehetero,360*180,MPI_REAL,back_modis_icehetero,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_underhetero,360*180,MPI_REAL,back_modis_underhetero,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	call MPI_Gather(modis_obshetero,360*180,MPI_REAL,back_modis_obshetero,360*180,&
         MPI_REAL,my_root,MPI_COMM_WORLD,mpi_err)

	include 'deallocate_array.file'
 IF (myid == my_root) Then
	Tmodis_clrnum=sum(back_modis_clrnum,3)
	Tmodis_liqnum=sum(back_modis_liqnum,3)
	Tmodis_icenum=sum(back_modis_icenum,3)
	Tmodis_undernum=sum(back_modis_undernum,3)
	Tmodis_obsnum=sum(back_modis_obsnum,3)
	Thetero_pdf=sum(back_hetero_pdf,3)
	Tmodis_clrhetero=sum(back_modis_clrhetero,3)
	Tmodis_liqhetero=sum(back_modis_liqhetero,3)
	Tmodis_icehetero=sum(back_modis_icehetero,3)
	Tmodis_underhetero=sum(back_modis_underhetero,3)
	Tmodis_obshetero=sum(back_modis_obshetero,3)
	Tmodcldfraction=sum(back_modcldfraction,3)
	Tmodliqfraction=sum(back_modliqfraction,3)
	
	wfname=trim("modisphase_heterogeneity_"//cld_date//"_newdomain_0.5.hdf")
	call write_cldphase_heter(wfname)	
	print *,'finish writing'
	deallocate(mod03_list)
	call system("rm -rf count*")
	call system("rm -rf mod06*")
	call date_and_time(values=values)
  EndIf

    call MPI_FINALIZE(mpi_err)	
	
 end
