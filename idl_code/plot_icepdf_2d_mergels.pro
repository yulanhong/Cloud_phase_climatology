
pro plot_icepdf_2d_mergels

  season=['MAM','JJA','SON','DJF']
  liqtopflag=0 ; check liqtop distributions
  plotlsflag=0 ; check land sea difference
  xvalue=findgen(41)*0.5

  allicetop=0L
  allicebase=0L
  allicethick=0L
  allmixtop=0L
  allliqtop=0L

  allicebase_2d=0L

  allobsnumls=0L
  a=0L
  allcldnumls=0L

  maplimit=[-10,80,30,150]

  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/'
  tau_interval=(findgen(76)+1)*0.1-4.5

  For mi=0,3 Do Begin
 
  if mi eq 0 then begin
  allfname1=file_search(datadir,'*03_day.hdf')
  allfname2=file_search(datadir,'*04_day.hdf')
  allfname3=file_search(datadir,'*05_day.hdf')
  endif
  if mi eq 1 then begin
  allfname1=file_search(datadir,'*06_day.hdf')
  allfname2=file_search(datadir,'*07_day.hdf')
  allfname3=file_search(datadir,'*08_day.hdf')
  endif
  if mi eq 2 then begin
  allfname1=file_search(datadir,'*09_day.hdf')
  allfname2=file_search(datadir,'*10_day.hdf')
  allfname3=file_search(datadir,'*11_day.hdf')
  endif
  if mi eq 3 then begin
  allfname1=file_search(datadir,'*12_day.hdf')
  allfname2=file_search(datadir,'*01_day.hdf')
  allfname3=file_search(datadir,'*02_day.hdf')
  endif
  
  fname=[allfname1,allfname2,allfname3]

 ; fname=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial/','*.hdf')

  Nf=n_elements(fname)

  fnamelen=strlen(fname)


  Ticetop=0L
  Ticebase=0L
  Ticethick=0L
  Ticebase_2d=0L

  Tmixtop=0L
  Tliqtop=0L

  Tobsnumls=0L
  Tcldnumls=0L
	
  for fi=0, Nf-1 do begin
 	If (fnamelen(fi) eq 123) then begin
		read_dardar,fname[fi],'ice_top_pdf',icetop
		read_dardar,fname[fi],'ice_base_pdf',icebase
		read_dardar,fname[fi],'ice_thick_pdf',icethick
		read_dardar,fname[fi],'mix_top_pdf',mixtop
		read_dardar,fname[fi],'liq_top_pdf',liqtop
		read_dardar,fname[fi],'obsnum_landocean_SEA',obsnumls
		read_dardar,fname[fi],'cldnum_landocean_SEA',cldnumls	
		read_dardar,fname[fi],'ice_basetop_2d',icebase_2d
		a=a+total(obsnumls)
		print,a

		allobsnumls=allobsnumls+obsnumls
		allcldnumls=allcldnumls+cldnumls


		Ticetop=Ticetop+icetop
		Ticebase=Ticebase+icebase
		Ticethick=Ticethick+icethick
		Tmixtop=Tmixtop+mixtop
		Tliqtop=Tliqtop+liqtop
		Ticebase_2d=Ticebase_2d+icebase_2d
		
     endif ; end filename

  endfor; end for one season

  	allicetop=allicetop+Ticetop
  	allicebase=allicebase+Ticebase
 	allicethick=allicethick+Ticethick
  	allmixtop=allmixtop+Tmixtop
  	allliqtop=allliqtop+Tliqtop

	allicebase_2d=allicebase_2d+Ticebase_2d

  endfor; end for four season
	
	flag2dpdf=1
	IF (flag2dpdf eq 1) Then Begin
		pos1=[0.10,0.20,0.35,0.90]
		pos2=[0.40,0.20,0.65,0.90]
		pos3=[0.70,0.20,0.95,0.90]
		barpos=[0.2,0.15,0.80,0.18]

		allicebase_2d1=total(allicebase_2d,4)
		y1=reform(allicebase_2d1[*,*,0])/float(total(allicebase_2d1[*,*,0]))
		y2=reform(allicebase_2d1[*,*,1])/float(total(allicebase_2d1[*,*,1]))
		y3=reform(allicebase_2d1[*,*,2])/float(total(allicebase_2d1[*,*,2]))
		ytickv=[5,10,15,20]
		yname =['5','10','15','20']
		minvalue=0
		maxvalue=0.015
