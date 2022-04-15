
pro plot_hetero_CCM
	
  lnthick=1.2
  mjo_flag=0 ; original data with seasonality
  accuflag=1 ; get accumulative PDFs
  title=['1','2','3','4','5','6','7','8']
  lncolor=['lime','green','dark orange','blue','grey','red','purple','Cyan']
  Ninterval=800
  fontsz=12
  subtitle1=['a1)','a2)','a3)','a4)','a5)','a6)','a7)','a8)']
  subtitle2=['b1)','b2)','b3)','b4)','b5)','b6)','b7)','b8)']
  subtitle3=['c1)','c2)','c3)','c4)','c5)','c6)','c7)','c8)']
  subtitle4=['d1)','d2)','d3)','d4)','d5)','d6)','d7)','d8)']
  accutitle=['a) MJO Phase 1','b) MJO Phase 2','c) MJO Phase 3','d) MJO Phase 4','e) MJO Phase 5','f) MJO Phase 6','g) MJO Phase 7','h) MJO Phase 8']
  
  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/MJO/MODIS'

  Thetero_pdf=0
  Thetero_num=0.0
  Thetero_value=0.0 
  Tcldphase_mjo=0L
  Treflect645_value=0.0
  Tbt11_value=0.0

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
 	Nf=n_elements(allfname)
	
    season_hetero_pdf=intarr(Ninterval,8)
    season_hetero_num=intarr(72,90,8)
	season_hetero_value=fltarr(72,90,8)
	season_bt11_value=fltarr(72,90,8)
	season_reflect645_value=fltarr(72,90,8)

 	For fi=0,Nf-1 Do Begin
    IF (strlen(allfname[fi]) eq 108) Then Begin
	yrst=strmid(allfname[fi],88,4)
	year=fix(yrst)
    IF year ge 2007 and year le 2010 Then Begin	
	read_dardar,allfname[fi],'hetero_invertal',x
	read_dardar,allfname[fi],'hetero_spatial_num',hetero_num
	read_dardar,allfname[fi],'hetero_spatial',hetero_value
	read_dardar,allfname[fi],'subarea_cldphase_fre',cldphase_fre
	read_dardar,allfname[fi],'reflect645_spatial',reflect645_value
	read_dardar,allfname[fi],'bt11_spatial',bt11_value

	print,allfname[fi]

	season_hetero_num=season_hetero_num+hetero_num
	
	ind=where(finite(hetero_value) eq 0)
	hetero_value[ind]=0.0
	season_hetero_value=season_hetero_value+hetero_value*hetero_num
	ind=where(finite(reflect645_value) eq 0)
	reflect645_value[ind]=0.0
	season_reflect645_value= season_reflect645_value + reflect645_value*hetero_num
	ind=where(finite(bt11_value) eq 0)
	bt11_value[ind]=0.0
	season_bt11_value= season_bt11_value + bt11_value*hetero_num
		
    read_dardar,allfname[fi],'subarea_hetero_pdf',hetero_pdf	
	season_hetero_pdf=season_hetero_pdf+hetero_pdf

	Thetero_pdf=Thetero_pdf+hetero_pdf
	Thetero_value=Thetero_value+hetero_value*hetero_num
	Thetero_num=Thetero_num+hetero_num
	Treflect645_value=Treflect645_value + reflect645_value*hetero_num
	Tbt11_value=Tbt11_value + bt11_value*hetero_num
	Tcldphase_mjo=Tcldphase_mjo+cldphase_fre
	EndIF ; end filelen
	EndIF ; endif in 2007-2010
	EndFor ; end for reading file

   Endfor ; end for seasons

   restore,'merge_ccm_cldphase_mjophase_newdomain_R05.sav' ; restore the cloud phase frequency as a function of MJO phase from Merged CC and MODIS (plot_hetero_mjo.pro)
  merge_cldphase=Newcldphase_fre

  lon=(findgen(360))-180
  lat=(findgen(180))-90
	Newcldphase_fre=dblarr(4,8)             ; original     changed  
	Newcldphase_fre[0,*]=Tcldphase_mjo[4,*] ; 1 ice        0 clr
	Newcldphase_fre[1,*]=Tcldphase_mjo[1,*] ; 2 mixed      1 ice
	Newcldphase_fre[2,*]=Tcldphase_mjo[0,*] ; 0 water      2 water 
	Newcldphase_fre[3,*]=Tcldphase_mjo[3,*] ; 3 undetermined    3 undetermined
	;for H_simga
	minvalue=0.0
	maxvalue=0.25
	
	;for BT
	;minvalue=240
	;maxvalue=300
	;for R
