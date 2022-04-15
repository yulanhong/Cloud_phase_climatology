
pro plot_CCM_radiation
  
  pdfflag=1
  annualpdf=1; set pdfflag and annualpdf eq 1 to plot pdfs	
  spectral=1 ; set 1 to plot annual and seasonal spectral radiation 
  lnthick=2
  lncolor=['lime','blue','dark orange','red','purple','Cyan','green']
  fontsz=11.5

  subtitle1=['a1)','a2)','a3)','a4)','a5)','a6)','a7)','a8)']
  subtitle2=['b1)','b2)','b3)','b4)','b5)','b6)','b7)','b8)']
  subtitle3=['c1)','c2)','c3)','c4)','c5)','c6)','c7)','c8)']
  subtitle4=['d1)','d2)','d3)','d4)','d5)','d6)','d7)','d8)']

  season=['MAM','JJA','SON','DJF']
  
  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/CCM_Radiation/R05'
  all_reflect645_pdf=ulonarr(121,7,4) 
  all_reflect_ratio_pdf=ulonarr(500,7,4)
  all_bt11_pdf=ulonarr(201,7,4)
  all_btddiff_pdf=ulonarr(300,7,4)

  all_reflect645_cdf=ulonarr(121,7,4) 
  all_reflect_ratio_cdf=ulonarr(500,7,4)
  all_bt11_cdf=ulonarr(201,7,4)
  all_btddiff_cdf=ulonarr(300,7,4)

  all_radsza_num=ulonarr(6,70,7,4)
  all_radsza=dblarr(6,70,7,4)

  For mi=0,3 Do Begin
	if (mi eq 0) then begin
	strongfname1=file_search(datadir,'*03.hdf')
	strongfname2=file_search(datadir,'*04.hdf')
	strongfname3=file_search(datadir,'*05.hdf')
	endif
	if (mi eq 1) then begin
	strongfname1=file_search(datadir,'*06.hdf')
	strongfname2=file_search(datadir,'*07.hdf')
	strongfname3=file_search(datadir,'*08.hdf')
  	endif
	if (mi eq 2) then begin
	strongfname1=file_search(datadir,'*09.hdf')
	strongfname2=file_search(datadir,'*10.hdf')
	strongfname3=file_search(datadir,'*11.hdf')
  	endif
	if (mi eq 3) then begin
	strongfname1=file_search(datadir,'*12.hdf')
	strongfname2=file_search(datadir,'*01.hdf')
	strongfname3=file_search(datadir,'*02.hdf')
	endif

    allfname=[strongfname1,strongfname2,strongfname3]

 	Nf=n_elements(allfname)

	sea_reflect645_pdf=ulonarr(121,7)
	sea_reflect_ratio_pdf=ulonarr(500,7)
	sea_bt11_pdf=ulonarr(201,7)
	sea_btddiff_pdf=ulonarr(300,7)

	sea_reflect645_cdf=ulonarr(121,7)
	sea_reflect_ratio_cdf=ulonarr(500,7)
	sea_bt11_cdf=ulonarr(201,7)
	sea_btddiff_cdf=ulonarr(300,7)

	sea_reflect645_spanum=ulonarr(72,90,7)
	sea_reflect645_spa=dblarr(72,90,7)
	sea_bt11_spanum=ulonarr(72,90,7)
	sea_bt11_spa=dblarr(72,90,7)


	sea_radsza_num=ulonarr(6,70,7)
	sea_radsza=dblarr(6,70,7)

 	For fi=0,Nf-1 Do Begin
	IF (strlen(allfname[fi]) eq 104) Then Begin
	print,allfname[fi]
	read_dardar,allfname[fi],'reflect645_pdf',reflect645_pdf
	read_dardar,allfname[fi],'reflect_ratio_pdf',reflect_ratio_pdf
	read_dardar,allfname[fi],'BT11_pdf',bt11_pdf
	read_dardar,allfname[fi],'BTD8.5_11_pdf',btddiff_pdf
	read_dardar,allfname[fi],'reflect0.645_num',reflect645_spanum
	read_dardar,allfname[fi],'reflectance_0.645',reflect645_spa
	read_dardar,allfname[fi],'BT_11_num',bt11_spanum
	read_dardar,allfname[fi],'BT_11',bt11_spa
	read_dardar,allfname[fi],'subarea_radsza_num',radsza_num
	read_dardar,allfname[fi],'subarea_radsza',radsza

	sea_reflect645_pdf=sea_reflect645_pdf+reflect645_pdf
	sea_reflect_ratio_pdf=sea_reflect_ratio_pdf+reflect_ratio_pdf
	sea_bt11_pdf=sea_bt11_pdf+bt11_pdf
	sea_btddiff_pdf=sea_btddiff_pdf+btddiff_pdf
	
	ind=where(radsza_num eq 0)
	radsza[ind]=0.0
	sea_radsza=sea_radsza+radsza*radsza_num
	sea_radsza_num=sea_radsza_num+radsza_num
	
	EndIf	
	EndFor ; end for reading file

	IF (pdfflag eq 1 ) Then Begin
	
	;	xtitle='$R_{0.645 \mu m}$'
	;	xtitle='$R_{1.6 \mu m}$/$R_{0.645 \mu m}$'
	;	xtitle='$BT_{11 \mu m}$'
		xtitle='$BT_{8.5}$-BT_{11}$'
	;	xrange=[0,1.5] ;ratio
	;	xrange=[180,300]; BT 
		xrange=[-3,7] ;BT  diff
