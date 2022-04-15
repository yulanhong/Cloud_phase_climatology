
pro plot_heteropdf_season
	
  allflag=1 ; for all pdf
  lnthick=1.2
  pdfflag=0 ; for seasonal pdf
  numflag=0
  hetflag=0
;  title=['Clear','Ice only','Ice above liquid','Ice above mixed','Liquid only','Mixed only']
  title=['Clear','Ice only','Liquid only','Mixed only','Ice above liquid','Ice above mixed']
  Ninterval=800
  fontsz=10
  
  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat/R05'
  subtitle=['MAM','JJA','SON','DJF']
  season=['MAM','JJA','SON','DJF']

  subtitle1=['a1)','a2)','a3)','a4)']
  subtitle2=['b1)','b2)','b3)','b4)']

  posx1=[0.05,0.29,0.53,0.77]
  posx2=[0.25,0.49,0.73,0.97]
  posy1=[0.67,0.32]
  posy2=[0.93,0.58]

  Thetero_pdf=0
  Tmodcldfra=0.0
  Tmodliqfra=0.0 
  Tmismatch=0L	

  For mi=0,3 Do Begin
	if (mi eq 0) then begin
	allfname1=file_search(datadir,'*03.hdf')
	allfname2=file_search(datadir,'*04.hdf')
	allfname3=file_search(datadir,'*05.hdf')
	endif
	if (mi eq 1) then begin
	allfname1=file_search(datadir,'*06.hdf')
	allfname2=file_search(datadir,'*07.hdf')
	allfname3=file_search(datadir,'*08.hdf')
  	endif
	if (mi eq 2) then begin
	allfname1=file_search(datadir,'*09.hdf')
	allfname2=file_search(datadir,'*10.hdf')
	allfname3=file_search(datadir,'*11.hdf')
  	endif
	if (mi eq 3) then begin
	allfname1=file_search(datadir,'*12.hdf')
	allfname2=file_search(datadir,'*01.hdf')
	allfname3=file_search(datadir,'*02.hdf')
	endif

    allfname=[allfname1,allfname2,allfname3]
	
 	Nf=n_elements(allfname)

    season_hetero_pdf=intarr(Ninterval,6)
	season_modcldfra=fltarr(Ninterval,6)
	season_modliqfra=fltarr(Ninterval,6)
    season_hetero_num=intarr(72,90,6)
	season_hetero_value=fltarr(72,90,6)
	season_mismatch=0

 	For fi=0,Nf-1 Do Begin

	IF (strlen(allfname[fi]) eq 130) Then Begin
	read_dardar,allfname[fi],'hetero_invertal',x
	read_dardar,allfname[fi],'hetero_spatial_num',hetero_num
	read_dardar,allfname[fi],'hetero_spatial',hetero_value

	season_hetero_num=season_hetero_num+hetero_num
	
	ind=where(finite(hetero_value) eq 0)
	hetero_value[ind]=0.0
	season_hetero_value=season_hetero_value+hetero_value*hetero_num
		
    read_dardar,allfname[fi],'subarea_hetero_pdf',hetero_pdf	
	season_hetero_pdf=season_hetero_pdf+hetero_pdf
	Thetero_pdf=Thetero_pdf+hetero_pdf

	read_dardar,allfname[fi],'subarea_modcldfracti',modcldfra
	read_dardar,allfname[fi],'subarea_modliqfracti',modliqfra

	ind=where(hetero_pdf eq 0)
	modcldfra[ind]=0.0
	modliqfra[ind]=0.0
	season_modcldfra=season_modcldfra+modcldfra*hetero_pdf
	season_modliqfra=season_modliqfra+modliqfra*hetero_pdf

	Tmodcldfra=Tmodcldfra+modcldfra*hetero_pdf
	Tmodliqfra=Tmodliqfra+modliqfra*hetero_pdf
		
	read_dardar,allfname[fi],'cldsatcld_modisliq',misnum
	season_mismatch=season_mismatch+misnum
	Tmismatch=Tmismatch+misnum
	EndIf ; end if file match
	EndFor ; end for reading file

    if pdfflag eq 1 then begin

	pos1=[posx1[mi]+0.015,posy1[0],posx2[mi],posy2[0]]
    pos2=[posx1[mi]+0.015,posy1[1]-0.02,posx2[mi],posy2[1]-0.02]

    clrfra=season_modcldfra[*,0]/season_hetero_pdf[*,0]
    icefra=season_modcldfra[*,1]/season_hetero_pdf[*,1]
    iceliqfra=season_modcldfra[*,2]/season_hetero_pdf[*,2]
    icemixfra=season_modcldfra[*,3]/season_hetero_pdf[*,3]
    liqfra=season_modcldfra[*,4]/season_hetero_pdf[*,4]
    mixfra=season_modcldfra[*,5]/season_hetero_pdf[*,5]

    ;for i=0,5 do print, subtitle+title[i]+' fre',total(season_hetero_pdf[*,i])/total(season_hetero_pdf)	

    ;liquid cloud fraction for each pixel in a 5x5 pixels region
    clrfra1=season_modliqfra[*,0]/season_hetero_pdf[*,0]
    icefra1=season_modliqfra[*,1]/season_hetero_pdf[*,1]
    iceliqfra1=season_modliqfra[*,2]/season_hetero_pdf[*,2]
    icemixfra1=season_modliqfra[*,3]/season_hetero_pdf[*,3]
    liqfra1=season_modliqfra[*,4]/season_hetero_pdf[*,4]
    mixfra1=season_modliqfra[*,5]/season_hetero_pdf[*,5]
	yrange=[0,2.5]
	xrange=[-4,1]
	lnthick=1.0
    If mi eq 0 then begin
  	p=plot(x,float(season_hetero_pdf[*,0])*100/total(season_hetero_pdf[*,0]),xrange=xrange,xlog=0,thick=lnthick,dim=[850,400],$
	name='Clear',histogram=1,title=subtitle[mi],yrange=yrange,font_size=fontsz,$
	xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency(%)',position=pos1,xticklen=0.03,yticklen=0.03)
	p01=plot(x,clrfra,name='clear',xrange=xrange,yrange=[0,1.2],xtitle='$log_{10}(H_{\sigma})$',$
             ytitle='Cloud Fraction',position=pos2,font_size=fontsz,/current,thick=lnthk,xticklen=0.03,yticklen=0.03)
	EndIf else begin	
  	p=plot(x,float(season_hetero_pdf[*,0])*100/total(season_hetero_pdf[*,0]),xrange=xrange,xlog=0,thick=lnthick,$
	name='Clear',histogram=1,title=subtitle[mi],yrange=yrange,font_size=fontsz,$
	xtitle='$log_{10}(H_{\sigma})$',position=pos1,/current,xticklen=0.03,yticklen=0.03)
	p01=plot(x,clrfra,name='clear',xrange=xrange,yrange=[0,1.2],xtitle='$log_{10}(H_{\sigma})$',$
             position=pos2,font_size=fontsz,/current,thick=lnthk,xticklen=0.03,yticklen=0.03)
	Endelse
  	p1=plot(x,float(season_hetero_pdf[*,1])*100/total(season_hetero_pdf[*,1]),thick=lnthick,color='r',overplot=p,name='Ice',histogram=1)
  	p2=plot(x,float(season_hetero_pdf[*,2])*100/total(season_hetero_pdf[*,2]),thick=lnthick,color='g',overplot=p,name='Ice-liquid',histogram=1)
  	p3=plot(x,float(season_hetero_pdf[*,3])*100/total(season_hetero_pdf[*,3]),thick=lnthick,color='b',overplot=p,name='Ice-mix',histogram=1)
  	p4=plot(x,float(season_hetero_pdf[*,4])*100/total(season_hetero_pdf[*,4]),thick=lnthick,color='purple',overplot=p,name='Liquid',histogram=1)
  	p5=plot(x,float(season_hetero_pdf[*,5])*100/total(season_hetero_pdf[*,5]),thick=lnthick,color='grey',overplot=p,name='Mix',histogram=1)

	p11=plot(x,icefra,thick=lnthick,color='r',overplot=p01)
	p12=plot(x,iceliqfra,thick=lnthick,color='g',overplot=p01)
	p13=plot(x,icemixfra,thick=lnthick,color='b',overplot=p01)
	p14=plot(x,liqfra,thick=lnthick,color='purple',overplot=p01)
	p15=plot(x,mixfra,thick=lnthick,color='grey',overplot=p01)

	p21=plot(x,clrfra1,thick=lnthick,linestyle='dash',color='black',overplot=p01)
	p21=plot(x,icefra1,thick=lnthick,linestyle='dash',color='r',overplot=p01)
	p22=plot(x,iceliqfra1,thick=lnthick,linestyle='dash',color='g',overplot=p01)
	p23=plot(x,icemixfra1,thick=lnthick,linestyle='dash',color='b',overplot=p01)
	p24=plot(x,liqfra1,thick=lnthick,linestyle='dash',color='purple',overplot=p01)
	p25=plot(x,mixfra1,thick=lnthick,linestyle='dash',color='grey',overplot=p01)
  	endif

  	lon=(findgen(72))*5-180
  	lat=(findgen(90))*2-90
  	maplimit=[-40,70,40,160]
;
  if numflag eq 1 then begin
	tnum=total(season_hetero_num,3)
	for i=0,5 do begin
	mp=map('Geographic',limit=maplimit,transparency=30,dimensions=[700,700],position=pos)
	c=image(reform(season_hetero_num[*,*,i])/tnum,lon,lat,rgb_table=33,overplot=mp,min_value=0.0,$
		max_value=1.0,title=title[i]+' '+season[mi])
    ct=colorbar(target=c,title='Occurrence Frequency')
	mc=mapcontinents(/continents,transparency=30)
	;c.save,'heterogeneity_number_'+title[i]+'200708.png'
	
	endfor
  endif
;
  avehetero=season_hetero_value/season_hetero_num
  minvalue=floor(min(avehetero,/nan))
  maxvalue=ceil(max(avehetero,/nan))

  ind=where(season_hetero_num eq 0)
  avehetero[ind]=2

  if hetflag eq 1 then begin
	minvalue=0.0
	maxvalue=0.5
	for i=0,5 do begin
	mp=map('Geographic',limit=maplimit,transparency=30,dimensions=[700,700],position=pos)
	c=image(reform(avehetero[*,*,i]),lon,lat,rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue,title=title[i]+' '+season[mi])
    ct=colorbar(target=c,title='$H_\sigma$',border=1)
	mc=mapcontinents(/continents,transparency=0);,fill_color='grey')
