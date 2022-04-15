
 pro plot_hor_8p,onenum,muln_num,mul1_num,horobs,lon,lat

   nx=n_elements(lon)
   ny=n_elements(lat)
   monind=[6,7,8]
   tponenum=total(onenum[*,*,*,monind],4) 
   tpmulnnum=total(muln_num[*,*,*,monind],4) 
   tpmul1num=total(mul1_num[*,*,*,monind],4) 
   tphorobs=total(horobs[*,*,monind],3)
   
   pos1=[0.05,0.60,0.24,0.95]
   pos2=[0.05,0.18,0.24,0.53]
   pos3=[0.27,0.60,0.47,0.95]
   pos4=[0.27,0.18,0.47,0.53]
   pos5=[0.50,0.60,0.70,0.95]
   pos6=[0.50,0.18,0.70,0.53]
   pos7=[0.73,0.60,0.93,0.95]
   pos8=[0.73,0.18,0.93,0.53]
 
   fontsz=11 
   maplimit=[-10,75,35,155]
   
   n=21
   index=findgen(n)*12.5
   horlevs=findgen(n)*0.025
   tickname=['0','','','','0.1','','','','0.2','','','','0.3',$
        '','','','0.4','','','','0.5']
 
   For i=0,7 Do Begin
    if i eq 0 then begin
	title='a) All One-layer Cloud'
 	horfre=total(tponenum,3)/float(tphorobs)
	c=contour(horfre,lon,lat,c_value=horlevs,n_levels=n,$
       	dim=[1000,500],rgb_table=33,rgb_indices=index,/fill,$
      	position=pos1,font_size=fontsz)
	mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   	grid=mp.MAPGRID
   	grid.label_position=0
   	grid.linestyle='dotted'
   	grid.grid_longitude=20
	mc=mapcontinents(/continents,transparency=30)
  	mc['Longitudes'].label_angle=0

	t=text(pos1[0],pos1[3],title,font_size=fontsz,/normal)
    endif
    if i eq 1 then begin
	pos=pos2
	horfre=(tpmul1num+tpmulnnum)/float(tphorobs)
	title='b) All Multi-layer Cloud'
    endif
    if i eq 2 then begin
	title='c) One-layer Ice Cloud'
 	horfre=tponenum[*,*,0]/float(tphorobs)
	pos=pos3
    endif     

    if i eq 3 then begin
	pos=pos4
	horfre=tpmul1num[*,*,0]/float(tphorobs)
	title='d) Multi-layer Ice Cloud'
    endif

    if i eq 4 then begin
	title='e) One-layer Liquid Cloud'
 	horfre=tponenum[*,*,2]/float(tphorobs)
	pos=pos5
    endif     

    if i eq 5 then begin
	pos=pos6
	horfre=tpmulnnum[*,*,0]/float(tphorobs)
	title='f) Multi-layer Ice-liquid Cloud'
    endif

    if i eq 6 then begin
	title='g) One-layer Mixed Cloud'
 	horfre=tponenum[*,*,1]/float(tphorobs)
	pos=pos7
    endif     

    if i eq 7 then begin
	title='h) Multi-layer Ice-mixed Cloud'
 	horfre=tpmulnnum[*,*,1]/float(tphorobs)
	pos=pos8
    endif     

    if i ge 1 then begin 
	c1=contour(horfre,lon,lat,c_value=horlevs,n_levels=n,$
       	rgb_table=33,rgb_indices=index,/fill,/current,$
      	position=pos,font_size=fontsz)
	mp=map('Geographic',limit=maplimit, overplot=c1,transparency=30)
   	grid=mp.MAPGRID
   	grid.label_position=0
   	grid.linestyle='dotted'
   	grid.grid_longitude=20
	mc=mapcontinents(/continents,transparency=30)
  	mc['Longitudes'].label_angle=0

	t=text(pos[0],pos[3],title,font_size=fontsz,/normal)
   endif
	
   EndFor

     barpos=[pos1[2],pos2[1]-0.08,pos7[0],pos2[1]-0.05]
     ct=colorbar(target=c1,title='Cloud Frequency',taper=0,border=1,$
        orientation=0,position=barpos,tickname=tickname)
     ct.font_size=fontsz
  stop
 end