;		yrange=[0,0.3] ;BT, reflectance
		yrange=[0,0.10] ; ratio, BTD
		Nmax=300
		x=findgen(Nmax)*0.1-8.5
		xname=['Ice only','Mixed only','Liquid only','Ice above liquid','Ice above mixed','Clear']
		savetitle='BTD'
		plotpdf=0

		for typei=0,5 do begin
			for xi=0, 499 do begin
			if xi eq 0 then begin
			sea_reflect645_cdf[0,typei]=sea_reflect645_pdf[0,typei]
			sea_reflect_ratio_cdf[0,typei]=sea_reflect_ratio_pdf[0,typei]
			sea_bt11_cdf[0,typei]=sea_bt11_pdf[0,typei]
			sea_btddiff_cdf[0,typei]=sea_btddiff_pdf[0,typei]
			endif
			if xi gt 0 and xi le 120 then sea_reflect645_cdf[xi,typei]= sea_reflect645_cdf[xi-1,typei]+sea_reflect645_pdf[xi,typei]
			if xi gt 0 and xi le 499 then sea_reflect_ratio_cdf[xi,typei]= sea_reflect_ratio_cdf[xi-1,typei]+sea_reflect_ratio_pdf[xi,typei]
			if xi gt 0 and xi le 200 then sea_bt11_cdf[xi,typei]= sea_bt11_cdf[xi-1,typei]+sea_bt11_pdf[xi,typei]
			if xi gt 0 and xi le 299 then sea_btddiff_cdf[xi,typei]= sea_btddiff_cdf[xi-1,typei]+sea_btddiff_pdf[xi,typei]
			endfor
		if plotpdf eq 1 then begin
		fre_pdf=sea_btddiff_pdf[*,typei]/total(sea_btddiff_pdf[*,typei])
		fre_cdf=sea_btddiff_cdf[*,typei]/float(sea_btddiff_cdf[Nmax-1,typei])
		
		if typei eq 0 then begin
			p=plot(x,fre_pdf,xrange=xrange,thick=lnthick,position=[0.1,0.15,0.5,0.9],$
      		name=xname[typei],yrange=yrange,font_size=fontsz,xtitle=xtitle,color=lncolor[typei],$
			ytitle='Frequency',yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,title=season[mi],$
			dim=[750,400])

			p0=plot(x,fre_cdf,xrange=xrange,thick=lnthick,position=[0.55,0.15,0.95,0.9],$
      		name=xname[typei],yrange=[0,1],font_size=fontsz,xtitle=xtitle,color=lncolor[typei],$
			/current,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,title=season[mi])
		endif

		if typei ge 1 then begin
		 p1=plot(x,fre_pdf,thick=lnthick,overplot=p,color=lncolor[typei],name=xname[typei])
		 p10=plot(x,fre_cdf,thick=lnthick,overplot=p0,color=lncolor[typei],name=xname[typei])
		endif

	    if typei eq 0 then ld=legend(target=[p],position=[0.18,0.85],transparency=100,horizontal_alignment=0) $
		else ld=legend(target=[p1],position=[0.18,0.85-typei*0.06],transparency=100,horizontal_alignment=0)
		endif; endif plot
	   Endfor ; end cloud type	
	
		;p.save,'cldphase_'+savetitle+'_'+season[mi]+'.png'

		all_reflect645_pdf[*,*,mi]=sea_reflect645_pdf	
		all_reflect645_cdf[*,*,mi]=sea_reflect645_cdf	
		all_reflect_ratio_pdf[*,*,mi]=sea_reflect_ratio_pdf	
		all_reflect_ratio_cdf[*,*,mi]=sea_reflect_ratio_cdf	
		all_bt11_pdf[*,*,mi]=sea_bt11_pdf	
		all_bt11_cdf[*,*,mi]=sea_bt11_cdf	
		all_btddiff_pdf[*,*,mi]=sea_btddiff_pdf	
		all_btddiff_cdf[*,*,mi]=sea_btddiff_cdf	
	EndIF ; end if pdfflag 1

		all_radsza[*,*,*,mi]=sea_radsza
		all_radsza_num[*,*,*,mi]=sea_radsza_num

   Endfor ; end for seasons

	; === to plot spectral for different phase ====
	If spectral eq 1 then begin
		symsz=1.8
		sza_scp=29
		sea_sym=['circle','triangle','square','star']
		sea_ave=total(all_radsza,2)/total(all_radsza_num,2)
		all_radsza1=total(all_radsza,4)
		all_radsza_num1=total(all_radsza_num,4)
		all_ave=total(all_radsza1,2)/total(all_radsza_num1,2)	
		
		annual_data=fltarr(6,6) ; 0-spectral, 1-cloud type		
		sea_data=fltarr(6,6,4) ; 0-spectral, 1-cloud type		
		annual_data[*,0]=all_ave[*,5] ;clear
		annual_data[*,1]=all_ave[*,0] ;ice
		annual_data[*,2]=all_ave[*,3] ;ice-liquid
		annual_data[*,3]=all_ave[*,4] ;ice-mixed
		annual_data[*,4]=all_ave[*,2] ;liquid only
		annual_data[*,5]=all_ave[*,1] ;mixed only
	

		sea_data[*,0,*]=sea_ave[*,5,*] ;clear
		sea_data[*,1,*]=sea_ave[*,0,*] ;ice
		sea_data[*,2,*]=sea_ave[*,3,*] ;ice-liquid
		sea_data[*,3,*]=sea_ave[*,4,*] ;ice-mixed
		sea_data[*,4,*]=sea_ave[*,2,*] ;liquid only
		sea_data[*,5,*]=sea_ave[*,1,*] ;mixed only
		
