; if plot one month data, just comment for loop

pro plot_cldphase_2D_month

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
fontsz=11
Nh=101
season=['MAM', 'JJA','SON','DJF']
subtitle=['a1)','b1)','c1)','d1)','e1)',$
	  'a2)','b2)','c2)','d2)','e2)',$
	  'a3)','b3)','c3)','d3)','e3)',$
	  'a4)','b4)','c4)','d4)','e4)']
subtitle1=['Ice only','Liquid only','Mixed only','Ice above liquid','Ice above mixed']
posy1=[0.89,0.79,0.69,0.59]
posy2=[0.98,0.88,0.78,0.68]
posy3=[0.41,0.31,0.21,0.11]
posy4=[0.50,0.40,0.30,0.20]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
maplimit=[-10,80,30,150]
;maplimit=[0,110,20,125]
;subarea=[0,105,20,135]
subarea=maplimit

elnino=['200701','200702','200703','200704','200705','200706',$
     '200906','200907','200908','200909','200910','200911','200912',$
     '201001','201002','201003','201004','201005']
lanina=['200707','200708','200709','200710','200711','200712',$
     '200801','200802','200803','200804','200805','200806','200807','200808','200809','200810','200811','200812',$
     '200901','200902','200903','200904','200905',$
     '201006','201007','201008','201009','201010','201011','201012']

;=========saving map here=============
read_png,'map.png',imdata
imdata=reform(imdata[0,*,*])
; for day vs . night
;datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn"
; for all
datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn"

For mi=0,3 Do Begin

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
ice_num=0L
mix_num=0L
liq_num=0L
icemix_num=0L
iceliq_num=0L

ice_numh=0L
mix_numh=0L
liq_numh=0L
icemix_numh=0L
iceliq_numh=0L

Ticebelow=0L

Tone_numh=0L
Tmul1_numh=0L
Tmuln_numh=0L
lon=findgen(72)*5-180
lat=findgen(90)*2-90

Ticetop=0L

for fi=0,Nf-1 do begin
fname=allfname[fi]

year=strmid(fname,9,6,/rev)
yrind=where(year eq elnino)

IF (strlen(fname) eq 128) then begin ;and yrind[0] ne -1) Then Begin

;read_dardar,fname,'latitude',lat
;read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',tpobsnum
print,fname,total(tpobsnum)
obsnum=obsnum+tpobsnum

read_dardar,fname,'onelayercloud_frequency',one_numh
read_dardar,fname,'mullayercloud_onephase_frequency',mul1_numh
read_dardar,fname,'mullayercloud_mulphase_frequency',muln_numh
ice_numh=ice_numh+reform(one_numh[*,*,0])+reform(mul1_numh[*,*,0])
mix_numh=mix_numh+reform(one_numh[*,*,1])+reform(mul1_numh[*,*,1])
liq_numh=liq_numh+reform(one_numh[*,*,2])+reform(mul1_numh[*,*,2])
icemix_numh=icemix_numh+reform(muln_numh[*,*,1])
iceliq_numh=iceliq_numh+reform(muln_numh[*,*,0])

Tone_numh=Tone_numh+one_numh
Tmul1_numh=Tmul1_numh+mul1_numh
Tmuln_numh=Tmuln_numh+muln_numh

read_dardar,fname,'iceonly_numv_temperature',iceonly_T
read_dardar,fname,'mixonly_numv_temperature',mixonly_T
read_dardar,fname,'liqonly_numv_temperature',liqonly_T
read_dardar,fname,'iceup_mixlow_numv_temperature',icemix_T
read_dardar,fname,'iceup_liqlow_numv_temperature',iceliq_T
ice_num=ice_num+total(iceonly_T,4)
mix_num=mix_num+total(mixonly_T,4)
liq_num=liq_num+total(liqonly_T,4)
icemix_num=icemix_num+total(icemix_T,4)
iceliq_num=iceliq_num+total(iceliq_T,4)

