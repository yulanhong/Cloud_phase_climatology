pro plot_water_profile,region

	Nh=125
	hgt=25-findgen(Nh)*0.24	
	season=['MAM','JJA','SON','DJF']
    pos1=[0.10,0.6,0.50,0.95]
    pos2=[0.55,0.6,0.95,0.95]
    pos3=[0.10,0.15,0.50,0.50]
    pos4=[0.55,0.15,0.95,0.50]
	title=['a)','b)','c)','d)']

	aveiwc=fltarr(4,125,4) ;rank 3 for four season
	aveire=fltarr(4,125,4)
	avelwc=fltarr(4,125,4)
	avelre=fltarr(4,125,4)
	lncolor=['black','r','b','grey']
	yrange=[1,20]
	ytitle='Altitude (km)'
	
	For mi=0,3 Do Begin
	
	icefname=region+'_icecloud_profile_'+season[mi]+'.txt'
	data=read_ascii(icefname,data_start=1)
	icdata=data.(0)
	aveiwc[*,*,mi]=icdata[1:4,*]
	aveire[*,*,mi]=icdata[5:8,*]
	icfre=float(icdata[0,*])/float(icdata[1,*])

	icnumfname=region+'_ice_profile_num_'+season[mi]+'.sav'  
	restore,icnumfname
	icenumv=Ticenumv2
	
	liqfname=region+'_liquidcloud_profile_'+season[mi]+'.txt'
	data=read_ascii(liqfname,data_start=1)
	wcdata=data.(0)
	avelwc[*,*,mi]=wcdata[1:4,*]
	avelre[*,*,mi]=wcdata[5:8,*]
	print,liqfname,icefname

	liqnumfname=region+'_liq_profile_num_'+season[mi]+'.sav'  
	restore,liqnumfname
	liqnumv=Tliqnumv2

	EndFor

	;to get average and standard deviation
	meaniwc=fltarr(4,125) 
	meanire=fltarr(4,125)
	meanlwc=fltarr(4,125)
	meanlre=fltarr(4,125)
	
	stdiwc=fltarr(4,125) 
	stdire=fltarr(4,125)
	stdlwc=fltarr(4,125)
	stdlre=fltarr(4,125)

	for hi=0,124 do begin
		meaniwc[0,hi]=mean(reform(aveiwc[0,hi,*]))
		meaniwc[1,hi]=mean(reform(aveiwc[1,hi,*]))
		meaniwc[2,hi]=mean(reform(aveiwc[2,hi,*]))
		meaniwc[3,hi]=mean(reform(aveiwc[3,hi,*]))

		stdiwc[0,hi]=stddev(reform(aveiwc[0,hi,*]))
		stdiwc[1,hi]=stddev(reform(aveiwc[1,hi,*]))
		stdiwc[2,hi]=stddev(reform(aveiwc[2,hi,*]))
		stdiwc[3,hi]=stddev(reform(aveiwc[3,hi,*]))

		meanire[0,hi]=mean(reform(aveire[0,hi,*]))
		meanire[1,hi]=mean(reform(aveire[1,hi,*]))
		meanire[2,hi]=mean(reform(aveire[2,hi,*]))
		meanire[3,hi]=mean(reform(aveire[3,hi,*]))

		stdire[0,hi]=stddev(reform(aveire[0,hi,*]))
		stdire[1,hi]=stddev(reform(aveire[1,hi,*]))
		stdire[2,hi]=stddev(reform(aveire[2,hi,*]))
		stdire[3,hi]=stddev(reform(aveire[3,hi,*]))

		meanlwc[0,hi]=mean(reform(avelwc[0,hi,*]))
		meanlwc[1,hi]=mean(reform(avelwc[1,hi,*]))
		meanlwc[2,hi]=mean(reform(avelwc[2,hi,*]))
		meanlwc[3,hi]=mean(reform(avelwc[3,hi,*]))

		stdlwc[0,hi]=stddev(reform(avelwc[0,hi,*]))
		stdlwc[1,hi]=stddev(reform(avelwc[1,hi,*]))
		stdlwc[2,hi]=stddev(reform(avelwc[2,hi,*]))
		stdlwc[3,hi]=stddev(reform(avelwc[3,hi,*]))

		meanlre[0,hi]=mean(reform(avelre[0,hi,*]))
		meanlre[1,hi]=mean(reform(avelre[1,hi,*]))
		meanlre[2,hi]=mean(reform(avelre[2,hi,*]))
		meanlre[3,hi]=mean(reform(avelre[3,hi,*]))

		stdlre[0,hi]=stddev(reform(avelre[0,hi,*]))
		stdlre[1,hi]=stddev(reform(avelre[1,hi,*]))
		stdlre[2,hi]=stddev(reform(avelre[2,hi,*]))
		stdlre[3,hi]=stddev(reform(avelre[3,hi,*]))
	endfor

	yerr=fltarr(125)	
	yrange=[1,20]
	lnthk=2
	capsize=0.01
	fontsz=13

    piwc=plot(meaniwc[0,*],hgt,position=pos1,color='black',xrange=[0,0.4],yrange=yrange,/current,$
		dim=[700,700],ytitle=ytitle,xtitle='IWC (g $m^{-3}$)',thick=lnthk,name='ice') ;,sym_transparency=70,/nodata)
    piwcer=errorplot(meaniwc[0,*],hgt,stdiwc[0,*],yerr,color='black',errorbar_capsize=capsize,overplot=piwc,transparency=70)

    piwc1=plot(meaniwc[1,*],hgt,overplot=piwc,color='r',thick=lnthk,name='ice-liquid')
    piwcer1=errorplot(meaniwc[1,*],hgt,stdiwc[1,*],yerr,color='r',errorbar_capsize=capsize,overplot=piwc1,transparency=70)

    piwc2=plot(meaniwc[2,*],hgt,overplot=piwc,color='g',thick=lnthk,name='ice-mix')
    piwcer2=errorplot(meaniwc[2,*],hgt,stdiwc[2,*],yerr,color='g',errorbar_capsize=capsize,overplot=piwc2,transparency=70)

    piwc3=plot(meaniwc[3,*],hgt,overplot=piwc,color='b',thick=lnthk,name='mix')
    piwcer3=errorplot(meaniwc[3,*],hgt,stdiwc[3,*],yerr,color='b',errorbar_capsize=capsize,overplot=piwc2,transparency=70)
	ld=legend(target=[piwc,piwc1,piwc2,piwc3],position=[0.4,0.95])
	t1=text(pos1[0]+0.02,pos1[3]+0.01,'a)',font_size=fontsz)

    pire=plot(meanire[0,*],hgt,position=pos2,color='black',xrange=[0,50],yrange=yrange,/current,$
		ytitle='',xtitle='Ice Re ($\mu m$)',thick=lnthk) ;,sym_transparency=70,/nodata)
    pireer=errorplot(meanire[0,*],hgt,stdire[0,*],yerr,color='black',errorbar_capsize=capsize,overplot=pire,transparency=70)

    pire1=plot(meanire[1,*],hgt,overplot=pire,color='r',thick=lnthk)
    pireer1=errorplot(meanire[1,*],hgt,stdire[1,*],yerr,color='r',errorbar_capsize=capsize,overplot=pire1,transparency=70)

    pire2=plot(meanire[2,*],hgt,overplot=pire,color='g',thick=lnthk)
    pireer2=errorplot(meanire[2,*],hgt,stdire[2,*],yerr,color='g',errorbar_capsize=capsize,overplot=pire2,transparency=70)

    pire3=plot(meanire[3,*],hgt,overplot=pire,color='b',thick=lnthk)
    pireer3=errorplot(meanire[3,*],hgt,stdire[3,*],yerr,color='b',errorbar_capsize=capsize,overplot=pire3,transparency=70)
	t2=text(pos2[0]+0.02,pos2[3]+0.01,'b)',font_size=fontsz)

    plwc=plot(meanlwc[0,*],hgt,position=pos3,color='black',xrange=[0,0.3],yrange=yrange,/current,$
		ytitle='',xtitle='LWC (g $m^{-3}$)',thick=lnthk,name='liquid') ;,sym_transparency=70,/nodata)
    plwcer=errorplot(meanlwc[0,*],hgt,stdlwc[0,*],yerr,color='black',errorbar_capsize=capsize,overplot=plwc,transparency=70)

    plwc1=plot(meanlwc[1,*],hgt,overplot=plwc,color='r',thick=lnthk,name='ice-liquid')
    plwcer1=errorplot(meanlwc[1,*],hgt,stdlwc[1,*],yerr,color='r',errorbar_capsize=capsize,overplot=plwc1,transparency=70)

    plwc2=plot(meanlwc[2,*],hgt,overplot=plwc,color='g',thick=lnthk,name='ice-mix')
    plwcer2=errorplot(meanlwc[2,*],hgt,stdlwc[2,*],yerr,color='g',errorbar_capsize=capsize,overplot=plwc2,transparency=70)

    plwc3=plot(meanlwc[3,*],hgt,overplot=plwc,color='b',thick=lnthk,name='mix')
    plwcer3=errorplot(meanlwc[3,*],hgt,stdlwc[3,*],yerr,color='b',errorbar_capsize=capsize,overplot=plwc2,transparency=70)
	ld=legend(target=[plwc,plwc1,plwc2,plwc3],position=[0.4,0.5])
	t3=text(pos3[0]+0.02,pos3[3]+0.01,'c)',font_size=fontsz)


    plre=plot(meanlre[0,*],hgt,position=pos4,color='black',xrange=[0,10],yrange=yrange,/current,$
		ytitle=ytitle,xtitle='Liquid Re ($\mu m$)',thick=lnthk) ;,sym_transparency=70,/nodata)
    plreer=errorplot(meanlre[0,*],hgt,stdlre[0,*],yerr,color='black',errorbar_capsize=capsize,overplot=plre,transparency=70)

    plre1=plot(meanlre[1,*],hgt,overplot=plre,color='r',thick=lnthk)
    plreer1=errorplot(meanlre[1,*],hgt,stdlre[1,*],yerr,color='r',errorbar_capsize=capsize,overplot=plre1,transparency=70)

    plre2=plot(meanlre[2,*],hgt,overplot=plre,color='g',thick=lnthk)
    plreer2=errorplot(meanlre[2,*],hgt,stdlre[2,*],yerr,color='g',errorbar_capsize=capsize,overplot=plre2,transparency=70)

    plre3=plot(meanlre[3,*],hgt,overplot=plre,color='b',thick=lnthk)
    plreer3=errorplot(meanlre[3,*],hgt,stdlre[3,*],yerr,color='b',errorbar_capsize=capsize,overplot=plre3,transparency=70)
	t4=text(pos4[0]+0.02,pos4[3]+0.01,'d)',font_size=fontsz)

   	piwc.save,region+'_water_re_profile.png'
	stop
end
