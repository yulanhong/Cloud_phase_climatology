
pro plot_pdfs

  season=['MAM','JJA','SON','DJF']
  liqtopflag=0 ; check liqtop distributions
  plotlsflag=0 ; check land sea difference
  xvalue=findgen(41)*0.5

  allicetop=0L
  allicebase=0L
  allicethick=0L
  allmixtop=0L
  allliqtop=0L
  alldem=0.0
  demnum=0L 
  allliqtopni=0L
  allliqtopwi=0L


  maplimit=[0,105,20,135]

  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/'

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
  Tmixtop=0L
  Tliqtop=0L

  for fi=0, Nf-1 do begin

 	If (fnamelen(fi) eq 123) then begin
		read_dardar,fname[fi],'ice_top_pdf',icetop
		read_dardar,fname[fi],'ice_base_pdf',icebase
		read_dardar,fname[fi],'ice_thick_pdf',icethick
		read_dardar,fname[fi],'mix_top_pdf',mixtop
		read_dardar,fname[fi],'liq_top_pdf',liqtop

		Ticetop=Ticetop+icetop
		Ticebase=Ticebase+icebase
		Ticethick=Ticethick+icethick
		Tmixtop=Tmixtop+mixtop
		Tliqtop=Tliqtop+liqtop
	
	    read_dardar,fname[fi],'latitude',lat
	    read_dardar,fname[fi],'longitude',lon
		read_dardar,fname[fi],'onelayercloud_frequency',onenum
		read_dardar,fname[fi],'mullayercloud_onephase_frequency',mul1num
		read_dardar,fname[fi],'mullayercloud_mulphase_frequency',mulnnum
		read_dardar,fname[fi],'DEM_elevation',DEM_hgt
		read_dardar,fname[fi],'obsnum',obsnum
		read_dardar,fname[fi],'onelayercloud_topheight',onelaytop
		read_dardar,fname[fi],'onelayercloud_baseheight',onelaybase
		read_dardar,fname[fi],'mullayercloud_onephase_topheight',mul1laytop
		read_dardar,fname[fi],'mullayercloud_onephase_baseheight',mul1laybase
		read_dardar,fname[fi],'mullayercloud_mulphase_lowlaytopheight',lowlaytop
		read_dardar,fname[fi],'mullayercloud_mulphase_uplaytopheight',uplaytop
		read_dardar,fname[fi],'mullayercloud_mulphase_uplaybaseheight',uplaybase
	
	
		read_dardar,fname[fi],'num_liqtop_noice',numliqtopni
		read_dardar,fname[fi],'num_liqtop_iceabove',numliqtopwi
	
		allliqtopni=allliqtopni+numliqtopni
		allliqtopwi=allliqtopwi+numliqtopwi	

		print,total(obsnum),fname[fi]
	 	ind=where(obsnum eq 0)
		DEM_hgt[ind]=0.0 
		alldem=alldem+DEM_hgt*obsnum
		demnum=demnum+obsnum			
     endif ; end filename

  endfor; end for one season

  		allicetop=allicetop+Ticetop
  		allicebase=allicebase+Ticebase
 		allicethick=allicethick+Ticethick
  		allmixtop=allmixtop+Tmixtop
  		allliqtop=allliqtop+Tliqtop

  endfor; end for four season

	;===== get tomography height over the target area===	
	ind1=where(lat ge maplimit[0] and lat le maplimit[2])
	alldem1=alldem[*,ind1]
	demnum1=demnum[*,ind1]
	allliqtopni1=allliqtopni[*,ind1,*,*]
	allliqtopwi1=allliqtopwi[*,ind1,*,*]

	ind2=where(lon ge maplimit[1] and lon le maplimit[3])
	alldem2=alldem1[ind2,*]
	demnum2=demnum1[ind2,*]
	allliqtopni2=allliqtopni1[ind2,*,*,*]
	allliqtopwi2=allliqtopwi1[ind2,*,*,*]
	
	; to get average tomographic height
	ind=where(demnum2 gt 0)
	avedem=total(alldem2)/total(demnum2[ind])

	;========= check whether there are more liquid clouds with top > 5 occuring in lower altitude==
 	if liqtopflag eq 1 then begin
		
		mp=map('Geographic',limit=maplimit,layout=[2,1,1])
	   	grid=mp.MAPGRID
	  	grid.label_position=0 
		im=image(reform(allliqtopwi2[*,*,0,0])/float(total(allliqtopwi2[*,*,0,0])),lon[ind2],lat[ind1],rgb_table=33,$
		overplot=mp,min_value=0,max_value=0.05,title='Frequency of liquid cloud with top > 5km',xrange=[105,135],yrange=[0,20] )
	    mc=mapcontinents(/continents,transparency=30)

		mp=map('Geographic',limit=maplimit,layout=[2,1,2],/current)
	   	grid=mp.MAPGRID
	  	grid.label_position=0 
		im=image(reform(allliqtopwi2[*,*,1,0])/float(total(allliqtopwi2[*,*,1,0])),lon[ind2],lat[ind1],rgb_table=33,$
		overplot=mp,min_value=0,max_value=0.05,title='Frequency of liquid cloud with top < 5km')
	    mc=mapcontinents(/continents,transparency=30)

		ct=colorbar(target=im,position=[0.3,0.2,0.7,0.225])

		mp.save,'liqtop5km_distribution_ocean_ice_day_newdomain.png'

				stop 
	endif

	
	allplotflag=1
	pos1=[0.10,0.70,0.35,0.90]
	pos2=[0.10,0.43,0.35,0.63]
	pos3=[0.10,0.16,0.35,0.36]
	pos4=[0.42,0.70,0.67,0.90]
	pos5=[0.42,0.43,0.67,0.63]
	pos6=[0.74,0.70,0.99,0.90]
	pos7=[0.74,0.43,0.99,0.63]
    yrange=[0,0.3]
    ytitle='Frequency'

	If (allplotflag eq 1) Then begin

	 season_icetop=fltarr(41,3,4,2) ; 2: 0-oncea, 1-land
	 season_icebase=fltarr(41,3,4,2)
	 season_icethick=fltarr(41,3,4,2)
	 season_mixtop=fltarr(41,2,4,2)
	 season_liqtop=fltarr(41,2,4,2)

	 season_icetop_err=fltarr(41,3,2) ; 2: 0-oncea, 1-land
	 season_icebase_err=fltarr(41,3,2)
	 season_icethick_err=fltarr(41,3,2)
	 season_mixtop_err=fltarr(41,2,2)
	 season_liqtop_err=fltarr(41,2,2)

	;======= restore seasonal variations =============
	for mi=0,3 do begin
		for lstypei=0,1 do begin
     	restore,filename='icetop'+season[mi]+'.sav'
		season_icetop[*,0,mi,lstypei]=Ticetop1[*,0,lstypei]/total(Ticetop1[*,0,lstypei])	
		season_icetop[*,1,mi,lstypei]=Ticetop1[*,1,lstypei]/total(Ticetop1[*,1,lstypei])	
		season_icetop[*,2,mi,lstypei]=Ticetop1[*,2,lstypei]/total(Ticetop1[*,2,lstypei])	
     	restore,filename='icebase'+season[mi]+'.sav'
		season_icebase[*,0,mi,lstypei]=Ticebase1[*,0,lstypei]/total(Ticebase1[*,0,lstypei])	
		season_icebase[*,1,mi,lstypei]=Ticebase1[*,1,lstypei]/total(Ticebase1[*,1,lstypei])	
		season_icebase[*,2,mi,lstypei]=Ticebase1[*,2,lstypei]/total(Ticebase1[*,2,lstypei])	
     	restore,filename='icethick'+season[mi]+'.sav'
		season_icethick[*,0,mi,lstypei]=Ticethick1[*,0,lstypei]/total(Ticethick1[*,0,lstypei])	
		season_icethick[*,1,mi,lstypei]=Ticethick1[*,1,lstypei]/total(Ticethick1[*,1,lstypei])	
		season_icethick[*,2,mi,lstypei]=Ticethick1[*,2,lstypei]/total(Ticethick1[*,2,lstypei])	
     	restore,filename='mixtop'+season[mi]+'.sav'    
		season_mixtop[*,0,mi,lstypei]=Tmixtop1[*,0,lstypei]/total(Tmixtop1[*,0,lstypei])	
		season_mixtop[*,1,mi,lstypei]=Tmixtop1[*,1,lstypei]/total(Tmixtop1[*,1,lstypei])	
     	restore,filename='liqtop'+season[mi]+'.sav'
		season_liqtop[*,0,mi,lstypei]=Tliqtop1[*,0,lstypei]/total(Tliqtop1[*,0,lstypei])	
		season_liqtop[*,1,mi,lstypei]=Tliqtop1[*,1,lstypei]/total(Tliqtop1[*,1,lstypei])	
		endfor
	endfor
    ; get standard deviation
    for stepi=0,40 do begin
		for lstypei=0,1 do begin
		season_icetop_err[stepi,0,lstypei]=stddev(reform(season_icetop[stepi,0,*,lstypei]))
		season_icetop_err[stepi,1,lstypei]=stddev(reform(season_icetop[stepi,1,*,lstypei]))
		season_icetop_err[stepi,2,lstypei]=stddev(reform(season_icetop[stepi,2,*,lstypei]))
		season_icebase_err[stepi,0,lstypei]=stddev(reform(season_icebase[stepi,0,*,lstypei]))
		season_icebase_err[stepi,1,lstypei]=stddev(reform(season_icebase[stepi,1,*,lstypei]))
		season_icebase_err[stepi,2,lstypei]=stddev(reform(season_icebase[stepi,2,*,lstypei]))
		season_icethick_err[stepi,0,lstypei]=stddev(reform(season_icethick[stepi,0,*,lstypei]))
		season_icethick_err[stepi,1,lstypei]=stddev(reform(season_icethick[stepi,1,*,lstypei]))
		season_icethick_err[stepi,2,lstypei]=stddev(reform(season_icethick[stepi,2,*,lstypei]))
		season_mixtop_err[stepi,0,lstypei]=stddev(reform(season_mixtop[stepi,0,*,lstypei]))
		season_mixtop_err[stepi,1,lstypei]=stddev(reform(season_mixtop[stepi,1,*,lstypei]))
		season_liqtop_err[stepi,0,lstypei]=stddev(reform(season_liqtop[stepi,0,*,lstypei]))
		season_liqtop_err[stepi,1,lstypei]=stddev(reform(season_liqtop[stepi,1,*,lstypei]))
		endfor
	endfor 

	  lsflag=0
	  flagname='Ocean'
	  symsz=0.8
	  fontsz=10
    ; === ice top
	  yvalue=allicetop[*,*,lsflag]
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  p=plot(xvalue,y1,dim=[800,700],position=pos1,name='Ice only',title='Over Ocean',$
		yrange=yrange,xtitle='Ice Top (km)',ytitle=ytitle);,errorbar_capsize=0.1)

