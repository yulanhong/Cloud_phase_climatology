
; to test plot pressure,temperature and wind together 

pro plot_PTwind,pres,temp,uwind,vwind,lon,lat

n=12
index=findgen(n)*23

maplimit=[-10,70,30,150]

temp_val=[230,240,250,260,270,280,290,295,300,310,315,320]
c=contour(temp,lon,lat,c_value=temp_val,n_levels=n,$
	rgb_table=33,rgb_indices=index,/fill,dim=[600,500])

pres_val=[500,700,800,900,950,1000,1005,1010,1015,1020,1025,1030]
c1=contour(pres,lon,lat,c_value=pres_val,n_levels=n,$
	overplot=c,color=0,c_color=0)

v=vector(uwind,vwind,lon,lat,overplot=c,color='grey',head_angle=20)

l=legend(sample_magnitude=10,units='$m s^{-1}$',target=v,position=[0.8,0.95])

mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=20
mc=mapcontinents(/continents,transparency=40,fill_color='khaki')
 
stop

end
