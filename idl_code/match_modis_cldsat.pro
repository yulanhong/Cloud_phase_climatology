
pro match_modis_cldsat
 print,systime()

  year='2007'
  cldfname=file_search('/u/sciteam/yulanh/scratch/CLDCLASS/2007/200701','*.hdf')

  Nf=n_elements(cldfname)
  Nf=200

  dimx=15
  dimy=26
  spa_hetero=fltarr(dimx,dimy,6) ; 0-clear, 1-ice, 2-iceliq, 3-icemix,4-liq,5-mix
  spa_heteronum=ulonarr(dimx,dimy,6)
  a=findgen(400)*0.01-3.2
  hetero_x=[0,10^a]
  hetero_pdf=ulonarr(401,6) ; resolution 0.01 
  spectral_rad_sza=fltarr(7,70,6) ; seven wavelengths, 70 degeree of SZA and 6 category skies
  spectral_rad_sza_square=fltarr(7,70,6); for obtaining standard deviation 
  spectral_rad_sza_num=ulonarr(7,70,6) ; seven wavelengths, 70 degeree of SZA and 6 category skies
	
  latres=2
  lonres=5
  Nf=2
  For fi=1,Nf-1 Do Begin
  ; cloudsat data
	print,cldfname[fi]
    geoprof_fname='/u/sciteam/yulanh/scratch/2B-GEOPROF/2007/200701/'+strmid(cldfname[fi],47,19)+$
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

	read_cloudsat,geoprof_fname,'2B-GEOPROF','Radar_Reflectivity',radarZ
 ; read radar reflectivity
	
	ind1=where(lat ge -20 and lat le 30)
	lat1=lat[ind1]
	lon1=lon[ind1]
	cldlayer1=cldlayer[ind1]
	cldbase1 =cldbase[*,ind1]
	cldtop1  =cldtop[*,ind1]
	cldphase1=cldphase[*,ind1]
	dem_hgt1=dem_hgt[ind1]
    radarZ1=radarZ[*,ind1]

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
	print,mod02fname
	;========== to read modis data=================
  	fid=hdf_sd_start(mod02fname,/read)
   
  	sds_index=hdf_sd_nametoindex(fid,'EV_250_Aggr1km_RefSB')
  	nid=hdf_sd_select(fid,sds_index)
  	hdf_sd_getdata,nid,modis_250
  	scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  	hdf_sd_attrinfo,nid,scale_ind,data=scale250
  	scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  	hdf_sd_attrinfo,nid,scale_ind,data=offset250
  	rad_062=scale250[0]*(modis_250[*,*,0]-offset250[0])
	
  	sds_index=hdf_sd_nametoindex(fid,'EV_500_Aggr1km_RefSB')
  	nid=hdf_sd_select(fid,sds_index)
  	hdf_sd_getdata,nid,modis_500
  	scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  	hdf_sd_attrinfo,nid,scale_ind,data=scale500
  	scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  	hdf_sd_attrinfo,nid,scale_ind,data=offset500
  	rad_21=scale500[4]*(modis_500[*,*,4]-offset500[4])

  	sds_index=hdf_sd_nametoindex(fid,'EV_1KM_RefSB')
  	nid=hdf_sd_select(fid,sds_index)
  	hdf_sd_getdata,nid,modis_nir
  	scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  	hdf_sd_attrinfo,nid,scale_ind,data=scalenir
  	scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  	hdf_sd_attrinfo,nid,scale_ind,data=offsetnir
  	rad_21=scalenir[4]*(modis_nir[*,*,4]-offsetnir[4])

  	sds_index=hdf_sd_nametoindex(fid,'EV_1KM_Emissive')
  	nid=hdf_sd_select(fid,sds_index)
  	hdf_sd_getdata,nid,modis_emis
  	scale_ind=hdf_sd_attrfind(nid,'radiance_scales')
  	hdf_sd_attrinfo,nid,scale_ind,data=scaleemis
  	scale_ind=hdf_sd_attrfind(nid,'radiance_offsets')
  	hdf_sd_attrinfo,nid,scale_ind,data=offsetemis
  	rad_85=scaleemis[8]*(modis_emis[*,*,8]-offsetemis[8])
  	rad_120=scaleemis[11]*(modis_emis[*,*,11]-offsetemis[11])
  	hdf_sd_end,fid

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
		;print,si,phaseflag,allhhmm[modfi],tplat,tplon,modlat[colj,rowi],modlon[colj,rowi],colj,rowi,min(dis)
		;print, mod02fname

   ;print, si,colj,rowi,mod02fname,min(dis)
	; 866 nm used in Larry's paper
		Rsigma=cldspi[1,colj,rowi]
		diff_sigma=abs(Rsigma-hetero_x)
		sigmaind=where(min(diff_sigma) eq diff_sigma)
		Hsigma_scp=sigmaind[0]
 	
		tpsza=solarzenith[colj,rowi]
		sza_scp=round(tpsza)
		spectral_rad=fltarr(7) ;0: 0.55(4),1:0.645(1), 2: 0.858(2), 3: 1.375(26), 4: 1.6 (6), 5: 8.5 (29), 6: 12.02 (32)
		if modis_500[colj,rowi,1] le  32767 then spectral_rad[0]=scale500[1]*(modis_500[colj,rowi,1]-offset500[1])
		if modis_250[colj,rowi,0] le 32767 then spectral_rad[1]=scale250[0]*(modis_250[colj,rowi,0]-offset250[0])
		if modis_250[colj,rowi,1] le 32767 then spectral_rad[2]=scale250[1]*(modis_250[colj,rowi,1]-offset250[1])
		if modis_nir[colj,rowi,14] le 32767 then spectral_rad[3]=scalenir[14]*(modis_nir[colj,rowi,14]-offsetnir[14])
		if modis_500[colj,rowi,3] le 32767 then spectral_rad[4]=scale500[3]*(modis_500[colj,rowi,3]-offset500[3])
		if modis_emis[colj,rowi,8] le 32767 then  spectral_rad[5]=scaleemis[8]*(modis_emis[colj,rowi,8]-offsetemis[8])
		if modis_emis[colj,rowi,11] le 32767 then  spectral_rad[6]=scaleemis[11]*(modis_emis[colj,rowi,11]-offsetemis[11])
	
		tpradarz=radarZ2[*,si]

		case phaseflag of
		-1: Begin ; clear sky
			spa_hetero[lon_scp,lat_scp,0]=spa_hetero[lon_scp,lat_scp,0]+Rsigma
			spa_heteronum[lon_scp,lat_scp,0]=spa_heteronum[lon_scp,lat_scp,0]+1L
			hetero_pdf[Hsigma_scp,0]=hetero_pdf[Hsigma_scp,0]+1L	
		;	p=plot(spectral_rad,title='clear')
			spectral_rad_sza[*,sza_scp,0]= spectral_rad_sza[*,sza_scp,0]+spectral_rad
			spectral_rad_sza_square[*,sza_scp,0]= spectral_rad_sza_square[*,sza_scp,0]+spectral_rad*spectral_rad
		  	radind=where(spectral_rad gt 0)
			spectral_rad_sza_num[*,sza_scp,0]= spectral_rad_sza_num[*,sza_scp,0]+1L
	
			if (modphase[colj,rowi] ge 2) then print,si,modphase[colj-1:colj+1,rowi-1:rowi+1]			

			End
		1: Begin ; ice 
			spa_hetero[lon_scp,lat_scp,1]=spa_hetero[lon_scp,lat_scp,1]+Rsigma
			spa_heteronum[lon_scp,lat_scp,1]=spa_heteronum[lon_scp,lat_scp,1]+1L
			hetero_pdf[Hsigma_scp,1]=hetero_pdf[Hsigma_scp,1]+1L	
	;		p=plot(spectral_rad,title='ice')	
			spectral_rad_sza[*,sza_scp,1]= spectral_rad_sza[*,sza_scp,1]+spectral_rad
			spectral_rad_sza_square[*,sza_scp,1]= spectral_rad_sza_square[*,sza_scp,1]+spectral_rad*spectral_rad
		  	radind=where(spectral_rad gt 0)
			spectral_rad_sza_num[*,sza_scp,1]= spectral_rad_sza_num[*,sza_scp,1]+1L
			End
		2: Begin ; mix
			spa_hetero[lon_scp,lat_scp,5]=spa_hetero[lon_scp,lat_scp,5]+Rsigma
			spa_heteronum[lon_scp,lat_scp,5]=spa_heteronum[lon_scp,lat_scp,5]+1L
			hetero_pdf[Hsigma_scp,5]=hetero_pdf[Hsigma_scp,5]+1L	
  		   ; p=plot(spectral_rad,title='mix')		
			spectral_rad_sza[*,sza_scp,5]= spectral_rad_sza[*,sza_scp,5]+spectral_rad
			spectral_rad_sza_square[*,sza_scp,5]= spectral_rad_sza_square[*,sza_scp,5]+spectral_rad*spectral_rad
		  	radind=where(spectral_rad gt 0)
			spectral_rad_sza_num[*,sza_scp,5]= spectral_rad_sza_num[*,sza_scp,5]+1L
			End
		3: Begin ; liquid
			spa_hetero[lon_scp,lat_scp,4]=spa_hetero[lon_scp,lat_scp,4]+Rsigma
			spa_heteronum[lon_scp,lat_scp,4]=spa_heteronum[lon_scp,lat_scp,4]+1L
			hetero_pdf[Hsigma_scp,4]=hetero_pdf[Hsigma_scp,4]+1L	
			;p=plot(spectral_rad,title='liquid')	
			spectral_rad_sza[*,sza_scp,4]= spectral_rad_sza[*,sza_scp,4]+spectral_rad
			spectral_rad_sza_square[*,sza_scp,4]= spectral_rad_sza_square[*,sza_scp,4]+spectral_rad*spectral_rad
		  	radind=where(spectral_rad gt 0)
			spectral_rad_sza_num[*,sza_scp,4]= spectral_rad_sza_num[*,sza_scp,4]+1L
			End
		4: Begin ; ice-liquid
			spa_hetero[lon_scp,lat_scp,2]=spa_hetero[lon_scp,lat_scp,2]+Rsigma
			spa_heteronum[lon_scp,lat_scp,2]=spa_heteronum[lon_scp,lat_scp,2]+1L
			hetero_pdf[Hsigma_scp,2]=hetero_pdf[Hsigma_scp,2]+1L	
		;	p=plot(spectral_rad,title='ice-liquid')	
			spectral_rad_sza[*,sza_scp,2]= spectral_rad_sza[*,sza_scp,2]+spectral_rad
			spectral_rad_sza_square[*,sza_scp,2]= spectral_rad_sza_square[*,sza_scp,2]+spectral_rad*spectral_rad
		  	radind=where(spectral_rad gt 0)
			spectral_rad_sza_num[*,sza_scp,2]= spectral_rad_sza_num[*,sza_scp,2]+1L
			End
		5: Begin ; ice-mixed
			spa_hetero[lon_scp,lat_scp,3]=spa_hetero[lon_scp,lat_scp,3]+Rsigma
			spa_heteronum[lon_scp,lat_scp,3]=spa_heteronum[lon_scp,lat_scp,3]+1L
			hetero_pdf[Hsigma_scp,3]=hetero_pdf[Hsigma_scp,3]+1L	
			;p=plot(spectral_rad,title='ice-mix')	
			spectral_rad_sza[*,sza_scp,3]= spectral_rad_sza[*,sza_scp,3]+spectral_rad
			spectral_rad_sza_square[*,sza_scp,3]= spectral_rad_sza_square[*,sza_scp,3]+spectral_rad*spectral_rad
		  	radind=where(spectral_rad gt 0)
			spectral_rad_sza_num[*,sza_scp,3]= spectral_rad_sza_num[*,sza_scp,3]+1L
		
			End
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

 save,spa_hetero,filename='total_heterogeneity.sav'
 save,spa_heteronum,filename='heterogeneity_number.sav'
 save,hetero_pdf,filename='heterogeneity_pdf.sav'
 save,spectral_rad_sza,filename='spectral_rad_sza.sav'
 save,spectral_rad_sza_square,filename='spectral_rad_square.sav'
 save,spectral_rad_sza_num,filename='spectral_rad_num.sav'

	print, total(spa_heteronum)

 print,systime()
  stop
end
