		!*****************************************************************
		!       read from CloudSat product
		!****************************************************************

			subroutine read_cldclass(file_name)

			use global

			implicit none

			! declarations
			integer (kind=4) :: fid,swid,status,astat
			integer (kind=4) :: swopen,swattach,swdetach,swclose
			integer (kind=4) :: swfldinfo,swrdfld,swrdattr
			integer (kind=4) :: rank,dim_sizes(7),datatype,i,j
			character (len=255) :: n_attrs
			integer (kind=4) :: start(32),stride(32),edges(32)

			character (len=120) :: file_name,swathname,fieldname
				! declarations for fields to read
			integer,parameter :: DFACC_READ=1
				

			!======= choose the file and field to read
			swathname = "2B-CLDCLASS-LIDAR"
			!======= open the file
			fid = swopen(file_name, DFACC_READ)
			if (fid .eq. -1) then
				print *,'CANNOT OPEN CLDCLASS FILE',fid,file_name
				stop
			endif
		!	print *,fid
		 
			!======= attach to the swath
			swid = swattach(fid,swathname)
			if (swid .eq. -1) then
				print *,'CANNOT ATTACH TO SWATH(CLDCLASS)',swid
				stop
			endif
		 
			!======= get field information
			status = swfldinfo(swid,'CloudLayerTop',rank,&
						dim_sizes,datatype,n_attrs)
			if (status .ne. 0) then
				print *,'CANNOT GET FIELD INFO',status
				stop
			endif

			NROW=dim_sizes(2)
	allocate(dem_hgt(NROW))	
   	allocate(lon(NROW))
    allocate(lat(NROW))
    allocate(clayer(NROW))
	allocate(cldtime(NROW))
    allocate(cphase(10,NROW))
    start(1:2) = 0
	stride(1:2) = 1
	!======= read the field
    !========1 D=============        
	status = swrdfld(swid,'Latitude',start,stride,dim_sizes(2:2),lat)
	status = swrdfld(swid,'Longitude',start,stride,dim_sizes(2:2),lon)
	status = swrdfld(swid,'Cloudlayer',start,stride,dim_sizes(2:2),clayer)
	status = swrdfld(swid,'DEM_elevation',start,stride,dim_sizes(2:2),dem_hgt)
	status = swrdfld(swid,'Profile_time',start,stride,dim_sizes(2:2),cldtime)

   !=======2 D============
    status = swrdfld(swid,'CloudPhase',start,stride,&
                        dim_sizes(1:rank),cphase)

!	print *,cphase(1:10,4),file_name
!        stop
!======= detach from the swath
	status = swdetach(swid)
	if (status .ne. 0) then
		print *,'CANNOT DETACH FROM SWATH',status
		stop
	endif
 
	!======= close the file
	status = swclose(fid)
	if (status .ne. 0) then
		print *,'CANNOT CLOSE FILE',status
		stop
	endif

       ! print *, lat(10)
       ! print *, lon(10)
       ! print *, clayer(10)
       ! print *, cbase(:,10)
       ! print *, ctop(:,10)
       ! print *, wc_top(:,10)
       ! print *, cphase(:,10)
       ! print *, preci_flag(:,10)
        
   end
