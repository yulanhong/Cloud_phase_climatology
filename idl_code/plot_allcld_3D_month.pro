; if plot one month data, just comment for loop

pro plot_allcld_3D_month

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
fontsz=14
Nh=101
subtitle=['a) MAM', 'b) JJA','c) SON','d) DJF']

posx1=[0.08,0.53,0.08,0.53]
posx2=[0.43,0.88,0.43,0.88]
posy1=[0.60,0.60,0.15,0.15]
posy2=[0.95,0.95,0.50,0.50]
barpos=[0.2,0.07,0.8,0.09]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
;maplimit=[-10,80,30,150]
subarea=[0,105,20,135]
maplimit=[-10,80,30,150]
;=========saving map here=============
mp=map('Geographic',limit=maplimit,transparency=100)
grid=mp.MAPGRID
grid.hide=1
grid.label_position=0
grid.linestyle='dotted'
mc=mapcontinents(/continents,transparency=30)
mp.save,'map.png',border=0,resolution=300
stop
read_png,'map.png',imdata
imdata=reform(imdata[0,*,*])
obsnum=0L
onecl_num=0L
mulcl1_num=0L
mulcln_num=0L
onenumv=0L
mulnumv=0L
uwind=0.0
vwind=0.0

For mi=0,3 Do Begin

;pos=[posx1[mi],posy1[mi],posx2[mi],posy2[mi]]

if mi eq 0 then begin
allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*03_day.hdf')
allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*04_day.hdf')
allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*05_day.hdf')
endif
if mi eq 1 then begin
allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*06_day.hdf')
allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*07_day.hdf')
allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*08_day.hdf')
endif
if mi eq 2 then begin
allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*09_day.hdf')
allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*10_day.hdf')
allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*11_day.hdf')
endif
if mi eq 3 then begin
allfname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*12_day.hdf')
allfname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*01_day.hdf')
allfname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*02_day.hdf')
endif

allfname=[allfname1,allfname2,allfname3]

Nf=n_elements(allfname)

lon=findgen(72)*5-180+2.5
lat=findgen(90)*2-90+1

for fi=0,Nf-1 do begin
fname=allfname[fi]
IF (strlen(fname) eq 123) Then Begin
print,fname
read_dardar,fname,'obsnum',tpobsnum
obsnum=obsnum+tpobsnum
read_dardar,fname,'DEM_elevation',DEM_map
read_dardar,fname,'onelayercloud_frequency',tponecl_num
onecl_num=onecl_num+tponecl_num
read_dardar,fname,'mullayercloud_onephase_frequency',tpmulcl1_num
mulcl1_num=mulcl1_num+tpmulcl1_num
read_dardar,fname,'mullayercloud_mulphase_frequency',tpmulcln_num
mulcln_num=mulcln_num+tpmulcln_num
read_dardar,fname,'monthly_surfcae_uwind',tpuwind
ind=where(finite(tpuwind) eq 0)
tpuwind[ind]=0.0
uwind=uwind+tpuwind*tpobsnum
read_dardar,fname,'monthly_surfcae_vwind',tpvwind
ind=where(finite(tpvwind) eq 0)
tpvwind[ind]=0.0
vwind=vwind+tpvwind*tpobsnum
read_dardar,fname,'onelaynum_vertical',tponenumv
onenumv=onenumv+tponenumv
read_dardar,fname,'mullaynum_vertical',tpmulnumv
mulnumv=mulnumv+tpmulnumv
EndIf
; plot vertical----------------
endfor
endfor

uwind=uwind/obsnum
vwind=vwind/obsnum

;plot_ver_3p,frev,frev1,frev2,lat,height,levs,xrange,yrange

indlat=where(lat ge maplimit[0] and lat le maplimit[2])
lat1=lat[indlat]

