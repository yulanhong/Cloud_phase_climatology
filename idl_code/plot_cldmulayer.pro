
pro plot_cldmulayer

fname="/u/sciteam/yulanh/mydata/radar-lidar_out/radar-lidar/output/cldsat_cldclimotology5.hdf"

read_dardar,fname,'time',month
read_dardar,fname,'latitude',lat
read_dardar,fname,'longitude',lon
read_dardar,fname,'obsnum',obsnum
read_dardar,fname,'mullayercloud_onephase_frequency',mulcl1_num
read_dardar,fname,'mullayercloud_onephase_topheight',mulcl1_top
read_dardar,fname,'onelayercloud_frequency',onecl_num
read_dardar,fname,'onelayercloud_topheight',onecl_top

read_dardar,fname,'mullayercloud_mulphase_frequency',mulcln_num
read_dardar,fname,'mullayercloud_mulphase_lowlaytopheight',mulcln_lowtop
read_dardar,fname,'mullayercloud_mulphase_lowlaybaseheight',mulcln_lowbase
read_dardar,fname,'mullayercloud_mulphase_uplaytopheight',mulcln_uptop
read_dardar,fname,'mullayercloud_mulphase_uplaybaseheight',mulcln_upbase

;======= read ENSO index =====================
ensofname='/u/sciteam/yulanh/mydata/MEI_index/MEI_index.txt'
ENSO=read_ascii(ensofname)
ENSO=ENSO.(0)
ind=where(ENSO[0,*] ge 2007 and ENSO[0,*] le 2010)
ENSO1=ENSO[*,ind]

indlat=where(lat ge -10 and lat le 35)
lat1=lat[indlat]
mulcl1_num1=mulcl1_num[*,indlat,*,*]
mulcl1_top1=mulcl1_top[*,indlat,*,*]

onecl_num1=onecl_num[*,indlat,*,*]
obsnum1=obsnum[*,indlat,*]
onecl_top1=onecl_top[*,indlat,*,*]

mulcln_num1=mulcln_num[*,indlat,*,*]
mulcln_lowtop1=mulcln_lowtop[*,indlat,*,*]
mulcln_upbase1=mulcln_upbase[*,indlat,*,*]

obsnum1=obsnum[*,indlat,*]

indlon=where(lon ge 75 and lon le 155)
lon1=lon[indlon]
mulcl1_num2=mulcl1_num1[indlon,*,*,*]
mulcl1_top2=mulcl1_top1[indlon,*,*,*]

onecl_num2=onecl_num1[indlon,*,*,*]
obsnum2=obsnum1[indlon,*,*]
onecl_top2=onecl_top1[indlon,*,*,*]

mulcln_num2=mulcln_num1[indlon,*,*,*]
mulcln_lowtop2=mulcln_lowtop1[indlon,*,*,*]
mulcln_upbase2=mulcln_upbase1[indlon,*,*,*]

obsnum2=obsnum1[indlon,*,*]

;======= out put JJA only======================
plot_prec_fre,reform(onecl_num2[*,*,1,*]),obsnum2,month,lat1,lon1,ENSO1
stop
;plot_prec_enso,reform(mulcl1_num2[*,*,0,*]),obsnum2,month,lat1,lon1,ENSO1

;plot cloud top
plot_cloudtop,reform(mulcln_upbase2[*,*,0,*]),reform(mulcln_num2[*,*,0,*]),month,lat1,lon1,ENSO1
;plot_cldtop_enso,reform(onecl_top2[*,*,1,*]),reform(onecl_num2[*,*,1,*]),month,lat1,lon1,ENSO1
stop
end