;	  ind=where(season_icetop[*,0,0,lsflag] eq max(season_icetop[*,0,0,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,0,0,lsflag],symbol='Diamond',sym_filled=1,overplot=p,sym_size=symsz) 		
;	  ind=where(season_icetop[*,0,1,lsflag] eq max(season_icetop[*,0,1,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,0,1,lsflag],symbol='circle',sym_filled=1,overplot=p,sym_size=symsz) 		
;	  ind=where(season_icetop[*,0,2,lsflag] eq max(season_icetop[*,0,2,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,0,2,lsflag],symbol='Square',sym_filled=1,overplot=p,sym_size=symsz) 		
;	  ind=where(season_icetop[*,0,3,lsflag] eq max(season_icetop[*,0,3,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,0,3,lsflag],symbol='Triangle_down',sym_filled=1,overplot=p,sym_size=symsz) 		

	  p1=plot(xvalue,y2,color='r',name='Ice above liquid',overplot=p);,errorbar_color='r',$
		;errorbar_capsize=0.1)
;	  ind=where(season_icetop[*,1,0,lsflag] eq max(season_icetop[*,1,0,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,1,0,lsflag],symbol='Diamond',sym_filled=1,overplot=p,sym_size=symsz,color='r') 		
;	  ind=where(season_icetop[*,1,1,lsflag] eq max(season_icetop[*,1,1,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,1,1,lsflag],symbol='circle',sym_filled=1,overplot=p,sym_size=symsz,color='r') 		
;	  ind=where(season_icetop[*,1,2,lsflag] eq max(season_icetop[*,1,2,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,1,2,lsflag],symbol='Square',sym_filled=1,overplot=p,sym_size=symsz,color='r') 		
;	  ind=where(season_icetop[*,1,3,lsflag] eq max(season_icetop[*,1,3,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,1,3,lsflag],symbol='Triangle_down',sym_filled=1,overplot=p,sym_size=symsz,color='r') 		

	  p2=plot(xvalue,y3,color='b',name='Ice above mixed',overplot=p);,errorbar_color='b',$
		;errorbar_capsize=0.1)

;	  ind=where(season_icetop[*,2,0,lsflag] eq max(season_icetop[*,2,0,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,2,0,lsflag],symbol='Diamond',sym_filled=1,overplot=p,sym_size=symsz,color='b') 		
;	  ind=where(season_icetop[*,2,1,lsflag] eq max(season_icetop[*,2,1,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,2,1,lsflag],symbol='circle',sym_filled=1,overplot=p,sym_size=symsz,color='b') 		
;	  ind=where(season_icetop[*,2,2,lsflag] eq max(season_icetop[*,2,2,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,2,2,lsflag],symbol='Square',sym_filled=1,overplot=p,sym_size=symsz,color='b') 		
;	  ind=where(season_icetop[*,2,3,lsflag] eq max(season_icetop[*,2,3,lsflag]))
;	  ps=plot(xvalue[ind],season_icetop[ind,2,3,lsflag],symbol='Triangle_down',sym_filled=1,overplot=p,sym_size=symsz,color='b') 		

	  t=text(pos1[0]+0.02,pos1[3]-0.03,'Sample')
	  t=text(pos1[0]+0.02,pos1[3]-0.05,'7.872e05')	  
	  t1=text(pos1[0]+0.02,pos1[3]-0.07,'5.537e05',color='r')	  
	  t2=text(pos1[0]+0.02,pos1[3]-0.09,'1.763e05',color='b')	  
	  t3=text(pos1[0]+0.02,pos1[3],'a)')
	  ld=legend(target=[p,p1,p2],position=[0.34,0.81],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)

	; === ice base
      yvalue=allicebase[*,*,lsflag]
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  p1=plot(xvalue,y1,position=pos2,name='Ice only',/current,yrange=yrange,ytitle=ytitle,$
		xtitle='Ice Base (km)')
	  p11=plot(xvalue,y2,color='r',name='Ice above liquid',overplot=p1)
	  p12=plot(xvalue,y3,color='b',name='Ice above mixed',overplot=p1)
	  t3=text(pos2[0]+0.02,pos2[3],'b)')
	  ld=legend(target=[p1,p11,p12],position=[0.36,0.57],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	; === ice thick 
      yvalue=allicethick[*,*,lsflag]
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  p2=plot(xvalue,y1,position=pos3,name='Ice only',/current,$
			yrange=yrange,xtitle='Ice Geometrical Thickness (km)',ytitle=ytitle)
	  p21=plot(xvalue,y2,color='r',name='Ice above liquid',overplot=p2)
	  p22=plot(xvalue,y3,color='b',name='Ice above mixed',overplot=p2)
	  ld=legend(target=[p2,p21,p22],position=[0.36,0.31],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	  t3=text(pos3[0]+0.02,pos3[3],'c)')
	 
	; === liquid top 
	  ytitle='' 
      yvalue=allliqtop[*,*,lsflag]
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  p3=plot(xvalue,y1,position=pos4,name='No ice above',title='Over Ocean',/current,$
		yrange=yrange,ytitle=ytitle,xtitle='Liquid Top (km)')
	  p31=plot(xvalue,y2,color='r',name='Ice above',overplot=p3)
	  t=text(pos4[0]+0.02,pos4[3]-0.03,'Sample')
	  t=text(pos4[0]+0.02,pos4[3]-0.05,'2.870e05')	  
	  t1=text(pos4[0]+0.02,pos4[3]-0.07,'5.537e05',color='r')	  
	  t3=text(pos4[0]+0.02,pos4[3],'d)')
	  ld=legend(target=[p3,p31],position=[0.67,0.81],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)

	;=== mixed top
      yvalue=allmixtop[*,*,lsflag]
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  p4=plot(xvalue,y1,position=pos5,name='No ice above',title='',/current,yrange=yrange,$
		ytitle=ytitle,xtitle='Mixed Top (km)')
	  p41=plot(xvalue,y2,color='r',name='Ice above',overplot=p4)
	  t=text(pos5[0]+0.02,pos5[3]-0.03,'Sample')
	  t=text(pos5[0]+0.02,pos5[3]-0.05,'1.256e05')	  
	  t1=text(pos5[0]+0.02,pos5[3]-0.07,'1.763e05',color='r')	  
	  t3=text(pos5[0]+0.02,pos5[3],'e)')
	  ld=legend(target=[p4,p41],position=[0.67,0.55],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	;====== liquid land vs ocean
      yvalue=allliqtop
	  y3=float(yvalue[*,0,1])/total(yvalue[*,0,1])
	  p5=plot(xvalue,y3,name='No ice above',title='Over Land',position=pos6,/current,yrange=yrange,$
		ytitle=ytitle,xtitle='Liquid Top (km)')
	  y4=float(yvalue[*,1,1])/total(yvalue[*,1,1])
	  p53=plot(xvalue,y4,color='r',name='Ice above',overplot=p5)
	  t=text(pos6[0]+0.02,pos6[3]-0.03,'Sample')
	  t=text(pos6[0]+0.02,pos6[3]-0.05,'0.754e05')	  
	  t1=text(pos6[0]+0.02,pos6[3]-0.07,'1.666e05',color='r')	  
	  t3=text(pos6[0]+0.02,pos6[3],'f)')
	  ld=legend(target=[p5,p53],position=[0.99,0.81],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)

      yvalue=allmixtop
	  y3=float(yvalue[*,0,1])/total(yvalue[*,0,1])
	  p6=plot(xvalue,y3,name='No ice above',/current,yrange=yrange,$
		ytitle=ytitle,xtitle='Mixed Top (km)')
	  y4=float(yvalue[*,1,1])/total(yvalue[*,1,1])
	  p63=plot(xvalue,y4,color='r',name='Ice above ',position=pos7,overplot=p6)
	  ld=legend(target=[p6,p63],position=[0.99,0.55],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	  t=text(pos7[0]+0.02,pos7[3]-0.03,'Sample')
	  t=text(pos7[0]+0.02,pos7[3]-0.05,'0.261e05')	  
	  t1=text(pos7[0]+0.02,pos7[3]-0.07,'0.476e05',color='r')	  
	  t3=text(pos7[0]+0.02,pos7[3],'g)')
	  p.save,'top_base_iceocean_thick_pdfs_allyear_day_newdomain.png' 
	endif
	
  stop
end
