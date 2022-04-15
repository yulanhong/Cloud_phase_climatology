pro plot_ratio_hetero_cldfra

 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/CCM_Radiation'
 
 fname=file_search(datadir,'*wholedomain*')

 Nf=n_elements(fname)

 lnthick=2
 lncolor=['lime','dark orange','blue','red','purple','Cyan','green']
 fontsz=11.5
 xname=['Ice only','Mixed only','Liquid only','Ice above liquid','Ice above mixed','Clear']

 Thetero_ratio=0.0
 Tmodcld=0.0
 Tmodliq=0.0
 Tratio_num=0

 Thetero_r645=0.0
 Tmodcld_r645=0.0
 Tmodliq_r645=0.0
 Tr645_num=0

 Thetero_bt11=0.0
 Tmodcld_bt11=0.0
 Tmodliq_bt11=0.0
 Tbt11_num=0

 Thetero_btd=0.0
 Tmodcld_btd=0.0
 Tmodliq_btd=0.0
 Tbtd_num=0

 for fi=0,Nf-1 do begin
	print,fname[fi]
	read_dardar,fname[fi],'hetero_ratio',hetero_ratio ; heterogeneity as a function of reflected ratio
 	read_dardar,fname[fi],'modcldfraction_ratio',modcld
	read_dardar,fname[fi],'modliqfraction_ratio',modliq
	read_dardar,fname[fi],'reflect_ratio_pdf',reflect_ratio

	Tratio_num=Tratio_num+reflect_ratio
	ind=where(reflect_ratio eq 0)
	hetero_ratio[ind]=0.0
	modcld[ind]=0.0
	modliq[ind]=0.0
	Thetero_ratio=Thetero_ratio+hetero_ratio*reflect_ratio
	Tmodcld=Tmodcld+modcld*reflect_ratio
	Tmodliq=Tmodliq+modliq*reflect_ratio


	read_dardar,fname[fi],'hetero_reflect645',hetero_r645 ; heterogeniety as a function of reflectance 0.645
	read_dardar,fname[fi],'modcldfraction_refle',modcld_r645
	read_dardar,fname[fi],'modliqfraction_refle',modliq_r645
	read_dardar,fname[fi],'reflect645_pdf',r645_pdf

	Tr645_num=Tr645_num+r645_pdf
	ind=where(r645_pdf eq 0)
	hetero_r645[ind]=0.0
	modcld_r645[ind]=0.0
	modliq_r645[ind]=0.0
	Thetero_r645=Thetero_r645+hetero_r645*r645_pdf
	Tmodcld_r645=Tmodcld_r645+modcld_r645*r645_pdf
	Tmodliq_r645=Tmodliq_r645+modliq_r645*r645_pdf


	read_dardar,fname[fi],'hetero_BT11',hetero_bt11 ; heterogeneity as a function of bt11
	read_dardar,fname[fi],'modcldfraction_BT11',modcld_bt11
	read_dardar,fname[fi],'modliqfraction_BT11',modliq_bt11
	read_dardar,fname[fi],'BT11_pdf',bt11_pdf

	Tbt11_num=Tbt11_num+bt11_pdf
	ind=where(bt11_pdf eq 0)
	hetero_bt11[ind]=0.0
	modcld_bt11[ind]=0.0
	modliq_bt11[ind]=0.0
	Thetero_bt11=Thetero_bt11+hetero_bt11*bt11_pdf
	Tmodcld_bt11=Tmodcld_bt11+modcld_bt11*bt11_pdf
	Tmodliq_bt11=Tmodliq_bt11+modliq_bt11*bt11_pdf


	read_dardar,fname[fi],'hetero_BTD',hetero_btd ; heterogeneity as a function of bt11
	read_dardar,fname[fi],'modcldfraction_BTD',modcld_btd
	read_dardar,fname[fi],'modliqfraction_BTD',modliq_btd
	read_dardar,fname[fi],'BTD8.5_11_pdf',btd_pdf

	Tbtd_num=Tbtd_num+btd_pdf
	ind=where(btd_pdf eq 0)
	hetero_btd[ind]=0.0
	modcld_btd[ind]=0.0
	modliq_btd[ind]=0.0
	Thetero_btd=Thetero_btd+hetero_btd*btd_pdf
	Tmodcld_btd=Tmodcld_btd+modcld_btd*btd_pdf
	Tmodliq_btd=Tmodliq_btd+modliq_btd*btd_pdf
	
 endfor

 ;for heterogeneity as a function of ratio
  avehetero=Thetero_ratio/Tratio_num
  avemodcld=Tmodcld/Tratio_num
  avemodliq=Tmodliq/Tratio_num

 ;for heterogeneity as a function of r645
  avehetero_r645=Thetero_r645/Tr645_num
  avemodcld_r645=Tmodcld_r645/Tr645_num
  avemodliq_r645=Tmodliq_r645/Tr645_num

 ;for heterogeneity as a function of bt11 
  avehetero_bt11=Thetero_bt11/Tbt11_num
  avemodcld_bt11=Tmodcld_bt11/Tbt11_num
  avemodliq_bt11=Tmodliq_bt11/Tbt11_num

 ;for heterogeneity as a function of btd 
  avehetero_btd=Thetero_btd/Tbtd_num
  avemodcld_btd=Tmodcld_btd/Tbtd_num
  avemodliq_btd=Tmodliq_btd/Tbtd_num

  xdata1=findgen(121)*0.01 ; reflect645
  xdata2=findgen(500)*0.01
  xdata3=findgen(201)+150 ; bt11
  xdata4=findgen(300)*0.1-8.5

  yrange=[0,0.45]
  xrange1=[0,1] ;reflect
  xrange2=[0,1.1] ;ratio
  xrange3=[180,300]; BT 
  xrange4=[-3,7] ;BT  diff 

  data1=avehetero_r645
  data2=avehetero
  data3=avehetero_bt11
  data4=avehetero_btd
