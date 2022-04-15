        subroutine write_cldphase_heter (FILE_NAME)

        use global, only : dimx,dimy,Tspa_reflect645_num,Tspa_reflect645,Tspa_BT11,&
		Tspectral_rad_sza_num,Tspectral_rad_sza, Tspectral_rad_sza_square
        
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
		Rank=3
        start  ( 1:3 ) = 0
        edges  ( 1 ) = dimx
        edges  ( 2 ) = dimy
		edges  (3) =7 
        dim_sizes(1)=dimx
	    dim_sizes(2)=dimy
		dim_sizes(3)=7
        stride ( 1:3 ) = 1
        SDS_NAME="spatial_num"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_reflect645_num )
		status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,'number of 7 cloud scences:1-ice,&
        2-mix,3-liq,4-ice-liq,5-ice-mixed,6-clear,7-all')
        status = sfendacc ( sds_id )
	
        SDS_NAME="reflectance_0.645"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_reflect645/Tspa_reflect645_num)
        status = sfendacc ( sds_id )

        SDS_NAME="brightness_temprature_11"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspa_BT11/Tspa_reflect645_num)
        status = sfendacc ( sds_id )


        start  ( 1:3 ) = 0
        edges  ( 1 ) = 6
        edges  ( 2 ) = 70
		edges  (3) = 7 
        dim_sizes(1)= 6
	    dim_sizes(2)= 70
		dim_sizes(3)=7
        stride ( 1:3 ) = 1
        SDS_NAME="subarea_radsza_num"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tspectral_rad_sza_num)
        status = sfendacc(sds_id)
		
        SDS_NAME="subarea_radsza"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspectral_rad_sza/Tspectral_rad_sza_num )
        status = sfendacc ( sds_id )

        SDS_NAME="subarea_radsza_square"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges, Tspectral_rad_sza_square/Tspectral_rad_sza_num )
        status = sfendacc ( sds_id )

        status = sfend ( fid )
!        print *,status
        print *,'finish writing',file_name

        end subroutine write_cldphase_heter
