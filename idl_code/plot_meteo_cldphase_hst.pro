
pro plot_meteo_cldphase_hst

;  	allfname='/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/cldsat_cldclimotology25_meterology_200708.hdf'

	allfname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/','*12_day.hdf')
	subtitle='Dec.'
	Nf=n_elements(allfname)
	obsnum=0L
	iceonly_T=0L
	mixonly_T=0L
	liqonly_T=0L
	icemix_T=0L
	iceliq_T=0L
	iceonly_stat=0L
	mixonly_stat=0L
	liqonly_stat=0L
	icemix_stat=0L
	iceliq_stat=0L

	For fi=0,Nf-1 Do Begin
	print,strlen(allfname[fi])
	
	If strlen(allfname[fi]) eq 123 Then Begin

	fname=allfname[fi]
	print,fname
	read_dardar,fname,'obsnum',tpobsnum

	obsnum=obsnum+tpobsnum

	read_dardar,fname,'surface_temperature',surf_t
	 
	read_dardar,fname,'Low_atmos_stability',stat_low

	read_dardar,fname,'height',hgt

	read_dardar,fname,'latitude',lat

	read_dardar,fname,'longitude',lon

	read_dardar,fname,'iceonly_numv_temperature',tpiceonly_T

	iceonly_T=iceonly_T+tpiceonly_T	

	read_dardar,fname,'mixonly_numv_temperature',tpmixonly_T

	mixonly_T=mixonly_T+tpmixonly_T

	read_dardar,fname,'liqonly_numv_temperature',tpliqonly_T

	liqonly_T=liqonly_T+tpliqonly_T

	read_dardar,fname,'iceup_mixlow_numv_temperature',tpicemix_T

	icemix_T=icemix_T+tpicemix_T

	read_dardar,fname,'iceup_liqlow_numv_temperature',tpiceliq_T

	iceliq_T=iceliq_T+tpiceliq_T

	read_dardar,fname,'iceonly_numv_stability',tpiceonly_stat

	iceonly_stat=iceonly_stat+tpiceonly_stat	

	read_dardar,fname,'mixonly_numv_stability',tpmixonly_stat

	mixonly_stat=mixonly_stat+tpmixonly_stat

	read_dardar,fname,'liqonly_numv_stability',tpliqonly_stat

	liqonly_stat=liqonly_stat+tpliqonly_stat

	read_dardar,fname,'iceup_mixlow_numv_stability',tpicemix_stat

	icemix_stat=icemix_stat+tpicemix_stat

	read_dardar,fname,'iceup_liqlow_numv_stability',tpiceliq_stat

	iceliq_stat=iceliq_stat+tpiceliq_stat

	EndIf ; end if file len eq 105
	EndFor
;======================in a subscribed region==========================
;philippine 0-20,110-125
	maplimit=[-10,80,30,150]
	indlat=where(lat ge maplimit[0] and lat le maplimit[2])
	iceonly_T1=iceonly_T[*,indlat,*,*]
	mixonly_T1=mixonly_T[*,indlat,*,*]
	liqonly_T1=liqonly_T[*,indlat,*,*]
	icemix_T1=icemix_T[*,indlat,*,*]
	iceliq_T1=iceliq_T[*,indlat,*,*]

	iceonly_stat1=iceonly_stat[*,indlat,*,*]
	mixonly_stat1=mixonly_stat[*,indlat,*,*]
	liqonly_stat1=liqonly_stat[*,indlat,*,*]
	icemix_stat1=icemix_stat[*,indlat,*,*]
	iceliq_stat1=iceliq_stat[*,indlat,*,*]

	obsnum1=obsnum[*,indlat]

	indlon=where(lon ge maplimit[1] and lon le maplimit[3])
	iceonly_T2=iceonly_T1[indlon,*,*,*]
	mixonly_T2=mixonly_T1[indlon,*,*,*]
	liqonly_T2=liqonly_T1[indlon,*,*,*]
	icemix_T2=icemix_T1[indlon,*,*,*]
	iceliq_T2=iceliq_T1[indlon,*,*,*]

	iceonly_stat2=iceonly_stat1[indlon,*,*,*]
	mixonly_stat2=mixonly_stat1[indlon,*,*,*]
	liqonly_stat2=liqonly_stat1[indlon,*,*,*]
	icemix_stat2=icemix_stat1[indlon,*,*,*]
	iceliq_stat2=iceliq_stat1[indlon,*,*,*]

	obsnum2=obsnum1[indlon,*]
	Tobsnum=float(total(obsnum2))

	Ticeonly_T=total(iceonly_T2,1)
	Ticeonly_T=total(Ticeonly_T,1)
	
	Tmixonly_T=total(mixonly_T2,1)
	Tmixonly_T=total(Tmixonly_T,1)

	Tliqonly_T=total(liqonly_T2,1)
	Tliqonly_T=total(Tliqonly_T,1)

	Ticemix_T=total(icemix_T2,1)
	Ticemix_T=total(Ticemix_T,1)

	Ticeliq_T=total(iceliq_T2,1)
	Ticeliq_T=total(Ticeliq_T,1)

	data1=fltarr(55,101,5)
	data1[*,*,0]=transpose(Ticeonly_T)/Tobsnum
	data1[*,*,1]=transpose(Tmixonly_T)/Tobsnum
	data1[*,*,2]=transpose(Tliqonly_T)/Tobsnum
	data1[*,*,3]=transpose(Ticeliq_T)/Tobsnum
	data1[*,*,4]=transpose(Ticemix_T)/Tobsnum