;		for i=0,5 do begin
;		 print,'annual',annual_data[*,i]
;		 print,'season',season[0], sea_data[*,i,0]
;		 print,'season',season[1], sea_data[*,i,1]
;		 print,'season',season[2], sea_data[*,i,2]
;		 print,'season',season[3], sea_data[*,i,3]
;		endfor	
	;to plot cloud type vs. reflectace/BT

		xname2=['Clear','Ice only','Ice above liquid','Ice above mixed','Liquid only','Mixed only']
		x=findgen(6)
		p1=plot(x,annual_data[0,*],xtickname=xname2,xtickvalues=x,font_size=fontsz,yminor=0,xminor=0,color=lncolor[0],xrange=[-1,6],$
         yrange=[0,0.8],thick=lnthick,yticklen=1,ygridstyle=1,ytitle='Reflectance',xticklen=0.02,name='$R_{0.645}$',$
		 dim=[650,500],position=[0.15,0.2,0.85,0.9])
		ax=p1.axes
		ax[0].text_orientation=50
		pos=p1.position
		;t=text(pos[0]+0.1,pos[3]+0.02,'$SZA ~ 30^\deg$',font_size=fontsz+1)

		p2=plot(x,annual_data[1,*],color=lncolor[1],overplot=p1,thick=lnthick,name='$R_{1.375}$')
		p3=plot(x,annual_data[2,*],color=lncolor[2],overplot=p1,thick=lnthick,name='$R_{1.64}$')
		p4=plot(x,annual_data[3,*],color=lncolor[3],overplot=p1,thick=lnthick,name='$R_{2.13}$')
		
		p5=plot(x,annual_data[4,*],color=lncolor[4],thick=lnthick,/current,position=p1.position,$
			axis_style=0,yrange=[140,300],xrange=[-1,6],name='$BT_{8.55}$')
		ax1=axis('y',target=p5,location=[max(p5.xrange),0,0],textpos=1,tickdir=1,ticklen=0.02,minor=0,$
			title='Brightness Temperature (K)',tickvalues=[140,180,220,260,300])		
		p6=plot(x,annual_data[5,*],color=lncolor[5],overplot=p5,thick=lnthick,name='$BT_{11.03}$')

		ld=legend(target=[p1,p2,p3,p4,p5,p6],position=[0.18,0.75],font_size=fontsz,transparency=100,horizontal_alignment=0)

		; to plot wavelength vs. reflectance/BT	
		xname=['Clear','Ice only','Ice above liquid','Ice above mixed','Liquid only','Mixed only']
		xname2=['0.645','1.375','1.64','2.13','8.55','11.03']
		x=findgen(6)
		annual_data[4,*]=annual_data[4,*]/1000.0
		annual_data[5,*]=annual_data[5,*]/1000.0
