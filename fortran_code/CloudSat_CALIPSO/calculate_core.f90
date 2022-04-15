
        subroutine calculate_core()
       
        use global
        implicit none
        !*********local variables***************************
       
        integer :: hi,si,lat_scp,lon_scp,top_scp,base_scp,sfphase,&
		m1fphase,mnfphase, nliqflag,&
                fic,fwc,fmi,ific,ifwc,ifmi,rain_flag(3)
	integer :: top_scp_lay,base_scp_lay,surf_scp,temp_scp

        real :: tp_lat,tp_lon,tp_base(NCOL_S),tp_top(NCOL_S),&
                tp_wctop(NCOL_S),tp_prof_p(125),tp_prof_t(125),&
		tp_uwind(125),tp_vwind(125)

        integer(kind=1) :: tp_preci(NCOL_S),tp_layer,tp_phase(NCOL_S)
	integer(kind=2) :: tp_maphgt
	integer(kind=4) :: tp_frev(dimh)
       
        !print *,Julday,month,mon_scp 
	mon_scp=month
        wmon(mon_scp)=month
!        print *, shape(preci_flag)
 	obsnum=0
	!preci_fre=0
	OneLay_fre=0
	MulLay_1fre=0
	MulLay_nfre=0

	obsnumv=0
	allcld_frev=0
	onelay_frev=0
	onelayic_frev=0 
	onelaymc_frev=0
	liqnoice_frev=0

	mullay_frev=0
	mullayic_frev=0
	icemix_frev=0
	liqice_frev=0
	liqice_freh=0

	sum_onelaytopH=0.0
	sum_onelaybaseH=0.0
	sum1_mullaytopH=0.0
	sum1_mullaybaseH=0.0
	sumn_lowlaytopH=0.0
	sumn_lowlaybaseH=0.0
	sumn_uplaytopH=0.0
	sumn_uplaybaseH=0.0
	liqice_liqtop=0.0

	onelay_surf_p=0.0
	onelay_surf_t=0.0
	onelay_surf_u=0.0
	onelay_surf_v=0.0
	mullay_1surf_p=0.0
	mullay_1surf_t=0.0
	mullay_1surf_u=0.0
	mullay_1surf_v=0.0
	mullay_nsurf_p=0.0
	mullay_nsurf_t=0.0
	mullay_nsurf_u=0.0
	mullay_nsurf_v=0.0

	mean_surf_p=0.0
	mean_surf_T=0.0
	mean_surf_u=0.0
	mean_surf_v=0.0	

	DEM_elevation=0.0

       Do si=1,NROW

        tp_lat=lat(si)

        tp_lon=lon(si)
        
        !tp_preci=preci_flag(:,si)

        tp_layer=clayer(si)

        tp_phase=cphase(:,si)

        tp_base=cbase(:,si)
        
        tp_top=ctop(:,si)
        
        tp_wctop=wc_top(:,si)
        
	tp_prof_t=prof_t(:,si)

	tp_prof_p=prof_p(:,si)

	tp_uwind=uwind(:,si)

	tp_vwind=vwind(:,si)

	tp_maphgt=map_hgt(si)

	surf_scp=count(tp_uwind .ne. -999.0)

	temp_scp=nint(surf_t(si) - 250)
	if (temp_scp < 1) temp_scp=1
	if (temp_scp > Ntemp) temp_scp=Ntemp
	
	print *, temp_scp, surf_t(si)
	stop
	!print *,surf_scp,tp_uwind(surf_scp),tp_vwind(surf_scp)
	
        !*** grid into bins*******
        !***start from -90 and -180, rounds to the nearest
        ! whole number, note that index starts from 1

        lat_scp=nint((tp_lat+90-latbin_res/2.0)/latbin_res+1) 
        lon_scp=nint((tp_lon+180-lonbin_res/2.0)/lonbin_res+1) 
        if (lat_scp < 1) lat_scp=1
        if (lon_scp < 1) lon_scp=1
        if (lat_scp > dimy) lat_scp=dimy
        if (lon_scp > dimx) lon_scp=dimx

        obsnum(lon_scp,lat_scp,mon_scp)=&
        obsnum(lon_scp,lat_scp,mon_scp)+1
	obsnumv(lon_scp,lat_scp,:,mon_scp)=&
	obsnumv(lon_scp,lat_scp,:,mon_scp)+1
        !print *,tp_lat,lat_scp, tp_lon, lon_scp

	!======= to get monthly surface wind,temperature and pressure
	mean_surf_p(lon_scp,lat_scp,mon_scp)=&
	mean_surf_p(lon_scp,lat_scp,mon_scp)+&
	surf_p(si)

	mean_surf_t(lon_scp,lat_scp,mon_scp)=&
	mean_surf_t(lon_scp,lat_scp,mon_scp)+&
	surf_t(si)
		
	mean_surf_u(lon_scp,lat_scp,mon_scp)=&
	mean_surf_u(lon_scp,lat_scp,mon_scp)+&
	tp_uwind(surf_scp)

	mean_surf_v(lon_scp,lat_scp,mon_scp)=&
	mean_surf_v(lon_scp,lat_scp,mon_scp)+&
	tp_vwind(surf_scp)

	IF (tp_maphgt == -9999) tp_maphgt=0
	IF (tp_maphgt > 8850) tp_maphgt=0
	DEM_elevation(lon_scp,lat_scp)=DEM_elevation(lon_scp,lat_scp)&
	+tp_maphgt/1000.0		
	
        !***single layer clouds, no need to loop
        IF (tp_layer == 1) Then
                sfphase=tp_phase(1)
                OneLay_fre(lon_scp,lat_scp,sfphase,mon_scp)&
                =OneLay_fre(lon_scp,lat_scp,sfphase,mon_scp)+1
 
                sum_onelaytopH(lon_scp,lat_scp,sfphase,mon_scp)&
                =sum_onelaytopH(lon_scp,lat_scp,sfphase,mon_scp)&
                +tp_top(1)

                sum_onelaybaseH(lon_scp,lat_scp,sfphase,mon_scp)&
                =sum_onelaybaseH(lon_scp,lat_scp,sfphase,mon_scp)&
                +tp_base(1)
		
		onelay_surf_p(lon_scp,lat_scp,sfphase,mon_scp)=&
		onelay_surf_p(lon_scp,lat_scp,sfphase,mon_scp)+&
		surf_p(si)

		onelay_surf_t(lon_scp,lat_scp,sfphase,mon_scp)=&
		onelay_surf_t(lon_scp,lat_scp,sfphase,mon_scp)+&
		surf_t(si)
		
		onelay_surf_u(lon_scp,lat_scp,sfphase,mon_scp)=&
		onelay_surf_u(lon_scp,lat_scp,sfphase,mon_scp)+&
		tp_uwind(surf_scp)

		onelay_surf_v(lon_scp,lat_scp,sfphase,mon_scp)=&
		onelay_surf_v(lon_scp,lat_scp,sfphase,mon_scp)+&
		tp_vwind(surf_scp)
	
	!	print *,si,surf_p(si),surf_t(si),tp_uwind(surf_scp),tp_vwind(surf_scp)
		
                !*** for precipitation flag*****************
                !if (tp_preci(1)>0) &
               ! preci_fre(lon_scp,lat_scp,tp_preci(1),mon_scp)&
               ! =preci_fre(lon_scp,lat_scp,tp_preci(1),mon_scp)&
               ! +1       
		!*** for vertical distribution***************
		top_scp=nint((25-tp_top(1))/0.25)	
		base_scp=nint((25-tp_base(1))/0.25)	
		
		onelay_frev(lon_scp,lat_scp,top_scp:base_scp,mon_scp)&
		= onelay_frev(lon_scp,lat_scp,top_scp:base_scp,mon_scp)&
		+1	
		!*** if it is ice cloud *******************
		If (sfphase .eq. 1) Then 
		onelayic_frev(lon_scp,lat_scp,top_scp:base_scp,temp_scp,mon_scp)&
		=onelayic_frev(lon_scp,lat_scp,top_scp:base_scp,temp_scp,mon_scp)&
		+1	
		EndIf
		!**** if it is mixed phase cloud	
		If (sfphase .eq. 2) Then 
		onelaymc_frev(lon_scp,lat_scp,top_scp:base_scp,temp_scp,mon_scp)&
		=onelaymc_frev(lon_scp,lat_scp,top_scp:base_scp,temp_scp,mon_scp)&
		+1	
		EndIf	
		!*** if it is liquid cloud******************
		If (sfphase .eq. 3) Then 
		liqnoice_frev(lon_scp,lat_scp,top_scp:base_scp,temp_scp,mon_scp)&
		=liqnoice_frev(lon_scp,lat_scp,top_scp:base_scp,temp_scp,mon_scp)&
		+1	
		EndIf
	!	print *, onelay_frev(lon_scp,lat_scp,:,mon_scp)
	
        EndIf ! end onelayer
         
        !**** multi layer clouds, loop for multilayer info, each case is independent 
        ! case1 : all ice 
        ! case2 : all mixed
        ! case3 : all liquid
        ! case4 : upper ice, lower water
        ! case5 : upper ice, lower mixed phase
        ! case6 : upper mixed phase, lower water
        !***********************************************
        IF (tp_layer > 1) Then 
        m1fphase=0
        mnfphase=0
        fic=0
        ific=0 ! mark first layer
        fmi=0
        ifmi=0
        fwc=0
        ifwc=0
        rain_flag=0
	tp_frev=0
        ! set flags for cloud phase and rain
        Do hi=1, tp_layer 
               if (tp_phase(hi) == 1) then
                        fic=hi
                        if (ific ==0 ) ific=fic 
                endif           
               if (tp_phase(hi) == 2) then  ! top
                        fmi=hi  
                        if (ifmi == 0) ifmi=fmi ! base
                endif
               if (tp_phase(hi) == 3) then
                        fwc=hi   
                        if (ifwc == 0) ifwc=fwc 
               endif           

               !if (tp_preci(hi) == 1) rain_flag(1)=1
               !if (tp_preci(hi) == 2) rain_flag(2)=1
               !if (tp_preci(hi) == 3) rain_flag(3)=1
	
		!**** record the subscript of cloud layers 
		top_scp_lay=nint((25-tp_top(hi))/0.25)  	 
		base_scp_lay=nint((25-tp_base(hi))/0.25)  	 
		!**** record multiple layer vertical distribution
		tp_frev(top_scp_lay:base_scp_lay)=1
		mullay_frev(lon_scp,lat_scp,top_scp_lay:base_scp_lay,mon_scp)&
		= mullay_frev(lon_scp,lat_scp,top_scp_lay:base_scp_lay,mon_scp)&
		+1	 
        Enddo ! end 10 layer 