;	minvalue=0
;	maxvalue=0.4
 ; plot spatial hetero,subarea cloud type occurrence, and subarea hsigma 
 IF mjo_flag eq 1 then begin
	avehetero_value=Tbt11_value/Thetero_num

	posx1=[0.10,0.33,0.56,0.79]
	posx2=[0.28,0.51,0.74,0.97]
	posy1=[0.88,0.77,0.66,0.55,0.44,0.33,0.22,0.11]
	posy2=[0.97,0.86,0.75,0.64,0.53,0.42,0.31,0.20]
	maplimit=[-20,70,30,150]
	yrange=[0,1]
	x1=indgen(4)
	x2=indgen(6)
	xname=['','','','','']
	xname2=['','','','','','','']
	yrange1=[0,60]

	fontsz=10

	for i=0,7 do begin
	pos1=[posx1[0],posy1[i],posx2[0],posy2[i]]
	pos2=[posx1[1],posy1[i],posx2[1],posy2[i]]
	pos3=[posx1[2],posy1[i],posx2[2],posy2[i]]
	pos4=[posx1[3],posy1[i],posx2[3],posy2[i]]
	
	ind=where(Thetero_pdf[*,i] eq 0)
	phetero=(Thetero_pdf[*,i])*100/total(Thetero_pdf[*,i])
	phetero[ind]=!values.f_nan

	loc1=399 ; -2  clr
	loc2=465 ; -1.34 ice
	loc3=559 ; -0.4 liq
	if i eq 0 then begin	
  	p=plot(x,phetero,xrange=xrange,xlog=0,thick=lnthick,$
	name='1',histogram=0,yrange=yrange,font_size=fontsz,symbol='dot',$
	xtitle='',position=pos2,yminor=0,yticklen=1,ygridstyle=1,dimensions=[700,850])

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
	 xtickname=xname,xtickvalues=x1,font_size=fontsz,yrange=yrange1,yminor=0,xminor=0,yticklen=0.01)

	b1=barplot(x2,merge_cldphase[*,0]*100/total(merge_cldphase[*,i]),fill_color='grey',position=pos4,/current,$
	 xtickname=xname2,xtickvalues=x2,font_size=fontsz,yrange=yrange1,yminor=0,xminor=0,yticklen=0.01)

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
	xtitle=xtitle,position=pos2,/current,yminor=0,yticklen=1,ygridstyle=1)

	xname=['','','','','','']
	if i eq 7 then xname=['Clear','Ice','Liquid','Undetermined','']
	b=barplot(x1,Newcldphase_fre[*,i]*100/total(Newcldphase_fre[*,i]),fill_color='grey',position=pos3,/current,$
	xtickname=xname,xtickvalues=x1,font_size=fontsz,yrange=yrange1,yminor=0,xminor=0,yticklen=0.01)
	ax=b.axes
	ax[0].text_orientation=50

	if i eq 7 then xname2=['Clear','Ice only','Ice above liquid','Ice above mixed','Liquid only','Mixed only']
	b1=barplot(x2,merge_cldphase[*,i]*100/total(merge_cldphase[*,i]),fill_color='grey',position=pos4,/current,$
	xtickname=xname2,xtickvalues=x2,font_size=fontsz,yrange=yrange1,yminor=0,xminor=0,yticklen=0.01)
	ax=b1.axes
	ax[0].text_orientation=50

	endelse
	; write the position
    dy1=findgen(11)*0.1
	dx1=fltarr(800)-2
	pp1=plot(dx1,dy1,overplot=p,linestyle='dashed')
	point1=strmid(string(phetero[loc1]),5,4)
	t1=text(pos2[0]+0.03,pos2[3]-0.035,point1,font_size=fontsz-1)
	dx1=fltarr(800)-1.3
	pp2=plot(dx1,dy1,overplot=p,linestyle='dashed',color='r')
	point2=strmid(string(phetero[loc2]),5,4)
	t1=text(pos2[0]+0.095,pos2[3]-0.035,point2,font_size=fontsz-1,color='r')
	dx1=fltarr(800)-0.4
	pp3=plot(dx1,dy1,overplot=p,linestyle='dashed',color='purple')
	point3=strmid(string(phetero[loc3]),5,4)
	t1=text(pos2[0]+0.14,pos2[3]-0.05,point3,font_size=fontsz-1,color='purple')

	; to write modis each category fraction
	modisfra=Newcldphase_fre[*,i]*100/total(Newcldphase_fre[*,i])
	modisfra1=string(modisfra)
	t1=text(pos3[0]+0.02,pos3[1]+modisfra[0]*1.5*0.001,strmid(modisfra1[0],7,4),font_size=fontsz-1,color='black')	
	t1=text(pos3[0]+0.055,pos3[1]+modisfra[1]*1.5*0.001,strmid(modisfra1[1],7,4),font_size=fontsz-1,color='black')	
	t1=text(pos3[0]+0.09,pos3[1]+modisfra[2]*1.5*0.001,strmid(modisfra1[2],7,4),font_size=fontsz-1,color='black')	
	t1=text(pos3[0]+0.13,pos3[1]+modisfra[3]*1.5*0.001,strmid(modisfra1[3],7,3),font_size=fontsz-1,color='black')	
	; to write modis CC merge fraction
	cldsat=merge_cldphase[*,i]*100/total(merge_cldphase[*,i])
	cldsat1=string(cldsat)
	t1=text(pos4[0]+0.007,pos4[1]+cldsat[0]*1.5*0.001,strmid(cldsat1[0],7,4),font_size=fontsz-1,color='black')	
	t1=text(pos4[0]+0.035,pos4[1]+cldsat[1]*1.5*0.001,strmid(cldsat1[1],7,4),font_size=fontsz-1,color='black')	
	t1=text(pos4[0]+0.065,pos4[1]+cldsat[2]*1.5*0.001,strmid(cldsat1[2],7,4),font_size=fontsz-1,color='black')	
	if i ne 4 then t1=text(pos4[0]+0.09,pos4[1]+cldsat[3]*1.5*0.001,strmid(cldsat1[3],7,3),font_size=fontsz-1,color='black')	
	if i eq 4 then t1=text(pos4[0]+0.09,pos4[1]+cldsat[3]*1.5*0.001,strmid(cldsat1[3],7,4),font_size=fontsz-1,color='black')	
	if i eq 4 then t1=text(pos4[0]+0.11,pos4[1]+cldsat[4]*2.5*0.001,strmid(cldsat1[4],7,4),font_size=fontsz-1,color='black')	
	if i ne 4 then t1=text(pos4[0]+0.11,pos4[1]+cldsat[4]*1.5*0.001,strmid(cldsat1[4],7,4),font_size=fontsz-1,color='black')	
	t1=text(pos4[0]+0.145,pos4[1]+cldsat[5]*1.5*0.001,strmid(cldsat1[5],7,3),font_size=fontsz-1,color='black')	

	;to write subtitle
	t1=text(pos1[0]+0.013,pos1[3]-0.016,subtitle1[i],font_size=fontsz-1)
	t1=text(pos2[0]+0.013,pos2[3]-0.016,subtitle2[i],font_size=fontsz-1)
	t1=text(pos3[0]+0.013,pos3[3]-0.016,subtitle3[i],font_size=fontsz-1)
	t1=text(pos4[0]+0.013,pos4[3]-0.016,subtitle4[i],font_size=fontsz-1)

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

	ct=colorbar(target=c,position=[pos1[0],pos1[1]-0.04,pos1[2]+0.01,pos1[1]-0.03],title='$H_{\sigma}$',font_size=fontsz-1)	

	mp.save,'bt11_spatial_pdf_CCmodhase_strongmjo0710_newdomain_R05.png'
	stop
 EndIf ; endif mjoflag=1 

 ; to get accumulative PDFs 
 IF accuflag eq 1 then begin

	posx1=[0.05,0.28,0.52,0.76,0.05,0.28,0.52,0.76]
	posx2=[0.24,0.48,0.72,0.96,0.24,0.48,0.72,0.96]
	posy1=[0.70,0.70,0.70,0.70,0.48,0.48,0.48,0.48]
	posy2=[1.00,1.00,1.00,1.00,0.78,0.78,0.78,0.78]

	avehetero_value=Thetero_value/Thetero_num
	maplimit=[-20,70,30,150]
	xrange=[-3,0]
	For i=0,7 Do Begin
		spos=[posx1[i],posy1[i],posx2[i],posy2[i]]

	; to plot spatial sigma
		If i eq 0 then begin
		
		mp=map('Geographic',limit=maplimit,transparency=30,position=spos,/current,dim=[850,700])
		c=image(reform(avehetero_value[*,*,i]),lon,lat,rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
		mc=mapcontinents(/continents,transparency=0,fill_color='white')
		grid=mp.MAPGRID
    	grid.label_position=0
    	grid.linestyle='dotted'
    	grid.grid_longitude=20
    	grid.font_size=fontsz-2.5
		mc['Longitudes'].label_angle=0
		EndIf Else Begin
		mp=map('Geographic',limit=maplimit,transparency=30,position=spos,/current)
		c=image(reform(avehetero_value[*,*,i]),lon,lat,rgb_table=33,overplot=mp,min_value=minvalue,max_value=maxvalue)
		mc=mapcontinents(/continents,transparency=0,fill_color='white')
		grid=mp.MAPGRID
    	grid.label_position=0
    	grid.linestyle='dotted'
    	grid.grid_longitude=20
    	grid.font_size=fontsz-2.5
		mc['Longitudes'].label_angle=0
		EndElse

		t1=text(spos[0]+0.01,spos[3]-0.07,accutitle[i],font_size=fontsz-1)
		; to plot a retangle
		ind=where(lat ge -10 and lat le 10,count)
		tpx=fltarr(count)
		tpx(*)=100
		dp=plot(tpx,lat[ind],linestyle='dash',thick=2,overplot=c,color='red')	
		tpx(*)=140
		dp1=plot(tpx,lat[ind],linestyle='dash',thick=2,overplot=c,color='red')	
		ind=where(lon ge 100 and lon le 140,count)
		tpy=fltarr(count)
		tpy(*)=-10
		dp2=plot(lon[ind],tpy,linestyle='dash',thick=2,overplot=c,color='red')	
		tpy(*)=10
		dp2=plot(lon[ind],tpy,linestyle='dash',thick=2,overplot=c,color='red')	

		; to plot pdf and cdf
		cpos=[0.08,0.15,0.33,0.40]
		accupdf=fltarr(800)
		accupdf[0]=Thetero_pdf[0,i]
		for j=1,799 do accupdf[j]=Thetero_pdf[j,i]+accupdf[j-1]
		ind=where(Thetero_pdf[*,i] eq 0)
		;pdf
		phetero=(Thetero_pdf[*,i])*100/total(Thetero_pdf[*,i])
		phetero[ind]=!values.f_nan
		;cdf
		chetero=accupdf/total(Thetero_pdf[*,i])
		if i eq 0 then p=plot(x,phetero,xrange=xrange,thick=lnthick,position=cpos,/current,$
      	name=title[i],yrange=[0,1],symbol='dot',font_size=fontsz,xtitle='$log_{10}(H_{\sigma})$',color=lncolor[i],$
		ytitle='Frequency (%)',yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02)
	
		if i ge 1 then p1=plot(x,phetero,xrange=xrange,thick=lnthick,$
      	name=title[i],yrange=[0,1],symbol='dot',overplot=p,color=lncolor[i],transparency=1-i*10)

	    if i eq 0 then ld=legend(target=[p],position=[0.97,0.4],transparency=100,sample_width=0.1) $
		else ld=legend(target=[p1],position=[0.97,0.4-i*0.02],transparency=100,sample_width=0.1)

		;--- to plot cloud phase type from MODIS
		pos3=[0.38,0.15,0.58,0.40]
		x1=findgen(4)
		xname=['','','','']
		if i eq 7 then xname=['Clear','Ice','Liquid','Undetermined']
		if i eq 0 then b=plot(x1,Newcldphase_fre[*,i]*100/total(Newcldphase_fre[*,i]),position=pos3,/current,$
		xtickname=xname,xtickvalues=x1,font_size=fontsz,yminor=0,xminor=0,yticklen=1,color=lncolor[i],xrange=[-1,4],$
		sym='circle',sym_filled=1,sym_size=1,yrange=[0,60],thick=lnthick,ygridstyle=1,xticklen=0.02)

		if i ge 1 then b11=plot(x1,Newcldphase_fre[*,i]*100/total(Newcldphase_fre[*,i]),position=pos3,overplot=b,$
		xtickname=xname,xtickvalues=x1,color=lncolor[i],xrange=[-1,4],thick=lnthick,yticklen=1,ygridstyle=1,$
		sym='circle',sym_filled=1,sym_size=1,yrange=[0,70],xticklen=0.02)
		ax=b.axes
		ax[0].text_orientation=50
	
		pos4=[0.63,0.15,0.85,0.40]
		x2=findgen(6)
		if i eq 7 then xname2=['Clear','Ice only','Ice above liquid','Ice above mixed','Liquid only','Mixed only']
		if i eq 0 then b1=plot(x2,merge_cldphase[*,i]*100/total(merge_cldphase[*,i]),position=pos4,/current,$
		xtickname=xname2,xtickvalues=x2,font_size=fontsz,yminor=0,xminor=0,color=lncolor[i],xrange=[-1,6],$
		sym='circle',sym_filled=1,sym_size=1,yrange=[0,45],thick=lnthick,yticklen=1,ygridstyle=1,xticklen=0.02)


		if i ge 1 then b21=plot(x2,merge_cldphase[*,i]*100/total(merge_cldphase[*,i]),position=pos4,overplot=b1,$
		xtickname=xname2,xtickvalues=x2,font_size=fontsz,yminor=0,xminor=0,color=lncolor[i],xrange=[-1,6],$
		sym='circle',sym_filled=1,sym_size=1,yrange=[0,45],thick=lnthick,yticklen=1,ygridstyle=1,xticklen=0.02)
		ax=b1.axes
		ax[0].text_orientation=50
		
	EndFor
	ctitle='$H_{\sigma}$'
	;ctitle='$BT_{11} (K)$'
	;ctitle='$R_{0.645}$'
	ct=colorbar(target=c,position=[0.15,0.49,0.85,0.51],title=ctitle,font_size=fontsz)
    c.save,'hetero_spatial_pdf_CCmodhase_strongmjo07-10_newdomain_R05.png'


	t=text(0.87,0.4,'MJO Phase',font_size=fontsz)
    dy1=findgen(11)*0.1
	dx1=fltarr(800)-2
	pp1=plot(dx1,dy1,overplot=p,linestyle='dashed')
;	dx1=fltarr(800)-1.3
;	pp2=plot(dx1,dy1,overplot=p,linestyle='dashed')
	dx1=fltarr(800)-0.4
	pp3=plot(dx1,dy1,overplot=p,linestyle='dashed')
	t2=text(cpos[0]+0.01,cpos[3]+0.01,'i)',font_size=fontsz)
	t3=text(Pos3[0]+0.01,pos3[3]+0.01,'j)',font_size=fontsz)
	t4=text(Pos4[0]+0.01,pos4[3]+0.01,'k)',font_size=fontsz)

     p.save,'Hsimga_modiscurve_strongmjo07-10_newdomain_R05.png'
	stop	
 EndIf ; end accuflag 

end
