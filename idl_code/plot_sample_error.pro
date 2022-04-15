pro plot_sample_error

 ;2x5 degrees
fname25=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial','*cldclimotology25*')

fname22=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_cloudtop','*cldclimotology2*')

fname55=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial','*cldclimotology5*')

;========= plot within a maplimt========================
maplimit=[-20,80,30,150]

;========= get 5x5 cloud fraction==========================
Nf55=n_elements(fname55)
ind=where(strlen(fname55) eq 101,count)
fname55=fname55[ind]
Nf55=count

Tobs55=ulonarr(72,36,12)
Tonelay55=ulonarr(72,36,3,12)
Tmul1lay55=ulonarr(72,36,3,12)
Tmulnlay55=ulonarr(72,36,3,12)
Tcldfre55=fltarr(48) ; to get time series
Julfre55=fltarr(72,36)

for fi=0,Nf55-1 do begin
  read_dardar,fname55[fi],'latitude',lat55
  read_dardar,fname55[fi],'longitude',lon55
  read_dardar,fname55[fi],'obsnum',obs55
  read_dardar,fname55[fi],'onelayercloud_frequency',onelay55
  read_dardar,fname55[fi],'mullayercloud_onephase_frequency',mul1lay55
  read_dardar,fname55[fi],'mullayercloud_mulphase_frequency',mulnlay55

  Tobs55=Tobs55+obs55
  Tonelay55=Tonelay55+onelay55
  Tmul1lay55=Tmul1lay55+mul1lay55
  Tmulnlay55=Tmulnlay55+mulnlay55
  tcld=reform(onelay55[59,18,*,*])+reform(mul1lay55[59,18,*,*])+reform(mulnlay55[59,18,*,*])
  Tcldfre55[fi*12:fi*12+11]=total(tcld,1)/float(reform(obs55[59,18,*]))

  if fi eq 0 then Julfre55=total(onelay55[*,*,*,6]+mul1lay55[*,*,*,6]+mulnlay55[*,*,*,6],3)/float(reform(obs55[*,*,6]))

endfor
indlat=where(lat55 ge maplimit[0] and lat55 le maplimit[2])
lat55_1=lat55[indlat]
Tobs55_1=Tobs55[*,indlat,*]
Tonelay55_1=Tonelay55[*,indlat,*,*]
Tmul1lay55_1=Tmul1lay55[*,indlat,*,*]
Tmulnlay55_1=Tmulnlay55[*,indlat,*,*]

indlon=where(lon55 ge maplimit[1] and lon55 le maplimit[3])
lon55_1=lon55[indlon]
Tobs55_2=Tobs55_1[indlon,*,*]
Tonelay55_2=Tonelay55_1[indlon,*,*,*]
Tmul1lay55_2=Tmul1lay55_1[indlon,*,*,*]
Tmulnlay55_2=Tmulnlay55_1[indlon,*,*,*]

;========= get 2x5 cloud fraction=============================
Nf25=n_elements(fname25)
ind=where(strlen(fname25) eq 105,count)
fname25=fname25[ind]
Nf25=count

Tobs25=ulonarr(72,90)
Tonelay25=ulonarr(72,90,3)
Tmul1lay25=ulonarr(72,90,3)
Tmulnlay25=ulonarr(72,90,3)
Tcldfre25=fltarr(48) ; to get time series
Julfre25=fltarr(72,90)

for fi=0,Nf25-1 do begin
  read_dardar,fname25[fi],'latitude',lat25
  read_dardar,fname25[fi],'longitude',lon25
  read_dardar,fname25[fi],'obsnum',obs25
  read_dardar,fname25[fi],'onelayercloud_frequency',onelay25
  read_dardar,fname25[fi],'mullayercloud_onephase_frequency',mul1lay25
  read_dardar,fname25[fi],'mullayercloud_mulphase_frequency',mulnlay25

  Tobs25=Tobs25+obs25
  Tonelay25=Tonelay25+onelay25
  Tmul1lay25=Tmul1lay25+mul1lay25
  Tmulnlay25=Tmulnlay25+mulnlay25
 
  Tcldfre25[fi]= total(reform(onelay25[59,46,*]+mul1lay25[59,46,*]+mulnlay25[59,46,*]))/float(reform(obs25[59,46]))
  if fi eq 6 then Julfre25=total(onelay25+mul1lay25+mulnlay25,3)/float(obs25)
endfor
indlat=where(lat25 ge maplimit[0] and lat25 le maplimit[2])
lat25_1=lat25[indlat]
Tobs25_1=Tobs25[*,indlat]
Tonelay25_1=Tonelay25[*,indlat,*]
Tmul1lay25_1=Tmul1lay25[*,indlat,*]
Tmulnlay25_1=Tmulnlay25[*,indlat,*]

