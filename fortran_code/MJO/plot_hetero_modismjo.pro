
pro plot_hetero_modismjo
	
  lnthick=1.2
  pdfflag=0
  numflag=0
  hetflag=1
  mjo_flag=0 ; do not show seasonality
  title=['1','2','3','4','5','6','7','8']
  Ninterval=800
  fontsz=12
  
  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/MJO/MODIS'
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

  season_cldphase_fre=ulonarr(5,8,4)   
  orig_fra=fltarr(5,8,4)
  dese_fra=fltarr(5,8,4)

  For mi=0,3 Do Begin
	if (mi eq 0) then begin
	strongfname1=file_search(datadir,'*03_strongmjo.hdf')
	strongfname2=file_search(datadir,'*04_strongmjo.hdf')
	strongfname3=file_search(datadir,'*05_strongmjo.hdf')
	endif
	if (mi eq 1) then begin
	strongfname1=file_search(datadir,'*06_strongmjo.hdf')
	strongfname2=file_search(datadir,'*07_strongmjo.hdf')
	strongfname3=file_search(datadir,'*08_strongmjo.hdf')
  	endif
	if (mi eq 2) then begin
	strongfname1=file_search(datadir,'*09_strongmjo.hdf')
	strongfname2=file_search(datadir,'*10_strongmjo.hdf')
	strongfname3=file_search(datadir,'*11_strongmjo.hdf')
  	endif
	if (mi eq 3) then begin
	strongfname1=file_search(datadir,'*12_strongmjo.hdf')
	strongfname2=file_search(datadir,'*01_strongmjo.hdf')
	strongfname3=file_search(datadir,'*02_strongmjo.hdf')
	endif

    allfname=[strongfname1,strongfname2,strongfname3]
;	print,allfname
 	Nf=n_elements(allfname)


 	For fi=0,Nf-1 Do Begin
	yrst=strmid(allfname[fi],78,4)
	year=fix(yrst)
	IF year ge 2007 and year le 2010 Then Begin	
	read_dardar,allfname[fi],'hetero_invertal',x
	read_dardar,allfname[fi],'hetero_spatial_num',hetero_num
	read_dardar,allfname[fi],'hetero_spatial',hetero_value
	read_dardar,allfname[fi],'subarea_cldphase_fre',cldphase_fre
	stop	
	ind=where(finite(hetero_value) eq 0)
	hetero_value[ind]=0.0
		
    read_dardar,allfname[fi],'subarea_hetero_pdf',hetero_pdf	

	Thetero_pdf=Thetero_pdf+hetero_pdf
	Thetero_value=Thetero_value+hetero_value*hetero_num
	Thetero_num=Thetero_num+hetero_num
	Tcldphase_mjo=Tcldphase_mjo+cldphase_fre	

	season_cldphase_fre[*,*,mi]=season_cldphase_fre[*,*,mi]+cldphase_fre
	
	EndIf ; end year	
	EndFor ; end for reading file

	; deseasonalized
	; seasonal index 
	SI=[[1.380811,0.87418 ,0.90176 ,0.943248],$ ; clear
		[0.740774,1.200463,1.204953,0.85381 ],$ ; ice
		[1.105336,0.673468,0.811095,1.410101],$ ; liquid
		[0.815559,1.10709 ,1.012854,1.064497]] ; undetermined

	for i=0,7 do begin
	 orig_fra[*,i,mi]=season_cldphase_fre[*,i,mi]/total(season_cldphase_fre[*,i,mi])
	 dese_fra[0,i,mi]=orig_fra[0,i,mi]/si[mi,2] ; liquid
	 dese_fra[1,i,mi]=orig_fra[1,i,mi]/si[mi,1] ;ice
	 dese_fra[3,i,mi]=orig_fra[3,i,mi]/si[mi,3] ;undetermined
	 dese_fra[4,i,mi]=orig_fra[4,i,mi]/si[mi,0] ; clear
	endfor	

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

  	lon=(findgen(360))-180
  	lat=(findgen(180))-90
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

  EndFor ; end for season

  orig_fra1=total(orig_fra,3)/4.0
  dese_fra1=total(dese_fra,3)/4.0

 ; plot spatial hetero,subarea cloud type occurrence, and subarea hsigma 
 IF mjo_flag eq 1 then begin
	avehetero_value=Thetero_value/Thetero_num
	posx1=[0.10,0.40,0.70]
	posx2=[0.35,0.65,0.95]
	posy1=[0.90,0.79,0.68,0.57,0.46,0.35,0.24,0.13]
	posy2=[0.99,0.88,0.77,0.66,0.55,0.44,0.33,0.22]
	minvalue=0.0
	maxvalue=0.3
	maplimit=[-20,70,30,150]
	xrange=[-4,1]
	yrange=[0,1]
	x1=indgen(5)
	xname=['','','','','','']
	yrange1=[0,60]
	fontsz=10

	Newcldphase_fre=dblarr(5,8)             ; original     changed  
	Newcldphase_fre[0,*]=Tcldphase_mjo[4,*] ; 1 ice        0 clr
	Newcldphase_fre[1,*]=Tcldphase_mjo[1,*] ; 2 mixed      1 ice
	Newcldphase_fre[2,*]=Tcldphase_mjo[0,*] ; 0 water      2 water 
	Newcldphase_fre[3,*]=Tcldphase_mjo[3,*] ; 3 undetermined    3 undetermined
											; 4 clear	
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
	if i eq 7 then xname=['Clear','Ice','Liquid','Undetermined','']
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

	p.save,'hetero_spatial_pdf_modhase_strongmjo0710.png'
	stop
 EndIf 

 If pdfflag eq 1 then begin
  	ld=legend(target=[p,p1,p2,p3,p4,p5,p6,p7],position=[0.5,0.7])
	p.save,'CCM_pdf_heteroseaon_mjo0710.png'
 EndIf 
  stop

end