;	n=11
;	index=findgen(n)*25
;	levs=findgen(n)*0.005+0.005
;	c=contour(Ticeonly_tfre,surf_t,hgt,xrange=[290,305],yrange=[0,20],$
;	rgb_table=53,/fill,rgb_indices=index,c_value=levs,n_levels=n)
;	c1=contour(Tmixonly_tfre,surf_t,hgt,overplot=c,rgb_table=54,$
;	rgb_indices=index,c_value=levs,n_levels=n,/fill)
;	c2=contour(Tliqonly_tfre,surf_t,hgt,overplot=c,rgb_table=20,$
;	rgb_indices=index,c_value=levs,n_levels=n,/fill)
;	c3=contour(Ticemix_tfre,surf_t,hgt,overplot=c,rgb_table=60,$
;	rgb_indices=index,c_value=levs,n_levels=n,/fill)
;	c4=contour(Ticeliq_tfre,surf_t,hgt,overplot=c,rgb_table=56,$
;	rgb_indices=index,c_value=levs,n_levels=n,/fill)

	Ticeonly_stat=total(iceonly_stat2,1)
	Ticeonly_stat=total(Ticeonly_stat,1)
	
	Tmixonly_stat=total(mixonly_stat2,1)
	Tmixonly_stat=total(Tmixonly_stat,1)

	Tliqonly_stat=total(liqonly_stat2,1)
	Tliqonly_stat=total(Tliqonly_stat,1)

	Ticemix_stat=total(icemix_stat2,1)
	Ticemix_stat=total(Ticemix_stat,1)

	Ticeliq_stat=total(iceliq_stat2,1)
	Ticeliq_stat=total(Ticeliq_stat,1)

	data2=fltarr(25,101,5)
	data2[*,*,0]=transpose(Ticeonly_stat)/Tobsnum
	data2[*,*,1]=transpose(Tmixonly_stat)/Tobsnum
	data2[*,*,2]=transpose(Tliqonly_stat)/Tobsnum
	data2[*,*,3]=transpose(Ticeliq_stat)/Tobsnum
	data2[*,*,4]=transpose(Ticemix_stat)/Tobsnum

	plot_meto_std_10p,data1,data2,surf_t,stat_low,hgt,subtitle
;	p=contour(Ticeonly_sfre,stat_low,hgt,xrange=[0,12],yrange=[0,20],rgb_table=33,/fill)
;	c1=contour(Tmixonly_sfre,stat_low,hgt,color='b',overplot=p)
;	c2=contour(Tliqonly_sfre,stat_low,hgt,color='g',overplot=p)
;	c3=contour(Ticemix_sfre,stat_low,hgt,color='purple',overplot=p)
;	c4=contour(Ticeliq_sfre,stat_low,hgt,color='pink',overplot=p)
	
	stop
end
