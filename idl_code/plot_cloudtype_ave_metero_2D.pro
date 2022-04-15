
pro plot_cloudtype_ave_metero_2D

 for mi=1,3 do begin
 if mi eq 0 then begin
 	fname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*03_R05_day.hdf')
 	fname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*04_R05_day.hdf')
 	fname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*05_R05_day.hdf')
 endif
 if mi eq 1 then begin
 	fname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*06_R05_day.hdf')
 	fname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*07_R05_day.hdf')
 	fname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*08_R05_day.hdf')
 endif
 if mi eq 2 then begin
 	fname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*09_R05_day.hdf')
 	fname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*10_R05_day.hdf')
 	fname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*11_R05_day.hdf')
 endif
 if mi eq 3 then begin
 	fname1=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*12_R05_day.hdf')
 	fname2=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*01_R05_day.hdf')
 	fname3=file_search('/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Serial_dn/version_meteo','*02_R05_day.hdf')
 endif

 fname=[fname1,fname2,fname3]

 Nf=n_elements(fname)

 Tave_low_stat=0.0D
 Tave_low_stat2=0.0D
 Tcldfre_lowstat=0L
	
 Tave_low_sp=0.0D
 Tave_low_sp2=0.0D
 Tcldfre_lowsp=0L

 Tave_low_temp=0.0D
 Tave_low_temp2=0.0D
 Tcldfre_lowtemp=0L

 Tave_up_stat=0.0D
 Tave_up_stat2=0.0D
 Tcldfre_upstat=0L
	
 Tave_up_sp=0.0D
 Tave_up_sp2=0.0D
 Tcldfre_upsp=0L

 Tave_up_temp=0.0D
 Tave_up_temp2=0.0D
 Tcldfre_uptemp=0L

  posx1=[0.08,0.32,0.56,0.80]
  posx2=[0.25,0.49,0.73,0.97]
  posy1=[0.57,0.13]
  posy2=[0.87,0.43]

  for fi=0,Nf-1 do begin

;	print,fname[fi]
	strmon=strmid(fname[fi],9,2,/rev)

    mon=fix(strmon)

	read_dardar,fname[fi],'latitude',lat
	read_dardar,fname[fi],'longitude',lon
	read_dardar,fname[fi],'monthly_surface_temperature',surf_t		
	
	read_dardar,fname[fi],'average_low_stat',ave_low_stat
	read_dardar,fname[fi],'average_low_stat_square',ave_low_stat2
	read_dardar,fname[fi],'cldfre_lowstat',cldfre_lowstat
	Tave_low_stat=Tave_low_stat+ave_low_stat
	Tave_low_stat2=Tave_low_stat2+ave_low_stat2
	Tcldfre_lowstat=Tcldfre_lowstat+cldfre_lowstat

	read_dardar,fname[fi],'average_low_sp',ave_low_sp
	read_dardar,fname[fi],'average_low_sp_square',ave_low_sp2
	read_dardar,fname[fi],'cldfre_lowsp',cldfre_low_sp
	Tave_low_sp=Tave_low_sp+ave_low_sp
	Tave_low_sp2=Tave_low_sp2+ave_low_sp2
	Tcldfre_lowsp=Tcldfre_lowsp+cldfre_low_sp

	read_dardar,fname[fi],'average_low_temp',ave_low_temp
	read_dardar,fname[fi],'average_low_temp_square',ave_low_temp2
	read_dardar,fname[fi],'cldfre_lowtemp',cldfre_low_temp

	Tave_low_temp=Tave_low_temp+ave_low_temp
	Tave_low_temp2=Tave_low_temp2+ave_low_temp2
	Tcldfre_lowtemp=Tcldfre_lowtemp+cldfre_low_temp

	read_dardar,fname[fi],'average_up_stat',ave_up_stat
	read_dardar,fname[fi],'average_up_stat_square',ave_up_stat2
	read_dardar,fname[fi],'cldfre_upstat',cldfre_upstat

	Tave_up_stat=Tave_up_stat+ave_up_stat
	Tave_up_stat2=Tave_up_stat2+ave_up_stat2
	Tcldfre_upstat=Tcldfre_upstat+cldfre_upstat

	read_dardar,fname[fi],'average_up_sp',ave_up_sp
	read_dardar,fname[fi],'average_up_sp_square',ave_up_sp2
	read_dardar,fname[fi],'cldfre_upsp',cldfre_up_sp
	Tave_up_sp=Tave_up_sp+ave_up_sp
	Tave_up_sp2=Tave_up_sp2+ave_up_sp2
	Tcldfre_upsp=Tcldfre_upsp+cldfre_up_sp

	read_dardar,fname[fi],'average_up_temp',ave_up_temp
	read_dardar,fname[fi],'average_up_temp_square',ave_up_temp2
	read_dardar,fname[fi],'cldfre_uptemp',cldfre_up_temp

	Tave_up_temp=Tave_up_temp+ave_up_temp
	Tave_up_temp2=Tave_up_temp2+ave_up_temp2
	Tcldfre_uptemp=Tcldfre_uptemp+cldfre_up_temp
	
  endfor ; endfor files


