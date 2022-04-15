 pro plot_modis_hetero

 pdflag=1
 sigmaflag=0; for sigma frequency and average over spatial

 dir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis/'
 lat=findgen(180)-90
 lon=findgen(360)-180

 maplimit=[-20,80,30,150]

 subtitle=['MAM','JJA','SON','DJF']
 subtitle1=['a1)','a2)','a3)','a4)']
 subtitle2=['b1)','b2)','b3)','b4)']
 subtitle3=['c1)','c2)','c3)','c4)']

 posx1=[0.05,0.27,0.49,0.71]
 posx2=[0.23,0.45,0.67,0.89]
 posy1=[0.72,0.41,0.10]
 posy2=[0.97,0.66,0.35]

 barpos1=[0.97,0.43,0.99,0.95]
 barpos2=[0.97,0.09,0.99,0.35]
 bartitle='$H_{\sigma}$'
; bartitle='Cloud Occurrence Frequency'
 fontsz=11
 lnthk=1.8
 symsz=1.3

 For mi=0,3 Do Begin
 if mi eq 0 then begin
 fname1=file_search(dir,'*03.hdf')
 fname2=file_search(dir,'*04.hdf')
 fname3=file_search(dir,'*05.hdf')
 endif	
 if mi eq 1 then begin
 fname1=file_search(dir,'*06.hdf')
 fname2=file_search(dir,'*07.hdf')
 fname3=file_search(dir,'*08.hdf')
 endif
 if mi eq 2 then begin
 fname1=file_search(dir,'*09.hdf')
 fname2=file_search(dir,'*10.hdf')
 fname3=file_search(dir,'*11.hdf')
 endif
 if mi eq 3 then begin
 fname1=file_search(dir,'*12.hdf')
 fname2=file_search(dir,'*01.hdf')
 fname3=file_search(dir,'*02.hdf')
 endif
 fname=[fname1,fname2,fname3]
 Nf=n_elements(fname)
 
 Tobsnum=0L
 Tliqnum=0L
 Ticenum=0L
 Tclrnum=0L
 Tundernum=0L
 Tclrhetero=0.0
 Tunderhetero=0.0
 Tliqhetero=0.0
 Ticehetero=0.0
 Tobshetero=0.0

 Thetero_pdf=0
 Tcldfraction=0.0	
 Tliqfraction=0.0
 
 for fi=0,Nf-1 do begin
	year=strmid(fname[fi],9,4,/rev)
;	If year eq '2007'  or year eq '2008' or year eq '2009' or year eq '2010' then begin

	read_dardar,fname[fi],'modis_obsnum',obsnum
	read_dardar,fname[fi],'modis_liqnum',liqnum
	read_dardar,fname[fi],'modis_icenum',icenum
	read_dardar,fname[fi],'modis_clrnum',clrnum
	read_dardar,fname[fi],'modis_undernum',undernum

	read_dardar,fname[fi],'modis_clrhetero',clrhetero
	read_dardar,fname[fi],'modis_liqhetero',liqhetero
	read_dardar,fname[fi],'modis_icehetero',icehetero
	read_dardar,fname[fi],'modis_obshetero',obshetero
	read_dardar,fname[fi],'modis_underhetero',underhetero

	read_dardar,fname[fi],'subarea_hetero_pdf',hetero_pdf
	read_dardar,fname[fi],'hetero_interval',hetero_x

	read_dardar,fname[fi],'subarea_cldfraction',cldfraction
	read_dardar,fname[fi],'subarea_liqfraction',liqfraction

	Thetero_pdf=Thetero_pdf+hetero_pdf	

	print,fname[fi]
	yymm=strmid(fname[fi],9,6,/rev)

	Tobsnum=Tobsnum+obsnum
	Tliqnum=Tliqnum+liqnum
	Ticenum=Ticenum+icenum
	Tclrnum=Tclrnum+clrnum
	Tundernum=Tundernum+undernum
	
	ind=where(hetero_pdf eq 0)
	cldfraction[ind]=0.0
	liqfraction[ind]=0.0
	Tcldfraction=Tcldfraction+cldfraction*hetero_pdf
	Tliqfraction=Tliqfraction+liqfraction*hetero_pdf	

	ind=where(liqnum eq 0)
	if ind[0] ne -1 then liqhetero[ind]=0.0
	Tliqhetero=Tliqhetero+liqhetero*liqnum

	ind=where(icenum eq 0)
	if ind[0] ne -1 then icehetero[ind]=0.0
	Ticehetero=Ticehetero+icehetero*icenum
	
	ind=where(undernum eq 0)
	if ind[0] ne -1 then underhetero[ind]=0.0
	Tunderhetero=Tunderhetero+underhetero*undernum

	ind=where(obsnum eq 0)
	if ind[0] ne -1 then obshetero[ind]=0.0
	Tobshetero=Tobshetero+obshetero*obsnum

;	endif; end year
 endfor
 ;====== get cloud frenquency in each season in the subarea
 print,'clr frac, cloud fraction liq, ice, under',total(Thetero_pdf[*,0])/total(Thetero_pdf[*,5]),$
		total(Thetero_pdf[*,1])/total(Thetero_pdf[*,5]),$
		total(Thetero_pdf[*,2])/total(Thetero_pdf[*,5]),total(Thetero_pdf[*,4])/total(Thetero_pdf[*,5])
