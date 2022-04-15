
pro plot_hetero_anomaly

  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/ENSO'
  datadir1='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis'

  lat=findgen(180)-90
  lon=findgen(360)-180
  ;save seasonal average of each year
  sea_obsnumr=ulonarr(360,180,4)
  sea_obsnumb=ulonarr(360,180,4)
  sea_r64=fltarr(360,180,4)
  sea_bt11=fltarr(360,180,4)
  sea_obsnumh=ulonarr(360,180,4)
  sea_hetero=fltarr(360,180,4)

  ; for elnino
  el_obsnumr=ulonarr(360,180,4)
  el_obsnumb=ulonarr(360,180,4)
  el_r64=fltarr(360,180,4)
  el_bt11=fltarr(360,180,4)
  el_obsnumh=ulonarr(360,180,4)
  el_hetero=fltarr(360,180,4)

  ; for lanina
  la_obsnumr=ulonarr(360,180,4)
  la_obsnumb=ulonarr(360,180,4)
  la_r64=fltarr(360,180,4)
  la_bt11=fltarr(360,180,4)
  la_obsnumh=ulonarr(360,180,4)
  la_hetero=fltarr(360,180,4)

  for mi=0,3 do begin
 	if mi eq 0 then begin
    	allfname1=file_search(datadir,'*03.hdf')
    	allfname2=file_search(datadir,'*04.hdf')
    	allfname3=file_search(datadir,'*05.hdf')

    	allfname11=file_search(datadir1,'*03.hdf')
    	allfname21=file_search(datadir1,'*04.hdf')
    	allfname31=file_search(datadir1,'*05.hdf')
	endif
 	if mi eq 1 then begin
    	allfname1=file_search(datadir,'*06.hdf')
    	allfname2=file_search(datadir,'*07.hdf')
    	allfname3=file_search(datadir,'*08.hdf')
    	
		allfname11=file_search(datadir1,'*06.hdf')
    	allfname21=file_search(datadir1,'*07.hdf')
    	allfname31=file_search(datadir1,'*08.hdf')
	endif
 	if mi eq 2 then begin
    	allfname1=file_search(datadir,'*09.hdf')
    	allfname2=file_search(datadir,'*10.hdf')
    	allfname3=file_search(datadir,'*11.hdf')

		allfname11=file_search(datadir1,'*09.hdf')
    	allfname21=file_search(datadir1,'*10.hdf')
    	allfname31=file_search(datadir1,'*11.hdf')
	endif
 	if mi eq 3 then begin
    	allfname1=file_search(datadir,'*12.hdf')
    	allfname2=file_search(datadir,'*01.hdf')
    	allfname3=file_search(datadir,'*02.hdf')

    	allfname11=file_search(datadir1,'*12.hdf')
    	allfname21=file_search(datadir1,'*01.hdf')
    	allfname31=file_search(datadir1,'*02.hdf')
	endif

 	allfname=[allfname1,allfname2,allfname3] 
 	allfnameh=[allfname11,allfname21,allfname31] 

    Nf=n_elements(allfname)
    
    For fi=0,Nf-1 Do Begin

    year=strmid(allfname[fi],9,4,/rev)

    mon=strmid(allfname[fi],5,2,/rev)
    mon=fix(mon)
	elflag=0
	laflag=0
	yi=fix(year)-2003

    IF (year ne '2018') Then begin
     read_dardar,allfname[fi],'modis_obsnum',obsnum
     read_dardar,allfname[fi],'modis_reflectance_64',r64
     read_dardar,allfname[fi],'modis_bt_11',bt11

	 read_dardar,allfnameh[fi],'modis_obsnum',obsnumh
     read_dardar,allfnameh[fi],'modis_obshetero',hetero

  	 ind=where(finite(hetero) eq 0)
     if ind[0] ne -1 then begin
         hetero[ind]=0.0
         obsnumh[ind]=0.0
     endif
     sea_obsnumh[*,*,mi]=sea_obsnumh[*,*,mi]+obsnumh
     sea_hetero[*,*,mi]=sea_hetero[*,*,mi]+hetero*obsnumh

   	 print,allfname[fi] 
  	 obsnum21=obsnum
	 ind=where(finite(r64) eq 0)
     if ind[0] ne -1 then begin
         r64[ind]=0.0
         obsnum21[ind]=0.0
     endif
	 obsnum22=obsnum
     ind=where(finite(bt11) eq 0)
     if ind[0] ne -1 then begin
         bt11[ind]=0.0
         obsnum22[ind]=0.0
     endif
  	sea_obsnumr[*,*,mi]=sea_obsnumr[*,*,mi]+obsnum21
  	sea_obsnumb[*,*,mi]=sea_obsnumb[*,*,mi]+obsnum22
 	sea_r64[*,*,mi]=sea_r64[*,*,mi]+r64*obsnum21
  	sea_bt11[*,*,mi]=sea_bt11[*,*,mi]+bt11*obsnum22

    IF (year eq '2003' and mon le 3) Then elflag=1 
    IF (year eq '2006' and mon ge 8) Then elflag=1 
    IF (year eq '2009' and mon ge 10) Then elflag=1
    IF (year eq '2010' and mon le 4) Then elflag=1
    IF (year eq '2015' and mon ge 5) Then elflag=1
    IF (year eq '2016' and mon le 5) Then elflag=1

	IF (elflag eq 1) Then Begin
  		el_obsnumr[*,*,mi]=el_obsnumr[*,*,mi]+obsnum21
  		el_obsnumb[*,*,mi]=el_obsnumb[*,*,mi]+obsnum22
 		el_r64[*,*,mi]=el_r64[*,*,mi]+r64*obsnum21
  		el_bt11[*,*,mi]=el_bt11[*,*,mi]+bt11*obsnum22
		el_obsnumh[*,*,mi]=el_obsnumh[*,*,mi]+obsnumh
 		el_hetero[*,*,mi]=el_hetero[*,*,mi]+hetero*obsnumh
	EndIF


    IF (year eq '2005' and mon ge 10) Then laflag=1 
    IF (year eq '2006' and mon le 4) Then laflag=1
    IF (year eq '2007' and mon ge 6) Then laflag=1
    IF (year eq '2008') Then laflag=1
    IF (year eq '2009' and mon le 5) Then laflag=1
    IF (year eq '2010' and mon ge 6) Then laflag=1
    IF (year eq '2011') Then laflag=1
    IF (year eq '2012' and mon le 3) Then laflag=1
    IF (year eq '2013' and mon ge 5 and mon le 8) Then laflag=1
    IF (year eq '2016' and mon ge 10 and mon le 11) Then laflag=1
    IF (year eq '2017' and mon ge 7) Then laflag=1
    IF (year eq '2018' and mon le 6) Then laflag=1

 	IF (laflag eq 1) Then Begin
  		la_obsnumr[*,*,mi]=la_obsnumr[*,*,mi]+obsnum21
  		la_obsnumb[*,*,mi]=la_obsnumb[*,*,mi]+obsnum22
 		la_r64[*,*,mi]=la_r64[*,*,mi]+r64*obsnum21
  		la_bt11[*,*,mi]=la_bt11[*,*,mi]+bt11*obsnum22
		la_obsnumh[*,*,mi]=la_obsnumh[*,*,mi]+obsnumh
 		la_hetero[*,*,mi]=la_hetero[*,*,mi]+hetero*obsnumh
		
	EndIF

	print,year,mon,laflag,elflag
    EndIf ; end year

    Endfor ; end files


    Endfor; season

    clima_r64=sea_r64/sea_obsnumr
	clima_bt11=sea_bt11/sea_obsnumb
	clima_hetero=sea_hetero/sea_obsnumh

    la_r64=la_r64/la_obsnumr
	la_bt11=la_bt11/la_obsnumb
	la_hetero=la_hetero/la_obsnumh
    el_r64=el_r64/el_obsnumr
	el_bt11=el_bt11/el_obsnumb
	el_hetero=el_hetero/el_obsnumh

    ; to plot
     posx1=[0.06,0.53];,0.38,0.54,0.70,0.86]
     posx2=[0.50,0.97];,0.50,0.66,0.82,0.98]
     posy1=[0.77,0.56,0.35,0.14]
     posy2=[0.97,0.76,0.55,0.34]
     lnthk=3.0
     fontsz=10
     subtitle1=['$El Nino$','$La Nina$','$El Nino$','$La Nina$',$
		'$El Nino$','$La Nina$']
	 subtitle=[['a1)','b1)','c1)','d1)','e1)','f1)'],$
        ['a2)','b2)','c2)','d2)','e2)','f2)'],$
         ['a3)','b3)','c3)','d3)','e3)','f3)'],$
         ['a4)','b4)','c4)','d4)','e4)','f4)']]
	 maplimit=[-10,80,30,150]
	 rmin=-0.1
	 rmax=0.1
	 btmin=-10
	 btmax=10
	 hmin=-0.03
	 hmax=0.03
	
	 for mi=0,3 do begin
		data1=reform(el_r64[*,*,mi])-reform(clima_r64[*,*,mi])
		data2=reform(la_r64[*,*,mi])-reform(clima_r64[*,*,mi])
		data3=reform(el_bt11[*,*,mi])-reform(clima_bt11[*,*,mi])
		data4=reform(la_bt11[*,*,mi])-reform(clima_bt11[*,*,mi])
		data5=reform(el_hetero[*,*,mi])-reform(clima_hetero[*,*,mi])
		data6=reform(la_hetero[*,*,mi])-reform(clima_hetero[*,*,mi])

		pos1=[posx1[0],posy1[mi],posx2[0],posy2[mi]]
	    pos2=[posx1[1],posy1[mi],posx2[1],posy2[mi]]
