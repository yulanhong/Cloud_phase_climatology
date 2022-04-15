
pro multiple_layer_analysis 

 datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Thick_top_met"

 fontsz=12
 subtitle=['MAM', 'JJA','SON','DJF']
 subtitle1=['a1)', 'a2)','a3)','a4)']
 subtitle2=['b1)', 'b2)','b3)','b4)']

 posx1=[0.05,0.29,0.53,0.77]
 posx2=[0.25,0.49,0.73,0.97]
 posy1=[0.70,0.27]
 posy2=[0.96,0.60]

;maplimit=[-90,-180,90,180]
 maplimit=[-20,70,30,150]
 maplimit1=[0,105,20,135]

 barpos1=[0.30,0.66,0.70,0.68]
 
 For mi=0,3 Do Begin

 if mi eq 0 then begin
 allfname1=file_search(datadir,'*03_day.hdf')
 allfname2=file_search(datadir,'*04_day.hdf')
 allfname3=file_search(datadir,'*05_day.hdf')
 endif
 if mi eq 1 then begin
 allfname1=file_search(datadir,'*06_day.hdf')
 allfname2=file_search(datadir,'*07_day.hdf')
 allfname3=file_search(datadir,'*08_day.hdf')
 endif
 if mi eq 2 then begin
 allfname1=file_search(datadir,'*09_day.hdf')
 allfname2=file_search(datadir,'*10_day.hdf')
 allfname3=file_search(datadir,'*11_day.hdf')
 endif
 if mi eq 3 then begin
 allfname1=file_search(datadir,'*12_day.hdf')
 allfname2=file_search(datadir,'*01_day.hdf')
 allfname3=file_search(datadir,'*02_day.hdf')
 endif
 
 allfname=[allfname1,allfname2,allfname3]
 
 Nf=n_elements(allfname)
 
 Tice_thick_single=0.0
 Ticenum_single=0
 Tice_thick_multi=0.0
 Ticenum_multi=0
 Tobsnum=0

 Tliq_top_single=0.0
 Tliqnum_single=0
 Tliq_top_multi=0.0
 Tliqnum_multi=0
 
 for fi=0,Nf-1 do begin
	read_dardar,allfname[fi],'liquid_top_single_layer',liq_top_single
	read_dardar,allfname[fi],'liq_num_single_layer',liqnum_single
	Tliqnum_single=Tliqnum_single+liqnum_single
	ind=where(liqnum_single eq 0)
	liq_top_single[ind]=0.0
	Tliq_top_single=Tliq_top_single+liqnum_single*liq_top_single

	read_dardar,allfname[fi],'liq_top_multi_layer',liq_top_multi
	read_dardar,allfname[fi],'liq_num_multi_layer',liqnum_multi
	Tliqnum_multi=Tliqnum_multi+liqnum_multi
	ind=where(liqnum_multi eq 0)
	liq_top_multi[ind]=0.0
	Tliq_top_multi=Tliq_top_multi+liqnum_multi*liq_top_multi

	read_dardar,allfname[fi],'ice_thick_single_layer_base10',icethick_single
	read_dardar,allfname[fi],'ice_num_single_layer_base10',icenum_single
	ind=where(icenum_single eq 0)
	icethick_single[ind]=0.0
	Tice_thick_single=Tice_thick_single+icethick_single*icenum_single
	Ticenum_single=Ticenum_single+icenum_single

	read_dardar,allfname[fi],'ice_num_multi_layer_base10',icenum_multi
	read_dardar,allfname[fi],'ice_thick_multi_layer_base10',icethick_multi
	ind=where(icenum_multi eq 0)
	icethick_multi[ind]=0.0
	Tice_thick_multi=Tice_thick_multi+icethick_multi*icenum_multi
	Ticenum_multi=Ticenum_multi+icenum_multi

	read_dardar,allfname[fi],'latitude',lat
    read_dardar,allfname[fi],'longitude',lon	
	read_dardar,allfname[fi],'obsnum',obsnum
    Tobsnum=Tobsnum+obsnum
 endfor
 ; get single and multiple layer cloud frequency
 ind1=where(lon ge maplimit[1] and lon le maplimit[3],count)
 N10=count
 ind2=where(lat ge maplimit[0] and lat le maplimit[2],count)
 N20=count
 print,'SEA frequency of single ice layer for ice only',total(Ticenum_single[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1],0])/total(Tobsnum[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1]]) 
 print,'SEA frequency of single ice layer for ice above liquid',total(Ticenum_single[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1],1])/total(Tobsnum[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1]]) 

 print,'SEA frequency of multi ice layer for ice only',total(Ticenum_multi[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1],0])/total(Tobsnum[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1]]) 
 print,'SEA frequency of multi ice layer for ice above liquid',total(Ticenum_multi[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1],1])/total(Tobsnum[ind1[0]:ind1[N10-1],ind2[0]:ind2[N20-1]]) 

 aveicethick_single=Tice_thick_single/Ticenum_single
 aveicethick_multi =Tice_thick_multi/Ticenum_multi
 data=aveicethick_single[*,*,0]-aveicethick_single[*,*,1] ; ice only munus ice above liquid 
 data1=aveicethick_multi[*,*,0]-aveicethick_multi[*,*,1] ; ice only munus ice above liquid 
