        subroutine write_cldphase_heter (FILE_NAME)

        use global, only : dimx,dimy,Tspa_reflect645_num,&
                Tspa_reflect645,Tspa_BT11_num,Tspa_BT11,&
                Tspectral_rad_sza_num,Tspectral_rad_sza,&
                Tspectral_rad_sza_square,Treflect645_pdf,&
                TBT11_pdf,TBTD_pdf,N645,N213,NBT11,NBTD,Nratio,&
				Tratio_645_21,TBT11_BTD_2dpdf,Ntau,tau_interval,&
				Ttau_reflect645_iceonly,Ttau_BT11_iceonly,&
				Ttau_BTD_iceonly,Ttau_reflect13_iceonly,&
				Thetero_ratio,Tmodcldfraction_ratio,Tmodliqfraction_ratio,&
				Thetero_reflect645,Tmodcldfraction_reflect645,Tmodliqfraction_reflect645,&
				Thetero_BT11,Tmodcldfraction_BT11,Tmodliqfraction_BT11,&
				Thetero_BTD,Tmodcldfraction_BTD,Tmodliqfraction_BTD,&
				Treflect213_pdf,TR645_213_2dpdf_clr,TR645_213_ratio_clr
        
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

        fid = sfstart( trim(FILE_NAME), DFACC_CREATE )
        IF (fid==-1) then
                print *,'process stop at writing file: ',FILE_NAME
                stop
        ENDIF

       !***************WRITE GEODATAFIELD************************************     
		Rank=1
		start(1)=0
        stride(1)=1
        edges (1) =Ntau
        dim_sizes(1)=Ntau

        SDS_name='tau_interval(log)'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, tau_interval)
        status = sfendacc (sds_id)

        Rank=2
        start (1:2)=0
        stride(1:2)=1
        edges (1) =N645
        edges (2) =7 
        dim_sizes(1)=N645
        dim_sizes(2)=7
        
        SDS_name='reflect645_pdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Treflect645_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'pdf in the subarea')
        status = sfendacc (sds_id)

	    SDS_name='hetero_reflect645'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Thetero_reflect645/Treflect645_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'hetero as a function of reflectance 0.645')
        status = sfendacc (sds_id)

	    SDS_name='modcldfraction_reflect645'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodcldfraction_reflect645/Treflect645_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of reflect 0.645')
        status = sfendacc (sds_id)

	    SDS_name='modliqfraction_reflect645'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodliqfraction_reflect645/Treflect645_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of reflect 0.645')
        status = sfendacc (sds_id)

        edges (1)=N213
        dim_sizes(1)=N213
	    SDS_name='reflect213_pdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,Treflect213_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'reflectance 0.213, resolution0.001')
        status = sfendacc (sds_id)

        edges (1) =Nratio
        dim_sizes(1)=Nratio
        SDS_name='reflect_ratio_pdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tratio_645_21)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'reflectance of 1.6 to 0.645 pdf in the subarea')
        status = sfendacc (sds_id)
    
	    SDS_name='hetero_ratio'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Thetero_ratio/Tratio_645_21)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'hetero as a function of 2.1/1.6 reflectance ratio')
        status = sfendacc (sds_id)

	    SDS_name='modcldfraction_ratio'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodcldfraction_ratio/Tratio_645_21)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of 2.1/1.6 reflectance ratio')
        status = sfendacc (sds_id)

	    SDS_name='modliqfraction_ratio'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodliqfraction_ratio/Tratio_645_21)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis liqcloud fraction in 5x5m2 as a function of 2.1/1.6 reflectance ratio')

        edges (1) =NBT11
        dim_sizes(1)=NBT11
        SDS_name='BT11_pdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, TBT11_pdf)
        status = sfendacc (sds_id)

	    SDS_name='hetero_BT11'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Thetero_BT11/TBT11_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'hetero as a function of BT 11')
        status = sfendacc (sds_id)

	    SDS_name='modcldfraction_BT11'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodcldfraction_BT11/TBT11_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of BT11')
        status = sfendacc (sds_id)

	    SDS_name='modliqfraction_BT11'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodliqfraction_BT11/TBT11_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of BT11')
        status = sfendacc(sds_id)



        edges (1) =NBTD
        dim_sizes(1)=NBTD
        SDS_name='BTD8.5_11_pdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, TBTD_pdf)
        status = sfendacc (sds_id)

	    SDS_name='hetero_BTD'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Thetero_BTD/TBTD_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'hetero as a function of BTD')
        status = sfendacc (sds_id)

	    SDS_name='modcldfraction_BTD'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodcldfraction_BTD/TBTD_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of BTD')
        status = sfendacc (sds_id)

	    SDS_name='modliqfraction_BTD'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Tmodliqfraction_BTD/TBTD_pdf)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
                'modis cloud fraction in 5x5m2 as a function of BTD')
        status = sfendacc(sds_id)

        edges (1) =Ntau
        edges (2) =N645
        dim_sizes(1)=Ntau
        dim_sizes(2)=N645

        SDS_name='tau_reflect645_iceonly'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Ttau_reflect645_iceonly)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,20,&
                '2dhis_for ice only')
        status = sfendacc (sds_id)

        SDS_name='tau_reflect1375_iceonly'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Ttau_reflect13_iceonly)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,20,&
                '2dhis_for ice only')
        status = sfendacc (sds_id)

        edges (2) =NBT11
        dim_sizes(2)=NBT11
        SDS_name='tau_BT11_iceonly'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Ttau_BT11_iceonly)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,20,&
                '2dhis_for ice only')
        status = sfendacc (sds_id)
		
        edges (2) =NBTD
        dim_sizes(2)=NBTD
        SDS_name='tau_BTD_iceonly'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, Ttau_BTD_iceonly)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,20,&
                '2dhis_for ice only')
        status = sfendacc (sds_id)

        Rank=3
        start  ( 1:3 ) = 0
        edges  ( 1 ) = dimx
        edges  ( 2 ) = dimy
        edges  (3) =7 
        dim_sizes(1)=dimx
        dim_sizes(2)=dimy
        dim_sizes(3)=7
        stride ( 1:3 ) = 1
        SDS_NAME="reflect0.645_num"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
       status=sfwdata(sds_id, start, stride, edges, Tspa_reflect645_num)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
        'number of 7 cloud scences:1-ice,&
        2-mix,3-liq,4-ice-liq,5-ice-mixed,6-clear,7-all')
        status = sfendacc (sds_id)

        SDS_NAME="reflectance_0.645"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, &
                Tspa_reflect645/Tspa_reflect645_num)
        status = sfendacc(sds_id)

        SDS_NAME="BT_11_num"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                 Tspa_BT11_num)
        status = sfendacc(sds_id)

        SDS_NAME="BT_11"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                 Tspa_BT11/Tspa_BT11_num)
        status = sfendacc(sds_id)

        edges (1) =NBT11
        dim_sizes(1)=NBT11
        edges (2) =NBTD
        dim_sizes(2)=NBTD

        SDS_name='BT11_BTD_2dpdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, TBT11_BTD_2dpdf)
        status = sfendacc (sds_id)

        edges (1) =N645
        dim_sizes(1)=N645
        edges (2) =N213
        dim_sizes(2)=N213

        SDS_name='reflect1621_2dpdf'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, TR645_213_2dpdf_clr)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
			'2dpdf of reflectance 1.6,2.1 um')
        status = sfendacc (sds_id)

        SDS_name='reflect1621_ratio'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, TR645_213_ratio_clr)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,100,&
			'reflectance ratio in 2dpdf of reflectance 1.6,2.1 um')
        status = sfendacc (sds_id)

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
        status=sfwdata(sds_id, start, stride, edges, &
                Tspectral_rad_sza_num)
        status = sfendacc(sds_id)

        SDS_NAME="subarea_radsza"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges,&
                Tspectral_rad_sza/Tspectral_rad_sza_num )
        status = sfendacc ( sds_id )

        SDS_NAME="subarea_radsza_square"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata ( sds_id, start, stride, edges,&
         Tspectral_rad_sza_square/Tspectral_rad_sza_num )
        status = sfendacc ( sds_id )

        status = sfend ( fid )
!        print *,status
        print *,'finish writing',file_name

        end subroutine write_cldphase_heter
