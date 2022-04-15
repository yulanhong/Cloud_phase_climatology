
pro match_modis_cldsat_ze_re
 print,systime()

  year='2007'
  cldfname=file_search('/u/sciteam/yulanh/scratch/CLDCLASS/2007/200708','*.hdf')

  Nf=n_elements(cldfname)
  Nf=200
  dimx=15
  dimy=26

  latres=2
  lonres=5

  ze_re_liquid=fltarr(dimx,dimy,120,125)  ; re range from 0-120, 125 for height
  ze_re_liquid_num=ulonarr(dimx,dimy,120,125)
  ze_re_ice=fltarr(dimx,dimy,120,125)
  ze_re_ice_num=ulonarr(dimx,dimy,120,125)

  hsigma_re=fltarr(120,2) ; mean hsigma for each re, 0-for ice, 1-liquid
  hsigma_re_square=fltarr(120,2) ; for getting hsigma std
  hsigma_re_num=ulonarr(120,2) 
 
  For fi=0,Nf-1 Do Begin
  ; cloudsat data
	print,cldfname[fi]
    geoprof_fname='/u/sciteam/yulanh/scratch/2B-GEOPROF/2007/200708/'+strmid(cldfname[fi],47,19)+$
		'_CS_2B-GEOPROF_GRANULE_P1_R05_E02_F00.hdf'

    IF file_test(geoprof_fname) eq 1 Then Begin 
 	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','Latitude',lat	 
  	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','Longitude',lon
	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','Height',hgt
	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','Cloudlayer',cldlayer
 	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','CloudLayerBase',cldbase
 	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','CloudLayerTop',cldtop
 	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','CloudPhase',cldphase
 	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','Profile_time',time
 	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','UTC_start',utc_start
	read_cloudsat,cldfname[fi],'2B-CLDCLASS-LIDAR','DEM_elevation',dem_hgt
	hgt=hgt/1000.0
 ; read radar reflectivity
	read_cloudsat,geoprof_fname,'2B-GEOPROF','Radar_Reflectivity',radarZ
	radarZ=radarZ/100.0
	
	ind1=where(lat ge -20 and lat le 30)
	lat1=lat[ind1]
	lon1=lon[ind1]
	cldlayer1=cldlayer[ind1]
	cldbase1 =cldbase[*,ind1]
	cldtop1  =cldtop[*,ind1]
	cldphase1=cldphase[*,ind1]
	dem_hgt1=dem_hgt[ind1]
    radarZ1=radarZ[*,ind1]
	hgt1=hgt[*,ind1]

	time1=time[ind1]
	ind2=where(lon1 ge 80 and lon1 le 150)
	lat2=lat1[ind2]
	lon2=lon1[ind2]
	time2=time1[ind2]
	cldlayer2=cldlayer1[ind2]
	cldbase2 =cldbase1[*,ind2]
	cldtop2  =cldtop1[*,ind2]
	cldphase2=cldphase1[*,ind2]
	dem_hgt2=dem_hgt1[ind2]
	radarZ2=radarZ1[*,ind2]
	hgt2=hgt1[*,ind2]
	;===== if in the target area====
	IF ind1[0] ne -1 and ind2[0] ne -1 Then Begin

	day=strmid(cldfname[fi],51,3)
	time0=(time2[0]+utc_start)/3600.0	
	hour0=floor(time0)
	min0=floor((time0-hour0)*60)
	
	;===== get the initial file of modis	
 	modhour = hour0
	modhour=strcompress(string(modhour/100.0),/rem)
	modhour=strmid(modhour,2,2)

	tpnum1=min0-floor(min0/10)*10
	if tpnum1 ge 0 and tpnum1 le 4 then tpnum2=0
	if tpnum1 ge 5 and tpnum1 le 9 then tpnum2=5
	modmin  = floor(min0/10.0)*10+tpnum2
	modmin = strcompress(string(modmin/100.0),/rem)
	modmin = strmid(modmin,2,2)

	mod_daymmhh=year+day;+'.'+string(modhour)+string(modmin)
	
    mod02fname1=file_search('/u/sciteam/yulanh/scratch/MODIS/MYD021KM/2007','*'+mod_daymmhh+'*') 
	mod03fname1=file_search('/u/sciteam/yulanh/scratch/MODIS/MYD03/2007','*'+mod_daymmhh+'*')
    mod06fname1=file_search('/u/sciteam/yulanh/scratch/MODIS/MYD06/2007','*'+mod_daymmhh+'*')
	
	IF (n_elements(mod02fname1) eq n_elements(mod03fname1) and n_elements(mod02fname1) eq n_elements(mod06fname1)) then begin

	; dealling with nighttime,goto next file
	allhh=strmid(mod06fname1,61,2)
	allhh=fix(allhh)
	IF (hour0 gt max(allhh)) then goto, jump2

	allhhmm=strmid(mod06fname1,61,4)		
	find=where(modhour[0]+modmin[0] eq allhhmm)
	modfi=find[0]
	
	si=0L	

	jump1:
	IF modfi gt n_elements(mod06fname1) then goto,jump2 ; if the end doesn't match any modis file, then go to next cloudsat file
	mod02fname=mod02fname1[modfi]
	mod03fname=mod03fname1[modfi]
	mod06fname=mod06fname1[modfi]

