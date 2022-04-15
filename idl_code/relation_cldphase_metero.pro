
pro relation_cldphase_metero

 datadir="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/Thick_top_met"

 cldthk=findgen(41)
 season=['MAM','JJA','SON','DJF']

 TSice_thick_upstat=0
 TSice_thick_lowstat=0
 TSice_thick_upsp  =0
 TSice_thick_lowsp  =0
 TSice_thick_upT =0
 TSliq_top_lowsp=0
 TSliq_top_lowT=0
 TSliq_top_lowstat=0

 TMice_thick_upstat=0
 TMice_thick_lowstat=0
 TMice_thick_upsp  =0
 TMice_thick_lowsp  =0
 TMice_thick_upT =0
 TMliq_top_lowsp=0
 TMliq_top_lowT=0
 TMliq_top_lowstat=0

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
 
 allfname=[allfname1,allfname2,allfname3]
 
 Nf=n_elements(allfname)
 
 
 for fi=0,Nf-1 do begin
	read_dardar,allfname[fi],'stability_low_high',stability
	read_dardar,allfname[fi],'high180_temperature',temp180
	read_dardar,allfname[fi],'surface_temperature',temp_surf

	read_dardar,allfname[fi],'ice_single_thick_upstat',sice_thick_upstat
	TSice_thick_upstat = TSice_thick_upstat + sice_thick_upstat
	read_dardar,allfname[fi],'ice_single_thick_upsp',sice_thick_upsp
	TSice_thick_upsp = TSice_thick_upsp + sice_thick_upsp
	read_dardar,allfname[fi],'ice_single_thick_upT',sice_thick_upt
	TSice_thick_upT=TSice_thick_upT+sice_thick_upt
	read_dardar,allfname[fi],'ice_single_thick_lowstat',sice_thick_lowstat
	TSice_thick_lowstat = TSice_thick_lowstat + sice_thick_lowstat
	read_dardar,allfname[fi],'ice_single_thick_lowsp',sice_thick_lowsp
	TSice_thick_lowsp = TSice_thick_lowsp + sice_thick_lowsp

	read_dardar,allfname[fi],'ice_multi_thick_upstat',mice_thick_upstat
	TMice_thick_upstat = TMice_thick_upstat + mice_thick_upstat
	read_dardar,allfname[fi],'ice_multi_thick_upsp',mice_thick_upsp
	TMice_thick_upsp = TMice_thick_upsp + mice_thick_upsp
	read_dardar,allfname[fi],'ice_multi_thick_upT',mice_thick_upt
	TMice_thick_upT=TMice_thick_upT+mice_thick_upt
	read_dardar,allfname[fi],'ice_multi_thick_lowstat',mice_thick_lowstat
	TMice_thick_lowstat = TMice_thick_lowstat + mice_thick_lowstat
	read_dardar,allfname[fi],'ice_multi_thick_lowsp',mice_thick_lowsp
	TMice_thick_lowsp = TMice_thick_lowsp + mice_thick_lowsp


	read_dardar,allfname[fi],'liq_single_top_lowstat',sliq_top_lowstat
	TSliq_top_lowstat = TSliq_top_lowstat + sliq_top_lowstat
	read_dardar,allfname[fi],'liq_single_top_lowsp',sliq_top_lowsp
	TSliq_top_lowsp = TSliq_top_lowsp + sliq_top_lowsp
	read_dardar,allfname[fi],'liq_single_top_lowT',sliq_top_lowt
	TSliq_top_lowT=TSliq_top_lowT+sliq_top_lowt

	read_dardar,allfname[fi],'liq_multi_top_lowstat',mliq_top_lowstat
	TMliq_top_lowstat = TMliq_top_lowstat + mliq_top_lowstat
	read_dardar,allfname[fi],'liq_multi_top_lowsp',mliq_top_lowsp
	TMliq_top_lowsp = TMliq_top_lowsp + mliq_top_lowsp
	read_dardar,allfname[fi],'liq_multi_top_lowT',mliq_top_lowt
	TMliq_top_lowT=TMliq_top_lowT+mliq_top_lowt

 endfor

 EndFor ; endfor four months

 TSice_thick_upsp_iceonly=reform(TSice_thick_upsp[*,*,0,0]+TMice_thick_upsp[*,*,0,0])/total(TSice_thick_upsp[*,*,0,0]+TMice_thick_upsp[*,*,0,0])
 TSice_thick_upsp_iceliq=reform(TSice_thick_upsp[*,*,1,0]+TMice_thick_upsp[*,*,1,0])/total(TSice_thick_upsp[*,*,1,0]+TMice_thick_upsp[*,*,1,0])
 TSice_thick_upstat_iceonly=reform(TSice_thick_upstat[*,*,0,0]+TMice_thick_upstat[*,*,0,0])/total(TSice_thick_upstat[*,*,0,0]+TMice_thick_upstat[*,*,0,0])
 TSice_thick_upstat_iceliq=reform(TSice_thick_upstat[*,*,1,0]+TMice_thick_upstat[*,*,1,0])/total(TSice_thick_upstat[*,*,1,0]+TMice_thick_upstat[*,*,1,0])
 TSice_thick_upT_iceonly=reform(TSice_thick_upT[*,*,0,0])/total(TSice_thick_upT[*,*,0,0])
 TSice_thick_upT_iceliq=reform(TSice_thick_upT[*,*,1,0])/total(TSice_thick_upT[*,*,1,0])
 TSice_thick_lowstat_iceonly=reform(TSice_thick_lowstat[*,*,0,0]+TMice_thick_lowstat[*,*,0,0])/total(TSice_thick_lowstat[*,*,0,0]+TMice_thick_lowstat[*,*,0,0])
 TSice_thick_lowstat_iceliq=reform(TSice_thick_lowstat[*,*,1,0]+TMice_thick_lowstat[*,*,1,0])/total(TSice_thick_lowstat[*,*,1,0]+TMice_thick_lowstat[*,*,1,0])
 TSice_thick_lowsp_iceonly=reform(TSice_thick_lowsp[*,*,0,0]+TMice_thick_lowsp[*,*,0,0])/total(TSice_thick_lowsp[*,*,0,0]+TMice_thick_lowsp[*,*,0,0])
 TSice_thick_lowsp_iceliq=reform(TSice_thick_lowsp[*,*,1,0]+TMice_thick_lowsp[*,*,1,0])/total(TSice_thick_lowsp[*,*,1,0]+TMice_thick_lowsp[*,*,1,0])

 TSliq_top_lowsp_liqonly=reform(TSliq_top_lowsp[*,*,0,0]+TMliq_top_lowsp[*,*,0,0])/total(TSliq_top_lowsp[*,*,0,0]+TMliq_top_lowsp[*,*,0,0])
 TSliq_top_lowsp_liqliq=reform(TSliq_top_lowsp[*,*,1,0]+TMliq_top_lowsp[*,*,1,0])/total(TSliq_top_lowsp[*,*,1,0]+TMliq_top_lowsp[*,*,1,0])
 TSliq_top_lowstat_liqonly=reform(TSliq_top_lowstat[*,*,0,0]+TMliq_top_lowstat[*,*,0,0])/total(TSliq_top_lowstat[*,*,0,0]+TMliq_top_lowstat[*,*,0,0])
 TSliq_top_lowstat_liqliq=reform(TSliq_top_lowstat[*,*,1,0]+TMliq_top_lowstat[*,*,1,0])/total(TSliq_top_lowstat[*,*,1,0]+TMliq_top_lowstat[*,*,1,0])
 TSliq_top_lowT_liqonly=reform(TSliq_top_lowT[*,*,0,0]+TMliq_top_lowT[*,*,0,0])/total(TSliq_top_lowT[*,*,0,0]+TMliq_top_lowT[*,*,0,0])
 TSliq_top_lowT_liqliq=reform(TSliq_top_lowT[*,*,1,0]+TMliq_top_lowT[*,*,1,0])/total(TSliq_top_lowT[*,*,1,0]+TMliq_top_lowT[*,*,1,0])

 pos1=[0.10,0.60,0.50,0.95]
 pos2=[0.55,0.60,0.95,0.95]
 pos3=[0.10,0.15,0.50,0.50]
 pos4=[0.55,0.15,0.95,0.50]

 minvalue=0.0
 maxvalue=0.09 
