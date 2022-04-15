; if plot one month data, just comment for loop

pro plot_allcld_2D_month_frewind

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
fontsz=12
Nh=101
subtitle=['MAM', 'JJA','SON','DJF']
subtitle1=['a1)', 'a2)','a3)','a4)']
subtitle2=['b1)', 'b2)','b3)','b4)']

posx1=[0.05,0.29,0.53,0.77]
posx2=[0.25,0.49,0.73,0.97]
posy1=[0.70,0.27]
posy2=[0.96,0.60]

barpos1=[0.30,0.66,0.70,0.68]
barpos2=[0.30,0.24,0.70,0.26]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
maplimit=[-10,80,30,150]
;maplimit=[-90,-180,90,180]
elnino=['200701','200702','200703','200704','200705','200706',$
	'200906','200907','200908','200909','200910','200911','200912',$
	'201001','201002','201003','201004','201005']
lanina=['200707','200708','200709','200710','200711','200712',$
	'200801','200802','200803','200804','200805','200806','200807','200808','200809','200810','200811','200812',$
	'200901','200902','200903','200904','200905',$
	'201006','201007','201008','201009','201010','201011','201012']

datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn"

Tobsnum=0L
Tonecl_num=0L
Tmulcl1_num=0L
Tmulcln_num=0L

For mi=0,3 Do Begin
 if mi le 1 then pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
 if mi ge 2 then pos1=[posx1[mi],posy1[1],posx2[mi],posy2[1]]

if mi eq 0 then begin
allfname1=file_search(datadir,'*03_R05_day.hdf')
allfname2=file_search(datadir,'*04_R05_day.hdf')
allfname3=file_search(datadir,'*05_R05_day.hdf')
endif
if mi eq 1 then begin
allfname1=file_search(datadir,'*06_R05_day.hdf')
allfname2=file_search(datadir,'*07_R05_day.hdf')
allfname3=file_search(datadir,'*08_R05_day.hdf')
endif
if mi eq 2 then begin
allfname1=file_search(datadir,'*09_R05_day.hdf')
allfname2=file_search(datadir,'*10_R05_day.hdf')
allfname3=file_search(datadir,'*11_R05_day.hdf')
endif
if mi eq 3 then begin
allfname1=file_search(datadir,'*12_R05_day.hdf')
allfname2=file_search(datadir,'*01_R05_day.hdf')
allfname3=file_search(datadir,'*02_R05_day.hdf')
endif

allfname=[allfname1,allfname2,allfname3]

Nf=n_elements(allfname)

obsnum=0L
onecl_num=0L
mulcl1_num=0L
mulcln_num=0L
onenumv=0L
mulnumv=0L

uwind=0.0
vwind=0.0
lon=findgen(72)*5-180
lat=findgen(90)*2-90

for fi=0,Nf-1 do begin
fname=allfname[fi]
year=strmid(fname,9,6,/rev)
yrind=where(year eq lanina)

IF (strlen(fname) eq 128 ) Then Begin
;read_dardar,fname,'latitude',lat
;read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',tpobsnum
;print,total(tpobsnum),fname
obsnum=obsnum+tpobsnum

;read_dardar,fname,'DEM_elevation',DEM_map
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
;Dem_map1=Dem_map[*,indlat]
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
;Dem_map2=Dem_map1[indlon,*]
;liqwicenumv2=liqwicenumv1[indlon,*,*,*]
uwind2=uwind1[indlon,*]
vwind2=vwind1[indlon,*]
obsnum2=obsnum1[indlon,*,*]

Tobsnum=Tobsnum+obsnum2
Tonecl_num=Tonecl_num+onecl_num2
Tmulcl1_num=Tmulcl1_num+mulcl1_num2
Tmulcln_num=Tmulcln_num+mulcln_num2

;==== to print targeted area frequency====
print,subtitle[mi],total(mulcln_num2+mulcl1_num2+onecl_num2)/float(total(obsnum2))
;print,total(obsnum2)
all_num2=mulcln_num+mulcl1_num+onecl_num


all_cldnum=total(all_num2,3)

one_cldnum=total(onecl_num2,3)