;  symbol=['Circle','Triangle','Square','Star']
  symbol=['Circle','Circle','Circle','Circle']
  symsz=1.0
  symcol=['g','b','dark orange','r','purple'] 
  sythick=3
  lnthick=2
  fontsz=10
  typename=['Ice only','Liquid only','Mixed only','Ice above liquid','Ice above mixed']
  seaname=['MAM','JJA','SON','DJF']
  ;for lower xrange=[7,15],zrange=[3.0,5.0],yrange=[285,295]
  ; for upper xrange=[0.005,0.05],zrange=[1,10],yrange=[211,215] 

  IF (mi eq 1 or mi eq 3) Then Begin

  pos1=[posx1[mi-1],posy1[0],posx2[mi-1],posy2[0]] ; for lower troposphere
  pos2=[posx1[mi],posy1[0],posx2[mi],posy2[0]] ; for lower troposphere
 
  pos3=[posx1[mi-1],posy1[1],posx2[mi-1],posy2[1]] ; for upper troposphere
  pos4=[posx1[mi],posy1[1],posx2[mi],posy2[1]] ; for upper troposphere
  ; =============== for lower troposphere ============================
  data1 =Tcldfre_lowsp
  data2 =Tave_low_sp
  data3 =Tave_low_sp2
  nsize =size(data1)
  seaave_lowsp =data2/total(data1,2) 
  seaave2_lowsp=data3/total(data1,2) 
  sea_lowsp_std=sqrt(seaave2_lowsp-seaave_lowsp*seaave_lowsp)

  data1 =Tcldfre_lowstat
  data2 =Tave_low_stat
  data3 =Tave_low_stat2
  nsize =size(data1)
  seaave_lowstat =data2/total(data1,2) 
  seaave2_lowstat=data3/total(data1,2) 
  sea_lowstat_std=sqrt(seaave2_lowstat-seaave_lowstat*seaave_lowstat)
 
  data1 =Tcldfre_lowtemp
  data2 =Tave_low_temp
  data3 =Tave_low_temp2
  nsize =size(data1)
  seaave_lowtemp =data2/total(data1,2) 
  seaave2_lowtemp=data3/total(data1,2) 
  sea_lowtemp_std=sqrt(seaave2_lowtemp-seaave_lowtemp*seaave_lowtemp)

  x=fltarr(5)	
  x=reform(seaave_lowsp[*,0])
  x[1]=reform(seaave_lowsp[2,0]) ;change the position of mixed only and liquid only
  x[2]=reform(seaave_lowsp[1,0])
  z=fltarr(5)
  z=reform(seaave_lowstat[*,0])
  z[1]=reform(seaave_lowstat[2,0])
  z[2]=reform(seaave_lowstat[1,0])
  y=fltarr(5)
  y=reform(seaave_lowtemp[*,0])
  y[1]=reform(seaave_lowtemp[2,0])	
  y[2]=reform(seaave_lowtemp[1,0])	

  xerr=fltarr(5)
  xerr=reform(sea_lowsp_std[*,0])
  xerr[1]=reform(sea_lowsp_std[2,0]) ;change the position of mixed only and liquid only
  xerr[2]=reform(sea_lowsp_std[1,0])
  zerr=fltarr(5)
  zerr=reform(sea_lowstat_std[*,0])
  zerr[1]=reform(sea_lowstat_std[2,0])
  zerr[2]=reform(sea_lowstat_std[1,0])
  yerr=fltarr(5)
  yerr=reform(sea_lowtemp_std[*,0])
  yerr[1]=reform(sea_lowtemp_std[2,0])	
  yerr[2]=reform(sea_lowtemp_std[1,0])	

  
  for ki=0,4 do begin 
  	if mi eq 1 and ki eq 0 then begin
		p=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$ ;temp vs sp
		symbol=symbol[mi],yrange=[7,15],xrange=[285,295],axis_style=2,position=pos1,dim=[1000,600],$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi])
		p.xtitle='Temperature (K)'
		p.ytitle='Specific Humidity ($g kg^{-1}$)'
		t1=text(pos1[2]+0.01,pos1[3]+0.02,'a) '+seaname[mi],font_size=fontsz+1)
	endif
    if mi eq 1 and ki ge 1 then p1=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=p,sym_thick=sythick,name=seaname[mi])
	;temp vs. stat	
	if mi eq 1 and ki eq 0 then begin
		p2=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$ ;temp vs sp
		symbol=symbol[mi],yrange=[3,5],xrange=[285,295],axis_style=2,position=pos2,/current,$ 
		sym_thick=sythick,xminor=0,yminor=0)
		p2.xtitle='Temperature (K)'
		p2.ytitle='Stability ($K km^{-1}$)'
