        subroutine write_cldphase_heter (FILE_NAME)

        use global, only : Tmodis_obsnum,Tmodis_r645,Tmodis_bt11
        
        implicit none
 
!******* Function declaration.**************************************
!
        integer sfstart,sfcreate, sfsnatt, sfwdata, sfendacc, sfend, &
                sfsattr
 
!**** Variable declaration *******************************************
!
        character(len=200) ::  FILE_NAME
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

		Rank=2
		dim_sizes(1)=360
		dim_sizes(2)=180
        edges(1) =360 
        edges(2) =180
		start(1:2)=0
		stride(1:2)=1

        SDS_NAME="modis_obsnum"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata (sds_id, start, stride, edges,Tmodis_obsnum)
        status = sfendacc ( sds_id )

        SDS_NAME="modis_reflectance_645"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,Tmodis_r645/Tmodis_obsnum)
        status = sfendacc( sds_id )


        SDS_NAME="modis_bt_11"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,Tmodis_bt11/Tmodis_obsnum)
        status = sfendacc ( sds_id )

        status = sfend ( fid )
!        print *,status
        print *,'finish writing',file_name

        end subroutine write_cldphase_heter