mulcln_num1=mulcln_num[*,indlat,*,*]
mulcl1_num1=mulcl1_num[*,indlat,*,*]
onecl_num1=onecl_num[*,indlat,*,*];+prec_num[*,indlat,*,*]
obsnum1=obsnum[*,indlat,*]
;obsnumv1=obsnumv[*,indlat,*,*]
onenumv1=onenumv[*,indlat,*,*]
mulnumv1=mulnumv[*,indlat,*,*]
Dem_map1=Dem_map[*,indlat]
uwind1=uwind[*,indlat]
vwind1=vwind[*,indlat]

;liqwicenumv1=liqwicenumv[*,indlat,*,*]

indlon=where(lon ge maplimit[1] and lon le maplimit[3])
lon1=lon[indlon]

mulcln_num2=mulcln_num1[indlon,*,*,*]
mulcl1_num2=mulcl1_num1[indlon,*,*,*]
onecl_num2=onecl_num1[indlon,*,*,*]
;obsnumv2=obsnumv1[indlon,*,*,*]
onenumv2=onenumv1[indlon,*,*,*]
mulnumv2=mulnumv1[indlon,*,*,*]
Dem_map2=Dem_map1[indlon,*]
;liqwicenumv2=liqwicenumv1[indlon,*,*,*]
uwind2=uwind1[indlon,*]
vwind2=vwind1[indlon,*]

all_num2=mulcln_num2+mulcl1_num2+onecl_num2

obsnum2=obsnum1[indlon,*,*]

all_cldnum=total(all_num2,3)

one_cldnum=total(onecl_num2,3)

mul_cldnum=total(mulcl1_num2+mulcln_num2,3)

all_cldfre=float(all_cldnum)/obsnum2

one_cldfre=float(one_cldnum)/obsnum2

mul_cldfre=float(mul_cldnum)/obsnum2

obsnumv2=ulonarr(n_elements(lon1),n_elements(lat1),Nh)
For xi=0,n_elements(lon1)-1 Do Begin
     for yi=0,n_elements(lat1)-1 Do Begin
	obsnumv2[xi,yi,*]=obsnum2[xi,yi]
     endfor
endfor

all_cldfrev=float(onenumv2+mulnumv2)/obsnumv2

;n=11

;levs=findgen(n)*0.1

;index=findgen(n)*25

;opacity=intarr(256)+10
dimx=n_elements(lon)
dimy=n_elements(lat)
dimz=n_elements(height)
data=fltarr(dimx,dimy,dimz)
data1=fltarr(dimx,dimy,dimz)

data[12,*,*]=reform(all_cldfrev[12,*,*]); -120
data[35,*,*]=reform(all_cldfrev[35,*,*]);-5
data[59,*,*]=reform(all_cldfrev[59,*,*]) ; centered at 12
;data[11,*,*]=reform(all_cldfrev[11,*,*])
;data[18,*,*]=reform(all_cldfrev[18,*,*])
;data[36,*,*]=reform(all_cldfrev[36,*,*])
;data[54,*,*]=reform(all_cldfrev[54,*,*])

;a1=image(reform(data[12,*,*]),lat,height,rgb_table=33)
;xaxis=axis('X',location=0,target=a1,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname)
;a1.scale,2,8
;a2=image(reform(data[35,*,*]),lat,height,rgb_table=33)
;xaxis=axis('X',location=0,target=a2,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname)
;a2.scale,2,8

;a3=image(reform(data[60,*,*]),lat,height,rgb_table=33)
;xaxis=axis('X',location=0,target=a3,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname)
;a3.scale,2,8

xtickv=[0,18,36,54,71]
xname=['-180','-90','0','90','175']
;xtickv=[0,7,9,12,15]
;xname=['72.5','107.5','117.5','127.5','147.5']
;ytickv=[0,3,6,9]
;yname=['-17.5','-2.5','12.5','27.5']
ytickv=[5,25,45,65,85]
yname=['-80','-40','0','40','80']
ztickv=[0,20,40,60,80]
zname=['0','5','10','15','20']

