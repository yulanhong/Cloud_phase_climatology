
pro plot_hetero_mjo
	
  lnthick=1.2
  cldmjo_flag=0 ;to get average H_\sigma for each cloud phase as a function of mjo
  pdfflag=0
  numflag=0
  hetflag=0
  mjo_flag=1 ; do not show seasonality
  title=['1','2','3','4','5','6','7','8']
  Ninterval=800
  fontsz=12
  
  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/MJO/CCM/R05'
  subtitle=['MAM','JJA','SON','DJF']
  season=['MAM','JJA','SON','DJF']

  subtitle1=['a1)','a2)','a3)','a4)']
  subtitle2=['b1)','b2)','b3)','b4)']

  posx1=[0.05,0.29,0.53,0.77]
  posx2=[0.25,0.49,0.73,0.97]
  posy1=[0.67,0.32]
  posy2=[0.93,0.58]

  Thetero_pdf=0
  Thetero_num=0.0
  Thetero_value=0.0 
  Tcldphase_mjo=0L

  For mi=0,3 Do Begin
	if (mi eq 0) then begin
	allfname1=file_search(datadir,'*03_strongmjo.hdf')
	allfname2=file_search(datadir,'*04_strongmjo.hdf')
	allfname3=file_search(datadir,'*05_strongmjo.hdf')
	endif
	if (mi eq 1) then begin
	allfname1=file_search(datadir,'*06_strongmjo.hdf')
	allfname2=file_search(datadir,'*07_strongmjo.hdf')
	allfname3=file_search(datadir,'*08_strongmjo.hdf')
  	endif
	if (mi eq 2) then begin
	allfname1=file_search(datadir,'*09_strongmjo.hdf')
	allfname2=file_search(datadir,'*10_strongmjo.hdf')
	allfname3=file_search(datadir,'*11_strongmjo.hdf')
  	endif
	if (mi eq 3) then begin
	allfname1=file_search(datadir,'*12_strongmjo.hdf')
	allfname2=file_search(datadir,'*01_strongmjo.hdf')
	allfname3=file_search(datadir,'*02_strongmjo.hdf')
	endif

    allfname=[allfname1,allfname2,allfname3]
	
 	Nf=n_elements(allfname)

    season_hetero_pdf=intarr(Ninterval,8)
    season_hetero_num=intarr(72,90,8)
	season_hetero_value=fltarr(72,90,8)

 	For fi=0,Nf-1 Do Begin
	IF strlen(allfname[fi]) eq 114 Then Begin
	read_dardar,allfname[fi],'hetero_invertal',x
	read_dardar,allfname[fi],'hetero_spatial_num',hetero_num
	read_dardar,allfname[fi],'hetero_spatial',hetero_value
	read_dardar,allfname[fi],'subarea_cldphase_fre',cldphase_fre

	season_hetero_num=season_hetero_num+hetero_num
	
	ind=where(finite(hetero_value) eq 0)
	hetero_value[ind]=0.0
	season_hetero_value=season_hetero_value+hetero_value*hetero_num
		
    read_dardar,allfname[fi],'subarea_hetero_pdf',hetero_pdf	
	season_hetero_pdf=season_hetero_pdf+hetero_pdf

	Thetero_pdf=Thetero_pdf+hetero_pdf
	Thetero_value=Thetero_value+hetero_value*hetero_num
	Thetero_num=Thetero_num+hetero_num
	Tcldphase_mjo=Tcldphase_mjo+cldphase_fre	
	print,total(hetero_num),allfname[fi]
	EndIf	
	EndFor ; end for reading file

    if pdfflag eq 1 then begin

	pos1=[posx1[mi]+0.015,posy1[0],posx2[mi],posy2[0]]
    pos2=[posx1[mi]+0.015,posy1[1]-0.02,posx2[mi],posy2[1]-0.02]


    for i=0,7 do print, subtitle+title[i]+' fre',total(season_hetero_pdf[*,i])/total(season_hetero_pdf)	

	yrange=[0,1.2]
	xrange=[-4,1]
    If mi eq 0 then begin
  	p=plot(x,float(season_hetero_pdf[*,0])*100/total(season_hetero_pdf[*,0]),xrange=xrange,xlog=0,thick=lnthick,dim=[850,400],$
	name='1',histogram=1,title=subtitle[mi],yrange=yrange,font_size=fontsz,$
	xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency(%)',position=pos1)
	EndIf else begin	
  	p=plot(x,float(season_hetero_pdf[*,0])*100/total(season_hetero_pdf[*,0]),xrange=xrange,xlog=0,thick=lnthick,$
	name='1',histogram=1,title=subtitle[mi],yrange=yrange,font_size=fontsz,$
	xtitle='$log_{10}(H_{\sigma})$',position=pos1,/current)
	Endelse
  	p1=plot(x,float(season_hetero_pdf[*,1])*100/total(season_hetero_pdf[*,1]),thick=lnthick,color='r',overplot=p,name='2',histogram=1)
  	p2=plot(x,float(season_hetero_pdf[*,2])*100/total(season_hetero_pdf[*,2]),thick=lnthick,color='g',overplot=p,name='3',histogram=1)
  	p3=plot(x,float(season_hetero_pdf[*,3])*100/total(season_hetero_pdf[*,3]),thick=lnthick,color='b',overplot=p,name='4',histogram=1)
  	p4=plot(x,float(season_hetero_pdf[*,4])*100/total(season_hetero_pdf[*,4]),thick=lnthick,color='purple',overplot=p,name='5',histogram=1)
  	p5=plot(x,float(season_hetero_pdf[*,5])*100/total(season_hetero_pdf[*,5]),thick=lnthick,color='grey',overplot=p,name='6',histogram=1)
  	p6=plot(x,float(season_hetero_pdf[*,6])*100/total(season_hetero_pdf[*,6]),thick=lnthick,color='dark orange',overplot=p,name='7',histogram=1)
  	p7=plot(x,float(season_hetero_pdf[*,7])*100/total(season_hetero_pdf[*,7]),thick=lnthick,color='pink',overplot=p,name='8',histogram=1)

  	endif

  	lon=(findgen(72))*5-180
  	lat=(findgen(90))*2-90
  	maplimit=[-30,70,40,160]
;
  if numflag eq 1 then begin
	tnum=total(season_hetero_num,3)
	for i=0,7 do begin
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
	maxvalue=0.3
	for i=0,7 do begin
	mp=map('Geographic',limit=maplimit,transparency=30,dimensions=[700,700],position=pos)
	c=image(reform(avehetero[*,*,i]),lon,lat,rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue,title=title[i]+' '+season[mi])
    ct=colorbar(target=c,title='$H_\sigma$',border=1)
	mc=mapcontinents(/continents,transparency=0);,fill_color='grey')
