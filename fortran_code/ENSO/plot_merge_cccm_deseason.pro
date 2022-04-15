
pro plot_merge_cccm_deseason

  maplimit=[0,105,20,135]

  ;========== ceres part =============================
  dir=''
  cfname=dir+'CERES_SSF1deg-Month_Aqua-MODIS_Ed4A_Subset_200207-201803.nc'
  read_dardar,cfname,'toa_sw_all_mon',ctoasw
  read_dardar,cfname,'toa_lw_all_mon',ctoalw
  read_dardar,cfname,'toa_sw_clr_mon',ctoaswclr
  read_dardar,cfname,'toa_lw_clr_mon',ctoalwclr
  read_dardar,cfname,'toa_sw_num_obs_all_mon',swnum
  read_dardar,cfname,'toa_lw_num_obs_all_mon',lwnum
  read_dardar,cfname,'lon',clon
  read_dardar,cfname,'lat',clat
  read_dardar,cfname,'time',time

  indlon=where(clon ge maplimit[1] and clon le maplimit[3],count)
  Nlon=count
  indlat=where(clat ge maplimit[0] and clat le maplimit[2],count)
  Nlat=count
  ctoasw1=ctoasw[indlon[0]:indlon[Nlon-1],indlat[0]:indlat[Nlat-1],*]
  swnum1=swnum[indlon[0]:indlon[Nlon-1],indlat[0]:indlat[Nlat-1],*]
  ctoaswclr1=ctoaswclr[indlon[0]:indlon[Nlon-1],indlat[0]:indlat[Nlat-1],*]

  ctoalw1=ctoalw[indlon[0]:indlon[Nlon-1],indlat[0]:indlat[Nlat-1],*]
  lwnum1=lwnum[indlon[0]:indlon[Nlon-1],indlat[0]:indlat[Nlat-1],*]
  ctoalwclr1=ctoalwclr[indlon[0]:indlon[Nlon-1],indlat[0]:indlat[Nlat-1],*]

  ind=where(ctoasw1 eq -999.0)
  ctoasw1[ind]=!values.f_nan
  ind=where(ctoalw1 eq -999.0)
  ctoalw1[ind]=!values.f_nan

  ind=where(ctoaswclr1 eq -999.0)
  ctoaswclr1[ind]=!values.f_nan
  ind=where(ctoalwclr1 eq -999.0)
  ctoalwclr1[ind]=!values.f_nan

  Nt=n_elements(time)
  lwtimeseries=fltarr(Nt)
  swtimeseries=fltarr(Nt)
  for ti=0,Nt-1 do begin
    swtimeseries[ti]=total(ctoasw1[*,*,ti]*swnum1[*,*,ti])/total(swnum1[*,*,ti])
    lwtimeseries[ti]=total(ctoalw1[*,*,ti]*lwnum1[*,*,ti])/total(lwnum1[*,*,ti])
  endfor 
  annualsw=total(ctoasw1*swnum1)/total(swnum1) 
  annuallw=total(ctoalw1*lwnum1)/total(lwnum1) 
 
  ;=== MODIS part =================================
  ;restore,'modisphase_timeseries_day.sav'
  ;modis_fre=cldfre
   restore,'modis_daytime_cldfre.sav'
   modis_fre=modis_dayfre
   restore,'modis_daytime_hetero.sav'
   modis_hetero=modis_hetero

   deseason_timeseries,reform(1-modis_fre[6:185,0]),modis_allfre_de
   deseason_timeseries,reform(modis_fre[6:185,1]),modis_liqfre_de
   deseason_timeseries,reform(modis_fre[6:185,2]),modis_icefre_de
  
 ;==== cloudsat part ==============================
  restore,'cldphase_subarea_fre_day.sav'
  cldsat_fre = subarea_fre
;  deseason_timeseries,reform(cldsat_fre[*,0]),cldsat_icefre,1
;  deseason_timeseries,reform(cldsat_fre[*,1]),cldsat_iceliqfre,1
;  deseason_timeseries,reform(cldsat_fre[*,2]),cldsat_icemixfre,1
;  deseason_timeseries,reform(cldsat_fre[*,3]),cldsat_liqfre,1
;  deseason_timeseries,reform(cldsat_fre[*,4]),cldsat_mixfre,1

