pro plot_clrhsigma_ASTER_MODIS_CC


   	restore,'Aqua_modisclear_pdf.sav'
	restore,'CC_clear_pdf.sav'
	
	data1=read_ascii('asterclear.txt')
	ASTER_clear_fre1=data1.(0)
	ASTER_clear_fre=fltarr(800)
	ASTER_clear_fre[0:599]=ASTER_clear_fre1[199:798]
	data2=read_ascii('modisclear.txt')
	modis_clear_fre1=data2.(0)
	modis_clear_fre=fltarr(800)
	modis_clear_fre[0:599]=modis_clear_fre1[199:798]

	x=findgen(800)*0.01-6
	xrange=[-3,0]
	yrange=[0,3]
	lnthick=2
	symsz=1.3
	fontsz=12

	pos1=[0.2,0.60,0.9,0.95]
	pos2=[0.2,0.15,0.9,0.45]


 	p01=plot(x,TCC_hetero_fre*100,xrange=xrange,thick=lnthick,xticklen=0.01,$	        
	name='CC Clear',yrange=yrange,font_size=fontsz,yticklen=0.01,color='red',$
        xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency (%)',symbol='dot',sym_size=symsz,xlog=0,$
		dim=[400,500],position=pos1)

 	p02=plot(x,TMOD_hetero_fre*100,thick=lnthick,overplot=p01,xticklen=0.01,$	        
	name='Aqua MODIS Clear',yrange=yrange,font_size=fontsz,yticklen=0.01,color='blue',$
        symbol='dot',sym_size=symsz,xlog=0)

 	p03=plot(x,ASTER_clear_fre*100,thick=lnthick,overplot=p01,xticklen=0.01,$	        
	name='ASTER+Terra MODIS Clear',yrange=yrange,font_size=fontsz,yticklen=0.01,color='cyan',$
        symbol='dot',sym_size=symsz,xlog=0)

 	p04=plot(x,modis_clear_fre*100,thick=lnthick,overplot=p01,xticklen=0.01,$	        
	name='Terra MODIS Clear',yrange=yrange,font_size=fontsz,yticklen=0.01,color='orange',$
        symbol='dot',sym_size=symsz,xlog=0)

	ld=legend(target=[p01,p02,p03,p04],position=[1.0,0.88],transparency=100,sample_width=0.08,$
         shadow=0,vertical_spacing=0.008,font_size=fontsz-1.5)

	; to plot pdf and cdf ....
	pdf2cdf,TCC_hetero_fre,TCC_hetero_cdf
	pdf2cdf,TMOD_hetero_fre,TMOD_hetero_cdf
	pdf2cdf,ASTER_clear_fre,ASTER_hetero_cdf
	pdf2cdf,modis_clear_fre,modis_hetero_cdf

	yrange=[0,100]
 	p11=plot(x,TCC_hetero_cdf*100,xrange=xrange,thick=lnthick,xticklen=1,ygridstyle=1,xgridstyle=1,$	        
	name='CC Clear',yrange=yrange,font_size=fontsz,yticklen=1,color='red',$
        xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency (%)',symbol='dot',sym_size=symsz,xlog=0,$
		/current,position=pos2,xminor=0,yminor=0)

 	p12=plot(x,TMOD_hetero_cdf*100,thick=lnthick,overplot=p11,$	        
	name='Aqua MODIS Clear',yrange=yrange,font_size=fontsz,color='blue',$
        symbol='dot',sym_size=symsz,xlog=0)

 	p13=plot(x,ASTER_hetero_cdf*100,thick=lnthick,overplot=p11,$	        
	name='ASTER+Terra MODIS Clear',yrange=yrange,font_size=fontsz,color='cyan',$
        symbol='dot',sym_size=symsz,xlog=0)

 	p14=plot(x,modis_hetero_cdf*100,thick=lnthick,overplot=p11,$	        
	name='Terra MODIS Clear',yrange=yrange,font_size=fontsz,color='orange',$
        symbol='dot',sym_size=symsz,xlog=0)
	

     p01.save,'clearsky_hsigma_RICO_SEA.png'

	stop

end
