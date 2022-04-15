
pro plot_highlow_meteo

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
fontsz=11
Nh=101
;subtitle=['Jul.','Aug.','Sep.','Oct.']
subtitle=['MAM', 'JJA','SON','DJF']
subtitle1=['a1)', 'a2)','a3)','a4)']
subtitle2=['b1)', 'b2)','b3)','b4)']
subtitle3=['c1)', 'c2)','c3)','c4)']
subtitle4=['d1)', 'd2)','d3)','d4)']

posx1=[0.05,0.27,0.49,0.71]
posx2=[0.23,0.45,0.67,0.89]
posy1=[0.76,0.52,0.28,0.04]
posy2=[0.96,0.72,0.48,0.24]

barpos1=[0.96,0.76,0.98,0.96]
barpos2=[0.96,0.52,0.98,0.72]
;barpos3=[0.96,0.28,0.98,0.48]
barpos3=[0.96,0.05,0.98,0.24]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
maplimit=[-10,80,30,150]
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
uwind850=0.0
vwind850=0.0
sp850=0.0
T850=0.0
stat_low=0.0

uwind180=0.0
vwind180=0.0
sp180=0.0
T180=0.0
stat_high=0.0

lon=(findgen(72))*5-180
lat=(findgen(90))*2-90

uwind1=0.0
vwind1=0.0
uwind2=0.0
vwind2=0.0
surf_T=0.0
high_T=0.0
surf_stat=0.0
high_stat=0.0
surf_rh=0.0
high_rh=0.0

for fi=0,Nf-1 do begin
fname=allfname[fi]
IF (strlen(fname) eq 123) Then Begin
print,fname
;read_dardar,fname,'latitude',lat
;read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',tpobsnum
print,total(tpobsnum)
obsnum=obsnum+tpobsnum

read_dardar,fname,'monthly_surfcae_uwind',tpuwind
ind=where(finite(tpuwind) eq 0)
tpuwind[ind]=0.0
uwind1=uwind1+tpuwind*tpobsnum

read_dardar,fname,'monthly_surfcae_vwind',tpvwind
ind=where(finite(tpvwind) eq 0)
tpvwind[ind]=0.0
vwind1=vwind1+tpvwind*tpobsnum

read_dardar,fname,'monthly_180_uwind',tpuwind
ind=where(finite(tpuwind) eq 0)
tpuwind[ind]=0.0
uwind2=uwind2+tpuwind*tpobsnum

read_dardar,fname,'monthly_180_vwind',tpvwind
ind=where(finite(tpvwind) eq 0)
tpvwind[ind]=0.0
vwind2=vwind2+tpvwind*tpobsnum

read_dardar,fname,'monthly_surface_temperature',tptemp
ind=where(finite(tptemp) eq 0)
tptemp[ind]=0.0
surf_T=surf_T+tptemp*tpobsnum

read_dardar,fname,'monthly_180_temp',tptemp
ind=where(finite(tptemp) eq 0)
tptemp[ind]=0.0
high_T=high_T+tptemp*tpobsnum

read_dardar,fname,'monthly_low_static_stability',lowstat
ind=where(finite(lowstat) eq 0)
lowstat[ind]=0.0
surf_stat=surf_stat+lowstat*tpobsnum

read_dardar,fname,'monthly_180_stat_lapserate',lowstat
ind=where(finite(lowstat) eq 0)
lowstat[ind]=0.0
high_stat=high_stat+lowstat*tpobsnum

read_dardar,fname,'monthly_850hpa_sp',tprh
ind=where(finite(tprh) eq 0)
tprh[ind]=0.0
surf_rh=surf_rh+tprh*tpobsnum

read_dardar,fname,'monthly_180_sp',tprh
ind=where(finite(tprh) eq 0)
tprh[ind]=0.0
high_rh=high_rh+tprh*tpobsnum
EndIf
; plot vertical----------------
endfor

uwind850=uwind1/obsnum
vwind850=vwind1/obsnum
T850=surf_T/obsnum
stat_low=surf_stat/obsnum
sp850=surf_rh/obsnum

uwind180=uwind2/obsnum
vwind180=vwind2/obsnum
T180=high_T/obsnum
stat_high=high_stat/obsnum
sp180=high_rh/obsnum
;levs=findgen(n)*0.1

;index=findgen(n)*25

;opacity=intarr(256)+10
pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
pos2=[posx1[mi],posy1[1],posx2[mi],posy2[1]]
pos3=[posx1[mi],posy1[2],posx2[mi],posy2[2]]
pos4=[posx1[mi],posy1[3],posx2[mi],posy2[3]]

tlevel=[212,212.5,213,214,215,216,217,218,219]
tnl=n_elements(tlevel)