pro plot_cldtop_enso,cldtop,cldnum,month,lat,lon,ENSO1

    ind=where(month ge 6 and month le 8)
    cldnum1=reform(cldnum[*,*,ind])
    cldtop1=reform(cldtop[*,*,ind])

    Lapre_num=cldnum1[*,*,0:2]*cldtop1[*,*,0:2]+cldnum1[*,*,9:11]*cldtop1[*,*,9:11]
    Laobs_num=cldnum1[*,*,0:2]+cldnum1[*,*,9:11]
   
    Enpre_num=cldnum1[*,*,3:5]*cldtop1[*,*,3:5]+cldnum1[*,*,6:8]*cldtop1[*,*,6:8]
    Enobs_num=cldnum1[*,*,3:5]+cldnum1[*,*,6:8]

    stop 
    data=fltarr(n_elements(lon),n_elements(lat),6)
 
    data[*,*,0]=Lapre_num[*,*,0]/float(Laobs_num[*,*,0])   
    data[*,*,1]=Lapre_num[*,*,1]/float(Laobs_num[*,*,1])   
    data[*,*,2]=Lapre_num[*,*,2]/float(Laobs_num[*,*,2])   
    data[*,*,3]=Enpre_num[*,*,0]/float(Enobs_num[*,*,0])   
    data[*,*,4]=Enpre_num[*,*,1]/float(Enobs_num[*,*,1])   
    data[*,*,5]=Enpre_num[*,*,2]/float(Enobs_num[*,*,2])   
   	    	
    maplimit=[-10,75,35,155]   

	print,max(data,/nan),min(data,/nan)
    plot_hor_6p,data,lat,lon,maplimit
 
    stop	

end

pro plot_cloudtop,cldtop,cldnum,month,lat,lon,ENSO1

   Jun_ave=fltarr(4)
   Jul_ave=fltarr(4)
   Aug_ave=fltarr(4)
   Sep_ave=fltarr(4)

   tcldn=total(cldnum,1)
   tcldn=total(tcldn,1)

   ind=where(month eq 6)
   Jun_num=reform(cldnum[*,*,ind])
   Jun_fre=total(Jun_num*cldtop[*,*,ind],3,/nan)/total(cldnum[*,*,ind],3)   

   a1=total(Jun_num*cldtop[*,*,ind],1,/nan)
   a2=total(a1,1)
   Jun_ave=a2/tcldn[ind]

   ind=where(month eq 7)
   Jul_num=reform(cldnum[*,*,ind])
   Jul_fre=total(Jul_num*cldtop[*,*,ind],3,/nan)/total(cldnum[*,*,ind],3) 

   a1=total(Jul_num*cldtop[*,*,ind],1,/nan)
   a2=total(a1,1)
   Jul_ave=a2/tcldn[ind]

   ind=where(month eq 8)
   Aug_num=reform(cldnum[*,*,ind])
   Aug_fre=total(Aug_num*cldtop[*,*,ind],3,/nan)/total(cldnum[*,*,ind],3) 

   a1=total(Aug_num*cldtop[*,*,ind],1,/nan)
   a2=total(a1,1)
   Aug_ave=a2/tcldn[ind]

   ind=where(month eq 9)
   Sep_num=reform(cldnum[*,*,ind])
   Sep_fre=total(Sep_num*cldtop[*,*,ind],3,/nan)/total(cldnum[*,*,ind],3) 

   a1=total(Sep_num*cldtop[*,*,ind],1,/nan)
   a2=total(a1,1)
   Sep_ave=a2/tcldn[ind]

   ;===========print total ave.==============
   ind=where(month ge 6 and month le 9)
   print,'total average',total(cldnum[*,*,ind]*cldtop[*,*,ind],/nan)/total(cldnum[*,*,ind])   
   print,Sep_ave,Aug_ave,Jul_ave,Jun_ave  
   ;=======to plot=====================================
   n=13

   ;levs=[0,0.01,0.03,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.7]
;    levs=findgen(n)*0.8+8
   levs=findgen(n)+6
;;   levs=findgen(n)*0.66+1.2

   index=findgen(n)*21

   plotx=findgen(4)
   pxname=['2007','2008','2009','2010']
   pxrange=[0,3]
   pyrange=[10.5,11.6]
