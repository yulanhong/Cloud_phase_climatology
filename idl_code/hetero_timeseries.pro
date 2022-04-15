pro hetero_timeseries

 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis'

 allfname=file_search(datadir,'*.hdf')

 Nf=n_elements(allfname)
 modis_hetero=fltarr(Nf,5)
 modis_dayfre=fltarr(Nf,4)

 lat=findgen(180)-90
 lon=findgen(360)-180
 
 for fi=0,Nf-1 do begin
	
	year=strmid(allfname[fi],9,4,/rev)
	IF year ne '2018' then begin
	read_dardar,allfname[fi],'modis_clrhetero',hetero_clr
	read_dardar,allfname[fi],'modis_icehetero',hetero_ice
	read_dardar,allfname[fi],'modis_liqhetero',hetero_liq
	read_dardar,allfname[fi],'modis_underhetero',hetero_und
	read_dardar,allfname[fi],'modis_obshetero',hetero_obs
  
	read_dardar,allfname[fi],'modis_clrnum',clrnum
	read_dardar,allfname[fi],'modis_icenum',icenum
	read_dardar,allfname[fi],'modis_liqnum',liqnum
	read_dardar,allfname[fi],'modis_undernum',undnum
	read_dardar,allfname[fi],'modis_obsnum',obsnum
	
	indlat=where(lat ge -10 and lat le 20)
    clrnum1=clrnum[*,indlat]
	hetero_clr1=hetero_clr[*,indlat]
	icenum1=icenum[*,indlat]
	hetero_ice1=hetero_ice[*,indlat]
	liqnum1=liqnum[*,indlat]
	hetero_liq1=hetero_liq[*,indlat]
	undnum1=undnum[*,indlat]
	hetero_und1=hetero_und[*,indlat]
	obsnum1=obsnum[*,indlat]
	hetero_obs1=hetero_obs[*,indlat]

	indlon=where(lon ge 100 and lon le 140)
    clrnum2=clrnum1[indlon,*]
	hetero_clr2=hetero_clr1[indlon,*]
	icenum2=icenum1[indlon,*]
	hetero_ice2=hetero_ice1[indlon,*]
	liqnum2=liqnum1[indlon,*]
	hetero_liq2=hetero_liq1[indlon,*]
	undnum2=undnum1[indlon,*]
	hetero_und2=hetero_und1[indlon,*]
	obsnum2=obsnum1[indlon,*]
	hetero_obs2=hetero_obs1[indlon,*]

	ind=where(clrnum2 eq 0)
	if ind[0] ne -1 then hetero_clr2[ind]=0.0
	ind=where(icenum2 eq 0)
	if ind[0] ne -1 then hetero_ice2[ind]=0.0
	ind=where(liqnum2 eq 0)
	if ind[0] ne -1 then hetero_liq2[ind]=0.0
	ind=where(undnum2 eq 0)
	if ind[0] ne -1 then hetero_und2[ind]=0.0
	ind=where(obsnum2 eq 0)
	if ind[0] ne -1 then hetero_obs2[ind]=0.0

	modis_dayfre[fi,0]=total(clrnum2)/float(total(obsnum2))
	modis_hetero[fi,0]=total(clrnum2*hetero_clr2)/total(clrnum2)
 
	modis_dayfre[fi,1]=total(liqnum2)/float(total(obsnum2))
	modis_hetero[fi,1]=total(liqnum2*hetero_liq2)/total(liqnum2)

	modis_dayfre[fi,2]=total(icenum2)/float(total(obsnum2))
	modis_hetero[fi,2]=total(icenum2*hetero_ice2)/total(icenum2)
 
	modis_dayfre[fi,3]=total(undnum2)/float(total(obsnum2))
	modis_hetero[fi,3]=total(undnum2*hetero_und2)/total(undnum2)

	modis_hetero[fi,4]=total(obsnum2*hetero_obs2)/total(obsnum2)
	endif ; end year
 endfor  ; end files

 save,modis_dayfre,filename='modis_daytime_cldfre_newdomain.sav'
 save,modis_hetero,filename='modis_daytime_hetero_newdomain.sav'
 stop
end

