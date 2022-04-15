; if plot one month data, just comment for loop

pro cldphase_timeseries

;fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200701.hdf"
allfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*_R05_day.hdf*')

Nf=n_elements(allfname)
	
subarea_fre=fltarr(Nf,5)

;maplimit=[0,105,20,135]
maplimit=[-10,100,20,140]
 
lon=(findgen(72)+1)*5-180
lat=(findgen(90)+1)*2-90

for fi=0,Nf-1 do begin

ice_numh=0L
mix_numh=0L
liq_numh=0L
icemix_numh=0L
iceliq_numh=0L

fname=allfname[fi]

IF (strlen(fname) eq 128 ) Then Begin


;read_dardar,fname,'latitude',lat
;read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',tpobsnum
obsnum=tpobsnum
print,fname,total(tpobsnum)

read_dardar,fname,'onelayercloud_frequency',one_numh
read_dardar,fname,'mullayercloud_onephase_frequency',mul1_numh
read_dardar,fname,'mullayercloud_mulphase_frequency',muln_numh

ice_numh=reform(one_numh[*,*,0])+reform(mul1_numh[*,*,0])
mix_numh=reform(one_numh[*,*,1])+reform(mul1_numh[*,*,1])
liq_numh=reform(one_numh[*,*,2])+reform(mul1_numh[*,*,2])
icemix_numh=reform(muln_numh[*,*,1])
iceliq_numh=reform(muln_numh[*,*,0])

indlat=where(lat ge maplimit[0] and lat le maplimit[2])
lat1=lat[indlat]

obsnum1=obsnum[*,indlat]

ice_numh1=ice_numh[*,indlat]
mix_numh1=mix_numh[*,indlat]
liq_numh1=liq_numh[*,indlat]
icemix_numh1=icemix_numh[*,indlat]
iceliq_numh1=iceliq_numh[*,indlat]

indlon=where(lon ge maplimit[1] and lon le maplimit[3])
lon1=lon[indlon]

obsnum2=obsnum1[indlon,*]

ice_numh2=ice_numh1[indlon,*]
mix_numh2=mix_numh1[indlon,*]
liq_numh2=liq_numh1[indlon,*]
icemix_numh2=icemix_numh1[indlon,*]
iceliq_numh2=iceliq_numh1[indlon,*]
	
 icefreh=total(ice_numh2)/float(total(obsnum2))
 subarea_fre[fi,0]=icefreh
  
 iceliqfreh=total(iceliq_numh2)/float(total(obsnum2))
 subarea_fre[fi,1]=iceliqfreh

 icemixfreh=total(icemix_numh2)/float(total(obsnum2))
 subarea_fre[fi,2]=icemixfreh
 liqfreh=total(liq_numh2)/float(total(obsnum2))
 subarea_fre[fi,3]=liqfreh
   
 mixfreh=total(mix_numh2)/total(obsnum2)
 subarea_fre[fi,4]=mixfreh

EndIf
endfor ;endfile
save,subarea_fre,filename='cldphase_subarea_fre_day_ensonewdomain_R05.sav'
stop
end
