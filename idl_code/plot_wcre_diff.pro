pro plot_wcre_diff

  region='Global'
  region='Philippine'
  fontsz=11
  Nh=125
;  rgbtable=33 ; for freqency
  rgbtable=55 ; for water path
  subtitle=['a1)','b1)','c1)','d1)',$
        'a2)','b2)','c2)','d2)',$
        'a3)','b3)','c3)','d3)',$
        'a4)','b4)','c4)','d4)']
  subtitle1=['Liquid','Ice-Liquid','Ice-Mixed','Mixed'] ; liquid clouds
  ;subtitle1=['Ice','Ice-Liquid','Ice-Mixed','Mixed'] ; ice clouds
  bartitle='Liquid Water Path (g $m^{-2}$)'
  flag='lwp'
  setminval=[0.0,0.0,0.0,0.0]
  setmaxval=[50,40,250,600]
;  bartitle='Cloud Occurrence Frequency'

  posy1=[0.77,0.55,0.33,0.11]
  posy2=[0.96,0.74,0.52,0.30]
  posx1=[0.05,0.29,0.53,0.77]
  posx2=[0.25,0.49,0.73,0.97]

  pos1=[0.10,0.6,0.50,0.95]
  pos2=[0.55,0.6,0.95,0.95]
  pos3=[0.10,0.2,0.50,0.55]
  pos4=[0.55,0.2,0.95,0.55]
  season=['MAM','JJA','SON','DJF']

  Nf=n_elements(fname)

  maplimit=[-90,-180,90,180]
  maplimit=[-20,80,30,150]
  dimx=72
  dimy=90
  dimz=125
 
  hgt=25-findgen(dimz)*0.24 
 
  levs=findgen(15)*0.025
  barlevs=['','','','']
  yrange=[0,20]
  xrange=[-90,90]
  ytitle='alt.'

 For mi=0,3 Do Begin

 if mi eq 0 then begin
 allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*03.hdf')
 allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*04.hdf')
 allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*05.hdf')
 endif
 if mi eq 1 then begin
 allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*06.hdf')
 allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*07.hdf')
 allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*08.hdf')
 endif
 if mi eq 2 then begin
 allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*09.hdf')
 allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*10.hdf')
 allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*11.hdf')
 endif
 if mi eq 3 then begin
 allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*12.hdf')
 allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*01.hdf')
 allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*02.hdf')
 endif
;
 fname=[allfname1,allfname2,allfname3]
; fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Phasediff_Parallel/','*.hdf')
 
 Nf=n_elements(fname)

 Tobsnumh=0L
 Ticenumh=0L
 Ticeliqnumh=0L
 Ticemixnumh=0L
 Tliqnumh=0L
 Tmixedh=0L
 Ticenumv=0L
 Tliqnumv=0L 
 Tiwp=fltarr(72,90,4)
 Tlwp=fltarr(72,90,4)
 Tiwp1=fltarr(72,90,4)
 Tlwp1=fltarr(72,90,4)

 Tiwc=0.0
 Tire=0.0
 Tlwc=0.0
 Tlre=0.0

 For fi=0, Nf-1 Do Begin
	read_dardar,fname[fi],'latitude',lat
	read_dardar,fname[fi],'longitude',lon
	read_dardar,fname[fi],'obsnumh',obsnum
	read_dardar,fname[fi],'icenumh',icenumh
	read_dardar,fname[fi],'iceliqnumh',iceliqnumh
	read_dardar,fname[fi],'icemixnumh',icemixnumh
	read_dardar,fname[fi],'liquidh',liqnumh
	read_dardar,fname[fi],'mixedh',mixedh
	read_dardar,fname[fi],'ice_numv',icenumv
	read_dardar,fname[fi],'liquid_numv',liqnumv
	read_dardar,fname[fi],'iwp',iwp
	read_dardar,fname[fi],'lwp',lwp
	read_dardar,fname[fi],'iwc',iwc
	read_dardar,fname[fi],'ire',ire
	read_dardar,fname[fi],'lwc',lwc
	read_dardar,fname[fi],'lre',lre
;	print, max(lwp,/nan),min(lwp,/nan)
	