;====== enso index ==============================
  read_mei,enso
  enso=enso[0:Nt-1]
 ;====== to plot ===================================
  xname=['0702','','','','','',$
        '','','','','','','0703','','','','','',$
        '','','','','','','0704','','','','','',$
        '','','','','','','0705','','','','','',$
        '','','','','','','0706','','','','','',$
        '','','','','','','0707','','','','','',$
        '','','','','','','0708','','','','','',$
        '','','','','','','0709','','','','','',$
        '','','','','','','0710','','','','','',$
        '','','','','','','0711','','','','','',$
        '','','','','','','0712','','','','','',$
        '','','','','','','0713','','','','','',$
        '','','','','','','0714','','','','','',$
        '','','','','','','0715','','','','','',$
        '','','','','','','0716','','','','','',$
        '','','','','','','0717','','','','','',$
        '','','']
	
  xname11=xname[6:185]
  ind=where(xname11 ne '')
  xname1=xname11[ind]
  xvalue=ind
  yzero=fltarr(n_elements(xname))
  xname2=xname11
  xname2[ind]=''
 
  x=findgen(180)
  fontsz=11 
  symsz=0.5
  lntick=2.5
  pos1=[0.1,0.81,0.90,0.97]
  pos2=[0.1,0.63,0.90,0.79]
  pos3=[0.1,0.45,0.90,0.61]
  pos4=[0.1,0.27,0.90,0.43]
  pos5=[0.1,0.09,0.90,0.25]
  xrange=[0,179]
  ; to plot ENSO Index
  p=plot(x,enso[6:185],position=pos1,dim=[700,800],xtickname=xname2,xtickvalues=xvalue,$
	font_size=fontsz,symbol='circle',sym_filled=1,sym_size=symsz,$
	xticklen=0.02,yticklen=0.01,ytitle='Index',xminor=0,yminor=0,xrange=xrange)
  p01=plot(x,yzero[6:185],linestyle='dash',overplot=p)
  t1=text(pos1[0]+0.02,pos1[3]-0.03,'a) ENSO Index',font_size=fontsz)

  ;=== to plot MODIS from MOD08
  ;data=modis_fre[0:Nt-1,*]
  ;modallcldfre=total(data,2)
  ;modclrfre=data[*,0]/float(modallcldfre)
  ;modliqfre=data[*,1]/float(modallcldfre)
  ;modicefre=data[*,2]/float(modallcldfre)
  ;modundfre=data[*,3]/float(modallcldfre)
  ;annualclr=total(data[*,0])/total(data)
  ;annualliq=total(data[*,1])/total(data)
  ;annualice=total(data[*,2])/total(data)
  ;annualund=total(data[*,3])/total(data)

  ;=== to plot MODIS from MOD06
  data=modis_dayfre[0:Nt-1,*]
  modclrfre=data[*,0]
  modliqfre=data[*,1]
  modicefre=data[*,2]
  annualclr=mean(modclrfre)
  annualliq=mean(modliqfre)
  annualice=mean(modicefre)

  p1=plot(x,modis_allfre_de,position=pos2,xtickname=xname2,xtickvalues=xvalue,$
	font_size=fontsz,/current,yrange=[0.05,0.9],symbol='circle',sym_filled=1,sym_size=symsz,$
        xticklen=0.02,yticklen=0.01,ytitle='Occurrence Frequency',name='All cloud',$
	xminor=0,yminor=0,axis_style=2,xrange=xrange,color='grey')
  ax=p1.axes
  ax[3].hide=1
  
  yvalue=fltarr(n_elements(xname[6:185]))
  yvalue[*]=1-annualclr
  p111=plot(x,yvalue,linestyle='dash',overplot=p1)
  ; get statiscs 
  r=correlate(modis_allfre_de,enso[6:185])
  print,'correlation: modis allcld vs enso',r
  t=r*sqrt(n_elements(modis_allfre_de)-2)/sqrt(1-r*r)
  print,'modis allcld correlate enso,t',t

  p12=plot(x,modis_icefre_de,overplot=p1,color='red',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Ice') 
  yvalue[*]=annualice
  p111=plot(x,yvalue,linestyle='dash',overplot=p1,color='red')

  r=correlate(modis_icefre_de,enso[6:185])
  print,'correlation: modis icecld vs enso',r
  t=r*sqrt(n_elements(modis_icefre_de)-2)/sqrt(1-r*r)
  print,'modis icecld correlate enso,t',t

  r=correlate(modis_icefre_de,modis_allfre_de)
  print,'correlation: modis icecld vs modis all',r
  t=r*sqrt(n_elements(modis_icefre_de)-2)/sqrt(1-r*r)
  print,'modis icecld correlate all,t',t

  p11=plot(x,modis_liqfre_de,/current,color='purple',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Liquid',axis_style=0,yrange=[0.10,0.35],xrange=p1.xrange,position=p1.position)

  r=correlate(modis_liqfre_de,enso[6:185])
  print,'correlation: modis liqcld vs enso',r
  t=r*sqrt(n_elements(modis_liqfre_de)-2)/sqrt(1-r*r)
  print,'modis liqcld correlate enso,t',t

  r=correlate(modis_liqfre_de,modis_allfre_de)
  print,'correlation: modis liqcld vs modis all',r
  t=r*sqrt(n_elements(modis_liqfre_de)-2)/sqrt(1-r*r)
  print,'modis liqcld correlate all,t',t

  r=correlate(modis_liqfre_de,modis_icefre_de)
  print,'correlation: modis liqcld vs modis ice',r
  t=r*sqrt(n_elements(modis_liqfre_de)-2)/sqrt(1-r*r)
  print,'modis liqcld correlate ice,t',t

  yvalue[*]=annualliq
  p111=plot(x,yvalue,linestyle='dash',overplot=p11,color='purple')
  a1=axis('y',target=p11,location=[max(p1.xrange),0,0],textpos=1,tickdir=1,ticklen=0.01,color='purple',$
	title='Occurrence Frequency',tickfont_size=fontsz,minor=0)

  t2=text(pos2[0]+0.02,pos2[3]-0.027,'b) MODIS Cloud',font_size=fontsz)
  ld1=legend(target=[p1,p11,p12],position=[pos2[0]+0.3,pos2[1]+0.03],orientation=1,$
	transparency=100,sample_width=0.07,shadow=0,font_size=fontsz)

  ;== to plot hetero 
  data=modis_hetero[0:Nt-1,*]
  deseason_timeseries,reform(data[6:185,4]),hetero_de 
  p5=plot(x,hetero_de,position=pos3,xtickname=xname2,xtickvalues=xvalue,$
        font_size=fontsz,/current,yrange=[0.08,0.14],symbol='circle',sym_filled=1,sym_size=symsz,$
        xticklen=0.02,yticklen=0.01,ytitle='$H_\sigma$',name='All sky',$
        xminor=0,yminor=0,xrange=xrange)
  yvalue=fltarr(n_elements(xname))
  yvalue[*]=mean(data[*,4])
  p511=plot(x,yvalue[6:185],linestyle='dash',overplot=p5)
 
  r=correlate(hetero_de,enso[6:185])
  print,'correlation: modis hetero vs enso',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'modis hetero correlate enso,t',t

  r=correlate(hetero_de,modis_allfre_de)
  print,'correlation: modis hetero vs allcld',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'modis hetero correlate all,t',t

  r=correlate(hetero_de,modis_icefre_de)
  print,'correlation: modis hetero vs icecld',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'modis hetero correlate ice,t',t

  r=correlate(hetero_de,modis_liqfre_de)
  print,'correlation: modis hetero vs liqcld',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'modis hetero correlate liq,t',t
 
  t3=text(pos3[0]+0.03,pos3[3]-0.027,'c) MODIS Heterogeneity',font_size=fontsz)
  ld1=legend(target=[p5],position=[pos3[0]+0.5,pos3[3]-0.01],orientation=1,$
        transparency=100,sample_width=0.08,shadow=0,font_size=fontsz)

  ;==== to plot cloudsat
  cldsat_fre1=fltarr(Nt,5)
  cldsat_fre1[0:53,*]=!values.f_nan
  cldsat_fre1[54:101,*]=cldsat_fre
  cldsat_fre1[102:nt-1,*]=!values.f_nan
  cldsat_allfre=total(cldsat_fre1,2)
 
  p2=plot(x,cldsat_fre1[6:185,0],position=pos4,xtickname=xname2,xtickvalues=xvalue,$
        font_size=fontsz,/current,yrange=[0,0.5],color='r',xrange=xrange,$
	symbol='circle',sym_filled=1,sym_size=symsz,yticklen=0.01,$
        xticklen=0.02,ytitle='Occurrence Frequency',name='Ice only',xminor=0,yminor=0)
  p21=plot(x,cldsat_fre1[6:185,1],overplot=p2,color='g',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Ice above liquid')  
  p22=plot(x,cldsat_fre1[6:185,2],overplot=p2,color='b',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Ice above mixed')  
  p23=plot(x,cldsat_fre1[6:185,3],overplot=p2,color='purple',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Liquid only')  
  p24=plot(x,cldsat_fre1[6:185,4],overplot=p2,color='grey',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Mixed only')  
  t3=text(pos4[0]+0.02,pos4[3]-0.027,'d) CloudSat Cloud',font_size=fontsz)
  ld2=legend(target=[p2,p21,p22,p23,p24],position=[pos4[0]+0.3,pos4[3]-0.03],orientation=0,$
	transparency=100,sample_width=0.05,shadow=0,vertical_spacing=0.01,font_size=fontsz)
  p2s=plot(findgen(48),reform(cldsat_allfre[54:101]),position=[pos4[0]+0.55,pos4[1]+0.04,pos4[2]-0.05,pos4[3]-0.03],symbol='circle',$
	sym_filled=1,sym_size=symsz,yticklen=0.01,xticklen=0.02,xtickname=xname1[5:8],xtickvalues=[6,18,30,42],/current,$
	font_size=fontsz,xminor=0,yminor=0,yrange=[0.65,1.0])
  t3s=text(pos4[0]+0.58,pos4[3]-0.12,'All Cloud',font_size=fontsz)
  yvalue1=fltarr(48)
  yvalue1[*]=mean(cldsat_allfre,/nan)
  p211=plot(findgen(48),yvalue1,linestyle='dash',overplot=p2s)
;  p13=plot(x,modundfre,overplot=p1,color='blue',symbol='circle',sym_filled=1,sym_size=symsz,$
  ;==== to plot ceres
;  deseason_timeseries,swtimeseries[6:185],swde 
  restore,'modis_daytime_rad.sav'	
  deseason_timeseries,modis_rad[0:179,0],swde

  p3=plot(x,swde,position=pos5,xtickname=xname1,xtickvalues=xvalue,$
        font_size=fontsz,/current,yrange=[0.1,0.3],xtext_orientation=30,$
	symbol='circle',sym_filled=1,sym_size=symsz,xminor=0,yminor=0,$
        xticklen=0.02,yticklen=0.01,ytitle='Reflectance',name='$R_{0.645}$',xrange=xrange);ytitle='Flux (W $m^{-2}$)',name='SW',xrange=xrange)
  ax1=p3.axes
  ax1[3].hide=1
  tx=text(pos5[0]+0.35,pos5[1]-0.05,'Time (mm/yy)')
  yvalue[*]=mean(modis_rad[0:179,0])
  p311=plot(x,yvalue[6:185],linestyle='dash',overplot=p3)

  r=correlate(swde,enso[6:185])
  print,'correlation: sw vs enso',r
  t=r*sqrt(n_elements(swde)-2)/sqrt(1-r*r)
  print,'sw enso,t',t
  
  r=correlate(swde,modis_allfre_de)
  print,'correlation: sw vs allcld',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'sw correlate all,t',t

  r=correlate(swde,modis_icefre_de)
  print,'correlation: sw vs icecld',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'sw correlate ice,t',t

  r=correlate(swde,modis_liqfre_de)
  print,'correlation: sw vs liqcld',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'sw correlate liq,t',t

  r=correlate(swde,hetero_de)
  print,'correlation: sw vs hetero',r
  t=r*sqrt(n_elements(hetero_de)-2)/sqrt(1-r*r)
  print,'sw correlate hetero,t',t


;  deseason_timeseries,lwtimeseries[6:185],lwde 
  deseason_timeseries,modis_rad[0:179,1],lwde 
  p31=plot(x,lwde,color='r',symbol='circle',sym_filled=1,sym_size=symsz,xrange=xrange,$
	thick=lnthick,name='$BT_{11}$',axis_style=0,/current,position=p3.position,yrange=[260,290])
  a2=axis('y',target=p31,location=[max(p31.xrange),0,0],textpos=1,tickdir=1,ticklen=0.01,color='red',$
	title='Brightness Temperature (K)',tickfont_size=fontsz,minor=0)
  yvalue[*]=mean(modis_rad[0:179,1])
  p311=plot(x,yvalue[6:185],linestyle='dash',overplot=p31,color='r')

  r=correlate(lwde,enso[6:185])
  print,'correlation: lw vs enso',r
  t=r*sqrt(n_elements(lwde)-2)/sqrt(1-r*r)
  print,'lw enso,t',t
  
  r=correlate(lwde,modis_allfre_de)
  print,'correlation: lw vs allcld',r
  t=r*sqrt(n_elements(lwde)-2)/sqrt(1-r*r)
  print,'lw correlate all,t',t

  r=correlate(lwde,modis_icefre_de)
  print,'correlation: lw vs icecld',r
  t=r*sqrt(n_elements(lwde)-2)/sqrt(1-r*r)
  print,'lw correlate ice,t',t

  r=correlate(lwde,modis_liqfre_de)
  print,'correlation: lw vs liqcld',r
  t=r*sqrt(n_elements(lwde)-2)/sqrt(1-r*r)
  print,'lw correlate liq,t',t

  r=correlate(lwde,hetero_de)
  print,'correlation: lw vs hetero',r
  t=r*sqrt(n_elements(lwde)-2)/sqrt(1-r*r)
  print,'lw correlate hetero,t',t

  r=correlate(lwde,swde)
  print,'correlation: lw vs sw',r
  t=r*sqrt(n_elements(lwde)-2)/sqrt(1-r*r)
  print,'lw correlate sw,t',t


  t4=text(pos5[0]+0.02,pos5[3]-0.027,'e) MODIS radiative feature',font_size=fontsz)
  ld3=legend(target=[p3,p31],position=[pos5[0]+0.63,pos5[3]-0.01],orientation=1,$
	transparency=100,sample_width=0.07,shadow=0,font_size=fontsz)
 
;  p.save,'subarea_timeseris_cccm_enso_day_deseason_modis.png'
stop
end

