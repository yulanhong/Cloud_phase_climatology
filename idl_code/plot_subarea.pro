
pro plot_subarea
 maplimit=[-10,75,35,155]
 subarea=[0,105,20,135]
 fontsz=12
 mp=map('Geographic',limit=maplimit, overplot=c,transparency=30,position=[0.1,0.2,0.9,0.85],$
        font_size=fontsz)
 
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.box_axes=1
 
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0

 x=fltarr(10)
 x[*]=subarea[1]
 y=findgen(6)*4
 p=plot(x,y,overplot=mp,color='r',/current,thick=3)

 x=fltarr(10)
 x[*]=subarea[3]
 y=findgen(6)*4
 p1=plot(x,y,overplot=mp,color='r',/current,thick=3)

 y=fltarr(10)
 y[*]=subarea[0]
 x=findgen(7)*5+105
 p2=plot(x,y,overplot=mp,color='r',/current,thick=3)

 y=fltarr(10)
 x=findgen(7)*5+105 
 y[*]=subarea[2]
 p2=plot(x,y,overplot=mp,color='r',/current,thick=3)

 mp.save,'Philippine_subarea.png'
 stop
end
