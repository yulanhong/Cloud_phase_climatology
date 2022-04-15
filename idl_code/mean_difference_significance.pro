
pro mean_difference_significance 

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
  allicetau=0L
  allicere =0L
  allavetau=0.0
  allavere =0.0

  allaveicetop=0.0
  allaveicebase=0.0
  allaveicethick=0.0
  
  allaveliqtop=0.0
  allavemixtop=0.0	

  allobsnumls=0L
  allcldnumls=0L

  maplimit=[-10,80,30,150]

  datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo/'
  tau_interval=(findgen(76)+1)*0.1-4.5
 
  For mi=3,3 Do Begin
 
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

  Nf=n_elements(fname)

  fnamelen=strlen(fname)

  Ticetop=0L
  Ticebase=0L
  Ticethick=0L
  Tmixtop=0L
  Tliqtop=0L

  Tobsnum=0L
  Tonenum=0L
  Tmul1num=0L
  Tmulnnum=0L
  Tonelaytop=0.0
  Tonelaybase=0.0
  Tmul1laytop=0.0
  Tmul1laybase=0.0
  Tlowlaytop=0.0
  Tuplaytop=0.0
  Tuplaybase=0.0 		
  Ticethickspa=0.0
  Ticethickspanum=0L

  Ticetau=0L
  Ticere =0L
  Tavetau=0.0
  Tavere =0.0
  Taveicetop=0.0
  Taveicebase=0.0
  Taveicethick=0.0
 
  Ticetau2=0L
  Ticere2 =0L
  Tavetau2=0.0
  Tavere2 =0.0
  Taveicetop2=0.0
  Taveicebase2=0.0
  Taveicethick2=0.0
 
  Taveliqtop=0.0
  Tavemixtop=0.0	
  Taveliqtop2=0.0
  Tavemixtop2=0.0	

  Tobsnumls=0L
  Tcldnumls=0L


  for fi=0, Nf-1 do begin
 	If (fnamelen(fi) eq 136) then begin
		read_dardar,fname[fi],'ice_top_pdf',icetop
		read_dardar,fname[fi],'ice_base_pdf',icebase
		read_dardar,fname[fi],'ice_thick_pdf',icethick
		read_dardar,fname[fi],'mix_top_pdf',mixtop
		read_dardar,fname[fi],'liq_top_pdf',liqtop
		read_dardar,fname[fi],'ice_tau_pdf',icetau
		read_dardar,fname[fi],'ice_re_pdf',icere

		read_dardar,fname[fi],'avetau',avetau
		read_dardar,fname[fi],'avere', avere
		read_dardar,fname[fi],'aveicetop',aveicetop
		read_dardar,fname[fi],'aveicebase',aveicebase
		read_dardar,fname[fi],'aveicethick',aveicethick
		read_dardar,fname[fi],'aveliqtop',aveliqtop
		read_dardar,fname[fi],'avemixtop',avemixtop

		read_dardar,fname[fi],'avetau_square',avetau2
		read_dardar,fname[fi],'avere_square', avere2
		read_dardar,fname[fi],'aveicetop_square',aveicetop2
		read_dardar,fname[fi],'aveicebase_square',aveicebase2
		read_dardar,fname[fi],'aveicethick_square',aveicethick2
		read_dardar,fname[fi],'aveliqtop_square',aveliqtop2
		read_dardar,fname[fi],'avemixtop_square',avemixtop2


		read_dardar,fname[fi],'obsnum_landocean_SEA',obsnumls
		read_dardar,fname[fi],'cldnum_landocean_SEA',cldnumls	
		print,fname[fi]		

		allicetau=allicetau+icetau
		allicere =allicere +icere

		allavetau=allavetau+avetau
		allavere =allavere +avere
		allaveicebase=allaveicebase+aveicebase
		allaveicetop=allaveicetop+aveicetop
		allaveicethick=allaveicethick+aveicethick

		allaveliqtop=allaveliqtop+aveliqtop
		allavemixtop=allavemixtop+avemixtop

		allobsnumls=allobsnumls+obsnumls
		allcldnumls=allcldnumls+cldnumls

		Ticetau=Ticetau+icetau
		Ticere =Ticere +icere

		Tavetau=Tavetau+avetau
		Tavere =Tavere +avere
		Tavetau2=Tavetau2+avetau2
		Tavere2 =Tavere2 +avere2

		Ticetop=Ticetop+icetop
		Ticebase=Ticebase+icebase
		Ticethick=Ticethick+icethick
		Tmixtop=Tmixtop+mixtop
		Tliqtop=Tliqtop+liqtop
	
		Taveicebase=Taveicebase+aveicebase
		Taveicetop=Taveicetop+aveicetop
		Taveicethick=Taveicethick+aveicethick
		Taveliqtop=Taveliqtop+aveliqtop
		Tavemixtop=Tavemixtop+avemixtop

		Taveicebase2=Taveicebase2+aveicebase2
		Taveicetop2=Taveicetop2+aveicetop2
		Taveicethick2=Taveicethick2+aveicethick2
		Taveliqtop2=Taveliqtop2+aveliqtop2
		Tavemixtop2=Tavemixtop2+avemixtop2

		Tobsnumls=Tobsnumls+obsnumls
		Tcldnumls=Tcldnumls+cldnumls

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
		print ,total(obsnum)
	    Tonenum=Tonenum+onenum
		Tmul1num=Tmul1num+mul1num
		Tmulnnum=Tmulnnum+mulnnum
		Tobsnum=Tobsnum+obsnum
	
		ind=where(onenum eq 0)
		onelaytop[ind]=0.0
		Tonelaytop=Tonelaytop+onelaytop*onenum
		onelaybase[ind]=0.0
		Tonelaybase=Tonelaybase+onelaybase*onenum
		ind=where(mul1num eq 0)
		mul1laytop[ind]=0.0
		mul1laybase[ind]=0.0
		Tmul1laytop=Tmul1laytop+mul1laytop*mul1num
		Tmul1laybase=Tmul1laybase+mul1laybase*mul1num

		ind=where(mulnnum eq 0)
		lowlaytop[ind]=0.0
		uplaytop[ind]=0.0
		uplaybase[ind]=0.0
		Tlowlaytop=Tlowlaytop+lowlaytop*mulnnum
		Tuplaytop =Tuplaytop + uplaytop*mulnnum
		Tuplaybase=Tuplaybase+ uplaybase*mulnnum
	
		read_dardar,fname[fi],'ice_cloud_thickness_num',icethickspanum
		read_dardar,fname[fi],'ice_cloud_thickness',icethickspa
		ind=where(icethickspanum eq 0)
		icethickspa[ind]=0.0
		Ticethickspanum=Ticethickspanum+icethickspanum
		Ticethickspa = Ticethickspa+icethickspa*icethickspanum

		read_dardar,fname[fi],'num_liqtop_noice',numliqtopni
		read_dardar,fname[fi],'num_liqtop_iceabove',numliqtopwi
	
		allliqtopni=allliqtopni+numliqtopni
		allliqtopwi=allliqtopwi+numliqtopwi	

		;print,total(obsnum),fname[fi]
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

	;===== get tomography height over the target area===	
	ind1=where(lat ge maplimit[0] and lat le maplimit[2])
	alldem1=alldem[*,ind1]
	demnum1=demnum[*,ind1]
	allliqtopni1=allliqtopni[*,ind1,*,*]
	allliqtopwi1=allliqtopwi[*,ind1,*,*]
	Tonenum1=Tonenum[*,ind1,*]
	Tmul1num1=Tmul1num[*,ind1,*]
	Tmulnnum1=Tmulnnum[*,ind1,*]
	Tonelaytop1=Tonelaytop[*,ind1,*]
	Tonelaybase1=Tonelaybase[*,ind1,*]
	Tmul1laytop1=Tmul1laytop[*,ind1,*]
	Tmul1laybase1=Tmul1laybase[*,ind1,*]
	Tlowlaytop1=Tlowlaytop[*,ind1,*]
	Tuplaytop1 =Tuplaytop[*,ind1,*]
	Tuplaybase1=Tuplaybase[*,ind1,*]
	Ticethickspa1=Ticethickspa[*,ind1,*]
	Ticethickspanum1=Ticethickspanum[*,ind1,*]
	Tobsnum1=Tobsnum[*,ind1]

	ind2=where(lon ge maplimit[1] and lon le maplimit[3])
	alldem2=alldem1[ind2,*]
	demnum2=demnum1[ind2,*]
	allliqtopni2=allliqtopni1[ind2,*,*,*]
	allliqtopwi2=allliqtopwi1[ind2,*,*,*]

	Tonenum2=Tonenum1[ind2,*,*]
	Tmul1num2=Tmul1num1[ind2,*,*]
	Tmulnnum2=Tmulnnum1[ind2,*,*]
	Tonelaytop2=Tonelaytop1[ind2,*,*]
	Tonelaybase2=Tonelaybase1[ind2,*,*]
	Tmul1laytop2=Tmul1laytop1[ind2,*,*]
	Tmul1laybase2=Tmul1laybase1[ind2,*,*]
	Tlowlaytop2=Tlowlaytop1[ind2,*,*]
	Tuplaytop2 =Tuplaytop1[ind2,*,*]
	Tuplaybase2=Tuplaybase1[ind2,*,*]
	Ticethickspa2=Ticethickspa1[ind2,*,*]
	Ticethickspanum2=Ticethickspanum1[ind2,*,*]
	Tobsnum2=Tobsnum1[ind2,*]
		print,season[mi]
	for i=0,2 do begin
	 seareave=Tavere[i,0]/total(Ticere[*,i,0])
	 print,'ocean ave re',seareave
	 searestd=sqrt(total(Tavere2[i,0])/total(Ticere[*,i,0])-seareave*seareave)
	 print,'ocean ave re stad',searestd
	 seatauave=total(Tavetau[i,0])/total(Ticetau[*,i,0])
	 print,'ocean ave tau mean',seatauave
	 seataustd=sqrt(total(Tavetau2[i,0])/total(Ticetau[*,i,0])-seatauave*seatauave)
	 print,'ocean ave tau std',seataustd
   	
	 seareave=Tavere[i,1]/total(Ticere[*,i,1])
	 print,'land ave re',seareave
	 searestd=sqrt(total(Tavere2[i,1])/total(Ticere[*,i,1])-seareave*seareave)
	 print,'land ave re stad',searestd
	 seatauave=total(Tavetau[i,1])/total(Ticetau[*,i,1])
	 print,'land ave tau mean',seatauave
	 seataustd=sqrt(total(Tavetau2[i,1])/total(Ticetau[*,i,1])-seatauave*seatauave)
	 print,'land ave tau std',seataustd
	endfor
	 ;ice only vs ice above liquid
	 n1=total(Ticetau[*,0,0])
	 n2=total(Ticetau[*,1,0])
	 s1=(total(Tavetau2[0,0])/n1-(Tavetau[0,0]/n1)^2.0); variance
	 s2=(total(Tavetau2[1,0])/n2-(Tavetau[1,0]/n2)^2.0) ;variance
	 SE=sqrt(s1/n1+s2/n2)
 	 DF=SE*SE/(((s1/n1)^2.0/(n1-1))+((s2/n2)^2.0/(n2-1)))
	 print,DF,round(DF)
	 t=(Tavetau[0,0]/n1-Tavetau[1,0]/n2)/SE	
	stop	
	meanflag=1
	if meanflag eq 1 then begin
	print, season[mi]
	print,'frequency ocean',Tcldnumls[*,0]/float(Tobsnumls[0])	
	print,'frequency land',Tcldnumls[*,1]/float(Tobsnumls[1])	
	print,'land+ocean frequency',total(Tcldnumls,2)/float(total(Tobsnumls))
	print,'others frequency',Tcldnumls[6,*]/float(Tobsnumls)-total(Tcldnumls[0:4,*],1)/float(Tobsnumls),$
		total(Tcldnumls[6,*])/float(total(Tobsnumls))-total(Tcldnumls[0:4,*])/float(total(Tobsnumls))

	print,'ave ice top',Taveicetop/total(Ticetop,1)
	print,'std ice top',sqrt(Taveicetop2/total(Ticetop,1)-(Taveicetop/total(Ticetop,1))^2.0)
	print,'ave ice base',Taveicebase/total(Ticebase,1)
	print,'std ice base',sqrt(Taveicebase2/total(Ticebase,1)-(Taveicebase/total(Ticebase,1))^2.0)
	print,'ave ice thick',Taveicethick/total(Ticethick,1)
	print,'std ice thick',sqrt(Taveicethick2/total(Ticethick,1)-(Taveicethick/total(Ticethick,1))^2.0)
	print,'ave liqtop',Taveliqtop/total(Tliqtop,1)
	print,'std liqtop',sqrt(Taveliqtop2/total(Tliqtop,1)-(Taveliqtop/total(Tliqtop,1))^2.0)
	print,'ave mixtop',Tavemixtop/total(Tmixtop,1)
	print,'std mixtop',sqrt(Tavemixtop2/total(Tmixtop,1)-(Tavemixtop/total(Tmixtop,1))^2.0)
	
