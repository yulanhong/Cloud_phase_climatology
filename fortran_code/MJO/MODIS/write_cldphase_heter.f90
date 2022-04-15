        subroutine write_cldphase_heter (FILE_NAME)

        use global, only : dimx,dimy,Ninterval,hetero_x,Tspa_heteronum,Tcldphase_fre,&
		Thetero_pdf,Tspa_hetero,Tspa_bt11,Tspa_reflect645
        
        implicit none
 
!******* Function declaration.**************************************
!
        integer sfstart,sfcreate, sfsnatt, sfwdata, sfendacc, sfend, &
                sfsattr
 
!**** Variable declaration *******************************************
!
        character(len=250) ::  FILE_NAME
        character(len=20) :: SDS_NAME

        integer  ::     RANK
        integer :: parameter,DFACC_CREATE=4,DFNT_INT16=22,DFNT_INT32=24,&
                DFNT_FLOAT32=5,DFNT_CHAR8=4,DFNT_FLOAT=5,DFNT_INT8=21
        integer :: fid, sds_id, status
        integer :: start ( 3 ), edges ( 3 ), stride ( 3 ),dim_sizes(3)
        integer :: i, j
        real :: miss_value,offset,factor,datarange(2)

        fid = sfstart( FILE_NAME, DFACC_CREATE )
        IF (fid==-1) then
                print *,'process stop at writing file: ',FILE_NAME
                stop
        ENDIF

!***************WRITE GEODATAFIELD************************************     
		RANK=1
!        SDS_NAME="satclr_modcld_num"
        dim_sizes(1)=Ninterval
        start  ( 1 ) = 0
        edges  ( 1 ) = Ninterval
        stride ( 1 ) = 1
!        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!        status=sfwdata ( sds_id, start, stride, edges, Tmodcld_satclr )
!		status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,'pixel clear by cloudsat but cloudy by modis')
!        status = sfendacc ( sds_id )
	

		SDS_NAME='hetero_invertal'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, hetero_x )
		status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,'log10 hetero')
        status = sfendacc ( sds_id )

        RANK=2           
        SDS_NAME="subarea_hetero_pdf"
        dim_sizes(1)=Ninterval
	    dim_sizes(2)=8
        
        start  ( 1:2 ) = 0
        edges  ( 1 ) = Ninterval
        edges  ( 2 ) = 8
        stride ( 1:2 ) = 1
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Thetero_pdf )
        status = sfendacc ( sds_id )

        SDS_NAME="subarea_cldphase_fre"
        dim_sizes(1)=5
        edges(1)=5 
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tcldphase_fre )
		status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,'number of 5 cloud scences:1-ice,&
		2-liq,3-mixed,4-undertermined,5-clear')
        status = sfendacc ( sds_id )

		Rank=3
        start  ( 1:3 ) = 0
        edges  ( 1 ) = dimx
        edges  ( 2 ) = dimy
		edges  (3) =8 
        dim_sizes(1)=dimx
	    dim_sizes(2)=dimy
		dim_sizes(3)=8
        stride ( 1:3 ) = 1
        SDS_NAME="hetero_spatial_num"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_heteronum )
        status = sfendacc ( sds_id )
	
        SDS_NAME="hetero_spatial"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_hetero/Tspa_heteronum )
        status = sfendacc ( sds_id )

        SDS_NAME="reflect645_spatial"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_reflect645/Tspa_heteronum )
        status = sfendacc ( sds_id )

        SDS_NAME="bt11_spatial"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_bt11/Tspa_heteronum )
        status = sfendacc ( sds_id )

        status = sfend ( fid )
!        print *,status
        print *,'finish writing',file_name

        end subroutine write_cldphase_heter
