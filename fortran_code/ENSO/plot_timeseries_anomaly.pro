
pro plot_timeseries_anomaly

  ;=== MODIS part =================================
   restore,'modis_daytime_cldfre_newdomain.sav'
   modis_fre=modis_dayfre
   ind=where(modis_fre[*,0] gt 0)
   modis_allfre=1-modis_fre[ind,0]
   modis_liqfre=modis_fre[ind,1]
   modis_icefre=modis_fre[ind,2]
   monthly_anomaly,modis_allfre,modis_allfre_an
   monthly_anomaly,modis_liqfre,modis_liqfre_an
   monthly_anomaly,modis_icefre,modis_icefre_an

   restore,'modis_daytime_hetero_newdomain.sav'
   modis_hetero=modis_hetero ;0-clr,1-liq,2-ice,3-undetermined,4-all
   modis_allhetero=modis_hetero[ind,4] 
   monthly_anomaly,modis_allhetero,modis_hetero_an
	
   modis_liqhetero=modis_hetero[ind,1] 
   monthly_anomaly,modis_liqhetero,modis_liqhetero_an
   modis_icehetero=modis_hetero[ind,2] 
   monthly_anomaly,modis_icehetero,modis_icehetero_an
	
 ;==== cloudsat part ==============================
  restore,'cldphase_subarea_fre_day_ensonewdomain_R05.sav'
  cldsat_fre = subarea_fre[0:47,*]
  cldsat_allfre=total(cldsat_fre,2)
  monthly_anomaly,cldsat_allfre,cldsat_allfre_an
  monthly_anomaly,cldsat_fre[*,0],cldsat_icefre_an
  monthly_anomaly,cldsat_fre[*,1],cldsat_iceliqfre_an
  monthly_anomaly,cldsat_fre[*,2],cldsat_icemixfre_an
  monthly_anomaly,cldsat_fre[*,3],cldsat_liqfre_an
  monthly_anomaly,cldsat_fre[*,4],cldsat_mixfre_an
  monthly_anomaly,cldsat_fre[*,1]+cldsat_fre[*,3],cldsat_allliq_an

 ;==== modis radiation
  restore,'modis_daytime_rad_ensonewdomain.sav'	
  swrad=modis_rad[ind,0]
  lwrad=modis_rad[ind,1]
  monthly_anomaly,swrad,swrad_an
  monthly_anomaly,lwrad,lwrad_an