;		ps1=plot(x,annual_data[*,0],xtickname=xname2,xtickvalues=x,font_size=fontsz,yminor=0,xminor=0,color=lncolor[0],xrange=[-1,6],$
;         yrange=[0,0.8],thick=lnthick,yticklen=1,ygridstyle=1,ytitle='Reflectance',xticklen=0.02,name=xname[0],$
;		 dim=[650,500],position=[0.15,0.2,0.85,0.9])
;		ax=ps1.axes
;		ax[0].text_orientation=50
;		pos=ps1.position
;		t=text(pos[0]+0.1,pos[3]+0.02,'$SZA ~ 30^\deg$',font_size=fontsz+1)

;		ps2=plot(x,annual_data[*,1],color=lncolor[1],overplot=ps1,thick=lnthick,name=xname[1])
;		ps3=plot(x,annual_data[*,2],color=lncolor[2],overplot=ps1,thick=lnthick,name=xname[2])
;		ps4=plot(x,annual_data[*,3],color=lncolor[3],overplot=ps1,thick=lnthick,name=xname[3])
;		ps5=plot(x,annual_data[*,4],color=lncolor[4],overplot=ps1,thick=lnthick,name=xname[4])
;		ps6=plot(x,annual_data[*,5],color=lncolor[5],overplot=ps1,thick=lnthick,name=xname[5])
;			
;		ld=legend(target=[ps1,ps2,ps3,ps4,ps5,ps6],position=[0.45,0.85],font_size=fontsz,transparency=100,horizontal_alignment=0)
			
		; to plot 1.375 um difference between ice only- ice above liquid
		;diff_data_sea=reform(sea_ave[1,*,0,*])-reform(sea_ave[1,*,3,*])		
		;diff_data_ann=reform(all_ave[1,*,0])-reform(all_ave[1,*,3])		