indlon=where(lon25 ge maplimit[1] and lon25 le maplimit[3])
lon25_1=lon25[indlon]
Tobs25_2=Tobs25_1[indlon,*]
Tonelay25_2=Tonelay25_1[indlon,*,*]
Tmul1lay25_2=Tmul1lay25_1[indlon,*,*]
Tmulnlay25_2=Tmulnlay25_1[indlon,*,*]
;========== get 2x2 cloud fraction ================================
 
Nf22=n_elements(fname22)
Tobs22=ulonarr(180,90,12)
Tonelay22=ulonarr(180,90,3,12)
Tmul1lay22=ulonarr(180,90,3,12)
Tmulnlay22=ulonarr(180,90,3,12)
Tcldfre22=fltarr(48)
for fi=0,Nf22-1 do begin
  read_dardar,fname22[fi],'latitude',lat22
  read_dardar,fname22[fi],'longitude',lon22
  read_dardar,fname22[fi],'obsnum',obs22
  read_dardar,fname22[fi],'onelayercloud_frequency',onelay22
  read_dardar,fname22[fi],'mullayercloud_onephase_frequency',mul1lay22
  read_dardar,fname22[fi],'mullayercloud_mulphase_frequency',mulnlay22

  Tobs22=Tobs22+obs22
  Tonelay22=Tonelay22+onelay22
  Tmul1lay22=Tmul1lay22+mul1lay22
  Tmulnlay22=Tmulnlay22+mulnlay22

  tcld=reform(onelay22[148,46,*,*])+reform(mul1lay22[148,46,*,*])+reform(mulnlay22[148,46,*,*])
  Tcldfre22[fi*12:fi*12+11]=total(tcld,1)/float(reform(obs22[148,46,*]))

  if fi eq 0 then Julfre22=total(onelay22[*,*,*,6]+mul1lay22[*,*,*,6]+mulnlay22[*,*,*,6],3)/float(reform(obs22[*,*,6]))

endfor
indlat=where(lat22 ge maplimit[0] and lat22 le maplimit[2])
lat22_1=lat22[indlat]
Tobs22_1=Tobs22[*,indlat,*]
Tonelay22_1=Tonelay22[*,indlat,*,*]
Tmul1lay22_1=Tmul1lay22[*,indlat,*,*]
Tmulnlay22_1=Tmulnlay22[*,indlat,*,*]

indlon=where(lon22 ge maplimit[1] and lon22 le maplimit[3])
lon22_1=lon22[indlon]
Tobs22_2=Tobs22_1[indlon,*,*]
Tonelay22_2=Tonelay22_1[indlon,*,*,*]
Tmul1lay22_2=Tmul1lay22_1[indlon,*,*,*]
Tmulnlay22_2=Tmulnlay22_1[indlon,*,*,*]

;=========== to plot time series ================================
minvalue=0.0
maxvalue=1.0

pos1=[0.1,0.5,0.35,0.95]
mp=map('Geographic',limit=maplimit,transparency=100,position=pos1)
grid=mp.MAPGRID
grid.hide=1
grid.label_position=0
grid.linestyle='dotted'
ind=where(finite(Julfre22) eq 0)
if ind[0] ne -1 then Julfre22[ind]=-1
 
im22=image(Julfre22,lon22,lat22,xrange=[min(lon22_1),max(lon22_1)],yrange=[min(lat22_1),max(lat22_1)],$
	rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue,dim=[600,500])
mc=mapcontinents(/continents,transparency=30)
t1=text(pos1[0]+0.02,pos1[3]-0.11,'a) 2$\deg$x2$\deg$')

pos2=[0.4,0.5,0.65,0.95]
mp=map('Geographic',limit=maplimit,transparency=100,position=pos2,/current)
grid=mp.MAPGRID
grid.hide=1
grid.label_position=0
grid.linestyle='dotted'

ind=where(finite(Julfre25) eq 0)
if ind[0] ne -1 then Julfre25[ind]=-1