;	c.save,'heterogeneity_'+title[i]+'200708.png'
	
	endfor

  endif
  EndFor ; end for season

 ; to obtain h_\sigma of each cloud phase as a function of MJO phase
 IF cldmjo_flag eq 1 then begin
	maplimit=[-10,80,30,150]
 	ind1=where(lat ge maplimit[0] and lat le maplimit[2],count)
    Nlat=count
	ind2=where(lon ge maplimit[1] and lon le maplimit[3],count)
	Nlon=count
	Thetero_value1=Thetero_value[ind2[0]:ind2[Nlon-1],ind1[0]:ind1[Nlat-1],*,*]
	Thetero_num1=Thetero_num[ind2[0]:ind2[Nlon-1],ind1[0]:ind1[Nlat-1],*,*]
	Thetero_value2=total(Thetero_value1,1)
	Thetero_value3=total(Thetero_value2,1)
	Thetero_num2 = total(Thetero_num1,1)
	Thetero_num3 = total(Thetero_num2,1)	
	avehetero=Thetero_value3/Thetero_num3
	symsz=2
	lnthk=2
	color=['lime','green','dark orange','blue','grey','red','purple','Cyan']
	x=findgen(8)+1
	p=plot(x,avehetero[*,0],color='lime',name='Ice only',thick=lnthk,symbol='Circle',$
		xrange=[0,9],yrange=[0,0.25],sym_filled=1,sym_thick=symsz,xtitle='MJO phase',ytitle='$H_\sigma$')
	p1=plot(x,avehetero[*,2],color='blue',name='Liquid only',overplot=p,thick=lnthk,symbol='Circle',sym_filled=1,sym_thick=symsz)	
	p2=plot(x,avehetero[*,1],color='dark orange',name='Mixed only',overplot=p,thick=lnthk,symbol='Circle',sym_filled=1,sym_thick=symsz)	
	p3=plot(x,avehetero[*,3],color='red',name='Ice above liquid',overplot=p,thick=lnthk,symbol='Circle',sym_filled=1,sym_thick=symsz)	
	p4=plot(x,avehetero[*,4],color='purple',name='Ice above mixed',overplot=p,thick=lnthk,symbol='Circle',sym_filled=1,sym_thick=symsz)	
	p5=plot(x,avehetero[*,5],color='Cyan',name='Clear',overplot=p,thick=lnthk,symbol='Circle',sym_filled=1,sym_thick=symsz)	

	ld=legend(target=[p,p1,p2,p3,p4,p5],transparency=100,sample_width=0.1,position=[0.73,0.93])
	p.save,'cldmodis_avehetero_mjocloudphase_R05.png'
	stop
		
 EndIf

 ; plot spatial hetero,subarea cloud type occurrence, and subarea hsigma 
 IF mjo_flag eq 1 then begin
	avehetero_value=total(Thetero_value,4)/total(Thetero_num,4)
	posx1=[0.10,0.40,0.70]
	posx2=[0.35,0.65,0.95]
	posy1=[0.90,0.79,0.68,0.57,0.46,0.35,0.24,0.13]
	posy2=[0.99,0.88,0.77,0.66,0.55,0.44,0.33,0.22]
	minvalue=0.0
	maxvalue=0.3
	maplimit=[-20,70,30,150]
	xrange=[-4,1]
	yrange=[0,1]
	x1=indgen(6)
	xname=['','','','','','']
	yrange1=[0,40]
	fontsz=10

	Newcldphase_fre=dblarr(6,8)             ; original     changed  
	Newcldphase_fre[0,*]=Tcldphase_mjo[5,*] ; 0 ice        0 clr
	Newcldphase_fre[1,*]=Tcldphase_mjo[0,*] ; 1 mixed      1 ice
	Newcldphase_fre[2,*]=Tcldphase_mjo[3,*] ; 2 water      2 ice -liq
	Newcldphase_fre[3,*]=Tcldphase_mjo[4,*] ; 3 ice-liq    3 ice -mix
	Newcldphase_fre[4,*]=Tcldphase_mjo[2,*] ; 4 ice-mix    4 liq  
	Newcldphase_fre[5,*]=Tcldphase_mjo[1,*] ; 5 clear      5 mix

	save,Newcldphase_fre,filename='merge_ccm_cldphase_mjophase_newdomain_R05.sav'

	for i=0,7 do begin
	pos1=[posx1[0],posy1[i],posx2[0],posy2[i]]
	pos2=[posx1[1],posy1[i],posx2[1],posy2[i]]
	pos3=[posx1[2],posy1[i],posx2[2],posy2[i]]
	
	ind=where(Thetero_pdf[*,i] eq 0)
	phetero=(Thetero_pdf[*,i])*100/total(Thetero_pdf[*,i])
	phetero[ind]=!values.f_nan

	if i eq 0 then begin	
  	p=plot(x,phetero,xrange=xrange,xlog=0,thick=lnthick,$
	name='1',histogram=0,yrange=yrange,font_size=fontsz,symbol='dot',$
	xtitle='',position=pos2,yminor=0,yticklen=1,dimensions=[600,850])

	mp=map('Geographic',limit=maplimit,transparency=30,position=pos1,/current)
	c=image(reform(avehetero_value[*,*,i]),lon,lat,rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
	mc=mapcontinents(/continents,transparency=0,fill_color='grey')
	grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
    grid.font_size=fontsz-2.5
	mc['Longitudes'].label_angle=0


	b=barplot(x1,Newcldphase_fre[*,0]*100/total(Newcldphase_fre[*,i]),fill_color='grey',position=pos3,/current,$
	 xtickname=xname,xtickvalues=x1,font_size=fontsz,yrange=yrange1,yminor=0,yticklen=1)

	endif else begin

	mp=map('Geographic',limit=maplimit,transparency=30,position=pos1,/current)
	c=image(reform(avehetero_value[*,*,i]),lon,lat,rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
	mc=mapcontinents(/continents,transparency=0,fill_color='grey')
	grid=mp.MAPGRID
    grid.label_position=0
    grid.linestyle='dotted'
    grid.grid_longitude=20
    grid.font_size=fontsz-2.5
	mc['Longitudes'].label_angle=0
	xtitle=''
	if i eq 7 then xtitle='$log_{10}(H_{\sigma})$'
  	p=plot(x,phetero,xrange=xrange,xlog=0,thick=lnthick,$
	name='1',histogram=0,yrange=yrange,font_size=fontsz,symbol='dot',$
	xtitle=xtitle,position=pos2,/current,yminor=0,yticklen=1)

	xname=['','','','','','']
	if i eq 7 then xname=['Clear','Ice only','Ice above liquid','Ice above mixed','Liquid only','Mixed only']
	b=barplot(x1,Newcldphase_fre[*,i]*100/total(Newcldphase_fre[*,i]),fill_color='grey',position=pos3,/current,$
	xtickname=xname,xtickvalues=x1,font_size=fontsz,yrange=yrange1,yminor=0,yticklen=1)
	ax=b.axes
	ax[0].text_orientation=50
	endelse
	
	endfor	
	t1=text(0.015,0.97,'MJO',font_size=fontsz)	
	t2=text(0.01,0.95,'Phase',font_size=fontsz)	
	t3=text(0.035,0.93,'1',font_size=fontsz)	
	t4=text(0.035,0.84,'2',font_size=fontsz)	
	t5=text(0.035,0.73,'3',font_size=fontsz)	
	t6=text(0.035,0.62,'4',font_size=fontsz)	
	t7=text(0.035,0.51,'5',font_size=fontsz)	
	t8=text(0.035,0.40,'6',font_size=fontsz)	
	t9=text(0.035,0.29,'7',font_size=fontsz)	
	t0=text(0.035,0.18,'8',font_size=fontsz)	

	ct=colorbar(target=c,position=[pos1[0]-0.02,pos1[1]-0.04,pos1[2]+0.01,pos1[1]-0.03],title=xtitle,font_size=fontsz-1)	

	mp.save,'hetero_spatial_pdf_cloudphase_strongmjo_dn_R05.png'
	stop
 EndIf 

 If pdfflag eq 1 then begin
  	ld=legend(target=[p,p1,p2,p3,p4,p5,p6,p7],position=[0.5,0.7])
	p.save,'CCM_pdf_heteroseaon_mjo_R05.png'
 EndIf 
  stop

end
