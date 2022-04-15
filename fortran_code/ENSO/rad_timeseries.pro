pro rad_timeseries

 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/ENSO'

 allfname=file_search(datadir,'*.hdf')

 Nf=n_elements(allfname)
 modis_rad=fltarr(Nf,2)

 lat=findgen(180)-90
 lon=findgen(360)-180
	
 for fi=0,Nf-1 do begin

	year=strmid(allfname[fi],9,4,/rev)

 	IF (year ne '2018') Then begin 
	read_dardar,allfname[fi],'modis_obsnum',obsnum
	read_dardar,allfname[fi],'modis_reflectance_64',r64
	read_dardar,allfname[fi],'modis_bt_11',bt11

	indlat=where(lat ge -10 and lat le 20)
	obsnum1=obsnum[*,indlat]
	r64_1=r64[*,indlat]
	bt11_1=bt11[*,indlat]
	indlon=where(lon ge 100 and lon le 140)
	obsnum2=obsnum1[indlon,*]
	r64_2=r64_1[indlon,*]
	bt11_2=bt11_1[indlon,*]

	obsnum21=obsnum2
	ind=where(finite(r64_2) eq 0)
	if ind[0] ne -1 then begin
		r64_2[ind]=0.0
		obsnum21[ind]=0.0
	endif
	obsnum22=obsnum2
	ind=where(finite(bt11_2) eq 0)
	if ind[0] ne -1 then begin
		bt11_2[ind]=0.0
		obsnum22[ind]=0.0
	endif
	modis_rad[fi,0]=total(r64_2*obsnum21)/total(obsnum21)
	modis_rad[fi,1]=total(bt11_2*obsnum22)/total(obsnum22)

	EndIf; end year

 endfor 

 save,modis_rad,filename='modis_daytime_rad_ensonewdomain.sav'
stop 
end