im25=image(Julfre25,lon25,lat25,xrange=[min(lon25_1),max(lon25_1)],yrange=[min(lat25_1),max(lat25_1)],$
	rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
mc=mapcontinents(/continents,transparency=30)
t2=text(pos2[0]+0.02,pos2[3]-0.11,'b) 5$\deg$x2$\deg$')

pos3=[0.7,0.5,0.95,0.95]
mp=map('Geographic',limit=maplimit,transparency=100,position=pos3,/current)
grid=mp.MAPGRID
grid.hide=1
grid.label_position=0
grid.linestyle='dotted'

ind=where(finite(Julfre55) eq 0)
if ind[0] ne -1 then Julfre55[ind]=-1

im55=image(Julfre55,lon55,lat55,xrange=[min(lon55_1),max(lon55_1)],yrange=[min(lat55_1),max(lat55_1)],$
	rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
mc=mapcontinents(/continents,transparency=30)
t3=text(pos3[0]+0.02,pos3[3]-0.11,'c) 5$\deg$x5$\deg$')
sb=symbol(117,3,'Star',/data,target=mp,sym_color='black',sym_size=2,sym_filled=1)


ct=colorbar(target=im55,title='Cloud Frequency',taper=1,border=1,position=[0.2,0.53,0.80,0.55],font_size=12)

x=indgen(48)
;xname=[' ',' ',' ',' ',' ','200706',' ',' ',' ',' ',' ','200712',$
;      ' ',' ',' ',' ',' ','200806',' ',' ',' ',' ',' ','200812',$
;      ' ',' ',' ',' ',' ','200906',' ',' ',' ',' ',' ','200912',$
;      ' ',' ',' ',' ',' ','201006',' ',' ',' ',' ',' ','201012']
xname=['200706','200712','200806','200812','200906','200912','201006','201012']
xvalue=[5,11,17,23,29,35,41,47]

p=plot(x,Tcldfre22,color='black',symbol='circle',thick=1,sym_filled=1,sym_size=1.,xtitle='Month',ytitle='Cloud Frequency',$
	xrange=[0,47],yrange=[0.6,1.1],position=[0.17,0.15,0.9,0.37],/current,name='2$\deg$x2$\deg$',xtickname=xname,$
	xtickvalues=xvalue,font_size=11)
p1=plot(x,Tcldfre25,color='red',symbol='*',sym_size=1.,thick=1,xrange=[0,47],yrange=[0.6,1.1],position=p.position,$
	/current,name='5$\deg$x2$\deg$',axis_style=0)
p2=plot(x,Tcldfre55,color='blue',symbol='diamond',sym_size=1.,thick=1,xrange=[0,47],yrange=[0.6,1.1],sym_filled=1,/current,$
	position=p.position,name='5$\deg$x5$\deg$',axis_style=0)

ld=legend(target=[p,p1,p2],position=[0.9,0.47])
pos4=p.position
t4=text(pos4[0]+0.02,pos4[3]+0.01,'d)')
stop
;============ to plot four year average ===========================================
posx1=[0.10,0.53,0.10,0.53,0.10,0.53]
posx2=[0.45,0.88,0.45,0.88,0.45,0.88]
posy1=[0.70,0.70,0.43,0.43,0.16,0.16]
posy2=[0.90,0.90,0.63,0.63,0.36,0.36]


For mi=0,5 Do Begin
pos=[posx1[mi],posy1[mi],posx2[mi],posy2[mi]]

if mi eq 0 then begin
mp=map('Geographic',limit=maplimit,transparency=100,position=pos)
grid=mp.MAPGRID
grid.hide=1
grid.label_position=0
grid.linestyle='dotted'
cldnum22=total(total(Tonelay22_2,3),3)+total(total(Tmul1lay22_2,3),3)+total(total(Tmulnlay22_2,3),3)
print,'maximum 2x2',max(cldnum22)
cf22=float(cldnum22)/total(Tobs22_2,3)

im22=image(cf22,lon22_1,lat22_1,xrange=[min(lon22_1),max(lon22_1)],yrange=[min(lat22_1),max(lat22_1)],$
	rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue,dim=[600,700])
mc=mapcontinents(/continents,transparency=30)
endif

if mi eq 1 then begin
icenum22=total(reform(Tonelay22_2[*,*,0,*]),3)+total(reform(Tmul1lay22_2[*,*,0,*]),3)
icf22=float(icenum22)/total(Tobs22_2,3)
data=icf22
lon=lon22_1
lat=lat22_1
endif

if mi eq 2 then begin
cldnum25=total(Tonelay25_2,3)+total(Tmul1lay25_2,3)+total(Tmulnlay25_2,3)
print,'maximum 2x5',max(cldnum25)
cf25=float(cldnum25)/Tobs25_2
data=cf25
lon=lon25_1
lat=lat25_1
endif

if mi eq 3 then begin
icenum25=reform(Tonelay25_2[*,*,0])+reform(Tmul1lay25_2[*,*,0])
icf25=float(icenum25)/Tobs25_2
data=icf25
lon=lon25_1
lat=lat25_1
endif

if mi eq 4 then begin
cldnum55=total(total(Tonelay55_2,3),3)+total(total(Tmul1lay55_2,3),3)+total(total(Tmulnlay55_2,3),3)
print,'maximum 5x5',max(cldnum55)
cf55=float(cldnum55)/total(Tobs55_2,3)
data=cf55
lon=lon55_1
lat=lat55_1
endif

if mi eq 5 then begin
icenum55=total(reform(Tonelay55_2[*,*,0,*]),3)+total(reform(Tmul1lay55_2[*,*,0,*]),3)
icf55=float(icenum55)/total(Tobs55_2,3)
data=icf55
lon=lon55_1
lat=lat55_1
endif
if mi ge 1 then begin
mp=map('Geographic',limit=maplimit,transparency=100,position=pos,/current)
grid=mp.MAPGRID
grid.hide=1
grid.label_position=0
grid.linestyle='dotted'
im=image(data,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
	rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
mc=mapcontinents(/continents,transparency=30)
endif

EndFor
stop
end
