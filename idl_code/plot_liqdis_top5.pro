
pro plot_liqdis_top5

fontsz=12
Nh=101
;subtitle=['a) MAM', 'b) JJA','c) SON','d) DJF']

posx1=[0.08,0.53,0.08,0.53]
posx2=[0.43,0.88,0.43,0.88]
posy1=[0.55,0.55,0.10,0.10]
posy2=[0.95,0.95,0.50,0.50]
barpos=[0.2,0.10,0.8,0.13]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
;maplimit=[-90,-180,90,180]
;longap=90
;latgap=45
maplimit=[-10,80,30,150]
longap=20
latgap=10

fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*.hdf')

Nf=n_elements(fname)

obsnum=0L

Tliqbelowice=0L
Tliqnoice=0L

for fi=0,Nf-1 do begin
IF (strlen(fname[fi]) eq 123) Then Begin
	print,fname
	read_dardar,fname[fi],'latitude',lat
	read_dardar,fname[fi],'longitude',lon
	read_dardar,fname[fi],'obsnum',tpobsnum
	obsnum=obsnum+tpobsnum
	read_dardar,fname[fi],'num_liqtop_iceabove',liqbelowice
	Tliqbelowice=Tliqbelowice+liqbelowice
	read_dardar,fname[fi],'num_liqtop_noice',liqnoice
	Tliqnoice=Tliqnoice+liqnoice
EndIf
; plot vertical----------------
endfor


minvalue1=50
maxvalue1=21000

minvalue2=7500

dimx=n_elements(lon)
dimy=n_elements(lat)
Tliqbelowice1=total(Tliqbelowice,4)
Tliqbelowice2=total(Tliqbelowice1,3)
Tliqnoice1 = total(Tliqnoice,4)
Tliqnoice2 = total(Tliqnoice1,3)

pos=[posx1[0],posy1[0],posx2[0],posy2[0]]
mp=map('Geographic',limit=maplimit,transparency=30,dimensions=[600,450],position=pos)
c=image(reform(Tliqbelowice1[*,*,0]),lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=maxvalue2,min_value=minvalue1,title=subtitle,$
         rgb_table=33,overplot=mp,font_size=fontsz)
mc=mapcontinents(/continents,transparency=30)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=longap
grid.grid_latitude=latgap
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0
t1=text(pos[0]+0.04,pos[3]-0.06,'Top > 5 km',font_size=fontsz)

pos=[posx1[1],posy1[1],posx2[1],posy2[1]]
mp1=map('Geographic',limit=maplimit,transparency=30,/current,position=pos)
c1=image(reform(Tliqbelowice1[*,*,1]),lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=maxvalue1,min_value=minvalue1,title=subtitle,$
         rgb_table=33,overplot=mp1,font_size=fontsz)
mc=mapcontinents(/continents,transparency=30)
grid=mp1.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=longap
grid.grid_latitude=latgap
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0
t1=text(pos[0]+0.04,pos[3]-0.06,'Top < 5 km',font_size=fontsz)

pos=[posx1[2],posy1[2],posx2[2],posy2[2]]
mp2=map('Geographic',limit=maplimit,transparency=30,/current,position=pos)
c2=image(reform(Tliqnoice1[*,*,0]),lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=maxvalue2,min_value=minvalue1,title=subtitle,$
         rgb_table=33,overplot=mp2,font_size=fontsz)
mc=mapcontinents(/continents,transparency=30)
grid=mp2.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=longap
grid.grid_latitude=latgap
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0
t1=text(pos[0]+0.04,pos[3]-0.06,'Top > 5 km',font_size=fontsz)

pos=[posx1[3],posy1[3],posx2[3],posy2[3]]
mp3=map('Geographic',limit=maplimit,transparency=30,/current,position=pos)
c3=image(reform(Tliqnoice1[*,*,1]),lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=maxvalue1,min_value=minvalue1,title=subtitle,$
         rgb_table=33,overplot=mp3,font_size=fontsz)
mc=mapcontinents(/continents,transparency=30)
grid=mp3.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=longap
grid.grid_latitude=latgap
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0
t1=text(pos[0]+0.04,pos[3]-0.06,'Top < 5 km',font_size=fontsz)

t2=text(posx1[1]-0.2,posy2[1]-0.0,'Liquid below ice',font_size=fontsz+2)
t2=text(posx1[1]-0.2,posy2[3]-0.0,'Liquid only',font_size=fontsz+2)

barpos=[0.05,0.09,0.51,0.11]
ct=colorbar(target=c2,title='Cloud Occurrence',taper=1,border=1,$
        orientation=0,position=barpos,font_size=fontsz)

barpos=[0.55,0.09,0.95,0.11]
ct=colorbar(target=c3,title='Cloud Occurrence',taper=1,border=1,$
        orientation=0,position=barpos,font_size=fontsz,tickformat='(i5)')

mp.save,'cldsat_liqtop5_alldata_SEA.png'

stop

end
