
pro plot_allcld_3D

fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"

;fname="cldsat_cldclimotology5.hdf"
;read_dardar,fname,'time',month
read_dardar,fname,'latitude',lat
read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',obsnum
read_dardar,fname,'onelayercloud_frequency',onecl_num
read_dardar,fname,'onelayercloud_topheight',onecl_top
read_dardar,fname,'mullayercloud_onephase_frequency',mulcl1_num
read_dardar,fname,'mullayercloud_onephase_topheight',mulcl1_top
read_dardar,fname,'mullayercloud_mulphase_frequency',mulcln_num
read_dardar,fname,'mullayercloud_mulphase_lowlaytopheight',mulcln_lowtop
read_dardar,fname,'mullayercloud_mulphase_lowlaybaseheight',mulcln_lowbase
read_dardar,fname,'mullayercloud_mulphase_uplaytopheight',mulcln_uptop
read_dardar,fname,'mullayercloud_mulphase_uplaybaseheight',mulcln_upbase

read_dardar,fname,'obsnum_vertical',obsnumv
read_dardar,fname,'onelaynum_vertical',onenumv
read_dardar,fname,'mullaynum_vertical',mulnumv
read_dardar,fname,'liquinoicenum_vertical',liqnicenumv
read_dardar,fname,'liquiwithicenum_vertical',liqwicenumv
read_dardar,fname,'liquiwithice_liquidnum',liqwicenumh
read_dardar,fname,'liquiwithice_liquidtop',liqwicetop
; plot vertical----------------
height=25-findgen(101)*0.25


levs=findgen(15)*0.025
barlevs=['','','','']
yrange=[0,20]
xrange=[-90,90]

ytitle='alt.'
bartitle=''

;plot_ver_3p,frev,frev1,frev2,lat,height,levs,xrange,yrange

maplimit=[-20,70,30,150]

indlat=where(lat ge maplimit[0] and lat le maplimit[2])
lat1=lat[indlat]

mulcln_num1=mulcln_num[*,indlat,*,*]
mulcl1_num1=mulcl1_num[*,indlat,*,*]
onecl_num1=onecl_num[*,indlat,*,*];+prec_num[*,indlat,*,*]
obsnum1=obsnum[*,indlat,*]
obsnumv1=obsnumv[*,indlat,*,*]
onenumv1=onenumv[*,indlat,*,*]
mulnumv1=mulnumv[*,indlat,*,*]

indlon=where(lon ge maplimit[1] and lon le maplimit[3])
lon1=lon[indlon]

mulcln_num2=mulcln_num1[indlon,*,*,*]
mulcl1_num2=mulcl1_num1[indlon,*,*,*]
onecl_num2=onecl_num1[indlon,*,*,*]
obsnumv2=obsnumv1[indlon,*,*,*]
onenumv2=onenumv1[indlon,*,*,*]
mulnumv2=mulnumv1[indlon,*,*,*]


all_num2=mulcln_num2+mulcl1_num2+onecl_num2

obsnum2=obsnum1[indlon,*,*]

all_cldnum=total(all_num2,3)

one_cldnum=total(onecl_num2,3)

mul_cldnum=total(mulcl1_num2+mulcln_num2,3)

all_cldfre=float(total(all_cldnum,3))/total(obsnum2,3)

one_cldfre=float(total(one_cldnum,3))/total(obsnum2,3)

mul_cldfre=float(total(mul_cldnum,3))/total(obsnum2,3)

all_cldfrev=float(total(onenumv2+mulnumv2,4))/total(obsnumv2,4)

pos1=[0.1,0.72,0.8,0.93]
pos2=[0.1,0.42,0.8,0.63]
pos3=[0.1,0.12,0.8,0.33]
barpos=[0.92,0.2,0.95,0.8]
n=11

levs=findgen(n)*0.1

index=findgen(n)*25

;opacity=intarr(256)+10
dimx=n_elements(lon1)
dimy=n_elements(lat1)
dimz=n_elements(height)
data=fltarr(dimx,dimy,dimz)

;data[7,*,*]=reform(all_cldfrev[7,*,*])
data[9,*,*]=reform(all_cldfrev[9,*,*])
;data[11,*,*]=reform(all_cldfrev[11,*,*])
;data[18,*,*]=reform(all_cldfrev[18,*,*])
;data[36,*,*]=reform(all_cldfrev[36,*,*])
;data[54,*,*]=reform(all_cldfrev[54,*,*])

data=reverse(data,3)
;xtickv=[0,18,36,54,71]
;xname=['-177.5','-87.5','2.5','92.5','177.5']
xtickv=[0,7,9,12,15]
xname=['72.5','107.5','117.5','127.5','147.5']
ytickv=[0,3,6,9]
yname=['-17.5','-2.5','12.5','27.5']
;ytickv=[0,9,18,27,35]
;yname=['-87.5','-42.5','2.5','47.5','87.5']
ztickv=[0,20,40,60,80]
zname=['0','5','10','15','20']


vol=volume(data,axis_style=2,hints=3,rgb_table0=33,/auto_render,xtickvalues=xtickv,opacity_table0=opacity,$
	xtickname=xname,ytickvalues=ytickv,ytickname=yname,ztickvalues=ztickv,ztickname=zname,$
	max_value=1.0,min_value=0.2)

pos2=vol.position

c=image(all_cldfre,max_value=1.0,min_value=0.2,$
         rgb_table=33,/fill,title='Cloud Occurrence Frequency',$
        position=pos2,/current,depth_cue=[0,2],overplot=vol)
ct=colorbar(target=c,title='Cloud Frequency',taper=1,border=1,$
        orientation=1,position=barpos)
;c=contour(all_cldfre,c_value=levs,n_levels=n,$
;         rgb_table=33,rgb_indices=index,/fill,title='Cloud Occurrence Frequency',$
;        position=pos2,/current,depth_cue=[0,2],overplot=vol)

stop
   mp=map('Geographic',limit=maplimit,overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   mc=mapcontinents(/continents,transparency=30)





stop


end