; maxvalue=0.02 
 sp=stability
 xdata=cldthk*0.5
 ydata=sp
 title='lowstat'
 axtitle='Specific Humidity x100 $(g kg^{-1})$' 
 ytickv=[0,1,2,3,4,5]
 xtickv=[0,2,4,6,8,10]
; ytickv=[0,1,2,3,4,5]
 yname=['0','1','2','3','4','5']
; yname=['0','1','2','3','4','5']
 xname=['0','2','4','6','8','10']
 data1=TSice_thick_upsp_iceonly
 data2=TSice_thick_upsp_iceliq
 c1=image(data1-data2,xdata,ydata,max_value=0.01,min_value=-0.01,rgb_table=70,xrange=[0,10],yrange=[0,5],position=pos1,dim=[650,600])
 xaxis=axis('X',location=0,target=c1,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,ticklen=0.02,title='Ice Geometrical Thickness (km)')
 yaxis=axis('Y',location=0,target=c1,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,ticklen=0.02,title=axtitle)
 c1.scale,0.8,1.5

 axtitle='Stability $(K km^{-1})$' 
 ytickv=[2,4,6,8,10,12,14]
 yname=['2','4','6','8','10','12','14']
 data1=TSice_thick_upstat_iceonly
 data2=TSice_thick_upstat_iceliq
 c2=image(data1-data2,xdata,ydata,max_value=0.001,min_value=-0.001,rgb_table=70,xrange=[0,10],yrange=[2,14],position=pos2,/current)
 xaxis=axis('X',location=2,target=c2,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,ticklen=0.02,title='Ice Geometrical Thickness (km)')
 yaxis=axis('Y',location=0,target=c2,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,ticklen=0.02,title=axtitle)
 c2.scale,1.2,0.9

 axtitle='Specific Humidity $(g kg^{-1})$' 
 ytickv=[0,5,10,15,20]
 yname=['0','5','10','15','20']
 data1=TSliq_top_lowsp_liqonly
 data2=TSliq_top_lowsp_liqliq
 c3=image(data1-data2,xdata,ydata,max_value=0.01,min_value=-0.01,rgb_table=70,xrange=[0,10],yrange=[0,20],position=pos3,/current)
 xaxis=axis('X',location=0,target=c3,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,ticklen=0.02,title='Liquid Top Height (km)')
 yaxis=axis('Y',location=0,target=c3,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,ticklen=0.02,title=axtitle)
 c3.scale,2,0.9

 axtitle='Stability $(K km^{-1})$' 
 ytickv=[2,4,6,8]
 yname=['2','4','6','8']
 data1=TSliq_top_lowstat_liqonly
 data2=TSliq_top_lowstat_liqliq
 c4=image(data1-data2,xdata,ydata,max_value=0.01,min_value=-0.01,rgb_table=70,xrange=[0,10],yrange=[2,8],position=pos4,/current)
 xaxis=axis('X',location=2,target=c4,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,ticklen=0.02,title='Liquid Top Height (km)')
 yaxis=axis('Y',location=0,target=c4,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,ticklen=0.02,title=axtitle)
 c4.scale,0.85,1.2

 t1=text(pos1[0]+0.05,pos1[3]-0.03,'a)')
 t2=text(pos2[0]+0.05,pos2[3]-0.03,'b)')
 t3=text(pos3[0]+0.05,pos3[3]-0.03,'c)')
 t4=text(pos4[0]+0.05,pos4[3]-0.03,'d)')

 ct=colorbar(target=c1,taper=1,border=1,orientation=0,position=[0.2,0.06,0.8,0.08],font_size=11)

 c1.save,'icethickup_liqtop_sp_stat_single_ocean_day4yr.png'

; c3.save,'liqonly_iceliquid_'+title+'.png' 
 data1=TSliq_top_lowstat_liqonly
 data2=TSliq_top_lowstat_liqliq

stop
end