;	print,total(obsnum),fname[fi]
	strmmdd=strsplit(fname[fi],'_',/ext)
	strmmdd=strmmdd[5]
	strmmdd=strmid(strmmdd,0,6)

	Tobsnumh=Tobsnumh+obsnum
    Ticenumh=Ticenumh+icenumh
	Ticeliqnumh=Ticeliqnumh+iceliqnumh
	Ticemixnumh=Ticemixnumh+icemixnumh
	Tliqnumh=Tliqnumh+liqnumh
	Tmixedh=Tmixedh+mixedh
	Ticenumv=Ticenumv+icenumv
	Tliqnumv=Tliqnumv+liqnumv

	Ticenumv=Ticenumv+icenumv
	Tliqnumv=Tliqnumv+liqnumv

	ind=where(icenumh eq 0)
	iwp1=reform(iwp[*,*,0])
	iwp1[ind]=0.0
	ind=where(iceliqnumh eq 0)
	iwp2=reform(iwp[*,*,1])
	iwp2[ind]=0.0
	ind=where(icemixnumh eq 0)
	iwp3=reform(iwp[*,*,2])
	iwp3[ind]=0.0
	ind=where(mixedh eq 0)
	iwp4=reform(iwp[*,*,3])
	iwp4[ind]=0.0
	Tiwp[*,*,0]=iwp1*icenumh
	Tiwp[*,*,1]=iwp2*iceliqnumh
	Tiwp[*,*,2]=iwp3*icemixnumh
	Tiwp[*,*,3]=iwp4*mixedh
 	Tiwp1=Tiwp1+Tiwp
	
	ind=where(icenumv eq 0)
	iwc[ind]=0.0
	ire[ind]=0.0
	Tiwc=Tiwc+iwc*icenumv
	Tire=Tire+ire*icenumv
	
	ind=where(liqnumh eq 0)
	lwp1=reform(lwp[*,*,0])
	lwp1[ind]=0.0
	ind=where(iceliqnumh eq 0)
	lwp2=reform(lwp[*,*,1])
	lwp2[ind]=0.0
	ind=where(icemixnumh eq 0)
	lwp3=reform(lwp[*,*,2])
	lwp3[ind]=0.0
	ind=where(mixedh eq 0)
	lwp4=reform(lwp[*,*,3])
	lwp4[ind]=0.0

	Tlwp[*,*,0]=lwp1*liqnumh
	Tlwp[*,*,1]=lwp2*iceliqnumh
	Tlwp[*,*,2]=lwp3*icemixnumh
	Tlwp[*,*,3]=lwp4*mixedh
 	Tlwp1=Tlwp1+Tlwp
	
	ind=where(liqnumv eq 0)
	lwc[ind]=0.0
	lre[ind]=0.0
	Tlwc=Tlwc+lwc*liqnumv
	Tlre=Tlre+lre*liqnumv
	endfor ; end files

	obsnumv=ulonarr(n_elements(lon),n_elements(lat),dimz)
 	For xi=0,n_elements(lon)-1 Do Begin
     	for yi=0,n_elements(lat)-1 Do Begin
     	obsnumv[xi,yi,*]=Tobsnumh[xi,yi]
      	endfor
	endfor

 	;====== obtain average iwp and lwp========
	aveiwp=fltarr(72,90,4)
	avelwp=fltarr(72,90,4)

;	aveiwp[*,*,0]=Tiwp1[*,*,0]/Ticenumh
;	aveiwp[*,*,1]=Tiwp1[*,*,1]/Ticeliqnumh
;	aveiwp[*,*,2]=Tiwp1[*,*,2]/Ticemixnumh
;	aveiwp[*,*,3]=Tiwp1[*,*,3]/Tmixedh
	aveiwp[*,*,0]=Tiwp1[*,*,0]/Tobsnumh
	aveiwp[*,*,1]=Tiwp1[*,*,1]/Tobsnumh
	aveiwp[*,*,2]=Tiwp1[*,*,2]/Tobsnumh
	aveiwp[*,*,3]=Tiwp1[*,*,3]/Tobsnumh
	
