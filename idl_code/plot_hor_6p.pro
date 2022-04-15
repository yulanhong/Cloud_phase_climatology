
pro plot_hor_6p,data,lat,lon,maplimit,bartitle

  posx1=[0.10,0.53,0.10,0.53,0.10,0.53]
  posx2=[0.45,0.88,0.45,0.88,0.45,0.88]
  posy1=[0.70,0.70,0.43,0.43,0.16,0.16]
  posy2=[0.90,0.90,0.63,0.63,0.36,0.36]

  n=13
;  levs=findgen(n)*0.03
;  levs[n-1]=0.8
  levs=[0,0.01,0.03,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.7]
;  levs=findgen(n)+6
  index=findgen(n)*21

  title=['Jun.','Jun.','Jul.','Jul.','Aug.','Aug.']
 
  for i=0,5 do begin

      pos=[posx1[i],posy1[i],posx2[i],posy2[i]]

      if (i eq 0) then begin
	c=contour(data[*,*,i],lon,lat,c_value=levs,n_levels=n,$
      	dim=[600,800],rgb_table=33,rgb_indices=index,/fill,title=$
      	title[i],position=pos)

	mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   	grid=mp.MAPGRID
   	grid.label_position=0
   	grid.linestyle='dotted'

   	mc=mapcontinents(/continents,transparency=30)
  
	ct=colorbar(target=c,title=bartitle,taper=1,border=1,$
        orientation=0,position=[posx1[0]+0.05,posy1[5]-0.08,posx2[5],posy1[5]-0.06])

      endif else begin

	c=contour(data[*,*,i],lon,lat,c_value=levs,n_levels=n,$
      	rgb_table=33,rgb_indices=index,/fill,position=pos,/current,$
	title=title[i])

	mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   	grid=mp.MAPGRID
   	grid.label_position=0
   	grid.linestyle='dotted'

   	mc=mapcontinents(/continents,transparency=30)

      endelse
  endfor

  tx=text(posx1[0],posy2[0]+0.03,'MEI < 0 (2007 and 2010)',/normal)
  tx=text(posx1[1],posy2[0]+0.03,'MEI > 0 (2008 and 2009)',/normal)

 stop
end
