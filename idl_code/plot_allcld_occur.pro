
pro plot_allcld_occur

fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/output/cldsat_cldclimotology5.hdf"

read_dardar,fname,'time',month
read_dardar,fname,'latitude',lat
read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',obsnum
read_dardar,fname,'precipitation_frequency',prec_num
read_dardar,fname,'onelayercloud_frequency',onecl_num
read_dardar,fname,'onelayercloud_topheight',onecl_top
read_dardar,fname,'mullayercloud_onephase_frequency',mulcl1_num
read_dardar,fname,'mullayercloud_onephase_topheight',mulcl1_top
read_dardar,fname,'mullayercloud_mulphase_frequency',mulcln_num
read_dardar,fname,'mullayercloud_mulphase_lowlaytopheight',mulcln_lowtop
read_dardar,fname,'mullayercloud_mulphase_lowlaybaseheight',mulcln_lowbase
read_dardar,fname,'mullayercloud_mulphase_uplaytopheight',mulcln_uptop
read_dardar,fname,'mullayercloud_mulphase_uplaybaseheight',mulcln_upbase

maplimit=[-90,-180,90,180]

indlat=where(lat ge maplimit[0] and lat le maplimit[2])
lat1=lat[indlat]

mulcln_num1=mulcln_num[*,indlat,*,*]
mulcl1_num1=mulcl1_num[*,indlat,*,*]
onecl_num1=onecl_num[*,indlat,*,*];+prec_num[*,indlat,*,*]
obsnum1=obsnum[*,indlat,*]


indlon=where(lon ge maplimit[1] and lon le maplimit[3])
lon1=lon[indlon]

mulcln_num2=mulcln_num1[indlon,*,*,*]
mulcl1_num2=mulcl1_num1[indlon,*,*,*]
onecl_num2=onecl_num1[indlon,*,*,*]

all_num2=mulcln_num2+mulcl1_num2+onecl_num2

obsnum2=obsnum1[indlon,*,*]

all_cldnum=total(all_num2,3)

one_cldnum=total(onecl_num2,3)

mul_cldnum=total(mulcl1_num2+mulcln_num2,3)

all_cldfre=float(total(all_cldnum,3))/total(obsnum2,3)

one_cldfre=float(total(one_cldnum,3))/total(obsnum2,3)

mul_cldfre=float(total(mul_cldnum,3))/total(obsnum2,3)


pos1=[0.1,0.72,0.8,0.93]
pos2=[0.1,0.42,0.8,0.63]
pos3=[0.1,0.12,0.8,0.33]
barpos=[0.92,0.2,0.95,0.8]
n=11

levs=findgen(n)*0.1

index=findgen(n)*25

c=contour(all_cldfre,lon1,lat1,c_value=levs,n_levels=n,dim=[500,750],$
	rgb_table=33,rgb_indices=index,/fill,title='All observed cloud (81%)',$
	position=pos1)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   mc=mapcontinents(/continents,transparency=30)

c1=contour(one_cldfre,lon1,lat1,c_value=levs,n_levels=n,$
	rgb_table=33,rgb_indices=index,/fill,title='One layer cloud (40%)',$
	position=pos2,/current)
 
   mp=map('Geographic',limit=maplimit, overplot=c1,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   mc=mapcontinents(/continents,transparency=30)

c2=contour(mul_cldfre,lon1,lat1,c_value=levs,n_levels=n,$
	rgb_table=33,rgb_indices=index,/fill,title='Multi-layer cloud (41%)',$
	position=pos3,/current)
 
   mp=map('Geographic',limit=maplimit, overplot=c2,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   mc=mapcontinents(/continents,transparency=30)

ct=colorbar(target=c,title='Cloud Frequency',taper=1,border=1,$
        orientation=1,position=barpos)

stop


end
