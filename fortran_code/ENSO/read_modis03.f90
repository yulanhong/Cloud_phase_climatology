        subroutine read_modis03(fname)

		use global, only: modlat,modlon,modNrow,modNcol,solarzenith,landsea 
		
        implicit none

        !-----------------------------------------
        character(len=200) :: fname,sds_name
		real :: vscale
		integer (kind=2),allocatable :: solarzenith_1(:,:)

        integer :: fid,sd, sid, DFACC_READ=1
		integer :: rank, data_type, n_attrs
		integer :: dim_sizes(32), start(32), edges(32), stride(32)
        integer :: sfstart,sfselect,sfrdata,sfendacc,sfend,sffattr,&
                sfrattr,  err_code, sfn2index
        integer :: status
        integer :: sffinfo , sfginfo

		!print *,'1 nrow', NROW
		
        fid=sfstart(fname,DFACC_READ)
		sds_name='Latitude'
        sid=sfn2index(fid,'Latitude')
        sd =sfselect(fid,sid)
		status=sfginfo(sd,sds_name,rank,dim_sizes,data_type,n_attrs)
		start(1:2)=0
		edges(1)=dim_sizes(1)
		edges(2)=dim_sizes(2)
     
	 	modNrow = dim_sizes(2)
        modNcol = dim_sizes(1)

		stride(1:2)=1
		allocate(modlat(dim_sizes(1),dim_sizes(2)))
		status=sfrdata(sd,start,stride,edges,modlat)		
		status=sfendacc(sd)
	
	!	print *,dim_sizes,modNrow,modNcol,shape(modlat),modlat(1:2,1:2)
		!print *,'2 nrow', NROW
		sds_name='Longitude'
        sid=sfn2index(fid,'Longitude')
        sd =sfselect(fid,sid)
		status=sfginfo(sd,sds_name,rank,dim_sizes,data_type,n_attrs)
		!print *, rank,dim_sizes
		start(1:2)=0
		edges(1)=dim_sizes(1)
		edges(2)=dim_sizes(2)
		stride(1:2)=1
		allocate(modlon(dim_sizes(1),dim_sizes(2)))

		status=sfrdata(sd,start,stride,edges,modlon)		
		!print *,shape(modlon),modlon(1:2,1:2)
	
		status=sfendacc(sd)

		sds_name='SolarZenith'
        sid=sfn2index(fid,'SolarZenith')
        sd =sfselect(fid,sid)
		status=sfginfo(sd,sds_name,rank,dim_sizes,data_type,n_attrs)

		start(1:2)=0
		edges(1)=dim_sizes(1)
		edges(2)=dim_sizes(2)
		stride(1:2)=1
		allocate(solarzenith_1(dim_sizes(1),dim_sizes(2)))
		allocate(solarzenith(dim_sizes(1),dim_sizes(2)))
		status=sfrdata(sd,start,stride,edges,solarzenith_1)		
		vscale=0.01
		solarzenith=solarzenith_1*vscale
		status=sfendacc(sd)
		deallocate(solarzenith_1)
		!print *,shape(solarzenith),solarzenith(1:2,1:2)

		sds_name='Land/SeaMask'
        sid=sfn2index(fid,sds_name)
        sd =sfselect(fid,sid)
		allocate(landsea(dim_sizes(1),dim_sizes(2)))
		status=sfrdata(sd,start,stride,edges,landsea)		
		status=sfendacc(sd)
		
!		print *,shape(landsea),landsea(1:2,1:2)
	
		status=sfend(fid)
	
		!print *,'4 nrow in mod03',NROW
		
        end