!	print *,si,top_scp_lay,base_scp_lay
!	print *,mullay_frev(lon_scp,lat_scp,:,mon_scp)
!	stop
        ! case 1: ice
        If ((fic .ne. 0) .and. (fmi+fwc ==0)) Then
                m1fphase=1
                sum1_mullaytopH(lon_scp,lat_scp,1,mon_scp)&
                =sum1_mullaytopH(lon_scp,lat_scp,1,mon_scp)&
                +tp_top(fic)
	
                sum1_mullaybaseH(lon_scp,lat_scp,1,mon_scp)&
                =sum1_mullaybaseH(lon_scp,lat_scp,1,mon_scp)&
                +tp_base(ific)
	
		mullayic_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		= mullayic_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		+ tp_frev 
!		print *,top_scp_lay,base_scp_lay, mullayic_frev(lon_scp,lat_scp,:,mon_scp)
	!stop
        Endif
        ! case 2:mixed 
        If ((fic+fwc ==  0) .and. (fmi .ne. 0)) Then
                m1fphase=2
                sum1_mullaytopH(lon_scp,lat_scp,2,mon_scp)&
                =sum1_mullaytopH(lon_scp,lat_scp,2,mon_scp)&
                +tp_top(fmi)
                sum1_mullaybaseH(lon_scp,lat_scp,2,mon_scp)&
                =sum1_mullaybaseH(lon_scp,lat_scp,2,mon_scp)&
                +tp_base(ifmi)
		
        !print *,si, fwc,tp_top(fwc)
        Endif

        ! case 3: liquid
        If ((fic+fmi ==  0) .and. (fwc .ne. 0)) Then
                m1fphase=3
                sum1_mullaytopH(lon_scp,lat_scp,3,mon_scp)&
                =sum1_mullaytopH(lon_scp,lat_scp,3,mon_scp)&
                +tp_top(fwc)
                sum1_mullaybaseH(lon_scp,lat_scp,3,mon_scp)&
                =sum1_mullaybaseH(lon_scp,lat_scp,3,mon_scp)&
                +tp_base(ifwc)

		liqnoice_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		=liqnoice_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		+tp_frev	
        ! print *,si,top_scp_lay,base_scp_lay
	! print *,liqnoice_frev(lon_scp,lat_scp,:,mon_scp)
	!stop
        Endif

        If (m1fphase .ne. 0) then
        MulLay_1fre(lon_scp,lat_scp,m1fphase,mon_scp)=&
        MulLay_1fre(lon_scp,lat_scp,m1fphase,mon_scp)+1

	mullay_1surf_p(lon_scp,lat_scp,m1fphase,mon_scp)=&
	mullay_1surf_p(lon_scp,lat_scp,m1fphase,mon_scp)+&
	surf_p(si)

	mullay_1surf_t(lon_scp,lat_scp,m1fphase,mon_scp)=&
	mullay_1surf_t(lon_scp,lat_scp,m1fphase,mon_scp)+&
	surf_t(si)
		
	mullay_1surf_u(lon_scp,lat_scp,m1fphase,mon_scp)=&
	mullay_1surf_u(lon_scp,lat_scp,m1fphase,mon_scp)+&
	tp_uwind(surf_scp)

	mullay_1surf_v(lon_scp,lat_scp,m1fphase,mon_scp)=&
	mullay_1surf_v(lon_scp,lat_scp,m1fphase,mon_scp)+&
	tp_vwind(surf_scp)