;====== enso index ==============================
  data=read_ascii('meiv2.data')
  data=data.(0)
  year=data[0,*]
  data2=data[1:12,*]
  nsize=size(data2)
  nsz=nsize[4]
  data3=fltarr(nsz)
  data3=data2[0:nsz-1]
  enso=data3
	
 ;====== to plot ===================================
  xname=[$
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
        '','','','','','','0717','','','','',''$
        ]
	
  xname11=xname
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
  p=plot(x,enso,position=pos1,dim=[700,800],xtickname=xname2,xtickvalues=xvalue,$
	font_size=fontsz,symbol='circle',sym_filled=1,sym_size=symsz,$
	xticklen=0.02,yticklen=0.01,ytitle='Index',xminor=0,yminor=0,xrange=xrange)
  p01=plot(x,yzero,linestyle='dash',overplot=p)
  t1=text(pos1[0]+0.02,pos1[3]-0.03,'a) ENSO Index',font_size=fontsz)


  ;=== to plot MODIS from MOD06
  p1=plot(x,modis_allfre_an,position=pos2,xtickname=xname2,xtickvalues=xvalue,$
	font_size=fontsz,/current,yrange=[-0.2,0.2],symbol='circle',sym_filled=1,sym_size=symsz,$
        xticklen=0.02,yticklen=0.01,ytitle='Frequency Anomaly',name='All cloud',$
	xminor=0,yminor=0,axis_style=2,xrange=xrange,color='grey')
  ax=p1.axes
  ax[3].hide=1
  
  yvalue=yzero
  p111=plot(x,yvalue,linestyle='dash',overplot=p1)
  ; get statiscs 
  r=correlate(modis_allfre_an,enso)
  print,'correlation: modis allcld vs enso',r
  t=r*sqrt(n_elements(modis_allfre_an)-2)/sqrt(1-r*r)
  print,'modis allcld correlate enso,t',t

  p12=plot(x,modis_icefre_an,overplot=p1,color='red',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Ice') 

  r=correlate(modis_icefre_an,enso)
  print,'correlation: modis icecld vs enso',r
  t=r*sqrt(n_elements(modis_icefre_an)-2)/sqrt(1-r*r)
  print,'modis icecld correlate enso,t',t

  r=correlate(modis_icefre_an,modis_allfre_an)
  print,'correlation: modis icecld vs modis all',r
  t=r*sqrt(n_elements(modis_icefre_an)-2)/sqrt(1-r*r)
  print,'modis icecld correlate all,t',t

  p11=plot(x,modis_liqfre_an,/current,color='purple',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Liquid',axis_style=0,yrange=[-0.08,0.08],xrange=p1.xrange,position=p1.position)

  r=correlate(modis_liqfre_an,enso)
  print,'correlation: modis liqcld vs enso',r
  t=r*sqrt(n_elements(modis_liqfre_an)-2)/sqrt(1-r*r)
  print,'modis liqcld correlate enso,t',t

  r=correlate(modis_liqfre_an,modis_allfre_an)
  print,'correlation: modis liqcld vs modis all',r
  t=r*sqrt(n_elements(modis_liqfre_an)-2)/sqrt(1-r*r)
  print,'modis liqcld correlate all,t',t

  r=correlate(modis_liqfre_an,modis_icefre_an)
  print,'correlation: modis liqcld vs modis ice',r
  t=r*sqrt(n_elements(modis_liqfre_an)-2)/sqrt(1-r*r)
  print,'modis liqcld correlate ice,t',t

  a1=axis('y',target=p11,location=[max(p1.xrange),0,0],textpos=1,tickdir=1,ticklen=0.01,color='purple',$
	title='Frequency Anomaly',tickfont_size=fontsz,minor=0)

  t2=text(pos2[0]+0.02,pos2[3]-0.027,'b) MODIS Cloud',font_size=fontsz)
  ld1=legend(target=[p1,p11,p12],position=[pos2[0]+0.3,pos2[1]+0.03],orientation=1,$
	transparency=100,sample_width=0.07,shadow=0,font_size=fontsz)

  ;== to plot hetero 
  p5=plot(x,modis_hetero_an,position=pos3,xtickname=xname2,xtickvalues=xvalue,$
        font_size=fontsz,/current,yrange=[-0.02,0.02],symbol='circle',sym_filled=1,sym_size=symsz,$
        xticklen=0.02,yticklen=0.01,ytitle='$H_{\sigma}$  Anomaly',$
        xminor=0,yminor=0,xrange=xrange)
  yvalue=yzero
  p511=plot(x,yvalue,linestyle='dash',overplot=p5)
 
  r=correlate(modis_hetero_an,enso)
  print,'correlation: modis hetero vs enso',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'modis hetero correlate enso,t',t
  print,'modis liq hetero ~ enso',correlate(modis_liqhetero_an,enso)
  print,'modis ice hetero ~ enso',correlate(modis_icehetero_an,enso)
 
  r=correlate(modis_hetero_an,modis_allfre_an)
  print,'correlation: modis hetero vs allcld',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'modis hetero correlate all,t',t

  r=correlate(modis_hetero_an,modis_icefre_an)
  print,'correlation: modis hetero vs icecld',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'modis hetero correlate ice,t',t

  r=correlate(modis_hetero_an,modis_liqfre_an)
  print,'correlation: modis hetero vs liqcld',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'modis hetero correlate liq,t',t
 
  t3=text(pos3[0]+0.03,pos3[3]-0.027,'c) MODIS Heterogeneity',font_size=fontsz)
;  ld1=legend(target=[p5],position=[pos3[0]+0.5,pos3[3]-0.01],orientation=1,$
;        transparency=100,sample_width=0.08,shadow=0,font_size=fontsz)

  ;==== to plot cloudsat
  cldsat_fre=fltarr(n_elements(xname))
  cldsat_fre[0:47]=!values.f_nan
  cldsat_fre[48:95]=cldsat_icefre_an
  cldsat_fre[96:n_elements(xanme)-1]=!values.f_nan
  print,'modis ice vs. cldsat ice',correlate(modis_icefre_an[48:95],cldsat_icefre_an) 
  p2=plot(x,cldsat_fre,position=pos4,xtickname=xname2,xtickvalues=xvalue,$
        font_size=fontsz,/current,yrange=[-0.08,0.08],color='r',xrange=xrange,$
	symbol='circle',sym_filled=1,sym_size=symsz,yticklen=0.01,$
        xticklen=0.02,ytitle='Frequency Anomaly',name='Ice only',xminor=0,yminor=0)
  cldsat_fre[48:95]=cldsat_iceliqfre_an
  print,'modis ice vs. cldsat iceliq',correlate(modis_icefre_an[48:95],cldsat_iceliqfre_an) 
  print,'modis liq vs. cldsat iceliq',correlate(modis_liqfre_an[48:95],cldsat_iceliqfre_an) 
  p21=plot(x,cldsat_fre,overplot=p2,color='g',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Ice above liquid')  
  cldsat_fre[48:95]=cldsat_icemixfre_an
  print,'modis ice vs. cldsat icemix',correlate(modis_icefre_an[48:95],cldsat_icemixfre_an) 
  p22=plot(x,cldsat_fre,overplot=p2,color='b',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Ice above mixed')  
  cldsat_fre[48:95]=cldsat_liqfre_an
  print,'modis liq vs. cldsat liq',correlate(modis_liqfre_an[48:95],cldsat_liqfre_an) 
  p23=plot(x,cldsat_fre,overplot=p2,color='purple',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Liquid only')  
  cldsat_fre[48:95]=cldsat_mixfre_an
  print,'modis ice vs. cldsat mix',correlate(modis_icefre_an[48:95],cldsat_mixfre_an) 
  p24=plot(x,cldsat_fre,overplot=p2,color='grey',symbol='circle',sym_filled=1,sym_size=symsz,$
        thick=lnthick,name='Mixed only')  
  t3=text(pos4[0]+0.02,pos4[3]-0.027,'d) CC Cloud',font_size=fontsz)
  ld2=legend(target=[p2,p21,p22,p23,p24],position=[pos4[0]+0.28,pos4[3]-0.03],orientation=0,$
	transparency=100,sample_width=0.05,shadow=0,vertical_spacing=0.01,font_size=fontsz)

  p211=plot(x,yzero,linestyle='dash',overplot=p2)
  xname1s=reform(xname[48:95])
  ind=where(xname1s ne '')
  xname2s=xname1s[ind]
;  p13=plot(x,modundfre,overplot=p1,color='blue',symbol='circle',sym_filled=1,sym_size=symsz,$
  
  p2s=plot(reform(x[0:47]),cldsat_allliq_an,position=[pos4[0]+0.5,pos4[1]+0.04,pos4[2]-0.01,pos4[3]-0.04],symbol='circle',$
    sym_filled=1,sym_size=symsz,yticklen=0.01,xticklen=0.02,xtickname=xname2s,$
	xtickvalues=[6,18,30,42],/current,$
    font_size=fontsz,xminor=0,yminor=0,yrange=[-0.06,0.06])
  t3s=text(pos4[0]+0.58,pos4[3]-0.04,'All Liquid Cloud',font_size=fontsz-1)
  p212=plot(x[0:47],yzero[0:47],linestyle='dash',overplot=p2s)

  p3=plot(x,swrad_an,position=pos5,xtickname=xname1,xtickvalues=xvalue,$
        font_size=fontsz,/current,yrange=[-0.08,0.08],xtext_orientation=30,$
	symbol='circle',sym_filled=1,sym_size=symsz,xminor=0,yminor=0,$
        xticklen=0.02,yticklen=0.01,ytitle='$R_{0.645}$  Anomaly',name='$R_{0.645}$',xrange=xrange);ytitle='Flux (W $m^{-2}$)',name='SW',xrange=xrange)
  ax1=p3.axes
  ax1[3].hide=1
  tx=text(pos5[0]+0.35,pos5[1]-0.05,'Time (mm/yy)')
  yvalue=yzero
  p311=plot(x,yvalue,linestyle='dash',overplot=p3)

  r=correlate(swrad_an,enso)
  print,'correlation: sw vs enso',r
  t=r*sqrt(n_elements(swrad_an)-2)/sqrt(1-r*r)
  print,'sw enso,t',t
  
  r=correlate(swrad_an,modis_allfre_an)
  print,'correlation: sw vs allcld',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'sw correlate all,t',t

  r=correlate(swrad_an,modis_icefre_an)
  print,'correlation: sw vs icecld',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'sw correlate ice,t',t

  r=correlate(swrad_an,modis_liqfre_an)
  print,'correlation: sw vs liqcld',r
  t=r*sqrt(n_elements(modis_liqfre_an)-2)/sqrt(1-r*r)
  print,'sw correlate liq,t',t

  r=correlate(swrad_an,modis_hetero_an)
  print,'correlation: sw vs hetero',r
  t=r*sqrt(n_elements(modis_hetero_an)-2)/sqrt(1-r*r)
  print,'sw correlate hetero,t',t

;  deseason_timeseries,lwtimeseries[6:185],lwde 
  p31=plot(x,lwrad_an,color='r',symbol='circle',sym_filled=1,sym_size=symsz,xrange=xrange,$
	thick=lnthick,name='$BT_{11}$',axis_style=0,/current,position=p3.position,yrange=[-10,10])
  a2=axis('y',target=p31,location=[max(p31.xrange),0,0],textpos=1,tickdir=1,ticklen=0.01,color='red',$
	title='$BT_{11}$  Anomaly (K)',tickfont_size=fontsz,minor=0)
  ax1=p3.axes
  ax1[3].hide=1

  r=correlate(lwrad_an,enso)
  print,'correlation: lw vs enso',r
  t=r*sqrt(n_elements(lwrad_an)-2)/sqrt(1-r*r)
  print,'lw enso,t',t
  
  r=correlate(lwrad_an,modis_allfre_an)
  print,'correlation: lw vs allcld',r
  t=r*sqrt(n_elements(lwrad_an)-2)/sqrt(1-r*r)
  print,'lw correlate all,t',t

  r=correlate(lwrad_an,modis_icefre_an)
  print,'correlation: lw vs icecld',r
  t=r*sqrt(n_elements(lwrad_an)-2)/sqrt(1-r*r)
  print,'lw correlate ice,t',t

  r=correlate(lwrad_an,modis_liqfre_an)
  print,'correlation: lw vs liqcld',r
  t=r*sqrt(n_elements(lwrad_an)-2)/sqrt(1-r*r)
  print,'lw correlate liq,t',t

  r=correlate(lwrad_an,modis_hetero_an)
  print,'correlation: lw vs hetero',r
  t=r*sqrt(n_elements(lwrad_an)-2)/sqrt(1-r*r)
  print,'lw correlate hetero,t',t

  r=correlate(lwrad_an,swrad_an)
  print,'correlation: lw vs sw',r
  t=r*sqrt(n_elements(lwrad_an)-2)/sqrt(1-r*r)
  print,'lw correlate sw,t',t


  t4=text(pos5[0]+0.02,pos5[3]-0.027,'e) MODIS radiative feature',font_size=fontsz)
  ld3=legend(target=[p3,p31],position=[pos5[0]+0.6,pos5[3]-0.01],orientation=1,$
	transparency=100,sample_width=0.07,shadow=0,font_size=fontsz)
 
  p.save,'ensodomain_timeseris_anomaly_R05.png'
stop
end

