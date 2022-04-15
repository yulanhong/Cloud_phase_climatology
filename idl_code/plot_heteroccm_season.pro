; to plot H_sigma spatial distributions in four seasons 
pro plot_heteroccm_season

 allhetero=0.0
 allnum=0
 lon=(findgen(72))*5.0-180
 lat=(findgen(90))*2.0-90
 fontsz=10
 
 maplimit=[-10,80,30,150]
 posx1=[0.03,0.17,0.31,0.45,0.59,0.73,0.87]
 posx2=[0.14,0.28,0.42,0.56,0.70,0.84,0.98]
 posy1=[0.77,0.55,0.33,0.11]
 posy2=[0.97,0.75,0.53,0.31]
 subtitle=['Clear','Ice only','Liquid only','Mixed only','Ice above liquid','Ice above mixed','All sky'] 
 subtitle1=[['a1)','b1)','c1)','d1)','e1)','f1)','g1)'],$
			['a2)','b2)','c2)','d2)','e2)','f2)','g2)'],$
			['a3)','b3)','c3)','d3)','e3)','f3)','g3)'],$
			['a4)','b4)','c4)','d4)','e4)','f4)','g4)']]
	
 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat/R05'

  For mi=0,3 Do Begin
     if (mi eq 0) then begin
     allfname1=file_search(datadir,'*03.hdf')
     allfname2=file_search(datadir,'*04.hdf')
     allfname3=file_search(datadir,'*05.hdf')
     endif
     if (mi eq 1) then begin
     allfname1=file_search(datadir,'*06.hdf')
     allfname2=file_search(datadir,'*07.hdf')
     allfname3=file_search(datadir,'*08.hdf')
     endif
     if (mi eq 2) then begin
     allfname1=file_search(datadir,'*09.hdf')
     allfname2=file_search(datadir,'*10.hdf')
     allfname3=file_search(datadir,'*11.hdf')
     endif
     if (mi eq 3) then begin
     allfname1=file_search(datadir,'*12.hdf')
     allfname2=file_search(datadir,'*01.hdf')
     allfname3=file_search(datadir,'*02.hdf')
  endif


	allfname=[allfname1,allfname2,allfname3]
 
    Nf=n_elements(allfname)
	
	seahetero=0.0
	seanum=0

	For fi=0,Nf-1 Do Begin
		read_dardar,allfname[fi],'hetero_spatial',hetero
		read_dardar,allfname[fi],'hetero_spatial_num',num
		ind=where(num eq 0)
		hetero[ind]=0.0
		seahetero=seahetero+hetero*num
		seanum = seanum + num
	print,allfname[fi]
	EndFor ; endfor reading file
	
	allhetero=allhetero+seahetero
	allnum = allnum+seanum
	; to plot seasonal heterogeneity
	avehetero=seahetero/seanum
	minvalue=0.0
	maxvalue=0.35

    avehetero1=fltarr(72,90,7)
	avehetero1[*,*,0]=avehetero[*,*,0] ; clear
	avehetero1[*,*,1]=avehetero[*,*,1] ; ice
	avehetero1[*,*,2]=avehetero[*,*,4] ; ice-liquid
	avehetero1[*,*,3]=avehetero[*,*,5] ; ice-mixed 
	avehetero1[*,*,4]=avehetero[*,*,2] ; mixed
	avehetero1[*,*,5]=avehetero[*,*,3] ; liquid
	avehetero1[*,*,6]=avehetero[*,*,7] ; all
	
	for typei=0,6 do begin

		pos=[posx1[typei],posy1[mi],posx2[typei],posy2[mi]]
		barpos=[pos[0],pos[1]-0.05,pos[2],pos[1]-0.03]
		data=reform(avehetero1[*,*,typei])
		if mi eq 0 and typei eq 0 then begin
			mp=map('Geographic',limit=maplimit,transparency=0,dimensions=[1000,500],position=pos)
		    grid=mp.MAPGRID
			grid.label_position=0
			grid.linestyle='dotted'
			grid.grid_longitude=20

		    c=image(data,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
			max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
          	rgb_table=33,overplot=mp,font_size=fontsz-1)
			mc=mapcontinents(/continents,transparency=0,fill_color='white')
			 mc['Longitudes'].label_angle=0
			t1=text(pos[0]+0.008,pos[3]-0.05,subtitle1[typei,mi],font_size=fontsz+0.5)
			c.scale,1,1.2
		endif else begin
			mp=map('Geographic',limit=maplimit,transparency=0,position=pos,/current)
		    grid=mp.MAPGRID
			grid.label_position=0
			grid.linestyle='dotted'
			grid.grid_longitude=20
			if mi eq 0 then title=subtitle[typei] else title=''
	     	c=image(data,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
			  max_value=maxvalue,min_value=minvalue,title=title,$
		       rgb_table=33,overplot=mp,font_size=fontsz-1)
			mc=mapcontinents(/continents,transparency=0,fill_color='white')
		  	mc['Longitudes'].label_angle=0
			t1=text(pos[0]+0.008,pos[3]-0.05,subtitle1[typei,mi],font_size=fontsz+0.5)
			c.scale,1,1.2
		endelse
	
	endfor ; end type

	EndFor ; endfor season
	cttitle='$H_{\sigma}$'
	tigap=0.05
	barpos=[0.25,0.07,0.75,0.09]
	ct=colorbar(target=c,title=cttitle,taper=1,border=1,$
        orientation=0,position=barpos,font_size=fontsz+1,tickinterval=tigap);,tickvalues=tkvalue)

 	c.save,'cldphase_spatial_hetero_fourseason_R05.png'
	stop
end