!	print *,si,surf_p(si),surf_t(si),tp_uwind(surf_scp),tp_vwind(surf_scp)
	
        EndIf
        ! case 4: upper ice, lower liquid
        If ((fic .ne. 0) .and. (fmi == 0) .and. (fwc .ne. 0)) Then
                mnfphase=1
                sumn_lowlaytopH(lon_scp,lat_scp,1,mon_scp)&
                =sumn_lowlaytopH(lon_scp,lat_scp,1,mon_scp)&
                +tp_top(fwc)
                sumn_lowlaybaseH(lon_scp,lat_scp,1,mon_scp)&
                =sumn_lowlaybaseH(lon_scp,lat_scp,1,mon_scp)&
                +tp_base(ifwc)

                sumn_uplaytopH(lon_scp,lat_scp,1,mon_scp)&
                =sumn_uplaytopH(lon_scp,lat_scp,1,mon_scp)&
                +tp_top(fic)
                sumn_uplaybaseH(lon_scp,lat_scp,1,mon_scp)&
                =sumn_uplaybaseH(lon_scp,lat_scp,1,mon_scp)&
                +tp_base(ific)

		liqice_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		=liqice_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		+tp_frev
	 	 
	 	IF (fwc .gt. ifwc) Then
			nliqflag=2 
		else 
			nliqflag=1 
		Endif
         	liqice_freh(lon_scp,lat_scp,nliqflag,mon_scp)=&
		liqice_freh(lon_scp,lat_scp,nliqflag,mon_scp)+1

         	liqice_liqtop(lon_scp,lat_scp,nliqflag,mon_scp)=&
		liqice_liqtop(lon_scp,lat_scp,nliqflag,mon_scp)+tp_top(fwc)
	 !print *,si,top_scp_lay,base_scp_lay
	 !print *,liqice_frev(lon_scp,lat_scp,:,mon_scp)
	 !stop
        Endif ! end case 4

       !case 5: upper ice, lower mixed
        If ((fic .ne. 0) .and. (fmi .ne. 0)) Then
                mnfphase=2
                !mixed phase layer
                sumn_lowlaytopH(lon_scp,lat_scp,2,mon_scp)&
                =sumn_lowlaytopH(lon_scp,lat_scp,2,mon_scp)&
                +tp_top(fmi)

                sumn_lowlaybaseH(lon_scp,lat_scp,2,mon_scp)&
                =sumn_lowlaybaseH(lon_scp,lat_scp,2,mon_scp)&
                +tp_base(ifmi)

                sumn_uplaytopH(lon_scp,lat_scp,2,mon_scp)&
                =sumn_uplaytopH(lon_scp,lat_scp,2,mon_scp)&
                +tp_top(fic)
                sumn_uplaybaseH(lon_scp,lat_scp,2,mon_scp)&
                =sumn_uplaybaseH(lon_scp,lat_scp,2,mon_scp)&
                +tp_base(ific)

		icemix_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		=icemix_frev(lon_scp,lat_scp,:,temp_scp,mon_scp)&
		+tp_frev
		
		!print *,mixice_frev(lon_scp,lat_scp,:,mon_scp)
		!stop
        Endif  ! end case 5
        
        ! case 6: there is no ice
        If ((fic == 0) .and. (fmi .ne. 0) .and. (fwc .ne. 0)) Then
                mnfphase=3
                sumn_lowlaytopH(lon_scp,lat_scp,3,mon_scp)&
                =sumn_lowlaytopH(lon_scp,lat_scp,3,mon_scp)&
                +tp_top(fwc)

                sumn_lowlaybaseH(lon_scp,lat_scp,3,mon_scp)&
                =sumn_lowlaybaseH(lon_scp,lat_scp,3,mon_scp)&
                +tp_base(ifwc)

                sumn_uplaytopH(lon_scp,lat_scp,3,mon_scp)&
                =sumn_uplaytopH(lon_scp,lat_scp,3,mon_scp)&
                +tp_top(fmi)
                sumn_uplaybaseH(lon_scp,lat_scp,3,mon_scp)&
                =sumn_uplaybaseH(lon_scp,lat_scp,3,mon_scp)&
                +tp_base(ifmi)

        ! print *,si,fwc,ifwc,tp_top(fwc),tp_base(ifwc),fmi,ifmi,&
        !        tp_top(fmi),&
        !        tp_base(ifmi)
        Endif

        If (mnfphase .ne. 0) then
        MulLay_nfre(lon_scp,lat_scp,mnfphase,mon_scp)=&
        MulLay_nfre(lon_scp,lat_scp,mnfphase,mon_scp)+1

	mullay_nsurf_p(lon_scp,lat_scp,mnfphase,mon_scp)=&
	mullay_nsurf_p(lon_scp,lat_scp,mnfphase,mon_scp)+&
	surf_p(si)

	mullay_nsurf_t(lon_scp,lat_scp,mnfphase,mon_scp)=&
	mullay_nsurf_t(lon_scp,lat_scp,mnfphase,mon_scp)+&
	surf_t(si)
		
	mullay_nsurf_u(lon_scp,lat_scp,mnfphase,mon_scp)=&
	mullay_nsurf_u(lon_scp,lat_scp,mnfphase,mon_scp)+&
	tp_uwind(surf_scp)

	mullay_nsurf_v(lon_scp,lat_scp,mnfphase,mon_scp)=&
	mullay_nsurf_v(lon_scp,lat_scp,mnfphase,mon_scp)+&
	tp_vwind(surf_scp)

!	print *,si,surf_p(si),surf_t(si),tp_uwind(surf_scp),tp_vwind(surf_scp)
	
       EndIf
       !*** for precipitation flag*****************
       ! If (rain_flag(1) == 1) &
       !         preci_fre(lon_scp,lat_scp,1,mon_scp)&
       !         =preci_fre(lon_scp,lat_scp,1,mon_scp)&
       !         +1       
       ! If (rain_flag(2) == 1) &
       !         preci_fre(lon_scp,lat_scp,2,mon_scp)&
       !         =preci_fre(lon_scp,lat_scp,2,mon_scp)&
       !         +1
       ! If (rain_flag(3) == 1) &
       !         preci_fre(lon_scp,lat_scp,3,mon_scp)&
       !         =preci_fre(lon_scp,lat_scp,3,mon_scp)&
       !         +1
        EndIf ! end multiple layer

        Enddo ! end swath 

        end