;	read_modis_1,mod02fname,'EV_250_Aggr1km_RefSB',rad250
	
  	read_modis_1,mod03fname,'Latitude',modlat
  	read_modis_1,mod03fname,'Longitude',modlon
  	read_modis_1,mod03fname,'SolarZenith',solarzenith
  	read_modis_1,mod03fname,'SolarAzimuth',solarazimuth
	read_modis_1,mod03fname,'SensorZenith',sensorzenith
	read_modis_1,mod03fname,'SensorAzimuth',sensorazimuth

  	solarzenith=solarzenith/100.0
  	solarazimuth=solarazimuth/100.0
	read_modis_1,mod06fname,'Cloud_Phase_Optical_Properties',modphase
	read_modis_1,mod06fname,'Cloud_Mask_SPI',cldspi
    cldspi=cldspi/10000.0
	read_modis_1,mod06fname,'Cloud_Effective_Radius_16',re16
  	re16=re16/100.0
	read_modis_1,mod06fname,'Cloud_Effective_Radius',re21
  	re21=re21/100.0
	
	print,min(modlat),mod06fname
  ;============end reading modis file==========================
    minlat=min(lat2)
    maxlat=max(lat2)
    minlon=min(lon2)
    maxlon=max(lon2)

	Ns=n_elements(lat2)
	;==== dealing with each CloudSat measurement ====
;	c=contour(rad_85,modlon,modlat,rgb_table=33) 
 ;   p=plot(lon2,lat2,color='r')
	match_startflag=-1 ;if start matching (1) 
  
	while si le Ns-1 Do Begin
		;must be on ocean
		IF (dem_hgt2[si] le 0) Then Begin
	
		tplat=lat2[si]
		tplon=lon2[si]
		lat_scp=round((tplat+20)/latres)	
		lon_scp=round((tplon-80)/lonres)	
		if lat_scp lt 0 then lat_scp=0
		if lon_scp lt 0 then lon_scp=0
		if lat_scp gt dimy-1 then lat_scp=dimy-1
		if lon_scp gt dimx-1 then lon_scp=dimx-1

	   ;**** multi layer clouds, loop for multilayer info, each case is independent 
       ;case1 : all ice, phaseflag 1 
       ;case2 : all mixed, phaseflag 2
       ;case3 : all liquid, phaseflag 3
       ;case4 : upper ice, lower water, phaseflag 4
       ;case5 : upper ice, lower mixed phase, phaseflag 5
       ;case6 : upper mixed phase, lower water,phaseflag (belong to case 2)
       ;***********************************************
       phaseflag=-1
       ifice=0
       ifmix=0
       ifliq=0
       ;===== deal with cloudy sky======================
		tp_layer=cldlayer2[si]
	 	tp_phase=cldphase2[*,si]
	
       IF (tp_layer eq 1) Then Begin
           if (tp_phase[0] eq 1) then phaseflag=1
           if (tp_phase[0] eq 2) then phaseflag=2
           if (tp_phase[0] eq 3) then phaseflag=3
       EndIf ; end one layer
       IF (tp_layer gt 1) Then Begin
          For hi=0, tp_layer-1 Do Begin
            if (tp_phase[hi] eq 1) then ifice=ifice+1
            if (tp_phase[hi] eq 2) then ifmix=ifmix+1
            if (tp_phase[hi] eq 3) then ifliq=ifliq+1
         EndFor
        if (ifice gt 0 and (ifmix+ifliq) eq 0) then phaseflag=1
        if ((ifice + ifliq) eq 0 and ifmix gt 0) then phaseflag=2
        if ((ifice + ifmix) eq 0 and ifliq gt 0) then phaseflag=3
        if (ifice gt 0 and ifmix eq 0 and ifliq gt 0) then phaseflag=4
        if (ifice gt 0 and ifmix gt 0) then phaseflag=5
        if (ifice eq 0 and ifmix gt 0 and ifliq gt 0) then phaseflag=2
      EndIf
	
	;======= colocate modis and cloudsat=====
	   difflat=abs(tplat-modlat)
	   difflon=abs(tplon-modlon)
	   dis=sqrt(difflon*difflon+difflat*difflat)
		;print,min(dis)
	   IF (min(dis) le 0.008) Then Begin ; if le around 700m than match 	

	   match_startflag=1 ;start matching whether it is si==0 or ne 0
	
	   locind=where(min(dis) eq dis)
	   nsize=size(modlat)
	   ncol=nsize[1]
	   nrow=nsize[2]
	;   colj=locind[0] mod ncol
	;   rowi=(locind[0]/ncol) mod nrow 
		res=array_indices(modlat,locind[0])
		colj=res[0]
		rowi=res[1]
	; 866 nm used in Larry's paper
		Rsigma=cldspi[1,colj,rowi]
		Hsigma_scp=round(Rsigma*100.0)
		
		tpre16=re16[colj,rowi]
		tpre21=re21[colj,rowi]
		tpmodphase=modphase[colj,rowi]	
	
		tpsza=solarzenith[colj,rowi]
		sza_scp=round(tpsza)
	
		tpradarz=radarZ2[*,si]
		tphgt=hgt2[*,si]
	
		case phaseflag of
	;	-1: Begin ; clear sky
	;		End
		1: Begin ; ice
			zeind=where(tpradarz gt -28 and tpradarz lt 100 and tphgt gt 0.5 )
			if (tpmodphase eq 3 and tpre21 gt 0 and zeind[0] ne -1) then begin
			rescp=round(tpre21)
			ze_re_ice[lon_scp,lat_scp,rescp,zeind]=ze_re_ice[lon_scp,lat_scp,rescp,zeind] + tpradarz[zeind]
			ze_re_ice_num[lon_scp,lat_scp,rescp,zeind]=ze_re_ice_num[lon_scp,lat_scp,rescp,zeind] + 1L
			hsigma_re[rescp,0]=hsigma_re[rescp,0]+rsigma
			hsigma_re_square[rescp,0]=hsigma_re_square[rescp,0]+rsigma*rsigma	
			hsigma_re_num[rescp,0]=hsigma_re_num[rescp,0]+1L	
			endif
			 
			End
	;	2: Begin ; mix