read_dardar,fname,'iceonly_numv_stability',iceonly_s
read_dardar,fname,'mixonly_numv_stability',mixonly_s
read_dardar,fname,'liqonly_numv_stability',liqonly_s
read_dardar,fname,'iceup_mixlow_numv_stability',icemix_s
read_dardar,fname,'iceup_liqlow_numv_stability',iceliq_s

read_dardar,fname,'ice_top_pdf',icetop
Ticetop=Ticetop+icetop

read_dardar,fname,'ice_below_others',icebelow
Ticebelow=Ticebelow+icebelow

EndIf

endfor ;endfile

;plot_ver_3p,frev,frev1,frev2,lat,height,levs,xrange,yrange

indlat=where(lat ge maplimit[0] and lat le maplimit[2])
lat1=lat[indlat]

obsnum1=obsnum[*,indlat,*]
ice_num1=ice_num[*,indlat,*]
mix_num1=mix_num[*,indlat,*]
liq_num1=liq_num[*,indlat,*]
icemix_num1=icemix_num[*,indlat,*]
iceliq_num1=iceliq_num[*,indlat,*]

ice_numh1=ice_numh[*,indlat]
mix_numh1=mix_numh[*,indlat]
liq_numh1=liq_numh[*,indlat]
icemix_numh1=icemix_numh[*,indlat]
iceliq_numh1=iceliq_numh[*,indlat]

Tone_numh1=Tone_numh[*,indlat,*]
Tmul1_numh1=Tmul1_numh[*,indlat,*]
Tmuln_numh1=Tmuln_numh[*,indlat,*]

indlon=where(lon ge maplimit[1] and lon le maplimit[3])
lon1=lon[indlon]

obsnum2=obsnum1[indlon,*,*]
ice_num2=ice_num1[indlon,*,*]
mix_num2=mix_num1[indlon,*,*]
liq_num2=liq_num1[indlon,*,*]
icemix_num2=icemix_num1[indlon,*,*]
iceliq_num2=iceliq_num1[indlon,*,*]

ice_numh2=ice_numh1[indlon,*]
mix_numh2=mix_numh1[indlon,*]
liq_numh2=liq_numh1[indlon,*]
icemix_numh2=icemix_numh1[indlon,*]
iceliq_numh2=iceliq_numh1[indlon,*]

Tone_numh2=Tone_numh1[indlon,*,*]
Tmul1_numh2=Tmul1_numh1[indlon,*,*]
Tmuln_numh2=Tmuln_numh1[indlon,*,*]
Nlon1=n_elements(lon1)
Nlat1=n_elements(lat1)
print,'ice below others',total(Ticebelow[indlon[0]:indlon[Nlon1-1],indlat[0]:indlat[Nlat1-1]])/total(obsnum[indlon[0]:indlon[Nlon1-1],indlat[0]:indlat[Nlat1-1]])
print,'liquid+mixed',total(Tmuln_numh2[*,*,2])/total(obsnum2)

obsnumv2=ulonarr(n_elements(lon1),n_elements(lat1),Nh)
For xi=0,n_elements(lon1)-1 Do Begin
     for yi=0,n_elements(lat1)-1 Do Begin
	obsnumv2[xi,yi,*]=obsnum2[xi,yi]
     endfor
endfor

;ice_frev=reverse(ice_num2,3)/float(obsnumv2)
;mix_frev=reverse(mix_num2,3)/float(obsnumv2)
;liq_frev=reverse(liq_num2,3)/float(obsnumv2)
;icemix_frev=reverse(icemix_num2,3)/float(obsnumv2)
;iceliq_frev=reverse(iceliq_num2,3)/float(obsnumv2)

