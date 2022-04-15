pro plot_2dhis_taurad

	datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/CCM_Radiation/'
	fname=file_search(datadir,'*.hdf')

	Nf=n_elements(fname)
	
	Treflect=0L
	Treflect1375=0L
	TBT11=0L
	TBTD=0L
	fontsz=10

	for fi=0, Nf-1 do begin
		IF (strlen(fname[fi]) eq 96) Then Begin 
		print,fname[fi]
		read_dardar,fname[fi],'tau_reflect645_iceon',reflect
		read_dardar,fname[fi],'tau_reflect1375_iceo',reflect1375
		read_dardar,fname[fi],'tau_BT11_iceonly',BT11
		read_dardar,fname[fi],'tau_BTD_iceonly',BTD
		read_dardar,fname[fi],'tau_interval(log)',tau
		Treflect=Treflect+reflect
		Treflect1375=Treflect1375+reflect1375
		TBT11 = TBT11 + BT11
		TBTD = TBTD + BTD

		EndIf
	endfor

	yreflect=findgen(121)*0.01
	yBT11=findgen(201)+150
	YBTD=findgen(300)*0.1-8.5
	pos1=[0.08,0.25,0.33,0.95]
;	pos2=[0.55,0.55,0.95,0.95]
	pos3=[0.39,0.25,0.64,0.95]
	pos4=[0.70,0.25,0.95,0.95]
	xtickv=[-3,-2,-1,0,1,2]
	xname=['-3','-2',-'1','0','1','2']
	ytickv=[0,0.1,0.2,0.3,0.4,0.5]
	yname=['0','0.1','0.2','0.3','0.4','0.5']
	maxvalue1=1.3
	maxvalue2=0.6
	maxvalue3=0.2
	fre1=Treflect/total(float(Treflect))

 	ind1=where(yreflect le 0.029,count) ;0.028 for subarea, 0.029 for wholedomain
	Ny=count
	ind2=where(tau le -0.39794,count)
	Ntau=count
	print,'small reflectance ice only',total(fre1[ind2[0]:ind2[Ntau-1],ind1[0]:ind1[Ny-1]])

	c1=image(fre1*100,tau,yreflect,rgb_table=56,dim=[800,450],position=pos1,$
		xrange=[-3,2],yrange=[0,0.5],axis_style=0,min_value=0.001,max_value=maxvalue1)
	xaxis=axis('X',location=0,target=c1,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,$
		title='$log_{10}(Ice \tau)$')
	yaxis=axis('Y',location=-3,target=c1,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,$
		title='$R_{0.645}$',ticklen=0.01)
	px=fltarr(121)
	px(*)=-0.39794
	p1=plot(px,yreflect,yrange=[0,0.5],linestyle='dashed',overplot=c1)
	py=fltarr(76)
	py(*)=0.029 ; halfwidth x value
	p2=plot(tau,py,xrange=[-3,2],linestyle='dashed',overplot=c1)
	c1.scale,0.95,8
	cb1=colorbar(target=c1,position=[0.05,0.28,0.33,0.30],title='Frequency (%)',font_size=fontsz+1)
	
;	fre2=Treflect1375/total(float(Treflect1375))
;	c2=image(fre2,tau,yreflect,rgb_table=56,position=pos2,/current,$
;		xrange=[-3,2],yrange=[0,0.5],axis_style=0,min_value=0,max_value=maxvalue1)
;	xaxis=axis('X',location=0,target=c2,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,$
;		title='$log_{10}(Ice \tau)$')
;	yaxis=axis('Y',location=-3,target=c2,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,$
;		title='$R_{1.375}$')
;	px=fltarr(121)
;	px(*)=-0.39794
;	p1=plot(px,yreflect,yrange=[0,0.5],linestyle='dashed',overplot=c2)
;	c2.scale,1,8
	
	ytickv=[200,220,240,260,280,300]
	yname=['200','220','240','260','280','300']
	fre3=TBT11/total(float(TBT11))

 	ind1=where(yBT11 ge 293,count) ;292 for subarea, 293 for wholedomain
	Ny=count
	ind2=where(tau le -0.39794,count)
	Ntau=count
	print,'large BT ice only',total(fre3[ind2[0]:ind2[Ntau-1],ind1[0]:ind1[Ny-1]])

	c3=image(fre3*100,tau,yBT11,rgb_table=56,position=pos3,min_value=0,max_value=maxvalue2,$
		xrange=[-3,2],yrange=[200,300],axis_style=0,/current)
	xaxis=axis('X',location=200,target=c3,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,$
		title='$log_{10}(Ice \tau)$')
	yaxis=axis('Y',location=-3,target=c3,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,$
		title='$BT_{11}$',ticklen=0.02)
	px=fltarr(201)
	px(*)=-0.39794
	p1=plot(px,yBT11,yrange=[200,300],linestyle='dashed',overplot=c3)
	py(*)=293.448 ; halfwidth x value
	p2=plot(tau,py,xrange=[-3,2],linestyle='dashed',overplot=c3)
	c3.scale,12.5,0.51
	cb2=colorbar(target=c3,position=[0.39,0.28,0.64,0.30],title='Frequency (%)',font_size=fontsz+1)

	t1=text(0.1,0.8,'a)')
	t1=text(0.41,0.8,'b)')
	t1=text(0.72,0.8,'c)')
	t2=text(0.15,0.75,'$\tau ~ 0.4$',font_size=fontsz)
	t2=text(0.10,0.47,'$R_{0.645}(f_{max}/2)$ ~ 0.029',font_size=fontsz)
	t3=text(0.53,0.75,'$\tau ~ 0.4$',font_size=fontsz)
	t3=text(0.40,0.70,'$BT_{11}(f_{max}/2)$ ~ 293',font_size=fontsz)
	t4=text(0.77,0.75,'$\tau ~ 0.4$',font_size=fontsz)
	t4=text(0.83,0.48,'$BTD(f_{max}/2)$ ~ -1.5',font_size=fontsz)
	
	ytickv=[-2,0,2,4,6]
	yname=['-2','0','2','4','6']
	fre4=TBTD/total(float(TBTD))
 	ind1=where(yBTD le -1.49715,count)
	Ny=count
	ind2=where(tau le -0.39794,count)
	Ntau=count
	print,'small BTD ice only',total(fre4[ind2[0]:ind2[Ntau-1],ind1[0]:ind1[Ny-1]])


	c4=image(fre4*100,tau,yBTD,rgb_table=56,position=pos4,$
		xrange=[-3,2],yrange=[-2.5,6.5],axis_style=0,/current,min_value=0,max_value=maxvalue3)
	xaxis=axis('X',location=-2.5,target=c4,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,$
		title='$log_{10}(Ice \tau)$')
	yaxis=axis('Y',location=-3,target=c4,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,$
		title='$BT_{8.5}-BT_{11}$',ticklen=0.02)
	px=fltarr(300)
	px(*)=-0.39794
	p1=plot(px,yBTD,yrange=[-2.5,6.5],linestyle='dashed',overplot=c4)
	py(*)=-1.42678 ; halfwidth x value
	p2=plot(tau,py,xrange=[-3,2],linestyle='dashed',overplot=c4)
	c4.scale,1.1,0.51
	cb3=colorbar(target=c4,position=[0.70,0.28,0.95,0.30],title='Frequency (%)',font_size=fontsz+1)
	c1.save,'tau_reflect_BT_2dhis_newdomain.png'
	stop
end