;		t1=text(pos1[0]+0.05,pos1[1]+0.19,'a) '+seaname[mi],font_size=fontsz)
	endif
    if mi eq 1 and ki ge 1 then p21=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=p2,sym_thick=sythick,name=seaname[mi])

	if mi eq 3 then begin ;DJF
		if ki eq 0 then begin
		p=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$
		symbol=symbol[mi],yrange=[7,15],xrange=[285,295],axis_style=2,position=pos1,/current,$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi])
		p.xtitle='Temperature (K)'
		p.ytitle='Specific Humidity ($g kg^{-1}$)'
		t2=text(pos1[2]+0.01,pos1[3]+0.02,'b) '+seaname[mi],font_size=fontsz+1)
		endif
    	if ki ge 1 then p1=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=p,sym_thick=sythick)
		
		if ki eq 0 then begin
		p2=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$
		symbol=symbol[mi],yrange=[3,5],xrange=[285,295],axis_style=2,position=pos2,/current,$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi])
		p2.xtitle='Temperature (K)'
		p2.ytitle='Stability ($K km^{-1}$)'
		endif
    	if ki ge 1 then p21=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=p2,sym_thick=sythick,name=seaname[mi])
		
	endif; endif mi eq 3
  ;plot yerr
  nx=round(2*xerr[ki]/0.001)
  x1=findgen(nx)*0.001+x[ki]-xerr[ki]
  y1=fltarr(nx)
  y1(*)=y[ki]
  print,max(x1),min(x1)
  p3=plot(y1,x1,color=symcol[ki],overplot=p,transparency=0,thick=lnthick,name=typename[ki])
  ; plot xerr
  ny=round(2*yerr[ki]/0.001)
  y1=findgen(ny)*0.001+y[ki]-yerr[ki]
  x1=fltarr(ny)
  x1(*)=x[ki]
  print,max(y1),min(y1)
  p4=plot(y1,x1,color=symcol[ki],overplot=p,transparency=0,thick=lnthick)

  z1=fltarr(ny)
  z1(*)=z[ki]
  p41=plot(y1,z1,color=symcol[ki],overplot=p2,transparency=0,thick=lnthick)
  ; plot yerr  
  nz=round(2*zerr[ki]/0.001)
  z1=findgen(nz)*0.001+z[ki]-zerr[ki]
  y1=fltarr(nz)
  y1(*)=y[ki]
  p5=plot(y1,z1,color=symcol[ki],overplot=p2,transparency=0,thick=lnthick)
  if mi eq 1 then ld=legend(target=[p3],position=[0.08,0.75-ki*0.02],shadow=0,sample_width=0.05,transparency=100,font_size=fontsz,horizontal_alignment=0)
  
  endfor ;end cloud type

 ;============= to plot upper troposphere ======================================
  data1 =Tcldfre_upsp
  data2 =Tave_up_sp
  data3 =Tave_up_sp2
  nsize =size(data1)
  seaave_upsp =data2/total(data1,2) 
  seaave2_upsp=data3/total(data1,2) 
  sea_upsp_std=sqrt(seaave2_upsp-seaave_upsp*seaave_upsp)

  data1 =Tcldfre_upstat
  data2 =Tave_up_stat
  data3 =Tave_up_stat2
  nsize =size(data1)
  seaave_upstat =data2/total(data1,2) 
  seaave2_upstat=data3/total(data1,2) 
  sea_upstat_std=sqrt(seaave2_upstat-seaave_upstat*seaave_upstat)
 
  data1 =Tcldfre_uptemp
  data2 =Tave_up_temp
  data3 =Tave_up_temp2
  nsize =size(data1)
  seaave_uptemp =data2/total(data1,2) 
  seaave2_uptemp=data3/total(data1,2) 
  sea_uptemp_std=sqrt(seaave2_uptemp-seaave_uptemp*seaave_uptemp)

  x=fltarr(5)	
  x=reform(seaave_upsp[*,0])
  x[1]=reform(seaave_upsp[2,0]) ;change the position of mixed only and liquid only
  x[2]=reform(seaave_upsp[1,0])
  z=fltarr(5)
  z=reform(seaave_upstat[*,0])
  z[1]=reform(seaave_upstat[2,0])
  z[2]=reform(seaave_upstat[1,0])
  y=fltarr(5)
  y=reform(seaave_uptemp[*,0])
  y[1]=reform(seaave_uptemp[2,0])	
  y[2]=reform(seaave_uptemp[1,0])	

  xerr=fltarr(5)
  xerr=reform(sea_upsp_std[*,0])
  xerr[1]=reform(sea_upsp_std[2,0]) ;change the position of mixed only and liquid only
  xerr[2]=reform(sea_upsp_std[1,0])
  zerr=fltarr(5)
  zerr=reform(sea_upstat_std[*,0])
  zerr[1]=reform(sea_upstat_std[2,0])
  zerr[2]=reform(sea_upstat_std[1,0])
  yerr=fltarr(5)
  yerr=reform(sea_uptemp_std[*,0])
  yerr[1]=reform(sea_uptemp_std[2,0])	
  yerr[2]=reform(sea_uptemp_std[1,0])	

  for ki=0, 4 do begin	
  	if mi eq 1 then begin
		if ki eq 0 then begin
		pu=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$
		symbol=symbol[mi],yrange=[0.005,0.05],xrange=[211,215],axis_style=2,position=pos3,$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi],/current)
	    pu.ytitle='Specific Humidity ($g kg^{-1}$)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
		pu.xtitle='Tempuerature (K)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
		t3=text(pos3[2]+0.01,pos3[3]+0.01,'c) '+seaname[mi],font_size=fontsz+1)
		endif
       if ki ge 1 then pu1=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=pu,sym_thick=sythick)

		if ki eq 0 then begin
		pu2=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$
		symbol=symbol[mi],yrange=[1,10],xrange=[211,215],axis_style=2,position=pos4,$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi],/current)
	    pu2.ytitle='Stability ($K km^{-1}$)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
		pu2.xtitle='Tempuerature (K)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