;	avelwp[*,*,0]=Tlwp1[*,*,0]/Tliqnumh
;	avelwp[*,*,1]=Tlwp1[*,*,1]/Ticeliqnumh
;	avelwp[*,*,2]=Tlwp1[*,*,2]/Ticemixnumh
;	avelwp[*,*,3]=Tlwp1[*,*,3]/Tmixedh
	avelwp[*,*,0]=Tlwp1[*,*,0]/Tobsnumh
	avelwp[*,*,1]=Tlwp1[*,*,1]/Tobsnumh
	avelwp[*,*,2]=Tlwp1[*,*,2]/Tobsnumh
	avelwp[*,*,3]=Tlwp1[*,*,3]/Tobsnumh

	;======== obtain profile of iwc,liq and plot=========
	ind1=where(lon ge maplimit[1] and lon le maplimit[3])
	ind2=where(lat ge maplimit[0] and lat le maplimit[2])
	Ticenumv1=total(Ticenumv[ind1,*,*,*],1)
	Ticenumv2=total(Ticenumv1[ind2,*,*],1)
	Tiwc1=total(Tiwc[ind1,*,*,*],1)
	Tiwc2=total(Tiwc1[ind2,*,*],1)
	Tire1=total(Tire[ind1,*,*,*],1)
	Tire2=total(Tire1[ind2,*,*],1)

	Tliqnumv1=total(Tliqnumv[ind1,*,*,*],1)
	Tliqnumv2=total(Tliqnumv1[ind2,*,*],1)
	Tlwc1=total(Tlwc[ind1,*,*,*],1)
	Tlwc2=total(Tlwc1[ind2,*,*],1)
	Tlre1=total(Tlre[ind1,*,*,*],1)
	Tlre2=total(Tlre1[ind2,*,*],1)

	Tobsnumv1=total(obsnumv[ind1,*,*],1)
	Tobsnumv2=total(Tobsnumv1[ind2,*],1)

	aveiwc=Tiwc2/Ticenumv2
	aveire=Tire2/Ticenumv2
	avelwc=Tlwc2/Tliqnumv2
	avelre=Tlre2/Tliqnumv2
	liqfrev=fltarr(125,4)
	icefrev=fltarr(125,4)
	liqfrev[*,0]=float(Tliqnumv2[*,0])/Tobsnumv2
	liqfrev[*,1]=float(Tliqnumv2[*,1])/Tobsnumv2
	liqfrev[*,2]=float(Tliqnumv2[*,2])/Tobsnumv2
	liqfrev[*,3]=float(Tliqnumv2[*,3])/Tobsnumv2
	icefrev[*,0]=float(Ticenumv2[*,0])/Tobsnumv2	
	icefrev[*,1]=float(Ticenumv2[*,1])/Tobsnumv2	
	icefrev[*,2]=float(Ticenumv2[*,2])/Tobsnumv2	
	icefrev[*,3]=float(Ticenumv2[*,3])/Tobsnumv2

	;===== write the results for future plot======
	wfname=region+'_icecloud_profile_'+season[mi]+'.txt'
	openw,u,wfname,/get_lun
	printf,u,'obsnum, iwc1, iwc2, iwc3, iwc3, ire1,ire2,ire3,ire4'
	for hi=0,Nh-1 do printf,u,format='(I10,x,8(f12.8,x))',Tobsnumv2[hi],aveiwc[hi,0],aveiwc[hi,1],aveiwc[hi,2],$
		aveiwc[hi,3],aveire[hi,0],aveire[hi,1],aveire[hi,2],aveire[hi,3]
	free_lun,u
	wfname=region+'_liquidcloud_profile_'+season[mi]+'.txt'
	save,Ticenumv2,filename=region+'_ice_profile_num_'+season[mi]+'.sav'
	openw,u,wfname,/get_lun
	printf,u,'lcenum,obsnum, lwc1, lwc2, lwc3, lwc3, lre1,lre2,lre3,lre4'
	for hi=0,Nh-1 do printf,u,format='(I10,x,8(f12.8,x))',Tobsnumv2[hi],avelwc[hi,0],avelwc[hi,1],avelwc[hi,2],$
		avelwc[hi,3],avelre[hi,0],avelre[hi,1],avelre[hi,2],avelre[hi,3]
	free_lun,u
	save,Tliqnumv2,filename=region+'_liq_profile_num_'+season[mi]+'.sav'

	for typei=0,3 do begin ; for each cloud type

	pos=[posx1[typei],posy1[mi],posx2[typei],posy2[mi]]
	data=reform(avelwp[*,*,typei])
	print,max(data,/nan),min(data,/nan),mean(data,/nan)

	minval=setminval[typei]
	maxval=setmaxval[typei]
	
	if typei eq 0 and mi eq 0 then begin
	im=image(data,lon,lat,rgb_table=rgbtable,dim=[850,700],xrange=[min(lon),max(lon)],$
		yrange=[min(lat),max(lat)],min_value=minval,max_value=maxval,position=pos)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=im)
    grid=mp.MAPGRID
;    grid.hide=0
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
	grid.grid_latitude=10
 	mc=mapcontinents(/continents,transparency=30)
	mc['Longitudes'].label_angle=0
		
	endif else begin
	im=image(data,lon,lat,rgb_table=rgbtable,xrange=[min(lon),max(lon)],$
		yrange=[min(lat),max(lat)],min_value=minval,max_value=maxval,position=pos,/current)
	mp=map('Geographic',limit=maplimit,transparency=30,overplot=im,position=pos)
    grid=mp.MAPGRID
;    grid.hide=0
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
	grid.grid_latitude=10
    mc=mapcontinents(/continents,transparency=30)
	mc['Longitudes'].label_angle=0
	endelse
	if mi eq 0 then $
	t=text(pos[0]+0.07,pos[3]+0.01,subtitle1[typei],/normal,font_size=fontsz)
 	subi=typei+mi*4
	t=text(pos[0]+0.015,pos[3]-0.01,subtitle[subi]+' '+season[mi],/normal,font_size=fontsz-2)

	if mi eq 3  then begin
	barpos=[pos[0],pos[1]-0.05,pos[2],pos[1]-0.03]
	ct=colorbar(target=im,position=barpos,title=bartitle)
	endif

	endfor ; end cloud type	

EndFor
im.save,region+'_'+flag+'_distribution_fourseason.png'

;plot_water_profile,'Philippine'

stop 
end