ice_frev=total(ice_num2,1)/float(total(obsnumv2,1))
mix_frev=total(mix_num2,1)/float(total(obsnumv2,1))
liq_frev=total(liq_num2,1)/float(total(obsnumv2,1))
icemix_frev=total(icemix_num2,1)/float(total(obsnumv2,1))
iceliq_frev=total(iceliq_num2,1)/float(total(obsnumv2,1))

dimx=n_elements(lon1)
dimy=n_elements(lat1)
dimz=n_elements(height)


posx1=[0.05,0.24,0.43,0.62,0.82]
posx2=[0.22,0.41,0.61,0.80,0.99]
posx3=[0.08,0.265,0.45,0.635,0.82]
posx4=[0.25,0.435,0.62,0.805,0.99]

lonind1=where(lon1 ge subarea[1] and lon1 le subarea[3],count)
Nlon=count
latind1=where(lat1 ge subarea[0] and lat1 le subarea[2],count)
Nlat=count

for typei=0,4 do begin ; loop for cloud ploting cloud type

pos1=[posx1[typei],posy1[mi],posx2[typei],posy2[mi]]
pos2=[posx3[typei],posy3[mi],posx4[typei],posy4[mi]]
barpos1=[0.2,pos1[1]-0.04,0.8,pos1[1]-0.03]
barpos2=[0.2,pos2[1]-0.06,0.8,pos2[1]-0.05]

data=fltarr(dimy,dimz)
if typei eq 0 then begin
   data=ice_frev;reform(ice_frev[7,*,*])
;   data[11,*,*]=reform(ice_frev[11,*,*])
   datah=float(ice_numh2)/obsnum2
;   freh=total(ice_numh2)/float(total(obsnum2))

   minvalue=0.0;floor(min(datah)*10)/10.0
   maxvalue=0.5;ceil(max(datah)*10)/10.0
;   tkvalue=[0,0.25,0.45,0.65]
   tigap=0.2

   freh=total(ice_numh2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])/total(obsnum2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])
	print,freh
   freh=strcompress(string(round(freh*100)/100.0))
   freh=strmid(freh,0,5)
	  
endif
if typei eq 3 then begin
   data=iceliq_frev;reform(iceliq_frev[7,*,*])
;   data[11,*,*]=reform(iceliq_frev[11,*,*])
   datah=float(iceliq_numh2)/obsnum2
  
   freh=total(iceliq_numh2)/float(total(obsnum2))
 
   minvalue=0.0;floor(min(datah)*10)/10.0
   maxvalue=0.50;ceil(max(datah)*10)/10.0
   tigap=0.2
	
   freh=total(iceliq_numh2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])/total(obsnum2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])
	print,freh
   freh=strcompress(string(round(freh*100)/100.0))
   freh=strmid(freh,0,5)
;   print,min(datah),max(datah)
;   tkvalue=[0,0.1,0.3,0.5]
endif
if typei eq 4 then begin
   data=icemix_frev;reform(icemix_frev[7,*,*])
;   data[11,*,*]=reform(icemix_frev[11,*,*])
   datah=float(icemix_numh2)/obsnum2

;   freh=total(icemix_numh2)/float(total(obsnum2))

   minvalue=0.0;floor(min(datah)*10)/10.0
   maxvalue=0.5;ceil(max(datah)*10)/10.0
   tigap=0.2
	
   freh=total(icemix_numh2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])/total(obsnum2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])
	print,freh
   freh=strcompress(string(round(freh*100)/100.0))
   freh=strmid(freh,0,5)
;   tkvalue=[0,0.1,0.2,0.3]
;   print,min(datah),max(datah)
endif
if typei eq 1 then begin
   data=liq_frev;reform(liq_frev[7,*,*])
;   data[11,*,*]=reform(liq_frev[11,*,*])
   datah=float(liq_numh2)/obsnum2

;   freh=total(liq_numh2)/float(total(obsnum2))

   minvalue=0.0;floor(min(datah)*10)/10.0
   maxvalue=0.5;ceil(max(datah)*10)/10.0
   tigap=0.2