;		pd=plot(findgen(70),diff_data_ann,thick=lnthick,yminor=0,xminor=0,yticklen=1,ygridstyle=1,ytitle='$R_{1.375 \mu m,ice only}-R_{1.375 \mu m, ice above liquid}$',xticklen=0.02)
	
		xx=[0.18,0.18,0.18,0.18]	
		yy=[0.45,0.41,0.37,0.34]	
		for mi=0,3 do begin
		p10=plot(x,sea_data[0,*,mi],color=lncolor[0],thick=lnthick,overplot=p1,symbol=sea_sym[mi],sym_size=symsz,linestyle='',name=season[mi])
		p20=plot(x,sea_data[1,*,mi],color=lncolor[1],overplot=p1,thick=lnthick,symbol=sea_sym[mi],sym_size=symsz,linestyle='')
		p30=plot(x,sea_data[2,*,mi],color=lncolor[2],overplot=p1,thick=lnthick,symbol=sea_sym[mi],sym_size=symsz,linestyle='')
		p40=plot(x,sea_data[3,*,mi],color=lncolor[3],overplot=p1,thick=lnthick,symbol=sea_sym[mi],sym_size=symsz,linestyle='')
		
		p50=plot(x,sea_data[4,*,mi],color=lncolor[4],thick=lnthick,overplot=p5,symbol=sea_sym[mi],sym_size=symsz,linestyle='')
		p60=plot(x,sea_data[5,*,mi],color=lncolor[5],overplot=p5,thick=lnthick,symbol=sea_sym[mi],sym_size=symsz,linestyle='')
		ld=legend(target=[p10],position=[0.18,0.45-mi*0.04],font_size=fontsz,transparency=100,horizontal_alignment=0,horizontal_spacing=0.05,sample_width=0)

;		pd1=plot(findgen(70),diff_data_sea[*,mi],thick=lnthick,overplot=pd,symbol=sea_sym[mi],sym_size=symsz,linestyle='',name=season[mi])
;		ld=legend(target=[pd1],position=[0.18,0.55-mi*0.05],font_size=fontsz,transparency=100,horizontal_alignment=0,sample_width=0.1)

		endfor	

;		ps1.save,'cldphase_spectralwv_fourseason_newdomain20.png'
		p1.save,'cldphase_spectral_fourseason_newdomain_allsza_R05.png'