;   pyrange=[12.5,13.7]
;   pyrange=[3.5,4]
   pyrange1=[-1.7,1.2]
   psize=0.5
   enso2=enso1[6:9,*]
   xtitle="Year"
   bartitle='Cloud base (km)'
   fontsize=9
	
   maplimit=[-10,75,35,155]   
 
   pos1=[0.05,0.45,0.24,0.90]
   pos2=[0.05,0.15,0.24,0.35]
   pos3=[0.27,0.45,0.47,0.90]
   pos4=[0.27,0.15,0.47,0.35]
   pos5=[0.50,0.45,0.70,0.90]
   pos6=[0.50,0.15,0.70,0.35]
   pos7=[0.73,0.45,0.93,0.90]
   pos8=[0.73,0.15,0.93,0.35]
 
   c=contour(Jun_fre,lon,lat,c_value=levs,n_levels=n,$
      dim=[850,450],rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Jun. 2007-2010',position=pos1)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)
   pos21=[pos2[0]-0.01,pos2[1],pos2[2]-0.02,pos2[3]]
   c1=plot(plotx,Jun_ave,position=pos21,/current,xrange=pxrange,$
	  yrange=pyrange,xtickvalues=plotx,xtickname=pxname,$
          xticklen=0.01,yticklen=0.01,symbol="*",$
	  xtitle=xtitle,name=bartitle,font_size=fontsize)
   c12=plot(plotx,enso2[0,*],color='r',/current,axis_style=0,$
	position=pos21,symbol="D",yrange=pyrange1,name="MEI")
   a12=axis('y',target=c12,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

   ld=legend(target=[c1,c12],position=[0.45,0.1],/normal)

   c2=contour(Jul_fre,lon,lat,c_value=levs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Jul. 2007-2010',position=pos3,/current)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)
   pos41=[pos4[0]+0.01,pos4[1],pos4[2]-0.01,pos4[3]]
   c21=plot(plotx,Jul_ave,position=pos41,/current,xrange=pxrange,$
	yrange=pyrange,xtickv=plotx,xtickname=pxname,symbol='*',$
	xticklen=0.01,yticklen=0.01,xtitle=xtitle,font_size=fontsize)
   c22=plot(plotx,enso2[1,*],color='r',/current,axis_style=0,$
	position=pos41,symbol="D",yrange=pyrange1)
   a22=axis('y',target=c22,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

   c3=contour(Aug_fre,lon,lat,c_value=levs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Aug. 2007-2010',position=pos5,/current)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)

;   ct=colorbar(target=c,title=bartitle,taper=1,border=1,$
;	orientation=1,position=[pos5[2]+0.08,pos5[1],pos5[2]+0.1,pos5[3]])
  
   pos61=[pos6[0]+0.02,pos6[1],pos6[2]-0.01,pos6[3]]
   c31=plot(plotx,Aug_ave,position=pos61,/current,xrange=pxrange,$
	yrange=pyrange,symbol='*',xtitle=xtitle,font_size=fontsize,$
	xtickv=plotx,xtickname=pxname,xticklen=0.01,yticklen=0.01)

   c32=plot(plotx,enso2[2,*],color='r',/current,axis_style=0,$
	position=pos61,symbol="D",yrange=pyrange1)
   a32=axis('y',target=c32,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

   c4=contour(Sep_fre,lon,lat,c_value=levs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Sep. 2007-2010',position=pos7,/current)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)

   ct=colorbar(target=c,title=bartitle,taper=1,border=1,$
        orientation=1,position=[pos7[2]+0.055,pos7[1],pos7[2]+0.065,pos7[3]])

   pos81=[pos8[0]+0.02,pos8[1],pos8[2],pos8[3]]
   c31=plot(plotx,Sep_ave,position=pos81,/current,xrange=pxrange,$
        yrange=pyrange,symbol='*',xtitle=xtitle,font_size=fontsize,$
        xtickv=plotx,xtickname=pxname,xticklen=0.01,yticklen=0.01)

   c32=plot(plotx,enso2[3,*],color='r',/current,axis_style=0,$
        position=pos81,symbol="D",yrange=pyrange1,font_size=fontsize)
   a32=axis('y',target=c32,location=[max(c12.xrange),0,0],textpos=1,$
        tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

stop
end

pro plot_prec_enso,prec_num,obsnum,month,lat1,lon1,ENSO1
   
    ind=where(month ge 6 and month le 8)
    pre_num1=reform(prec_num[*,*,ind])
    obsnum1=reform(obsnum[*,*,ind])

    Lapre_num=pre_num1[*,*,0:2]+pre_num1[*,*,9:11]
    Laobs_num=obsnum1[*,*,0:2]+obsnum1[*,*,9:11]
   
    Enpre_num=pre_num1[*,*,3:5]+pre_num1[*,*,6:8]
    Enobs_num=obsnum1[*,*,3:5]+obsnum1[*,*,6:8]
   
    data=fltarr(n_elements(lon1),n_elements(lat1),6)
 
    data[*,*,0]=Lapre_num[*,*,0]/float(Laobs_num[*,*,0])   
    data[*,*,1]=Lapre_num[*,*,1]/float(Laobs_num[*,*,1])   
    data[*,*,2]=Lapre_num[*,*,2]/float(Laobs_num[*,*,2])   
    data[*,*,3]=Enpre_num[*,*,0]/float(Enobs_num[*,*,0])   
    data[*,*,4]=Enpre_num[*,*,1]/float(Enobs_num[*,*,1])   
    data[*,*,5]=Enpre_num[*,*,2]/float(Enobs_num[*,*,2])   
   	    	
    maplimit=[-10,75,35,155]   

    plot_hor_6p,data,lat1,lon1,maplimit,'Cloud Frequency'
 
    stop	
end

pro plot_prec_fre,prec_num,obsnum,month,lat,lon,ENSO1

   ; to plot JJA only

   Jun_ave=fltarr(4)
   Jul_ave=fltarr(4)
   Aug_ave=fltarr(4)
   Sep_ave=fltarr(4)

   tobs=total(obsnum,1)
   tobs=total(tobs,1)

   ind=where(month eq 6)
   Jun_num=reform(prec_num[*,*,ind])
   Jun_fre=float(total(Jun_num,3))/total(obsnum[*,*,ind],3)   

   a1=total(Jun_num,1)
   a2=total(a1,1)
   Jun_ave=a2/tobs[ind]

   ind=where(month eq 7)
   Jul_num=reform(prec_num[*,*,ind])
   Jul_fre=float(total(Jul_num,3))/total(obsnum[*,*,ind],3) 

   a1=total(Jul_num,1)
   a2=total(a1,1)
   Jul_ave=a2/tobs[ind]

   ind=where(month eq 8)
   Aug_num=reform(prec_num[*,*,ind])
   Aug_fre=float(total(Aug_num,3))/total(obsnum[*,*,ind],3) 

   a1=total(Aug_num,1)
   a2=total(a1,1)
   Aug_ave=a2/tobs[ind]

   ind=where(month eq 9)
   Sep_num=reform(prec_num[*,*,ind])
   Sep_fre=float(total(Sep_num,3))/total(obsnum[*,*,ind],3) 

   a1=total(Sep_num,1)
   a2=total(a1,1)
   Sep_ave=a2/tobs[ind]

   ;=======print total ave=======
   ind=where(month ge 6 and month le 9)
   print,'total average',total(prec_num[*,*,ind])/total(obsnum[*,*,ind])
   print,Sep_ave,Aug_ave,Jul_ave,Jun_ave	
   ;=======to plot=====================================
   n=11

   levs=[0,0.01,0.03,0.05,0.1,0.15,0.2,0.25,0.3,0.35,0.4,0.7]
;   levs=[0,0.01,0.03,0.05,0.07,0.09,0.1,0.12,0.15,0.17,0.2];,0.25,0.3,0.35,0.4,0.7]

   index=findgen(n)*25

   plotx=findgen(4)
   pxname=['2007','2008','2009','2010']
   pxrange=[0,3]
;   pyrange=[0.20,0.29]
   pyrange=[0.08,0.14]
   pyrange1=[-1.7,1.2]
   psize=0.5
   enso2=enso1[6:9,*]
   xtitle="Year"
   bartitle='Cloud Frequency'
   fontsize=9
	
   maplimit=[-10,75,35,155]   
 
   pos1=[0.05,0.45,0.24,0.90] 
   pos2=[0.05,0.15,0.24,0.35]
   pos3=[0.27,0.45,0.47,0.90] 
   pos4=[0.27,0.15,0.47,0.35]
   pos5=[0.50,0.45,0.70,0.90] 
   pos6=[0.50,0.15,0.70,0.35]
   pos7=[0.73,0.45,0.93,0.90] 
   pos8=[0.73,0.15,0.93,0.35]
 
   c=contour(Jun_fre,lon,lat,c_value=levs,n_levels=n,$
      dim=[1000,450],rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Jun. 2007-2010',position=pos1)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)
   pos21=[pos2[0],pos2[1],pos2[2]-0.02,pos2[3]]
   c1=plot(plotx,Jun_ave,position=pos21,/current,xrange=pxrange,$
	  yrange=pyrange,xtickvalues=plotx,xtickname=pxname,$
          xticklen=0.01,yticklen=0.01,symbol="*",font_size=fontsize,$
	  xtitle=xtitle,name=bartitle)
   c12=plot(plotx,enso2[0,*],color='r',/current,axis_style=0,$
	position=pos21,symbol="D",yrange=pyrange1,name="MEI",font_size=fontsize)
   a12=axis('y',target=c12,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

   ld=legend(target=[c1,c12],position=[0.45,0.1],/normal)

   c2=contour(Jul_fre,lon,lat,c_value=levs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Jul. 2007-2010',position=pos3,/current)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)
   pos41=[pos4[0]+0.01,pos4[1],pos4[2]-0.01,pos4[3]]
   c21=plot(plotx,Jul_ave,position=pos41,/current,xrange=pxrange,$
	yrange=pyrange,xtickv=plotx,xtickname=pxname,symbol='*',$
	xticklen=0.01,yticklen=0.01,xtitle=xtitle,font_size=fontsize)
   c22=plot(plotx,enso2[1,*],color='r',/current,axis_style=0,$
	position=pos41,symbol="D",yrange=pyrange1,font_size=fontsize)
   a22=axis('y',target=c22,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

   c3=contour(Aug_fre,lon,lat,c_value=levs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Aug.. 2007-2010',position=pos5,/current)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)

;   ct=colorbar(target=c,title=bartitle,taper=1,border=1,$
;	orientation=1,position=[pos5[2]+0.08,pos5[1],pos5[2]+0.1,pos5[3]])
  
   pos61=[pos6[0]+0.02,pos6[1],pos6[2]-0.01,pos6[3]]
   c31=plot(plotx,Aug_ave,position=pos61,/current,xrange=pxrange,$
	yrange=pyrange,symbol='*',xtitle=xtitle,font_size=fontsize,$
	xtickv=plotx,xtickname=pxname,xticklen=0.01,yticklen=0.01)

   c32=plot(plotx,enso2[2,*],color='r',/current,axis_style=0,$
	position=pos61,symbol="D",yrange=pyrange1,font_size=fontsize)
   a32=axis('y',target=c32,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)


   c4=contour(Sep_fre,lon,lat,c_value=levs,n_levels=n,$
      rgb_table=33,rgb_indices=index,/fill,title=$
      'Ave. Sep. 2007-2010',position=pos7,/current)

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30)
   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'

   mc=mapcontinents(/continents,transparency=30)

   ct=colorbar(target=c,title=bartitle,taper=1,border=1,$
	orientation=1,position=[pos7[2]+0.055,pos7[1],pos7[2]+0.065,pos7[3]])
  
   pos81=[pos8[0]+0.02,pos8[1],pos8[2],pos8[3]]
   c31=plot(plotx,Sep_ave,position=pos81,/current,xrange=pxrange,$
	yrange=pyrange,symbol='*',xtitle=xtitle,font_size=fontsize,$
	xtickv=plotx,xtickname=pxname,xticklen=0.01,yticklen=0.01)

   c32=plot(plotx,enso2[3,*],color='r',/current,axis_style=0,$
	position=pos81,symbol="D",yrange=pyrange1,font_size=fontsize)
   a32=axis('y',target=c32,location=[max(c12.xrange),0,0],textpos=1,$
	tickdir=1,ticklen=0.01,color='r',tickfont_size=fontsize)

stop
end