; 	    pos3=[posx1[2],posy1[mi],posx2[2],posy2[mi]]
; 	    pos4=[posx1[3],posy1[mi],posx2[3],posy2[mi]]
; 	    pos5=[posx1[4],posy1[mi],posx2[4],posy2[mi]]
; 	    pos6=[posx1[5],posy1[mi],posx2[5],posy2[mi]]

	    if mi eq 0 then begin
 	     im=image(data5,lon,lat,rgb_table=72,min_value=hmin,max_value=hmax,dim=[400,450],position=pos1)
 	     t21=text(pos1[0]+0.12,pos1[3]-0.01,subtitle1[0],font_size=fontsz)
 	     t22=text(pos2[0]+0.12,pos2[3]-0.01,subtitle1[1],font_size=fontsz)
 	    ; t23=text(pos3[0]+0.03,pos3[3]-0.02,subtitle1[2],font_size=fontsz)
        ; t24=text(pos4[0]+0.03,pos4[3]-0.02,subtitle1[3],font_size=fontsz)
 	    ; t25=text(pos5[0]+0.03,pos5[3]-0.02,subtitle1[4],font_size=fontsz)
        ; t26=text(pos6[0]+0.03,pos6[3]-0.02,subtitle1[5],font_size=fontsz)

		;=== to plot a retangel
		ind=where(lat ge -10 and lat le 20,count)
		tpx=fltarr(count)
		tpx(*)=100
		dp=plot(tpx,lat[ind],linestyle='dash',thick=2,overplot=im,color='red')
		tpx(*)=140
        dp1=plot(tpx,lat[ind],linestyle='dash',thick=2,overplot=im,color='red')
        ind=where(lon ge 100 and lon le 140,count)
        tpy=fltarr(count)
        tpy(*)=-10
        dp2=plot(lon[ind],tpy,linestyle='dash',thick=2,overplot=im,color='red')
        tpy(*)=20
        dp2=plot(lon[ind],tpy,linestyle='dash',thick=2,overplot=im,color='red')

 	     endif else begin
 	        im=image(data5,lon,lat,rgb_table=72,min_value=hmin,max_value=hmax,$
 	         position=pos1,/current)
 	     endelse
 	    mp=map('Geographic',limit=maplimit,transparency=0,overplot=im)
 	    grid=mp.MAPGRID
 	    grid.label_position=0
 	    grid.linestyle='dotted'
 	    grid.grid_longitude=20
 	    grid.grid_latitude=10
 	    grid.font_size=fontsz-2.0
 	    mc=mapcontinents(/continents,transparency=0,fill_color='white')
 	    mc['Longitudes'].label_angle=0
        t1=text(pos1[0]+0.05,pos1[3]-0.05,subtitle[0,mi],font_size=fontsz)
		im.scale,0.9,0.78

		im1=image(data6,lon,lat,rgb_table=72,min_value=hmin,max_value=hmax,$
          position=pos2,/current)
      mp=map('Geographic',limit=maplimit,transparency=0,overplot=im1)
      grid=mp.MAPGRID
      grid.label_position=0
      grid.linestyle='dotted'
      grid.grid_longitude=20
      grid.grid_latitude=10
      grid.font_size=fontsz-2.0
      mc=mapcontinents(/continents,transparency=0,fill_color='white')
      mc['Longitudes'].label_angle=0
      t2=text(pos2[0]+0.05,pos2[3]-0.05,subtitle[1,mi],font_size=fontsz)
	  im1.scale,0.9,0.78
	
	endfor ; endfor plot season  
	barpos1=[0.06,0.09,0.34,0.11]
	barpos2=[0.38,0.09,0.66,0.11]
	barpos3=[0.10,0.09,0.9,0.11]
;	ct=colorbar(target=im,title='$R_{0.645}$ Anomaly',font_size=fontsz,border=1,position=barpos1,orientation=0)
;	ct1=colorbar(target=im2,title='$BT_{11}$ Anomaly (K)',font_size=fontsz,border=1,position=barpos2,orientation=0)
	ct1=colorbar(target=im,title='$H_{\sigma}$ Anomaly',font_size=fontsz,border=1,position=barpos3,orientation=0)

	im.save,'ENSO_spatial_hetero_anomaly_R05.png'
  stop

end