;========== to plot pdf ===========
 IF pdflag eq 1 then begin
		xrange=[-4,1]
		yrange=[0,1.5]
	 	clrfre=(Thetero_pdf[*,0]/float(total(Thetero_pdf[*,0])))*100.0	
		ind=where(clrfre eq 0)
		ind1=where(max(clrfre) eq clrfre)
		print,'max clear position',hetero_x[ind1]
		clrfre[ind]=!values.f_nan
	
	 	liqfre=(Thetero_pdf[*,1]/float(total(Thetero_pdf[*,1])))*100.0	
		ind1=where(max(liqfre) eq liqfre)
		print,'max liquid position',hetero_x[ind1]
		ind=where(liqfre eq 0)
		liqfre[ind]=!values.f_nan
	 	icefre=(Thetero_pdf[*,2]/float(total(Thetero_pdf[*,2])))*100.0	
		ind=where(icefre eq 0)
		ind1=where(max(icefre) eq icefre)
		print,'max ice position',hetero_x[ind1]
		icefre[ind]=!values.f_nan
	 	underfre=(Thetero_pdf[*,4]/float(total(Thetero_pdf[*,4])))*100.0	
		ind=where(underfre eq 0)
		underfre[ind]=!values.f_nan
	 	allfre=(Thetero_pdf[*,3]/float(total(Thetero_pdf[*,3])))*100.0	
		ind=where(allfre eq 0)
		allfre[ind]=!values.f_nan

		;print,'cloud fraction liq, ice, under',total(Thetero_pdf[*,1])/total(Thetero_pdf[*,5]),$
		;total(Thetero_pdf[*,2])/total(Thetero_pdf[*,5]),total(Thetero_pdf[*,4])/total(Thetero_pdf[*,5])
		; cloud fraction for each pixel in a 5x5 pixels region
	 	clrfra=Tcldfraction[*,0]/Thetero_pdf[*,0]	
	 	liqfra=Tcldfraction[*,1]/Thetero_pdf[*,1]	
	 	icefra=Tcldfraction[*,2]/Thetero_pdf[*,2]	
	 	underfra=Tcldfraction[*,4]/Thetero_pdf[*,4]	
	 	allfra=Tcldfraction[*,5]/Thetero_pdf[*,5]	
	
		;liquid cloud fraction for each pixel in a 5x5 pixels region
	 	liqclrfra=Tliqfraction[*,0]/Thetero_pdf[*,0]	
	 	liqliqfra=Tliqfraction[*,1]/Thetero_pdf[*,1]	
	 	liqicefra=Tliqfraction[*,2]/Thetero_pdf[*,2]	
	 	liqunderfra=Tliqfraction[*,4]/Thetero_pdf[*,4]	
	 	liqallfra=Tliqfraction[*,5]/Thetero_pdf[*,5]	
		
		pos1=[posx1[mi]+0.02,posy1[0]-0.03,posx2[mi]+0.025,posy2[0]-0.03]
		pos2=[posx1[mi]+0.02,posy1[1]-0.08,posx2[mi]+0.025,posy2[1]-0.08]

		If mi eq 0 Then begin
		p=plot(hetero_x,clrfre,name='clear',dim=[850,400],xrange=xrange,yrange=yrange,xtitle='$log_{10}(H_{\sigma})$',$
			ytitle='Frequency(%)',position=pos1,title=subtitle[mi],font_size=fontsz,thick=lnthk,symbol='dot',sym_size=symsz)
		p01=plot(hetero_x,clrfra,name='clear',xrange=xrange,yrange=[0,1.2],xtitle='$log_{10}(H_{\sigma})$',$
			ytitle='Cloud Fraction',position=pos2,font_size=fontsz,/current,thick=lnthk,symbol='dot',sym_size=symsz)
		EndIf else begin
		p=plot(hetero_x,clrfre,name='clear',xrange=xrange,yrange=yrange,xtitle='$log_{10}(H_{\sigma})$',$
			position=pos1,title=subtitle[mi],/current,font_size=fontsz,thick=lnthk,symbol='dot',sym_size=symsz)
		p01=plot(hetero_x,clrfra,name='clear',xrange=xrange,yrange=[0,1.2],xtitle='$log_{10}(H_{\sigma})$',$
			position=pos2,font_size=fontsz,/current,thick=lnthk,symbol='dot',sym_size=symsz)
		EndElse
		p1=plot(hetero_x,liqfre,name='liquid',overplot=p,color='purple',thick=lnthk,symbol='dot',sym_size=symsz)
		p2=plot(hetero_x,icefre,name='ice',overplot=p,color='red',thick=lnthk,symbol='dot',sym_size=symsz)
		p3=plot(hetero_x,underfre,name='undetermined',overplot=p,color='blue',thick=lnthk,symbol='dot',sym_size=symsz)
	
		p11=plot(hetero_x,liqfra,name='liquid',overplot=p01,color='purple',thick=lnthk,symbol='dot',sym_size=symsz)
		p12=plot(hetero_x,icefra,name='ice',overplot=p01,color='red',thick=lnthk,symbol='dot',sym_size=symsz)
		p13=plot(hetero_x,underfra,name='undertermined',overplot=p01,color='blue',thick=lnthk,symbol='dot',sym_size=symsz)
	
		p02=plot(hetero_x,liqclrfra,linestyle='dash',overplot=p01,thick=lnthk);,symbol='dot',sym_size=symsz)
		p21=plot(hetero_x,liqliqfra,linestyle='dash',overplot=p01,color='purple',thick=lnthk);,symbol='dot',sym_size=symsz)
		p22=plot(hetero_x,liqicefra,linestyle='dash',overplot=p01,color='red',thick=lnthk);,symbol='dot',sym_size=symsz)
		p23=plot(hetero_x,liqunderfra,linestyle='dash',overplot=p01,color='blue',thick=lnthk);,symbol='dot',sym_size=symsz)

		t1=text(pos1[0]+0.01,pos1[3]+0.01,subtitle1[mi],font_size=fontsz)
		t2=text(pos2[0]+0.01,pos2[3]+0.01,subtitle2[mi],font_size=fontsz)
 	    if mi eq 2 then ld=legend(target=[p3,p1,p2,p],position=[pos1[0]+0.175,pos1[3]],transparency=100,shadow=0,$
		thick=lnthk,sample_width=0.08,font_size=fontsz-1)
	EndIF