;	c.save,'heterogeneity_'+title[i]+'200708.png'
	
	endfor

  endif
  EndFor ; end for season
 
 IF allflag eq 1 then begin
  		xrange=[-4,0]
        yrange=[0,2.5]
		yrange1=[0,1.2]
		pos1=[0.2,0.72,0.9,0.97]
		pos2=[0.2,0.41,0.9,0.66]
		pos3=[0.2,0.10,0.9,0.35]
;	   	pos1=[0.10,0.60,0.44,0.95]
;   	pos2=[0.53,0.60,0.89,0.95]
;   	pos3=[0.10,0.10,0.44,0.50]
;   	pos4=[0.53,0.10,0.89,0.50]
;		pos1=[0.11,0.15,0.36,0.95]
;		pos2=[0.43,0.15,0.66,0.95]
;		pos3=[0.73,0.15,0.98,0.95]

		lnthk=2		
		symsz=1.3
		fontsz=11

		; cloudsat-calipso clear, but modis cloudy
		mismatch_fre=Tmismatch/float(Thetero_pdf[*,0])

        ; cloud fraction for each pixel in a 5x5 pixels region
        clrfra=Tmodcldfra[*,0]/Thetero_pdf[*,0]
        icefra=Tmodcldfra[*,1]/Thetero_pdf[*,1]
        iceliqfra=Tmodcldfra[*,2]/Thetero_pdf[*,2]
        icemixfra=Tmodcldfra[*,3]/Thetero_pdf[*,3]
        liqfra=Tmodcldfra[*,4]/Thetero_pdf[*,4]
        mixfra=Tmodcldfra[*,5]/Thetero_pdf[*,5]

        ;liquid cloud fraction for each pixel in a 5x5 pixels region
        clrfra1=Tmodliqfra[*,0]/Thetero_pdf[*,0]
        icefra1=Tmodliqfra[*,1]/Thetero_pdf[*,1]
        iceliqfra1=Tmodliqfra[*,2]/Thetero_pdf[*,2]
        icemixfra1=Tmodliqfra[*,3]/Thetero_pdf[*,3]
		icemixfra1[604]=!values.f_nan
        liqfra1=Tmodliqfra[*,4]/Thetero_pdf[*,4]
        mixfra1=Tmodliqfra[*,5]/Thetero_pdf[*,5]

        clrfre=Thetero_pdf[*,0]*100/float(total(Thetero_pdf[*,0]))
        icefre=Thetero_pdf[*,1]*100/float(total(Thetero_pdf[*,1]))
        iceliqfre=Thetero_pdf[*,2]*100/float(total(Thetero_pdf[*,2]))
        icemixfre=Thetero_pdf[*,3]*100/float(total(Thetero_pdf[*,3]))
        liqfre=Thetero_pdf[*,4]*100/float(total(Thetero_pdf[*,4]))
        mixfre=Thetero_pdf[*,5]*100/float(total(Thetero_pdf[*,5]))

		ind=where(clrfre eq 0.0)
		clrfre[ind]=!values.f_nan
  		p=plot(x,clrfre,xrange=xrange,xlog=0,thick=lnthk,dim=[335,520],$
		name='Clear',yrange=yrange,font_size=fontsz,position=pos1,$
		xtitle='',ytitle='Frequency(%)',$
		symbol='dot',sym_size=symsz,xticklen=0.02,yticklen=0.02,color='cyan')
		;x=10.0^x
	
		ind=where(icefre eq 0.0)
		icefre[ind]=!values.f_nan
        p1=plot(x,icefre,name='Ice only',overplot=p,color='lime',thick=lnthk,symbol='dot',sym_size=symsz,$
			xlog=0)
		ind=where(iceliqfre eq 0.0)
		iceliqfre[ind]=!values.f_nan
		p2=plot(x,iceliqfre,name='Ice above liquid',overplot=p,color='r',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(icemixfre eq 0.0)
		icemixfre[ind]=!values.f_nan
		p3=plot(x,icemixfre,name='Ice above mixed',overplot=p,color='purple',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(liqfre eq 0.0)
		liqfre[ind]=!values.f_nan
		p4=plot(x,liqfre,name='Liquid only',overplot=p,color='blue',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(mixfre eq 0.0)
		mixfre[ind]=!values.f_nan
		p5=plot(x,mixfre,name='Mixed only',overplot=p,color='dark orange',thick=lnthk,symbol='dot',sym_size=symsz)
		t1=text(pos1[0]+0.03,pos1[3]-0.03,'a)CC Cloud',font_size=fontsz)

		; plot mismatch number
		;p03=plot(x,mismatch_fre,thick=lnthick,/current,xticklen=0.01,$
        ;  yrange=[0,0.5],font_size=fontsz,position=pos2,yticklen=0.01,$
        ;  xtitle='$log_{10}(H_{\sigma})$', ytitle='Mismatch ratio',$
		;  symbol='dot',sym_size=symsz,xrange=xrange)
		;ax=p03.axes
		;ax[3].hide=1
		;ind=where(Tmismatch eq 0)
		;Tmismatch[ind]=!values.f_nan
	    ;p031=plot(x,Tmismatch,symbol='dot',sym_size=symsz,color='grey',$
		;	yrange=[0,2000],axis_style=0,position=p03.position,/current,xrange=xrange)	
		;a1=axis('y',target=p031,location=[max(p03.xrange),0,0],textpos=1,tickdir=1,$
		;	ticklen=0.01,color='grey',title='Mismatch number')
		; to obtain the frction of CC samples identified as modis liquid
		xind=where(x ge -1)	
;		for i=0,5 do print, total(Tmismatch[i,xind])/total(Thetero_pdf[xind,i])

;		; plot cloud fraction
;		ind=where(clrfra eq 0.0)
;		clrfra[ind]=!values.f_nan
;  		p01=plot(x,clrfra,xrange=xrange,xlog=0,thick=lnthick,/current,xticklen=0.01,$
;		name='Clear',yrange=yrange1,font_size=fontsz,position=pos2,yticklen=0.01,$
;		xtitle='$log_{10}(H_{\sigma})$', ytitle='Cloud Fraction',symbol='dot',sym_size=symsz,color='cyan')
;		t2=text(pos2[0]+0.03,pos2[3]-0.03,'b)',font_size=fontsz)
;		ind=where(icefra eq 0.0)
;		icefra[ind]=!values.f_nan
;        p11=plot(x,icefra,name='Ice',overplot=p01,color='lime',thick=lnthk,symbol='dot',sym_size=symsz)
;		ind=where(iceliqfra eq 0.0)
;		iceliqfra[ind]=!values.f_nan
;		p12=plot(x,iceliqfra,name='Ice-Liquid',overplot=p01,color='r',thick=lnthk,symbol='dot',sym_size=symsz)
;		ind=where(icemixfra eq 0.0)
;		icemixfra[ind]=!values.f_nan
;		p13=plot(x,icemixfra,name='Ice-Mixed',overplot=p01,color='purple',thick=lnthk,symbol='dot',sym_size=symsz)
;		ind=where(liqfra eq 0.0)
;		liqfra[ind]=!values.f_nan
;		p14=plot(x,liqfra,name='Liquid',overplot=p01,color='blue',thick=lnthk,symbol='dot',sym_size=symsz)
;		ind=where(mixfra eq 0.0)
;		mixfra[ind]=!values.f_nan
;		p15=plot(x,mixfra,name='Mixed',overplot=p01,color='dark orange',thick=lnthk,symbol='dot',sym_size=symsz)
;		t2=text(pos2[0]+0.03,pos2[3]-0.03,'b) All cloud',font_size=fontsz)

		pdf2cdf,reform(Thetero_pdf[*,0]),clrcdf1
		clrcdf=100*float(clrcdf1)/clrcdf1[n_elements(clrcdf1)-1]	
  		p01=plot(x,clrcdf,xrange=xrange,thick=lnthick,/current,xticklen=0.01,$
		name='Clear',yrange=[0,100],font_size=fontsz,position=pos2,yticklen=1,yminor=0,ygridstyle=1,$
		color='cyan',$
		xtitle='',ytitle='Frequency (%)',symbol='dot',sym_size=symsz,xlog=0)

		pdf2cdf,reform(Thetero_pdf[*,1]),icecdf1	
		icecdf=100*float(icecdf1)/icecdf1[n_elements(icecdf1)-1]
        p11=plot(x,icecdf,name='Ice',overplot=p01,color='lime',thick=lnthk,symbol='dot',sym_size=symsz)

		pdf2cdf,reform(Thetero_pdf[*,2]),iceliqcdf1	
		iceliqcdf=100*float(iceliqcdf1)/iceliqcdf1[n_elements(iceliqcdf1)-1]
        p21=plot(x,iceliqcdf,name='Ice',overplot=p01,color='r',thick=lnthk,symbol='dot',sym_size=symsz)

		pdf2cdf,reform(Thetero_pdf[*,3]),icemixcdf1	
		icemixcdf=100*float(icemixcdf1)/icemixcdf1[n_elements(icemixcdf1)-1]
        p31=plot(x,icemixcdf,name='Ice',overplot=p01,color='purple',thick=lnthk,symbol='dot',sym_size=symsz)

		pdf2cdf,reform(Thetero_pdf[*,4]),liqcdf1	
		liqcdf=100*float(liqcdf1)/liqcdf1[n_elements(icemixcdf1)-1]
        p41=plot(x,liqcdf,name='Ice',overplot=p01,color='blue',thick=lnthk,symbol='dot',sym_size=symsz)

		pdf2cdf,reform(Thetero_pdf[*,5]),mixcdf1	
		mixcdf=100*float(mixcdf1)/mixcdf1[n_elements(icemixcdf1)-1]
        p51=plot(x,mixcdf,name='Ice',overplot=p01,color='dark orange',thick=lnthk,symbol='dot',sym_size=symsz)
		t2=text(pos2[0]+0.03,pos2[3]-0.03,'b) CC cloud',font_size=fontsz)

		ind=where(clrfra1 eq 0.0)
		clrfra1[ind]=!values.f_nan
  		p02=plot(x,clrfra1,xrange=xrange,thick=lnthick,/current,xticklen=0.01,$
		name='Clear',yrange=yrange1,font_size=fontsz,position=pos3,yticklen=0.01,color='cyan',$
		xtitle='$log_{10}(H_{\sigma})$',ytitle='Cloud Fraction',symbol='dot',sym_size=symsz,xlog=0)

		ind=where(icefra1 eq 0.0)
		icefra1[ind]=!values.f_nan
        p21=plot(x,icefra1,name='Ice',overplot=p02,color='lime',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(iceliqfra1 eq 0.0)
		iceliqfra1[ind]=!values.f_nan
		p22=plot(x,iceliqfra1,name='Ice-Liquid',overplot=p02,color='r',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(icemixfra1 eq 0.0)
		icemixfra1[ind]=!values.f_nan
		p23=plot(x,icemixfra1,name='Ice-Mixed',overplot=p02,color='purple',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(liqfra1 eq 0.0)
		liqfra1[ind]=!values.f_nan
		p24=plot(x,liqfra1,name='Liquid',overplot=p02,color='blue',thick=lnthk,symbol='dot',sym_size=symsz)
		ind=where(mixfra1 eq 0.0)
		mixfra1[ind]=!values.f_nan
		p25=plot(x,mixfra1,name='Mixed',overplot=p02,color='dark orange',thick=lnthk,symbol='dot',sym_size=symsz)
		t3=text(pos3[0]+0.03,pos3[3]-0.03,'c) MODIS Liquid Cloud',font_size=fontsz)
  	
	ld=legend(target=[p,p1,p2,p3,p4,p5],position=[0.66,0.94],transparency=100,sample_width=0.08,$
		shadow=0,vertical_spacing=0.008,font_size=fontsz-1.5)
	p.save,'CCM_pdf_heteroall_cf_pdfcdf_newdomain_R05.png'
	stop
 endif

 If pdfflag eq 1 then begin
  	ld=legend(target=[p,p1,p2,p3,p4,p5],position=[0.5,0.7])
	p.save,'CCM_pdf_heteroseaon_cf_newdomain_R05.png'
 EndIf 
  stop

end