;			End
		3: Begin ; liquid
			zeind=where(tpradarz gt -28 and tpradarz lt 100 and tphgt gt 0.5)
			if (tpmodphase eq 2 and tpre21 gt 0 and zeind[0] ne -1) then begin
			rescp=round(tpre21)
			ze_re_liquid[lon_scp,lat_scp,rescp,zeind]=ze_re_liquid[lon_scp,lat_scp,rescp,zeind] + tpradarz[zeind]
			ze_re_liquid_num[lon_scp,lat_scp,rescp,zeind]=ze_re_liquid_num[lon_scp,lat_scp,rescp,zeind] + 1L
			hsigma_re[rescp,1]=hsigma_re[rescp,1]+rsigma
			hsigma_re_square[rescp,1]=hsigma_re_square[rescp,1]+rsigma*rsigma	
			hsigma_re_num[rescp,1]=hsigma_re_num[rescp,1]+1L	
			endif
		
			End
	;	4: Begin ; ice-liquid
	;		End
	;	5: Begin ; ice-mixed
	;		End
		Else: tempstr='no select case'
		EndCase

	   EndIf Else Begin ; end if case match
			;if not match at the begining, may match later
			if (match_startflag eq -1) then goto,jump3
			modfi=modfi+1
			goto, jump1 ; if already start matching, go to next file	
	   Endelse

	  EndIf ; endif over ocean
		jump3:
		si=si+1L

	Endwhile ; end onefile
	EndIf ; if modis file exist
   endif; endif in the targeted area

	jump2:
   Endif ; end if 2b-geoprof file exists
 EndFor; end files 

 save,ze_re_ice,filename='ze_re_ice_200708.sav'
 save,ze_re_ice_num,filename='ze_re_icenum_200708.sav'
 save,ze_re_liquid,filename='ze_re_liquid_200708.sav'
 save,ze_re_liquid_num,filename='ze_re_liquidnum_200708.sav'
 save,hsigma_re,filename='hsigma_vsre_200708.sav'
 save,hsigma_re_square,filename='hsigma_square_vsre_200708.sav'
 save,hsigma_re_num,filename='hsigma_vsrenum_200708.sav'

 print,systime()
  stop
end