;		loadct,33,rgb_table=rgb
;		rgb=rgb[16+16*indgen(15),*]
	

		c1=image(y1,xvalue,xvalue,rgb_table=33,position=pos1,dim=[700,400],xrange=[5,20],yrange=[5,20],$
			min_value=minvalue,max_value=maxvalue)
		ax1=axis('X',location=5,target=c1,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,$
			title='Cloud Base (km)')
		ax2=axis('Y',location=5,target=c1,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Cloud Top (km)')

		c2=image(y2,xvalue,xvalue,rgb_table=33,position=pos2,/current,xrange=[5,20],yrange=[5,20],$
			min_value=minvalue,max_value=maxvalue)
		ax1=axis('X',location=5,target=c2,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Cloud Base (km)')
		ax2=axis('Y',location=5,target=c2,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='')
		c3=image(y3,xvalue,xvalue,rgb_table=33,position=pos3,/current,xrange=[5,20],yrange=[5,20],$
			min_value=minvalue,max_value=maxvalue)
		ax1=axis('X',location=5,target=c3,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Cloud Base (km)')
		ax2=axis('Y',location=5,target=c3,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='')
				
		t1=text(pos1[0]+0.04,pos1[3]-0.10,'Ice only',font_size=13)
		t2=text(pos2[0]+0.04,pos2[3]-0.10,'Ice above liquid',font_size=13)
		t3=text(pos3[0]+0.04,pos3[3]-0.10,'Ice above mixed',font_size=13)
	

		cb=colorbar(target=c1,position=barpos,title='Frequency',/border,font_size=13,rgb_table=rgb)
;		c1.save,'icetopbase_2dpdf_newdomain.png'
		stop
	EndIf

	allplotflag=0
	pos1=[0.10,0.70,0.35,0.90]
	pos2=[0.10,0.43,0.35,0.63]
	pos3=[0.10,0.16,0.35,0.36]
	pos4=[0.42,0.70,0.67,0.90]
	pos5=[0.42,0.43,0.67,0.63]
	pos6=[0.74,0.70,0.98,0.90]
	pos7=[0.74,0.43,0.98,0.63]
    yrange=[0,0.3]
    ytitle='Frequency'

	If (allplotflag eq 1) Then begin

	  symsz=0.8
	  fontsz=10
    ; === ice top
	  yvalue=total(allicetop,3)
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  ind=where(xvalue ge 15)
	  for i=0,2 do print,'ice greater than 15 km',total(yvalue[ind,i])/total(yvalue[*,i])		

	  p=plot(xvalue,y1,dim=[800,700],position=pos1,name='Ice only',$
		xtitle='Ice Top (km)',ytitle=ytitle,yrange=[0,0.2]);,errorbar_capsize=0.1)

	  p1=plot(xvalue,y2,color='r',name='Ice above liquid',overplot=p);,errorbar_color='r',$

	  p2=plot(xvalue,y3,color='b',name='Ice above mixed',overplot=p);,errorbar_color='b',$
		;errorbar_capsize=0.1)
	  t3=text(pos1[0]+0.02,pos1[3],'a)')
	  t=text(pos1[0]+0.02,pos1[3]-0.03,'Top > 15 km',font_size=fontsz)
	  t=text(pos1[0]+0.03,pos1[3]-0.05,'63.2%',font_size=fontsz)
	  t=text(pos1[0]+0.03,pos1[3]-0.07,'64.2%',color='r',font_size=fontsz)
	  t=text(pos1[0]+0.03,pos1[3]-0.09,'68.8%',color='b',font_size=fontsz)
	  
	  ld=legend(target=[p,p1,p2],position=[0.34,0.81],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
 	  ; to plot median; from plot_cdfpdf_merge
 	  my1=fltarr(n_elements(y1))
 	  my2=findgen(n_elements(y1))*0.1
	  my1(*)=15.08
	  mp=plot(my1,my2,linestyle='dashed',overplot=p,yrange=[0,0.2])	
	  my1(*)=15.13
	  mp1=plot(my1,my2,linestyle='dashed',color='r',overplot=p)	
	  my1(*)=15.29
	  mp1=plot(my1,my2,linestyle='dashed',color='b',overplot=p)
	
	; === ice base
      yvalue=total(allicebase,3)
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  ind=where(xvalue ge 10)
	  for i=0,2 do print,'ice base > 10 km',total(yvalue[ind,i])/total(yvalue[*,i])		
	  p1=plot(xvalue,y1,position=pos2,name='Ice only',/current,ytitle=ytitle,$
		xtitle='Ice Base (km)',yrange=[0,0.2])
	  p11=plot(xvalue,y2,color='r',name='Ice above liquid',overplot=p1)
	  p12=plot(xvalue,y3,color='b',name='Ice above mixed',overplot=p1)
	  t3=text(pos2[0]+0.02,pos2[3],'b)')
	  t=text(pos2[0]+0.02,pos2[3]-0.03,'Base > 10 km',font_size=fontsz)
	  t=text(pos2[0]+0.03,pos2[3]-0.05,'67.8%',font_size=fontsz)
	  t=text(pos2[0]+0.03,pos2[3]-0.07,'76.6%',color='r',font_size=fontsz)
	  t=text(pos2[0]+0.03,pos2[3]-0.09,'79.6%',color='b',font_size=fontsz)
	  ;ld=legend(target=[p1,p11,p12],position=[0.36,0.57],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	  my1(*)=11.09
	  mp=plot(my1,my2,linestyle='dashed',overplot=p1,yrange=[0,0.2])	
	  my1(*)=11.91
	  mp1=plot(my1,my2,linestyle='dashed',color='r',overplot=p1)	
	  my1(*)=11.83
	  mp1=plot(my1,my2,linestyle='dashed',color='b',overplot=p1)

	; === ice thick 
      yvalue=total(allicethick,3)
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  ind=where(xvalue le 3.)
	  for i=0,2 do print,'ice thick < 3.0 km',total(yvalue[ind,i])/total(yvalue[*,i])		
	  p2=plot(xvalue,y1,position=pos3,name='Ice only',/current,yrange=[0,0.2],$
		xtitle='Ice Geometrical Thickness (km)',ytitle=ytitle)
	  p21=plot(xvalue,y2,color='r',name='Ice above liquid',overplot=p2)
	  p22=plot(xvalue,y3,color='b',name='Ice above mixed',overplot=p2)

	; === liquid top 
	  ytitle='' 
      yvalue=reform(allliqtop[*,*,0])
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  p3=plot(xvalue,y1,position=pos6,name='Liquid only',/current,$
		yrange=[0,0.2],ytitle=ytitle,xtitle='Liquid Top (km)',color='purple')
	  p31=plot(xvalue,y2,color='green',name='Liquid below ice',overplot=p3)
	  t3=text(pos6[0]+0.02,pos6[3],'f)')
	  ld=legend(target=[p3,p31],position=[1.03,0.88],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)

      yvalue=reform(allliqtop[*,*,1])
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  p32=plot(xvalue,y1,color='purple',linestyle='dashed',overplot=p3)
	  p33=plot(xvalue,y2,color='green',linestyle='dashed',overplot=p3)

	;=== mixed top
      yvalue=reform(allmixtop[*,*,0])
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  p4=plot(xvalue,y1,position=pos7,name='Mixed only',title='',/current,yrange=[0,0.2],$
		ytitle=ytitle,xtitle='Mixed Top (km)',color='grey')
	  p41=plot(xvalue,y2,color='cyan',name='Mixed below ice',overplot=p4)
	  t3=text(pos7[0]+0.02,pos7[3],'g)')
	  ld=legend(target=[p4,p41],position=[0.99,0.60],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)

      yvalue=reform(allmixtop[*,*,1])
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  p42=plot(xvalue,y1,color='grey',linestyle='dashed',overplot=p4)
	  p43=plot(xvalue,y2,color='cyan',linestyle='dashed',overplot=p4)

	endif
	
  stop
end
