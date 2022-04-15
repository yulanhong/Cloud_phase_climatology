; if plot one month data, just comment for loop

pro plot_allcld_2D_month

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
fontsz=14
Nh=101
;subtitle=['a) MAM', 'b) JJA','c) SON','d) DJF']
subtitle='Oct'

posx1=[0.08,0.53,0.08,0.53]
posx2=[0.43,0.88,0.43,0.88]
posy1=[0.60,0.60,0.15,0.15]
posy2=[0.95,0.95,0.50,0.50]
barpos=[0.2,0.10,0.8,0.13]

height=25-findgen(Nh)*0.25
levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]
ytitle='alt.'
bartitle=''
maplimit=[-20,80,30,150]


allfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/R05/','*.hdf')

Nf=n_elements(allfname)

obsnum=0L
onecl_num=0L
mulcl1_num=0L
mulcln_num=0L
onenumv=0L
mulnumv=0L

uwind=0.0
vwind=0.0

for fi=0,Nf-1 do begin
fname=allfname[fi]
IF (strlen(fname) eq 128) Then Begin
print,fname
read_dardar,fname,'latitude',lat
read_dardar,fname,'longitude',lon
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

all_num=mulcln_num+mulcl1_num+onecl_num

obsnum2=obsnum1[indlon,*,*]

all_cldnum=total(all_num,3)

one_cldnum=total(onecl_num2,3)

mul_cldnum=total(mulcl1_num2+mulcln_num2,3)

all_cldfre=float(all_cldnum)/obsnum

one_cldfre=float(one_cldnum)/obsnum2

mul_cldfre=float(mul_cldnum)/obsnum2

obsnumv=ulonarr(n_elements(lon),n_elements(lat),Nh)
For xi=0,n_elements(lon)-1 Do Begin
     for yi=0,n_elements(lat)-1 Do Begin
	obsnumv[xi,yi,*]=obsnum[xi,yi]
     endfor
endfor

all_cldfrev=float(onenumv+mulnumv)/obsnumv

;n=11

;levs=findgen(n)*0.1

;index=findgen(n)*25

;opacity=intarr(256)+10
dimx=n_elements(lon1)
dimy=n_elements(lat1)
dimz=n_elements(height)
data=fltarr(dimx,dimy,dimz)

mp=map('Geographic',limit=maplimit,transparency=30,dimensions=[800,800],position=pos)

c=image(all_cldfre,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
	max_value=1.0,min_value=0.2,title=subtitle,$
         rgb_table=33,overplot=mp,font_size=fontsz)

mc=mapcontinents(/continents,transparency=30)
;v=vector(uwind2,vwind2,lon1,lat1,overplot=vol,color='grey',head_angle=30)

;mp=image(imdata,image_dimensions=[(max(lon1)-min(lon1)),(max(lat1)-min(lat1))],$
;	image_location=[lon1[0],lat1[0]],min_value=0,max_value=0,overplot=c)

ct=colorbar(target=c,title='Cloud Occurrence Frequency',taper=1,border=1,$
        orientation=0,position=barpos,font_size=fontsz)

mp.save,'cldsat_2d_meteorology_'+subtitle+'.png'

xtickv=[40,45,50,55,60]
xname=['-9','1','11','21','31']

ztickv=[0,20,40,60,80]
zname=['0','5','10','15','20']

p=image(reverse(reform(all_cldfrev[59,*,*]),2),xrange=[35,60],axis_style=0,rgb_table=33,max_value=0.6,min_value=0,title=subtitle,font_size=fontsz)
xaxis=axis('X',location=0,target=p,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='Lat')
yaxis=axis('Y',location=35,target=p,tickdir=0,textpos=0,tickvalues=ztickv,tickname=yname,title='Alt.(km)')

ct=colorbar(target=p,title='Cloud Occurrence Frequency',taper=1,border=1,$
        orientation=0,position=barpos,font_size=fontsz)
;p.scale,13.0,2.8
;p.save,'cldsat_2dhgt_meteorology_'+subtitle+'.png'

stop

end