;   tkvalue=[0,0.25,0.45,0.65]
	
   freh=total(liq_numh2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])/total(obsnum2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])
	print,freh
   freh=strcompress(string(round(freh*100)/100.0))
   freh=strmid(freh,0,5)
;   print,min(datah),max(datah)
endif
if typei eq 2 then begin
   data=mix_frev;reform(mix_frev[7,*,*])
;   data[11,*,*]=reform(mix_frev[11,*,*])
   datah=float(mix_numh2)/obsnum2

   freh=total(mix_numh2)/float(total(obsnum2))

   minvalue=0.0;floor(min(datah)*10)/10.0
   maxvalue=0.5;ceil(max(datah)*10)/10.0
;   tkvalue=[0,0.05,0.15,0.25]
   tigap=0.2
	
   freh=total(mix_numh2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])/total(obsnum2[lonind1[0]:lonind1[Nlon-1],latind1[0]:latind1[Nlat-1]])
	print,freh
   freh=strcompress(string(round(freh*100)/100.0))
   freh=strmid(freh,0,5)
;   print,min(datah),max(datah)
endif

ztickv=[0,20,40,60,80]
zname=['0','5','10','15','20']

if mi eq 0 and typei eq 0 then begin
c=image(datah,lon1,lat1,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=maxvalue,min_value=minvalue,position=pos1,dim=[800,900],$
         rgb_table=33)
endif else begin
c=image(datah,lon1,lat1,xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=maxvalue,min_value=minvalue,position=pos1,/current,$
         rgb_table=33)
endelse

 mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.grid_longitude=20
 grid.font_size=fontsz-2.5
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0

 c.scale,0.86,0.8

 ytickv=[-10,0,10,20]
 yname=['-10','0','10','20']
 ztickv=[0,5,10,15,20]
 zname=['0','5','10','15','20']
 ;all_cldfrev[7,*,*]
 p=image(data,lat1,height,xrange=[min(lat1),max(lat1)],axis_style=0,rgb_table=33,$
     max_value=0.2,min_value=0,position=pos2,/current)
 if mi eq 3 then xaxis=axis('X',location=0,target=p,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Latitude (degree)')
 if typei eq 0 then ytitle='Altitude (km)' else ytitle=''
 yaxis=axis('Y',location=min(lat1),target=p,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname,title=ytitle)
 p.font_size=fontsz
 p.scale,0.95,.95

subi=typei+mi*5
;t=text(pos1[0]+0.,pos1[3]-0.04,subtitle[subi],/normal,font_size=fontsz)
if mi eq 0 then $
t=text(pos1[0]+0.02,pos1[3]-0.005,subtitle1[typei],/normal,font_size=fontsz+1)

;t=text(pos[0],pos[3]-0.09,freh,/normal,font_size=fontsz)

If typei eq 0 then t=text(pos1[0]-0.03,pos1[1]+0.035,season[mi],orientation=90,font_size=fontsz)
If typei eq 0 then t=text(pos2[0]-0.05,pos2[1]+0.03,season[mi],orientation=90,font_size=fontsz)

endfor ; end each cloud type
endfor ; end each season
cttitle='Cloud Occurrence Frequency'
ct=colorbar(target=c,title=cttitle,taper=1,border=1,$
        orientation=0,position=barpos1,font_size=fontsz,tickinterval=0.1);,tickvalues=tkvalue)
ct1=colorbar(target=p,title=cttitle,taper=1,border=1,$
        orientation=0,position=barpos2,font_size=fontsz,tickinterval=0.05);,tickvalues=tkvalue)

t1=text(0.03,0.985,'a.',/normal,font_size=fontsz+3)
t2=text(0.03,0.52,'b.',/normal,font_size=fontsz+3)

c.save,'cldsat_cloudphase_fourseason_day_newdomain_zonal2D_R05.png'

stop

end