;for cloud occurrence
; 	data1=Tundernum/float(Tobsnum)
;	data2=Tclrnum/float(Tobsnum)
;	minvalue=0.0
;	maxvalue=0.5
;for sigma
	IF (sigmaflag eq 1) Then Begin
 	data1=Tobshetero/float(Tobsnum)
	data2=Ticehetero/float(Ticenum)
	data3=Tliqhetero/float(Tliqnum)
	minvalue=0.0
	maxvalue=.3
	maxvalue1=.5

	pos1=[posx1[mi],posy1[0],posx2[mi],posy2[0]]
	pos2=[posx1[mi],posy1[1],posx2[mi],posy2[1]]
	pos3=[posx1[mi],posy1[2],posx2[mi],posy2[2]]

	IF (mi eq 0) Then begin
	mp=map('Geographic',limit=maplimit,transparency=0,dimensions=[800,500],position=pos1)
 	grid=mp.MAPGRID
   	grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20

    c=image(data1,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
     max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
         rgb_table=33,overplot=mp,font_size=fontsz)
	mc=mapcontinents(/continents,transparency=30,fill_color='white')
	mc['Longitudes'].label_angle=0
	t1=text(pos1[0]+0.01,pos1[3]+0.0,subtitle1[mi],font_size=fontsz)

	EndIf else begin
	mp=map('Geographic',limit=maplimit,transparency=0,position=pos1,/current)
 	grid=mp.MAPGRID
   	grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20

    c=image(data1,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
     max_value=maxvalue,min_value=minvalue,title=subtitle[mi],$
         rgb_table=33,overplot=mp,font_size=fontsz)
	mc=mapcontinents(/continents,transparency=30,fill_color='white')
	mc['Longitudes'].label_angle=0
	t1=text(pos1[0]+0.01,pos1[3]+0.0,subtitle1[mi],font_size=fontsz)
	Endelse

	mp1=map('Geographic',limit=maplimit,transparency=0,position=pos2,/current)
 	grid=mp1.MAPGRID
   	grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20

    c2=image(data2,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
     max_value=maxvalue,min_value=minvalue,$
         rgb_table=33,overplot=mp1,font_size=fontsz)
	mc=mapcontinents(/continents,transparency=30,fill_color='white')
	mc['Longitudes'].label_angle=0
	t2=text(pos2[0]+0.01,pos2[3]+0.0,subtitle2[mi],font_size=fontsz)

	mp2=map('Geographic',limit=maplimit,transparency=0,position=pos3,/current)
 	grid=mp2.MAPGRID
   	grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20

    c3=image(data3,lon,lat, $ ;xrange=[min(lon1),max(lon1)],yrange=[min(lat1),max(lat1)],$
     max_value=maxvalue1,min_value=minvalue,$
         rgb_table=33,overplot=mp2,font_size=fontsz)
	mc=mapcontinents(/continents,transparency=30,fill_color='white')
	mc['Longitudes'].label_angle=0
	t2=text(pos3[0]+0.01,pos3[3]+0.0,subtitle3[mi],font_size=fontsz)
	
	EndIf ; endif sigma flag
 EndFor ; end month

 IF sigmaflag eq 1 then begin
 ct=colorbar(target=c,title=bartitle,font_size=fontsz,border=1,position=barpos1,orientation=1)
 ct1=colorbar(target=c3,title=bartitle,font_size=fontsz,border=1,position=barpos2,orientation=1)
 c.save,'modis_sigma_iceliqall0218.png'
 EndIf
 IF pdflag eq 1 then begin
 p.save,'modisphase_sigma_cf_pdf_0218.png'
 EndIf
stop
end	