;save,all_cldfrev,filename='cloud_all_frev'+subtitle+'.sav'

;if mi eq 0 then begin
;mp=map('Geographic',limit=maplimit,transparency=30,dimensions=[800,800],position=pos)
;endif else begin
;mp=map('Geographic',limit=maplimit,transparency=30,position=pos)
;endelse
pos=[0.15,0.2,0.9,0.9]

for xi=0,dimx-1 do begin
	for yi=0,dimy-1 do begin
		for zi=0,dimz-1 do begin
			data1[xi,yi,zi]=data[xi,yi,100-zi]
		endfor
	endfor
endfor

data1=data1[*,*,0:80]
vol=volume(data1,axis_style=0,rgb_table0=33,opacity_table0=opacity,$
	max_value=1.0,min_value=0.1,volume_location=[lon1[0],lat1[0],0],$
	volume_dimensions=[(max(lon1)-min(lon1))+1,(max(lat1)-min(lat1))+1,81],$
	dimensions=[650,600],position=pos,xrange=[min(lon1),max(lon1)],$
	yrange=[min(lat1),max(lat1)],hints=3)

xaxis=axis('X',location=[min(lat1),0],target=vol,tickdir=1,textpos=0,title='Longitude (degree)')
yaxis=axis('Y',location=[min(lon1),0],target=vol,tickdir=1,textpos=0,title='Latitude (degree)')
zaxis=axis('Z',location=[max(lon1),min(lat1)],target=vol,tickdir=0,textpos=1,$
	tickvalues=ztickv,tickname=zname,title='Altitude (km)')

c=image(all_cldfre,lon1,lat1,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=1.0,min_value=0.1,$
         rgb_table=33,overplot=vol)

;v=vector(uwind2,vwind2,lon1,lat1,overplot=vol,color='grey',head_angle=30)

;mp=image(imdata,image_dimensions=[(max(lon1)-min(lon1)),(max(lat1)-min(lat1))],$
;	image_location=[lon1[0],lat1[0]],min_value=0,max_value=0,overplot=c)
nsize=size(imdata)
NconX=nsize[1]
Ncony=nsize[2]
Conx=findgen(Nconx)*double(max(lon1)-min(lon1))/double(Nconx)+min(lon1)
Cony=findgen(Ncony)*double(max(lat1)-min(lat1))/double(Ncony)+min(lat1)

mp=contour(imdata,conx,cony,overplot=c,c_label_show=0,color='black')
;mp=map('Geographic',limit=maplimit,transparency=100,overplot=c)
;grid=mp.MAPGRID
;grid.hide=1
;grid.label_position=0
;grid.linestyle='dotted'
;mc=mapcontinents(/continents,transparency=30)

;if mi eq 3 then $
;l=legend(sample_magnitude=10,units='$m s^{-1}$',target=v,position=[pos[2],pos[3]+0.03])

;t=text(pos[0]+0.1,pos[3]+0.02,subtitle[mi],/normal,font_size=fontsz)

;vol.rotate,-35,/zaxis
;vol.rotate,5,/xaxis
;vol.rotate,0,/yaxis
vol.scale,0.7,1,0.65
;
;surf=surface(DEM_map2,overplot=vol)

;c=contour(all_cldfre,c_value=levs,n_levels=n,$
;         rgb_table=33,rgb_indices=index,/fill,title='Cloud Occurrence Frequency',$
;        position=pos2,/current,depth_cue=[0,2],overplot=vol)
;vol.save,'cldsat_meteorology_'+subtitle+'.png'
barpos=[0.2,0.885,0.8,0.91]
ct=colorbar(target=c,title='Cloud Occurrence Frequency',taper=1,border=1,$
        orientation=0,position=barpos,font_size=fontsz-1,tickinterval=0.1)

vol.save,'cldsat_meteorology_fourseason1.png'

stop

end
