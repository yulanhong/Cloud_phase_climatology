
pro plot_ENSO_radanomaly

  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/ENSO'
  lat=findgen(180)-90
  lon=findgen(360)-180
  ;save seasonal average of each year
  sea_obsnumr=ulonarr(360,180,4)
  sea_obsnumb=ulonarr(360,180,4)
  sea_r64=fltarr(360,180,4)
  sea_bt11=fltarr(360,180,4)

  ; for elnino
  el_obsnumr=ulonarr(360,180,4)
  el_obsnumb=ulonarr(360,180,4)
  el_r64=fltarr(360,180,4)
  el_bt11=fltarr(360,180,4)

  ; for lanina
  la_obsnumr=ulonarr(360,180,4)
  la_obsnumb=ulonarr(360,180,4)
  la_r64=fltarr(360,180,4)
  la_bt11=fltarr(360,180,4)

  for mi=0,3 do begin
 	if mi eq 0 then begin
    	allfname1=file_search(datadir,'*03.hdf')
    	allfname2=file_search(datadir,'*04.hdf')
    	allfname3=file_search(datadir,'*05.hdf')
	endif
 	if mi eq 1 then begin
    	allfname1=file_search(datadir,'*06.hdf')
    	allfname2=file_search(datadir,'*07.hdf')
    	allfname3=file_search(datadir,'*08.hdf')
	endif
 	if mi eq 2 then begin
    	allfname1=file_search(datadir,'*09.hdf')
    	allfname2=file_search(datadir,'*10.hdf')
    	allfname3=file_search(datadir,'*11.hdf')
	endif
 	if mi eq 3 then begin
    	allfname1=file_search(datadir,'*12.hdf')
    	allfname2=file_search(datadir,'*01.hdf')
    	allfname3=file_search(datadir,'*02.hdf')
	endif

 	allfname=[allfname1,allfname2,allfname3] 

    Nf=n_elements(allfname)
    yi=0 
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
	EndIF

	print,year,mon,laflag,elflag
    EndIf ; end year

    Endfor ; end files


    Endfor; season

    clima_r64=sea_r64/sea_obsnumr
	clima_bt11=sea_bt11/sea_obsnumb

    la_r64=la_r64/la_obsnumr
	la_bt11=la_bt11/la_obsnumb
    el_r64=el_r64/el_obsnumr
	el_bt11=el_bt11/el_obsnumb

    ; to plot
     posx1=[0.06,0.30,0.54,0.78]
     posx2=[0.26,0.50,0.74,0.98]
     posy1=[0.77,0.55,0.33,0.11]
     posy2=[0.97,0.75,0.53,0.31]
     lnthk=3.0
     fontsz=9
     subtitle1=['El Nino R','La Nina R','El Nino BT','La Nina BT']
	  subtitle=[['a1)','b1)','c1)','d1)'],$
        ['a2)','b2)','c2)','d2)'],$
         ['a3)','b3)','c3)','d3)'],$
         ['a4)','b4)','c4)','d4)']]
	 maplimit=[-10,80,30,150]
	 rmin=-0.1
	 rmax=0.1
	 btmin=-10
	 btmax=10
	
	 for mi=0,3 do begin
		data1=reform(el_r64[*,*,mi])-reform(clima_r64[*,*,mi])
		data2=reform(la_r64[*,*,mi])-reform(clima_r64[*,*,mi])
		data3=reform(el_bt11[*,*,mi])-reform(clima_bt11[*,*,mi])
		data4=reform(la_bt11[*,*,mi])-reform(clima_bt11[*,*,mi])

		pos1=[posx1[0],posy1[mi],posx2[0],posy2[mi]]
	    pos2=[posx1[1],posy1[mi],posx2[1],posy2[mi]]
 	    pos3=[posx1[2],posy1[mi],posx2[2],posy2[mi]]
 	    pos4=[posx1[3],posy1[mi],posx2[3],posy2[mi]]


	    if mi eq 0 then begin
 	     im=image(data1,lon,lat,rgb_table=72,min_value=rmin,max_value=rmax,dim=[650,600],position=pos1)
 	     t21=text(pos1[0]+0.02,pos1[3],subtitle1[0],font_size=fontsz)
 	     t22=text(pos2[0]+0.02,pos2[3],subtitle1[1],font_size=fontsz)
 	     t23=text(pos3[0]+0.02,pos3[3],subtitle1[2],font_size=fontsz)
         t24=text(pos4[0]+0.02,pos4[3],subtitle1[3],font_size=fontsz)
 	     endif else begin
 	        im=image(data1,lon,lat,rgb_table=72,min_value=rmin,max_value=rmax,$
 	         position=pos1,/current)
 	     endelse
 	    mp=map('Geographic',limit=maplimit,transparency=0,overplot=im)
 	    grid=mp.MAPGRID
 	    grid.label_position=0
 	    grid.linestyle='dotted'
 	    grid.grid_longitude=30
 	    grid.grid_latitude=20
 	    grid.font_size=fontsz-1.5
 	    mc=mapcontinents(/continents,transparency=0,color='white')
 	    mc['Longitudes'].label_angle=0
        t1=text(pos1[0],pos1[3]-0.02,subtitle[0,mi],font_size=fontsz)

		 im1=image(data2,lon,lat,rgb_table=72,min_value=rmin,max_value=rmax,$
          position=pos2,/current)
      mp=map('Geographic',limit=maplimit,transparency=0,overplot=im1)
      grid=mp.MAPGRID
      grid.label_position=0
      grid.linestyle='dotted'
      grid.grid_longitude=30
      grid.grid_latitude=20
      grid.font_size=fontsz-1.5
      mc=mapcontinents(/continents,transparency=0,color='white')
      mc['Longitudes'].label_angle=0
      t2=text(pos2[0],pos2[3]-0.02,subtitle[1,mi],font_size=fontsz)
  
      im2=image(data3,lon,lat,rgb_table=72,min_value=btmin,max_value=btmax,$
          position=pos3,/current)
      mp=map('Geographic',limit=maplimit,transparency=0,overplot=im2)
      grid=mp.MAPGRID
      grid.label_position=0
      grid.linestyle='dotted'
      grid.grid_longitude=30
      grid.grid_latitude=20
      grid.font_size=fontsz-1.5
      mc=mapcontinents(/continents,transparency=0,color='white')
      mc['Longitudes'].label_angle=0
      t3=text(pos3[0],pos3[3]-0.02,subtitle[2,mi],font_size=fontsz)
 
	   im3=image(data4,lon,lat,rgb_table=72,min_value=btmin,max_value=btmax,$
         position=pos4,/current)
     mp=map('Geographic',limit=maplimit,transparency=0,overplot=im3)
     grid=mp.MAPGRID
     grid.label_position=0
     grid.linestyle='dotted'
     grid.grid_longitude=30
     grid.grid_latitude=20
     grid.font_size=fontsz-1.5
     mc=mapcontinents(/continents,transparency=0,color='white')
     mc['Longitudes'].label_angle=0
     t4=text(pos4[0],pos4[3]-0.02,subtitle[3,mi],font_size=fontsz)
 

	endfor ; endfor plot season  


  stop


end