mul_cldnum=total(mulcl1_num2+mulcln_num2,3)

all_cldfre=float(all_cldnum)/obsnum

one_cldfre=float(one_cldnum)/obsnum2

mul_cldfre=float(mul_cldnum)/obsnum2

obsnumv2=ulonarr(n_elements(lon1),n_elements(lat1),Nh)
For xi=0,n_elements(lon1)-1 Do Begin
     for yi=0,n_elements(lat1)-1 Do Begin
	obsnumv2[xi,yi,*]=obsnum2[xi,yi]
     endfor
endfor

all_cldfrev=float(onenumv2+mulnumv2)/obsnumv2
all_cldzonal_frev=float(total(onenumv2,1)+total(mulnumv2,1))/total(obsnumv2,1)
;n=11

;levs=findgen(n)*0.1

;index=findgen(n)*25

;opacity=intarr(256)+10
dimx=n_elements(lon1)
dimy=n_elements(lat1)
dimz=n_elements(height)


;xname=['-177.5','-87.5','2.5','92.5','177.5']
xtickv=[0,7,9,12,15]
xname=['72.5','107.5','117.5','127.5','147.5']

pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
pos2=[posx1[mi]+0.01,posy1[1],posx2[mi]+0.01,posy2[1]]

if mi eq 0 then begin
c=image(all_cldfre,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=1.0,min_value=0.,title=subtitle[mi],$
     rgb_table=33,font_size=fontsz,dim=[900,600],position=pos1)
endif else begin
c=image(all_cldfre,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=1.0,min_value=0.,title=subtitle[mi],$
     rgb_table=33,font_size=fontsz,/current,position=pos1)
endelse
; v=vector(uR05
;if mi eq 3 then $
;l=legend(sample_magnitude=10,units='$m s^{-1}$',target=v,position=[pos1[2]-0.03,pos1[1]-0.02])

 mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.grid_longitude=20
 grid.font_size=fontsz-2.5
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0

 t=text(pos1[0]+0.015,pos1[3]-0.015,subtitle1[mi],/normal,font_size=fontsz)

 tpx=fltarr(n_elements(lat1))
 tpx(*)=lon1[7]
; p=plot(tpx,lat1,linestyle='dash',overplot=c)

;ytickv=[0,3,6,9]
;yname=['-17.5','-2.5','12.5','27.5']
ytickv=[-10,0,10,20]
yname=['-10','0','10','20']
ztickv=[0,5,10,15,20]
zname=['0','5','10','15','20']
;all_cldfrev[7,*,*]
p=image(reform(all_cldzonal_frev),lat1,height,xrange=[min(lat1),max(lat1)],axis_style=0,rgb_table=33,$
	max_value=0.6,min_value=0,font_size=fontsz,position=pos2,/current)
xaxis=axis('X',location=0,target=p,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Latitude (degree)')
if mi eq 0 then ytitle='Altitude (km)' else ytitle=''
yaxis=axis('Y',location=min(lat1),target=p,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname,title=ytitle)
;p.scale,1,1.2
;p.scale,1,1.0
t=text(pos2[0]+0.015,pos2[3]-0.06,subtitle2[mi],/normal,font_size=fontsz)

endfor ; endfor seasons

ct=colorbar(target=c,title='Cloud Occurrence Frequency',taper=1,border=1,$
        orientation=0,position=barpos1,font_size=fontsz)

ct=colorbar(target=p,title='Cloud Occurrence Frequency',taper=1,border=1,$
        orientation=0,position=barpos2,font_size=fontsz)
;c.save,'cldsat_fre_2d_fourseason_day_newdomain_zonalr05.png'

print,'total frequency',total(Tonecl_num+Tmulcl1_num+Tmulcln_num)/total(Tobsnum)
for i=0,2 do print,'one layer frequency',total(Tonecl_num[*,*,i])/total(Tobsnum)
for i=0,2 do print,'mul layer one phase',total(Tmulcl1_num[*,*,i])/total(Tobsnum)
for i=0,2 do pring,'mul layer mul phase',total(Tmulcln_num[*,*,i])/total(Tobsnum)
stop

end