;	print,'ice only top',total(Tonelaytop2[*,*,0]+Tmul1laytop2[*,*,0])/total(Tonenum2[*,*,0]+Tmul1num2[*,*,0])	
;	print,'ice only base',total(Tonelaybase2[*,*,0]+Tmul1laybase2[*,*,0])/total(Tonenum2[*,*,0]+Tmul1num2[*,*,0])	
;	print,'ice only thick',total(Ticethickspa2[*,*,0])/Total(Ticethickspanum2[*,*,0])
;	print,'liquid only top',total(Tonelaytop2[*,*,2]+Tmul1laytop2[*,*,2])/total(Tonenum2[*,*,2]+Tmul1num2[*,*,2])
;	print,'ice-liquid icetop',total(Tuplaytop2[*,*,0])/total(Tmulnnum2[*,*,0])
;	print,'ice-liquid icebase',total(Tuplaybase2[*,*,0])/total(Tmulnnum2[*,*,0])
;	print,'ice-liquid icethick',total(Ticethickspa2[*,*,1])/Total(Ticethickspanum2[*,*,1])
;	print,'ice-liquid liquidtop',total(Tlowlaytop2[*,*,0])/total(Tmulnnum2[*,*,0])
;	print,'ice-mix icetop',total(Tuplaytop2[*,*,1])/total(Tmulnnum2[*,*,1])
;	print,'ice-mix icebase',total(Tuplaybase2[*,*,1])/total(Tmulnnum2[*,*,1])
;	print,'ice-mix icethick',total(Ticethickspa2[*,*,2])/Total(Ticethickspanum2[*,*,2])
;	print,'ice-mix mixtop',total(Tlowlaytop2[*,*,1])/total(Tmulnnum2[*,*,1])
;	print,'mixed only top',total(Tonelaytop2[*,*,1]+Tmul1laytop2[*,*,1])/total(Tonenum2[*,*,1]+Tmul1num2[*,*,1])
	endif
	; to get average tomographic height
	ind=where(demnum2 gt 0)
	avedem=total(alldem2)/total(demnum2[ind])
  endfor; end for four season

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

				stop 
	endif

	
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
	  ;ld=legend(target=[p2,p21,p22],position=[0.36,0.31],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	  t3=text(pos3[0]+0.02,pos3[3],'c)')
	  t=text(pos3[0]+0.04,pos3[3]-0.03,'Thickness < 3.0 km',font_size=fontsz)
	  t=text(pos3[0]+0.05,pos3[3]-0.05,'57.4%',font_size=fontsz)
	  t=text(pos3[0]+0.05,pos3[3]-0.07,'71.5%',color='r',font_size=fontsz)
	  t=text(pos3[0]+0.05,pos3[3]-0.09,'68.1%',color='b',font_size=fontsz)
	;=== ice tau
      yvalue=total(allicetau,3)
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])
	  ind=where(tau_interval le -0.39794) ;tau~0.4
	  for i=0,2 do print,'ice tau < 0.4 ',total(yvalue[ind,i])/total(yvalue[*,i])		
	  ind=where(tau_interval le 0) ;tau~0.4
	  for i=0,2 do print,'ice tau < 1 ',total(yvalue[ind,i])/total(yvalue[*,i])		
	  p5=plot(tau_interval,y1,position=pos4,name='Ice only',/current,$
			xtitle='$log_{10}(Ice \tau)$',xrange=[-3.5,2],yrange=[0,0.1])
	  p51=plot(tau_interval,y2,color='r',name='Ice above liquid',overplot=p5)
	  p52=plot(tau_interval,y3,color='b',name='Ice above mixed',overplot=p5)
	  ;ld=legend(target=[p5,p51,p52],position=[0.67,0.81],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	  t3=text(pos4[0]+0.02,pos4[3],'d)')
	  t=text(pos4[0]+0.02,pos4[3]-0.03,'Ice $\tau$ < 0.4',font_size=fontsz)
	  t=text(pos4[0]+0.03,pos4[3]-0.05,'43.2%',font_size=fontsz)
	  t=text(pos4[0]+0.03,pos4[3]-0.07,'57.0%',color='r',font_size=fontsz)
	  t=text(pos4[0]+0.03,pos4[3]-0.09,'54.2%',color='b',font_size=fontsz)
	  t=text(pos4[0]+0.12,pos4[3]-0.03,'Ice $\tau$ < 1.0',font_size=fontsz)
	  t=text(pos4[0]+0.13,pos4[3]-0.05,'54.0%',font_size=fontsz)
	  t=text(pos4[0]+0.13,pos4[3]-0.07,'71.5%',color='r',font_size=fontsz)
	  t=text(pos4[0]+0.13,pos4[3]-0.09,'70.2%',color='b',font_size=fontsz)
	 
      yvalue=total(allicere,3)
	  y1=float(yvalue[*,0])/total(yvalue[*,0])
	  y2=float(yvalue[*,1])/total(yvalue[*,1])
	  y3=float(yvalue[*,2])/total(yvalue[*,2])

	  ind=where(findgen(150) le 20) ;tau~0.4
	  for i=0,2 do print,'ice re < 20 ',total(yvalue[ind,i])/total(yvalue[*,i])		

	  p6=plot(findgen(150),y1,position=pos5,name='Ice only',/current,$
			xtitle='Ice Effective Radius ($\mum$)',yrange=[0,0.1],$
			xrange=[0,80])
	  p61=plot(findgen(150),y2,color='r',name='Ice above liquid',overplot=p6)
	  p62=plot(findgen(150),y3,color='b',name='Ice above mixed',overplot=p6)
	  ;ld=legend(target=[p6,p61,p62],position=[0.67,0.55],shadow=0,sample_width=0.06,transparency=100,vertical_spacing=0.01,font_size=fontsz)
	  t3=text(pos5[0]+0.02,pos5[3],'e)')
	  t=text(pos5[0]+0.08,pos5[3]-0.03,'Re < 20 $\mum$',font_size=fontsz)
	  t=text(pos5[0]+0.09,pos5[3]-0.05,'41.0%',font_size=fontsz)
	  t=text(pos5[0]+0.09,pos5[3]-0.07,'51.1%',color='r',font_size=fontsz)
	  t=text(pos5[0]+0.09,pos5[3]-0.09,'46.4%',color='b',font_size=fontsz)
 
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
