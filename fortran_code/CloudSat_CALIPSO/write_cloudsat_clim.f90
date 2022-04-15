        subroutine write_cloudsat_clim (FILE_NAME)

        use global
        
        implicit none
 
!******* Function declaration.**************************************
!
        integer sfstart,sfcreate, sfsnatt, sfwdata, sfendacc, sfend, &
                sfsattr
 
!**** Variable declaration *******************************************
!
        character(len=120) ::  FILE_NAME
        character(len=50) :: SDS_NAME

        integer  ::     RANK
        integer :: parameter,DFACC_CREATE=4,DFNT_INT16=22,&
                DFNT_INT32=24,&
                DFNT_FLOAT32=5,DFNT_CHAR8=4,DFNT_FLOAT=5,DFNT_INT8=21
        integer :: fid, sds_id, status
        integer :: start ( 4 ), edges ( 4 ), stride ( 4 ),dim_sizes(4)
        integer :: i, j,k
        real :: miss_value,offset,factor,datarange(2)

        real :: wlon(dimx), wlat(dimy)
!**** End of variable declaration ************************************

        FORALL (i=1:dimx) wlon(i)=(i-1)*lonbin_res-180+lonbin_res/2.0
        FORALL (j=1:dimy) wlat(j)=(j-1)*latbin_res-90+latbin_res/2.0

        print *,FILE_NAME
!        print *,wlat,wlon,wmon
!     Open the file and initialize the SD interface.
        fid = sfstart( FILE_NAME, DFACC_CREATE )
        IF (fid==-1) then
                print *,'process stop at writing file: ',FILE_NAME
                stop
        ENDIF

!***************WRITE GEODATAFIELD************************************     
        RANK=1           
        SDS_NAME="time"
        dim_sizes(1)=Nmon
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT8,RANK,dim_sizes)
        
        start  ( 1 ) = 0
        edges  ( 1 ) = Nmon
        stride ( 1 ) = 1
    
        factor=1.0
        offset=0.0
        status=sfwdata(sds_id, start, stride, edges, wmon)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,25,&
                '')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,1,'month') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
        datarange(1)=1.0
        datarange(2)=12.0
        status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)

        dim_sizes(1) = dimh
        start  ( 1 ) = 0
        edges  ( 1 ) = dimh 
        stride ( 1 ) = 1
    
        factor=1.0
        offset=0.0
	SDS_NAME='height'
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, height)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,6,&
                'height')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,1,'km') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
        datarange(1)=0.0
        datarange(2)=25
        status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)

        dim_sizes(1)=dimy
        edges  ( 1 ) = dimy
        SDS_NAME="latitude"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=1.0
        offset=0.0
        status=sfwdata ( sds_id, start, stride, edges, wlat )
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,8,'latitude')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,6,'degree') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
        datarange(1)=-90.0
        datarange(2)=90.0
        status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)

        SDS_NAME="longitude"
        dim_sizes(1)=dimx
        edges  ( 1 ) = dimx
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=1.0
        offset=0.0
        status=sfwdata ( sds_id, start, stride, edges, wlon )
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,9,'longitude')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,6,'degree') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
        datarange(1)=-180.0
        datarange(2)=180.0
        status=sfsnatt(sds_id,'range',DFNT_FLOAT32,2,datarange)

!*************** RANK=2 ********************************************
        RANK=2
        dim_sizes(1)=dimx
        dim_sizes(2)=dimy
        edges(1)=dimx
        edges(2)=dimy
        start(1)=0
        start(2)=0
        stride(1)=1
        stride(2)=1
        SDS_NAME="DEM_elevation"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges, allDem_elevation/sum(Tobsnum,3))
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'average diginal elevation map')

!****************write data field **********************************
        RANK=3
        dim_sizes(1)=dimx
        dim_sizes(2)=dimy
        dim_sizes(3)=Nmon
        edges(1)=dimx
        edges(2)=dimy
        edges(3)=Nmon
        start(1)=0
        start(2)=0
        start(3)=0
        stride(1)=1
        stride(2)=1
        stride(3)=1
        
        SDS_NAME="obsnum"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,Tobsnum)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Monthly average observation number')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)
        status=sfsnatt(sds_id,'missing_value',DFNT_FLOAT32,1,miss_value)

	SDS_NAME="monthly_surfcae_pressure"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmean_surf_p/Tobsnum)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'Including cloudy and clear sky')

	SDS_NAME="monthly_surfcae_temperature"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmean_surf_t/Tobsnum)

	SDS_NAME="monthly_surfcae_uwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmean_surf_u/Tobsnum)

	SDS_NAME="monthly_surfcae_vwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmean_surf_v/Tobsnum)

!****************** RANK 4*********************************
        RANK=4
        dim_sizes(1)=dimx
        dim_sizes(2)=dimy
        dim_sizes(3)=3
        dim_sizes(4)=Nmon
        edges(1)=dimx
        edges(2)=dimy
        edges(3)=3
        edges(4)=Nmon
        start(1)=0
        start(2)=0
        start(3)=0
        start(4)=0
        stride(1)=1
        stride(2)=1
        stride(3)=1
        stride(4)=1
        
