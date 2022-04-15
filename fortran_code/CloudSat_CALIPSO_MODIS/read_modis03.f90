        subroutine read_modis03(fname)

        use global, only: modlat,modlon,modNrow,modNcol,solarzenith,landsea 

        implicit none

        !-----------------------------------------
        character(len=91) :: fname,sds_name
		real :: vscale
		integer (kind=2),allocatable :: solarzenith_1(:,:)

        integer :: fid,sd, sid, DFACC_READ=1
		integer :: rank, data_type, n_attrs
		integer :: dim_sizes(32), start(32), edges(32), stride(32)
        integer :: sfstart,sfselect,sfrdata,sfendacc,sfend,sffattr,&
                sfrattr,  err_code, sfn2index
        integer :: status
        integer :: sffinfo , sfginfo

        fid=sfstart(fname,DFACC_READ)

        sid=sfn2index(fid,'Latitude')
        sd =sfselect(fid,sid)
        
		status=sfginfo(sd,sds_name,rank,dim_sizes,data_type,n_attrs)
		start(1:2)=0
		edges(1)=dim_sizes(1)
		edges(2)=dim_sizes(2)
		stride(1:2)=1
		allocate(modlat(dim_sizes(1),dim_sizes(2)))
		status=sfrdata(sd,start,stride,edges,modlat)		
		status=sfendacc(sd)
	
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

		sds_name='Land/SeaMask'
 	    sid=sfn2index(fid,sds_name)
 	    sd =sfselect(fid,sid)
 	    allocate(landsea(dim_sizes(1),dim_sizes(2)))
 	    status=sfrdata(sd,start,stride,edges,landsea)
	    status=sfendacc(sd)


		status=sfend(fid)
	
		deallocate(solarzenith_1)
  
        end