; aveliqtop_single=Tliq_top_single/Tliqnum_single
; aveliqtop_multi =Tliq_top_multi/Tliqnum_multi
; data=aveliqtop_single[*,*,0]-aveliqtop_single[*,*,1] ; liq only munus liq above liquid 
; data1=aveliqtop_multi[*,*,0]-aveliqtop_multi[*,*,1] ; liq only munus liq above liquid 

 ind1=where(lon ge maplimit1[1] and lon le maplimit1[3],count)
 N1=count
 ind2=where(lat ge maplimit1[0] and lat le maplimit1[2],count)
 N2=count
 ;get average of difference
 print,'subarea single layer thickness ice only ,', $
	total(Tice_thick_single[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])/total(Ticenum_single[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])
 print,'subarea single layer thickness ice above liquid,', $
	total(Tice_thick_single[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],1])/total(Ticenum_single[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],1])

 print,'subarea multiple layer thickness ice only,', $
	total(Tice_thick_multi[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])/total(Ticenum_multi[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])
 print,'subarea multiple layer thickness ice above liquid,', $
	total(Tice_thick_multi[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],1])/total(Ticenum_multi[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],1])
 
 maxvalue=0.01
 minvalue=-0.01
 
 pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
 pos2=[posx1[mi],posy1[1],posx2[mi],posy2[1]]
 
 if mi eq 0 then begin
    c=image(data,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
       max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
       rgb_table=72,font_size=fontsz,dim=[900,600],position=pos1)
 endif else begin
    c=image(data,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
      max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
      rgb_table=72,font_size=fontsz,/current,position=pos1)
 endelse
  mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=20
  grid.font_size=fontsz-2.5
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0

  c1=image(data1,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
      max_value=maxvalue,min_value=minvalue,$
     rgb_table=72,font_size=fontsz,/current,position=pos2)

  mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
  grid=mp.MAPGRID
  grid.label_position=0
  grid.linestyle='dotted'
  grid.grid_longitude=20
  grid.font_size=fontsz-2.5
  mc=mapcontinents(/continents,transparency=30)
  mc['Longitudes'].label_angle=0
 
  t=text(pos1[0]+0.015,pos1[3]-0.045,subtitle1[mi],/normal,font_size=fontsz)
  t=text(pos2[0]+0.015,pos2[3]-0.045,subtitle2[mi],/normal,font_size=fontsz)
 EndFor ; endfor four months
 
 ct=colorbar(target=c,title='Top Height Difference (km)',taper=1,border=1,$
         orientation=0,position=barpos1,font_size=fontsz)

 c.save,'icethick_base10_only_belowice_single2multiple_phillipine.png'

stop
end