!        SDS_NAME="precipitation_frequency"
!        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
!        factor=0.0
!        offset=0.0
!        miss_value=-99.0
!        status=sfwdata (sds_id, start, stride, edges,Tpreci_fre)
!        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,45,&
!             'precipitation_1liquid_2solid_3likelydrizzle')
!        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
!        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
!        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)

        SDS_NAME="onelayercloud_frequency"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,TOneLay_fre)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,33,&
             'onelayercloud_1ice_2mixed_3liquid')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)

        SDS_NAME="onelayercloud_topheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                All_onelaytopH/TOneLay_fre)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,40,&
             'onelayercloud_avetop_1ice_2mixed_3liquid')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)

        SDS_NAME="onelayercloud_baseheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                All_onelaybaseH/TOneLay_fre)

	SDS_NAME="onelayercloud_surfcae_pressure"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allonelay_surf_p/TOneLay_fre)

	SDS_NAME="onelayercloud_surfcae_temperature"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allonelay_surf_t/TOneLay_fre)

	SDS_NAME="onelayercloud_surfcae_uwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allonelay_surf_u/TOneLay_fre)

	SDS_NAME="onelayercloud_surfcae_vwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allonelay_surf_v/TOneLay_fre)

        SDS_NAME="mullayercloud_onephase_frequency"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,TMulLay_1fre)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'mullayercloud_1ice_2mixed_3liquid')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)

        SDS_NAME="mullayercloud_onephase_topheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                All1_mullaytopH/TMulLay_1fre)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'mullayercloud_1ice_2mixed_3liquid')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)

        SDS_NAME="mullayercloud_onephase_baseheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                All1_mullaybaseH/TMulLay_1fre)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,120,&
             'mullayercloud_1ice_2mixed_3liquid')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)

	SDS_NAME="mullayercloud_onephase_pressure"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_1surf_p/TMulLay_1fre)

	SDS_NAME="mullayercloud_onephase_temperature"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_1surf_t/TMulLay_1fre)

	SDS_NAME="mullayercloud_onephase_uwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_1surf_u/TMulLay_1fre)

	SDS_NAME="mullayercloud_onephase_vwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_1surf_v/TMulLay_1fre)

        SDS_NAME="mullayercloud_mulphase_frequency"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,TMulLay_nfre)
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,65,&
             'mullayercloud_1iceupliquidlow_2iceuplowermixed_3&
                mixedupliquidlow')
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,' ') 
        status=sfsnatt(sds_id,'offset',DFNT_FLOAT32,1,offset)
        status=sfsnatt(sds_id,'factor',DFNT_FLOAT32,1,factor)

        SDS_NAME="mullayercloud_mulphase_lowlaytopheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Alln_lowlaytopH/TMulLay_nfre)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'m') 

        SDS_NAME="mullayercloud_mulphase_lowlaybaseheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Alln_lowlaybaseH/TMulLay_nfre)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'m') 

        SDS_NAME="mullayercloud_mulphase_uplaytopheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Alln_uplaytopH/TMulLay_nfre)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'m') 

        SDS_NAME="mullayercloud_mulphase_uplaybaseheight"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Alln_uplaybaseH/TMulLay_nfre)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'m') 

	SDS_NAME="mullayercloud_mulphase_pressure"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_nsurf_p/TMulLay_nfre)

	SDS_NAME="mullayercloud_mulphase_temperature"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_nsurf_t/TMulLay_nfre)
	
	SDS_NAME="mullayercloud_mulphase_uwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_nsurf_u/TMulLay_nfre)

	SDS_NAME="mullayercloud_mulphase_vwind"	
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        status=sfwdata(sds_id, start, stride, edges,&
                allmullay_nsurf_v/TMulLay_nfre)

	dim_sizes(3) = dimh
	edges(3) = dimh

        SDS_NAME="obsnum_vertical"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Tobsnumv)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 

        SDS_NAME="onelaynum_vertical"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Tonelay_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 

        SDS_NAME="mullaynum_vertical"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                Tmullay_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 


        SDS_NAME="onelay_ice_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Tonelayic_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 

        SDS_NAME="onelay_mix_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata (sds_id, start, stride, edges,&
                Tonelaymc_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 

	

        SDS_NAME="mullay_ice_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                Tmullayic_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 

        SDS_NAME="iceup_mixlow_numv"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                Ticemix_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 


        SDS_NAME="liquinoicenum_vertical"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                Tliqnoice_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,65,&
             'liquid clouds withou ice above, including all layers')

        SDS_NAME="liquiwithicenum_vertical"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                Tliqice_frev)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,65,&
             'liquid clouds with ice above, including all layers')

	dim_sizes(3) = 2
	edges(3) = 2

        SDS_NAME="liquiwithice_liquidnum"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_INT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                Tliqice_freh)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,65,&
             'liquid clouds with ice above, for liquid only,0-onelayer,&
		1-mullayer')
	
        SDS_NAME="liquiwithice_liquidtop"
        sds_id = sfcreate(fid,SDS_NAME,DFNT_FLOAT32,RANK,dim_sizes)
        factor=0.0
        offset=0.0
        miss_value=-99.0
        status=sfwdata(sds_id, start, stride, edges,&
                allliqice_liqtop/Tliqice_freh)
        status=sfsattr(sds_id,'units',DFNT_CHAR8,4,'') 
        status=sfsattr(sds_id,'Longname',DFNT_CHAR8,65,&
             'liquid clouds with ice above, for liquid only,0-onelayer,&
		1-mullayer')

!*******************************************************************
        status = sfendacc ( sds_id )
!        print *,status
!     Terminate access to the SD interface and close the file.
!
        status = sfend ( fid )
!        print *,status
        print *,'finish writing',file_name

        end subroutine write_cloudsat_clim