;  data1=avemodcld_r645
;  data2=avemodcld
;  data3=avemodcld_bt11
;  data4=avemodcld_btd
;  data1=avemodliq_r645
;  data2=avemodliq
;  data3=avemodliq_bt11
;  data4=avemodliq_btd

  ytitle='$H_\sigma$'
;  ytitle='Liquid cloud fraction'
;  ytitle='All cloud fraction'
  xtitle1='$R_{0.645}$'
  xtitle2='$R_{2.13}/R_{0.645}$'
  xtitle3='$BT_{11}$'
  xtitle4='BTD'
 
  pos1=[0.10,0.60,0.50,0.95]
  pos2=[0.57,0.60,0.97,0.95]
  pos3=[0.10,0.10,0.50,0.50]
  pos4=[0.57,0.10,0.97,0.50]

  for i=0,5 do begin
	if i eq 0 then begin
		p10=plot(xdata1,data1[*,i],xrange=xrange1,thick=lnthick,$
        name=xname[i],yrange=yrange,font_size=fontsz,xtitle=xtitle1,color=lncolor[i],$
        ytitle=ytitle,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,$
        dim=[600,500],position=pos1)
		t1=text(pos1[0]+0.03,pos1[3]+0.01,'a)')

		p20=plot(xdata2,data2[*,i],xrange=xrange2,thick=lnthick,position=pos2,$
        name=xname[i],yrange=yrange,font_size=fontsz,xtitle=xtitle2,color=lncolor[i],$
        yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,/current)
		t1=text(pos2[0]+0.03,pos2[3]+0.01,'b)')

		p30=plot(xdata3,data3[*,i],xrange=xrange3,thick=lnthick,position=pos3,$
        name=xname[i],yrange=yrange,font_size=fontsz,xtitle=xtitle3,color=lncolor[i],$
        ytitle=ytitle,yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,/current)
		t1=text(pos3[0]+0.03,pos3[3]+0.01,'c)')

		p40=plot(xdata4,data4[*,i],xrange=xrange4,thick=lnthick,position=pos4,$
        name=xname[i],yrange=yrange,font_size=fontsz,xtitle=xtitle4,color=lncolor[i],$
        yminor=0,yticklen=1,ygridstyle=1,xticklen=0.02,/current)
		t1=text(pos4[0]+0.03,pos4[3]+0.01,'d)')

    	ld=legend(target=[p10],position=[0.12,0.45],transparency=100,horizontal_alignment=0)
	endif else begin
		p1=plot(xdata1,data1[*,i],thick=lnthick,name=xname[i],color=lncolor[i],overplot=p10)
		p2=plot(xdata2,data2[*,i],thick=lnthick,name=xname[i],color=lncolor[i],overplot=p20)
		p3=plot(xdata3,data3[*,i],thick=lnthick,name=xname[i],color=lncolor[i],overplot=p30)
		p4=plot(xdata4,data4[*,i],thick=lnthick,name=xname[i],color=lncolor[i],overplot=p40)

    	ld=legend(target=[p1],position=[0.12,0.45-i*0.035],transparency=100,horizontal_alignment=0)
	endelse

  endfor
p10.save,'hetero_bt11_refect_btd_relation_fouryear_newdomain.png'
;p10.save,'allmodcld_bt11_refect_btd_relation_fouryear_newdomain.png'
stop
end