;		pd.save,'reflectance_1.375_iceonly_iceliquid_newdomain.png'	
			
	EndIf

	; === to plot annual pdf ===	
   IF pdfflag eq 1 and annualpdf eq 1 Then begin
		xtitle1='$R_{0.645}$'
		xtitle2='$R_{2.13}$/$R_{0.645}$'
		xtitle3='$BT_{11}$'
		xtitle4='$BT_{8.5}-BT_{11}$'
		xrange1=[0,1] ;reflect
		xrange2=[0,1.1] ;ratio
		xrange3=[180,300]; BT 
		xrange4=[-3,7] ;BT  diff
		yrange1=[0,30] ;BT, reflectance
		yrange2=[0,10] ; ratio, BTD
		
		x1=findgen(121)*0.01
		x2=findgen(500)*0.01
		x3=findgen(201)+150
		x4=findgen(300)*0.1-8.5
		xname=['Ice only','Liquid only','Mixed only','Ice above liquid','Ice above mixed','Clear']
		savetitle='allpdf'
		
		pos11=[0.07,0.60,0.26,0.93]
 		pos12=[0.07,0.14,0.26,0.47]
 		pos21=[0.30,0.60,0.50,0.93]
 		pos22=[0.30,0.14,0.50,0.47]
 		pos31=[0.54,0.60,0.74,0.93]
 	 	pos32=[0.54,0.14,0.74,0.47]
 		pos41=[0.78,0.60,0.98,0.93]
	    pos42=[0.78,0.14,0.98,0.47]
	
		all_reflect645_pdf1=all_reflect645_pdf
		all_reflect645_pdf[*,1,*]=  all_reflect645_pdf1[*,2,*]
		all_reflect645_pdf[*,2,*]=  all_reflect645_pdf1[*,1,*]
		all_reflect645_cdf1=all_reflect645_cdf
		all_reflect645_cdf[*,1,*]=  all_reflect645_cdf1[*,2,*]
		all_reflect645_cdf[*,2,*]=  all_reflect645_cdf1[*,1,*]

		all_reflect_ratio_pdf1=all_reflect_ratio_pdf
		all_reflect_ratio_pdf[*,1,*]=  all_reflect_ratio_pdf1[*,2,*]
		all_reflect_ratio_pdf[*,2,*]=  all_reflect_ratio_pdf1[*,1,*]
		all_reflect_ratio_cdf1=all_reflect_ratio_cdf
		all_reflect_ratio_cdf[*,1,*]=  all_reflect_ratio_cdf1[*,2,*]
		all_reflect_ratio_cdf[*,2,*]=  all_reflect_ratio_cdf1[*,1,*]

		all_bt11_pdf1=all_bt11_pdf
		all_bt11_pdf[*,1,*]=  all_bt11_pdf1[*,2,*]
		all_bt11_pdf[*,2,*]=  all_bt11_pdf1[*,1,*]
		all_bt11_cdf1=all_bt11_cdf
		all_bt11_cdf[*,1,*]=  all_bt11_cdf1[*,2,*]
		all_bt11_cdf[*,2,*]=  all_bt11_cdf1[*,1,*]

		all_btddiff_pdf1=all_btddiff_pdf
		all_btddiff_pdf[*,1,*]=  all_btddiff_pdf1[*,2,*]
		all_btddiff_pdf[*,2,*]=  all_btddiff_pdf1[*,1,*]
		all_btddiff_cdf1=all_btddiff_cdf
		all_btddiff_cdf[*,1,*]=  all_btddiff_cdf1[*,2,*]
		all_btddiff_cdf[*,2,*]=  all_btddiff_cdf1[*,1,*]

		; to plot pdf and cdf
		for typei=0,5 do begin

		fre_pdf1=100*(total(all_reflect645_pdf[*,typei,*],3)/total(all_reflect645_pdf[*,typei,*]))
		fre_cdf1=100*(total(all_reflect645_cdf[*,typei,*],3)/float(total(all_reflect645_cdf[120,typei,*])))
		fre_pdf2=100*(total(all_reflect_ratio_pdf[*,typei,*],3)/total(all_reflect_ratio_pdf[*,typei,*]))
		fre_cdf2=100*(total(all_reflect_ratio_cdf[*,typei,*],3)/float(total(all_reflect_ratio_cdf[499,typei,*])))
		fre_pdf3=100*(total(all_bt11_pdf[*,typei,*],3)/total(all_bt11_pdf[*,typei,*]))
		fre_cdf3=100*(total(all_bt11_cdf[*,typei,*],3)/float(total(all_bt11_cdf[200,typei,*])))
		fre_pdf4=100*(total(all_btddiff_pdf[*,typei,*],3)/total(all_btddiff_pdf[*,typei,*]))
		fre_cdf4=100*(total(all_btddiff_cdf[*,typei,*],3)/float(total(all_btddiff_cdf[299,typei,*])))

		if typei eq 0 then begin
			p11=plot(x1,fre_pdf1,xrange=xrange1,thick=lnthick,position=pos11,$
      		name=xname[typei],yrange=yrange1,font_size=fontsz,xtitle=' ',color=lncolor[typei],$
			ytitle='Frequency (%)',yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,$
			dim=[850,400])
			p12=plot(x1,fre_cdf1,xrange=xrange1,thick=lnthick,position=pos12,$
      		yrange=[0,100],font_size=fontsz,xtitle=xtitle1,color=lncolor[typei],$
			/current,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,ytitle='Frequency (%)')
	
			p21=plot(x2,fre_pdf2,xrange=xrange2,thick=lnthick,position=pos21,$
      		yrange=yrange2,font_size=fontsz,xtitle='',color=lncolor[typei],$
			ytitle='',yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,/current)
			p22=plot(x2,fre_cdf2,xrange=xrange2,thick=lnthick,position=pos22,$
      		yrange=[0,100],font_size=fontsz,xtitle=xtitle2,color=lncolor[typei],$
			/current,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02)

			p31=plot(x3,fre_pdf3,xrange=xrange3,thick=lnthick,position=pos31,$
      		yrange=yrange1,font_size=fontsz,xtitle='',color=lncolor[typei],$
			ytitle='',yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,/current)
			p32=plot(x3,fre_cdf3,xrange=xrange3,thick=lnthick,position=pos32,$
      		yrange=[0,100],font_size=fontsz,xtitle=xtitle3,color=lncolor[typei],$
			/current,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02)

			p41=plot(x4,fre_pdf4,xrange=xrange4,thick=lnthick,position=pos41,$
      		yrange=yrange2,font_size=fontsz,xtitle='',color=lncolor[typei],$
			ytitle='',yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,/current)
			p42=plot(x4,fre_cdf4,xrange=xrange4,thick=lnthick,position=pos42,$
      		yrange=[0,100],font_size=fontsz,xtitle=xtitle4,color=lncolor[typei],$
			/current,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02)

			t1=text(pos11[0]+0.01,pos11[3]-0.04,'a1)',font_size=fontsz)
			t1=text(pos12[0]+0.01,pos12[3]-0.04,'a2)',font_size=fontsz)
			t1=text(pos21[0]+0.01,pos21[3]-0.04,'b1)',font_size=fontsz)
			t1=text(pos22[0]+0.01,pos22[3]-0.04,'b2)',font_size=fontsz)
			t1=text(pos31[0]+0.01,pos31[3]-0.04,'c1)',font_size=fontsz)
			t1=text(pos32[0]+0.01,pos32[3]-0.04,'c2)',font_size=fontsz)
			t1=text(pos41[0]+0.01,pos41[3]-0.04,'d1)',font_size=fontsz)
			t1=text(pos42[0]+0.01,pos42[3]-0.04,'d2)',font_size=fontsz)
			t=text(pos21[0]+0.07,pos31[3]+0.02,'Probability Distribution Fuction',font_size=fontsz)
			t=text(pos22[0]+0.07,pos32[3]+0.02,'Cumulative Distribution Fuction',font_size=fontsz)

		endif

		if typei ge 1 then begin
		 p110=plot(x1,fre_pdf1,thick=lnthick,overplot=p11,color=lncolor[typei],name=xname[typei])
		 p120=plot(x1,fre_cdf1,thick=lnthick,overplot=p12,color=lncolor[typei],name=xname[typei])
		 p210=plot(x2,fre_pdf2,thick=lnthick,overplot=p21,color=lncolor[typei],name=xname[typei])
		 p220=plot(x2,fre_cdf2,thick=lnthick,overplot=p22,color=lncolor[typei],name=xname[typei])
		 p310=plot(x3,fre_pdf3,thick=lnthick,overplot=p31,color=lncolor[typei],name=xname[typei])
		 p320=plot(x3,fre_cdf3,thick=lnthick,overplot=p32,color=lncolor[typei],name=xname[typei])
		 p410=plot(x4,fre_pdf4,thick=lnthick,overplot=p41,color=lncolor[typei],name=xname[typei])
		 p420=plot(x4,fre_cdf4,thick=lnthick,overplot=p42,color=lncolor[typei],name=xname[typei])
		endif

		;---- get the peak position
	;	if (typei eq 5) then begin
		print,xname[typei]
		;gaussian fit to get the halfwidth
	  	ind=where(fre_pdf1 eq max(fre_pdf1))
