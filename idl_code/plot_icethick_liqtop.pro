
pro plot_icethick_liqtop

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
maplimit=[-20,80,30,150]
maplimit1=[0,105,20,135]
;maplimit=[-90,-180,90,180]

datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn"

loadct,41,file='myidlcolor.tbl'

For mi=0,3 Do Begin

if mi eq 0 then begin
allfname1=file_search(datadir,'*03_night.hdf')
allfname2=file_search(datadir,'*04_night.hdf')
allfname3=file_search(datadir,'*05_night.hdf')
endif
if mi eq 1 then begin
allfname1=file_search(datadir,'*06_night.hdf')
allfname2=file_search(datadir,'*07_night.hdf')
allfname3=file_search(datadir,'*08_night.hdf')
endif
if mi eq 2 then begin
allfname1=file_search(datadir,'*09_night.hdf')
allfname2=file_search(datadir,'*10_night.hdf')
allfname3=file_search(datadir,'*11_night.hdf')
endif
if mi eq 3 then begin
allfname1=file_search(datadir,'*12_night.hdf')
allfname2=file_search(datadir,'*01_night.hdf')
allfname3=file_search(datadir,'*02_night.hdf')
endif

allfname=[allfname1,allfname2,allfname3]

Nf=n_elements(allfname)

obsnum=0L
Ticethicknum=0L
Ticethick=0.0
Tonenum=0L
Tonetop=0.0
Tmulnum=0L
Tmultop=0.0
Tmul1num=0L
Tmul1top=0.0
Tliqicenum=0L
Tliqicetop=0.0

lon=(findgen(72)+1)*5-180
lat=(findgen(90)+1)*2-90

for fi=0,Nf-1 do begin
fname=allfname[fi]

IF (strlen(fname) eq 114 ) Then Begin
;read_dardar,fname,'latitude',lat
;read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',tpobsnum
print,total(tpobsnum),fname
obsnum=obsnum+tpobsnum
read_dardar,fname,'ice_cloud_thickness_num',icethicknum
Ticethicknum=Ticethicknum+icethicknum
read_dardar,fname,'ice_cloud_thickness',icethick
ind=where(icethicknum eq 0)
icethick[ind]=0.0
Ticethick=Ticethick+icethick*icethicknum

read_dardar,fname,'onelayercloud_topheight',onetop
read_dardar,fname,'onelayercloud_frequency',onenum
ind=where(onenum eq 0)
onetop[ind]=0.0
Tonenum=Tonenum+onenum
Tonetop=Tonetop+onenum*onetop

read_dardar,fname,'mullayercloud_mulphase_lowlaytopheight',multop
read_dardar,fname,'mullayercloud_mulphase_frequency',mulnum
ind=where(mulnum eq 0)
multop[ind]=0.0
Tmultop=Tmultop+multop*mulnum
Tmulnum=Tmulnum+mulnum

; for liquid below ice, to check one vs mullayer top
read_dardar,fname,'liquiwithice_liquidnum',liqicenum
read_dardar,fname,'liquiwithice_liquidtop',liqicetop
ind=where(liqicenum eq 0)
liqicetop[ind]=0.0
Tliqicenum=Tliqicenum+liqicenum
Tliqicetop=Tliqicetop+liqicetop*liqicenum

read_dardar,fname,'mullayercloud_onephase_frequency',mul1num
read_dardar,fname,'mullayercloud_onephase_topheight',mul1top
ind=where(mul1num eq 0)
mul1top[ind]=0.0
Tmul1num=Tmul1num+mul1num
Tmul1top=Tmul1top+mul1top*mul1num

EndIf
; plot vertical----------------
endfor

aveicethick=Ticethick/Ticethicknum
data=aveicethick[*,*,0]-aveicethick[*,*,1] ; iceonly-ice above liquid

liqonlytop=Tonetop[*,*,2]/Tonenum[*,*,2]; for onelayer liquid layers
liqonlymultop=Tmul1top[*,*,2]/Tmul1num[*,*,2] ; for liquid only but multiple layers
liqonlyalltop=(Tonetop[*,*,2]+Tmul1top[*,*,2])/(Tonenum[*,*,2]+Tmul1num[*,*,2])

liqicetop=Tmultop[*,*,0]/Tmulnum[*,*,0]
liq1icetop=Tliqicetop[*,*,0]/Tliqicenum[*,*,0]
liqnicetop=Tliqicetop[*,*,1]/Tliqicenum[*,*,1]
liqdata=liqonlyalltop - liqicetop

ind1=where(lon ge maplimit1[1] and lon le maplimit1[3],count)
N1=count
ind2=where(lat ge maplimit1[0] and lat le maplimit1[2],count)
N2=count
;get average of difference
print,'subarea thickness ice only ,', $
   total(Ticethick[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])/total(Ticethicknum[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])
print,'subarea thickness ice above liquid,', $
   total(Ticethick[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],1])/total(Ticethicknum[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],1])

print,'subarea liquid top only ,', $
   total(Tonetop[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],2]+Tmul1top[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],2])/total(Tonenum[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],2]+Tmul1num[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],2])
print,'subarea liquid below ice,', $
   total(Tmultop[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])/total(Tmulnum[ind1[0]:ind1[N1-1],ind2[0]:ind2[N2-1],0])


maxvalue=2
minvalue=-2

pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
pos2=[posx1[mi],posy1[1],posx2[mi],posy2[1]]

if mi eq 0 then begin
c=image(data,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
     rgb_table=72,font_size=fontsz,dim=[900,600],position=pos1)
endif else begin
c=image(data,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
     rgb_table=72,font_size=fontsz,/current,position=pos1)
endelse

 mp=map('Geographic',limit=maplimit,transparency=30,overplot=c)
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.grid_longitude=20
 grid.font_size=fontsz-2.5
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0

 t=text(pos1[0]+0.015,pos1[3]-0.015,subtitle1[mi],/normal,font_size=fontsz)

 c1=image(liqdata,lon,lat,xrange=[min(lon),max(lon)],yrange=[min(lat),max(lat)],$
     max_value=2,min_value=-2,$
     rgb_table=72,font_size=fontsz,/current,position=pos2)

 mp=map('Geographic',limit=maplimit,transparency=30,overplot=c1)
 grid=mp.MAPGRID
 grid.label_position=0
 grid.linestyle='dotted'
 grid.grid_longitude=20
 grid.font_size=fontsz-2.5
 mc=mapcontinents(/continents,transparency=30)
 mc['Longitudes'].label_angle=0

 t=text(pos2[0]+0.015,pos2[3]-0.045,subtitle2[mi],/normal,font_size=fontsz)
endfor

ct=colorbar(target=c,title='Geometrical Thickness Difference (km)',taper=1,border=1,$
        orientation=0,position=barpos1,font_size=fontsz)

ct=colorbar(target=c1,title='Liquid Top Difference (km)', taper=1,border=1,$
        orientation=0,position=barpos2,font_size=fontsz)

c.save,'icethick_liqtop_diff_all_Philipine_night.png'

stop

end