;		t3=text(pos4[2]+0.01,pos4[1]+0.01,'c) '+seaname[mi],font_size=fontsz)
		endif
       if ki ge 1 then p21=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=pu2,sym_thick=sythick)
	endif ;endif mi eq 1
	if mi eq 3 then begin
		if ki eq 0 then begin 
		pu=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$
		symbol=symbol[mi],yrange=[0.005,0.05],xrange=[211,215],axis_style=2,position=pos3,$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi],/current)
		pu.ytitle='Specific Humidity ($g kg^{-1}$)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
		pu.xtitle='Tempuerature (K)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
		t4=text(pos3[2]+0.01,pos3[3]+0.02,'d) '+seaname[mi],font_size=fontsz+1)
		endif
       if ki ge 1 then p1=scatterplot(y[ki],x[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=pu,sym_thick=sythick)

		if ki eq 0 then begin 
		pu2=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],$
		symbol=symbol[mi],yrange=[1,10],xrange=[211,215],axis_style=2,position=pos4,$ 
		sym_thick=sythick,xminor=0,yminor=0,name=seaname[mi],/current)
		pu2.xtitle='Tempuerature (K)';,tickdir=0,textpos=0,ticklen=0.03,tickfont_size=fontsz-2)
		pu2.ytitle='Stability ($K km^{-1}$)'
		endif
       if ki ge 1 then pu21=scatterplot(y[ki],z[ki],sym_filled=1,sym_size=symsz,sym_color=symcol[ki],symbol=symbol[mi],$
		overplot=pu2,sym_thick=sythick)

	endif ; endif mi eq 3
  ;plot yerr
  nx=round(2*xerr[ki]/0.001)
  x1=findgen(nx)*0.001+x[ki]-xerr[ki]
  y1=fltarr(nx)
  z1=fltarr(nx)
  y1(*)=y[ki]
  z1(*)=z[ki]
  p3=plot(y1,x1,color=symcol[ki],overplot=pu,transparency=0,thick=lnthick,name=typename[ki])
  ; plot xerr
  ny=round(2*yerr[ki]/0.001)
  y1=findgen(ny)*0.001+y[ki]-yerr[ki]
  x1=fltarr(ny)
  x1(*)=x[ki]
  print,max(y1),min(y1)
  p4=plot(y1,x1,color=symcol[ki],overplot=pu,transparency=0,thick=lnthick)

  z1=fltarr(ny)
  z1(*)=z[ki]
  p45=plot(y1,z1,color=symcol[ki],overplot=pu2,transparency=0,thick=lnthick)

  ; plot yerr
  nz=round(2*zerr[ki]/0.001)
  z1=findgen(nz)*0.001+z[ki]-zerr[ki]
  y1=fltarr(nz)
  y1(*)=y[ki]
  p5=plot(y1,z1,color=symcol[ki],overplot=pu2,transparency=0,thick=lnthick)
  endfor ; end cloud type

  Endif ; end if in JJA or SON


 endfor ; endseason

 tl=text(0.45,0.90,'Lower Troposphere',font_size=fontsz+3)
 tu=text(0.45,0.46,'Upper Troposphere',font_size=fontsz+3)
;  p.rotate,-20,/zaxis
;  p.rotate,5,/xaxis
p.save,'cloudtype_lower_mean_std_metero2D_R05.png'
stop	
 

end