;		res=gaussfit(x1,fre_pdf1,coef,nterms=3)
;		x=max(fre_pdf1)/2.0
;		res1=newton(x,'gausian_reverse')
		print,'max and half max r0.645', x1[ind[0]]
	
	  	ind=where(fre_pdf2 eq max(fre_pdf2))
;		res=gaussfit(x2,fre_pdf2,coef,nterms=3)
;		x=max(fre_pdf2)/2
;		res1=newton(X,'gausian_reverse')
		print,'max and half max ratio', x2[ind[0]]
;			

	  	ind=where(fre_pdf3 eq max(fre_pdf3))
		print,'bt11 maxvalue', x3[ind[0]]
;		res=gaussfit(x3,fre_pdf3,coef,nterms=3)
;		x=max(fre_pdf3)/2
;		res1=newton(X,'gausian_reverse')
		
	  	ind=where(fre_pdf4 eq max(fre_pdf4))
		print,'btd maxvalue', x4[ind[0]]
		res=gaussfit(x4,fre_pdf4,coef,nterms=3)
		x=max(fre_pdf4)/2
	
	;	endif

	    if typei eq 0 then ld=legend(target=[p11],position=[0.55,0.91],transparency=100,font_size=fontsz-1,horizontal_alignment=0,sample_width=0.1) $
		else ld=legend(target=[p110],position=[0.55,0.91-typei*0.04],transparency=100,font_size=fontsz-1,sample_width=0.1,horizontal_alignment=0)
	endfor ; end cloud type
	p11.save,'cldphase_allpdfcdf_annual_newdomain_R05.png'
	stop
	
   EndIF	;endif annual


end
		