;slevel=[3,4,5,6,7,8,9,10]
slevel=[4,5,6,8,9,10]
tns=n_elements(slevel)

plevel=[0.01,0.015,0.02,0.025,0.03,0.035,0.04,0.05,0.06]
tnp=n_elements(plevel)
ind1=where(lon ge maplimit[1] and lon le maplimit[3],count)
Nlon=count
ind2=where(lat ge maplimit[0] and lat le maplimit[2],count)
Nlat=count
lon1=lon[ind1]
lat1=lat[ind2]
;index=indgen(15)*2+272
;loadct,56,rgb_table=rgb
;rgb=rgb[25+25*indgen(10),*]
minvalue=265
maxvalue=300
spmax=16
spmin=0.5
statmax=6.0
statmin=-3.0

if mi eq 0 then begin
c=image(T850,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
     rgb_table=33,font_size=fontsz,dim=[950,600],position=pos1)
;c=contour(T850,lon,lat,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],n_levels=n_elements(index),c_value=index,$
;	rgb_table=rgb,/fill)
endif else begin
c=image(T850,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
     rgb_table=33,font_size=fontsz,/current,position=pos1)
endelse
print,'max min T180',max(T180[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]]),min(T180[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]])
p=contour(T180[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]],lon1,lat1,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	c_label_show=1,c_label_interval=0.6,$
	n_levels=tnl,c_value=tlevel,overplot=c,color='black')
p.c_label_interval=0.6
if mi eq 3 then p.c_label_interval=0.8

mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='none'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=10,color='grey')
mc['Longitudes'].label_angle=0

c1=image(stat_low,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=statmax,min_value=statmin,$
     rgb_table=30,font_size=fontsz,/current,position=pos4)
p1=contour(stat_high[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]],lon1,lat1,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	c_label_show=1,n_levels=tns,c_value=slevel,overplot=c1,color='black')
p1.c_label_interval=0.6
;print,'max min stat_high',max(stat_high[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]]),min(stat_high[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]])
mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='none'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=10,color='grey')
mc['Longitudes'].label_angle=0

c2=image(sp850,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=spmax,min_value=spmin,$
     rgb_table=72,font_size=fontsz,/current,position=pos2)

print,'max min sp_180',max(sp180[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]]),min(sp180[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]])
p2=contour(sp180[ind1[0]:ind1[Nlon-1],ind2[0]:ind2[Nlat-1]],lon1,lat1,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	c_label_show=1,n_levels=tnp,c_value=plevel,overplot=c2,color='black')
p2.c_label_interval=0.5

mp=map('Geographic',limit=maplimit,transparency=30,overplot=c2)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='none'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=10,color='grey')
mc['Longitudes'].label_angle=0

v=vector(uwind850,vwind850,lon,lat,color='gray',transparency=0,head_angle=15,$
	head_size=0.3,arrow_thick=0.5,head_indent=0.25,position=pos3,/current,length_scale=0.7)
v1=vector(uwind180,vwind180,lon,lat,color='orange red',transparency=50,head_angle=15,$
	head_size=0.3,arrow_thick=0.5,head_indent=0.25,overplot=v,length_scale=0.7)
mp=map('Geographic',limit=maplimit,transparency=30,overplot=v)
grid=mp.MAPGRID
grid.label_position=0
grid.linestyle='none'
grid.grid_longitude=20
grid.font_size=fontsz-2.5
mc=mapcontinents(/continents,transparency=40,color='black')
mc['Longitudes'].label_angle=0
if mi eq 3 then $
l=legend(sample_magnitude=5,units='$m s^{-1}$',target=v,position=[0.98,0.35])

t=text(pos1[0]+0.015,pos1[3]-0.02,subtitle1[mi],/normal,font_size=fontsz)
t=text(pos2[0]+0.015,pos2[3]-0.02,subtitle2[mi],/normal,font_size=fontsz)
t=text(pos3[0]+0.015,pos3[3]-0.0,subtitle3[mi],/normal,font_size=fontsz)
t=text(pos4[0]+0.015,pos4[3]-0.02,subtitle4[mi],/normal,font_size=fontsz)

endfor

ct=colorbar(target=c,title='Temperature (K)',taper=1,border=1,$
        orientation=1,position=barpos1,font_size=fontsz-2)

ct=colorbar(target=c1,title='Stability (K km$^{-1}$)',taper=1,border=1,$
        orientation=1,position=barpos3,font_size=fontsz-2)

ct=colorbar(target=c2,title='Specific Humidity (g $kg^{-1}$)',taper=1,border=1,$
        orientation=1,position=barpos2,font_size=fontsz-2)

c.save,'cldsat_highlow_2d_fourseason_day_newdomain_lapseratetropopause.png'

stop

end
