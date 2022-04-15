
pro plot_surf_meteo

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
fontsz=11
Nh=101
;subtitle=['Jul.','Aug.','Sep.','Oct.']
subtitle=['MAM', 'JJA','SON','DJF']
subtitle1=['a1)', 'a2)','a3)','a4)']
subtitle2=['b1)', 'b2)','b3)','b4)']
subtitle3=['c1)', 'c2)','c3)','c4)']

posx1=[0.05,0.27,0.49,0.71]
posx2=[0.23,0.45,0.67,0.89]
posy1=[0.70,0.39,0.08]
posy2=[0.96,0.65,0.34]

barpos1=[0.96,0.70,0.98,0.96]
barpos2=[0.96,0.39,0.98,0.65]
barpos3=[0.96,0.08,0.98,0.34]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
maplimit=[-20,80,30,150]
;maplimit=[-90,-180,90,180]

datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn"

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

obsnum=0L
uwind=0.0
vwind=0.0
surf_rh=0.0
surf_T=0.0
surf_stat=0.0

 lon=(findgen(72)+1)*5-180
 lat=(findgen(90)+1)*2-90


for fi=0,Nf-1 do begin
fname=allfname[fi]
IF (strlen(fname) eq 112) Then Begin
print,fname
;read_dardar,fname,'latitude',lat
;read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',tpobsnum
print,total(tpobsnum)
obsnum=obsnum+tpobsnum
read_dardar,fname,'monthly_surfcae_uwind',tpuwind
ind=where(finite(tpuwind) eq 0)
tpuwind[ind]=0.0
uwind=uwind+tpuwind*tpobsnum
read_dardar,fname,'monthly_surfcae_vwind',tpvwind
ind=where(finite(tpvwind) eq 0)
tpvwind[ind]=0.0
vwind=vwind+tpvwind*tpobsnum

read_dardar,fname,'monthly_surfcae_temperature',tptemp
ind=where(finite(tptemp) eq 0)
tptemp[ind]=0.0
surf_T=surf_T+tptemp*tpobsnum

read_dardar,fname,'monthly_low_static_stability',lowstat
ind=where(finite(lowstat) eq 0)
lowstat[ind]=0.0
surf_stat=surf_stat+lowstat*tpobsnum

read_dardar,fname,'monthly_850hpa_sp',tprh
ind=where(finite(tprh) eq 0)
tprh[ind]=0.0
surf_rh=surf_rh+tprh*tpobsnum
EndIf
; plot vertical----------------
endfor

uwind=uwind/obsnum
vwind=vwind/obsnum
surf_T=surf_T/obsnum
surf_stat=surf_stat/obsnum
surf_rh=surf_rh/obsnum

;levs=findgen(n)*0.1

;index=findgen(n)*25

;opacity=intarr(256)+10
pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
pos2=[posx1[mi],posy1[1],posx2[mi],posy2[1]]
pos3=[posx1[mi],posy1[2],posx2[mi],posy2[2]]

if mi eq 0 then begin
c=image(surf_T,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=305,min_value=290,title=subtitle[mi],$
     rgb_table=56,font_size=fontsz,dim=[950,500],position=pos1)
endif else begin
c=image(surf_T,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=305,min_value=290,title=subtitle[mi],$
     rgb_table=56,font_size=fontsz,/current,position=pos1)
endelse

mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0

c1=image(surf_stat,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=5,min_value=2,$
     rgb_table=64,font_size=fontsz,/current,position=pos2)

mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0

c2=image(surf_rh,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=16,min_value=0,$
     rgb_table=33,font_size=fontsz,/current,position=pos3)

mp=map('Geographic',limit=maplimit,transparency=30,overplot=c2)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='dotted'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=30)
mc['Longitudes'].label_angle=0

t=text(pos1[0]+0.015,pos1[3],subtitle1[mi],/normal,font_size=fontsz)
t=text(pos2[0]+0.015,pos2[3],subtitle2[mi],/normal,font_size=fontsz)
t=text(pos3[0]+0.015,pos3[3],subtitle3[mi],/normal,font_size=fontsz)

endfor

ct=colorbar(target=c,title='Surface Temperature (K)',taper=1,border=1,$
        orientation=1,position=barpos1,font_size=fontsz-2)

ct=colorbar(target=c1,title='Stability (K km$^{-1}$)',taper=1,border=1,$
        orientation=1,position=barpos2,font_size=fontsz-2)

ct=colorbar(target=c2,title='Specific Humidity (g $km^{-1}$)',taper=1,border=1,$
        orientation=1,position=barpos3,font_size=fontsz-2)

c.save,'cldsat_Tsp850sta_2d_fourseason_day.png'

stop

end
