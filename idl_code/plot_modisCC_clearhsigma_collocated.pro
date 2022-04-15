pro plot_modisCC_clearhsigma_collocated

	datadir1='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat/R05'

	fname1=file_search(datadir1,'*newdomain*')

	Nf1=n_elements(fname1)
	
	TCC_hetero_pdf=0.0
	Tmodcldclr_MODCC_num=0
	Tmodliq_satcld=0
	Tmodice_CCice=0

	for fi=0,Nf1-1 do begin
		read_dardar,fname1[fi],'hetero_invertal',x
		read_dardar,fname1[fi],'subarea_hetero_pdf',CC_hetero_pdf
		TCC_hetero_pdf=TCC_hetero_pdf+CC_hetero_pdf
		read_dardar,fname1[fi],'modcldclr_MODCC_num',modcldclr_MODCC_num
;		read_dardar,fname1[fi],'modcldclr_MODCC_hete',modcldclr_MODCC_hetero
		Tmodcldclr_MODCC_num=Tmodcldclr_MODCC_num+modcldclr_MODCC_num
;		Tmodcldclr_MODCC_hetero=Tmodcldclr_MODCC_hetero+modcldclr_MODCC_hetero
		read_dardar,fname1[fi],'cldsatcld_modisliq',modliq_satcld
		Tmodliq_satcld=Tmodliq_satcld+modliq_satcld
		
		read_dardar,fname1[fi],'modice_CCice_pdf',modice_CCice	
		Tmodice_CCice=Tmodice_CCice+modice_CCice

	endfor	

	TCC_hetero_fre=float(TCC_hetero_pdf[*,0])/total(TCC_hetero_pdf[*,0])
	pdf2cdf,reform(TCC_hetero_pdf[*,0]),TCC_hetero_cdf
	TCC_hetero_cdfre=float(TCC_hetero_cdf)/TCC_hetero_cdf[799]	
	
	TMODCC_clr_fre=float(Tmodcldclr_MODCC_num[*,0])/total(Tmodcldclr_MODCC_num[*,0])
	TMODcld_CCclr_fre=float(Tmodcldclr_MODCC_num[*,1])/total(Tmodcldclr_MODCC_num[*,1])
	TMODclr_CCcld_fre=float(Tmodcldclr_MODCC_num[*,2])/total(Tmodcldclr_MODCC_num[*,2])
	TMODcld_CCcld_fre=float(Tmodcldclr_MODCC_num[*,3])/total(Tmodcldclr_MODCC_num[*,3])

	pdf2cdf,reform(Tmodcldclr_MODCC_num[*,0]),TMODCC_clr_cdf
	TMODCC_clr_cdfre=fltarr(800)
	TMODCC_clr_cdfre=float(TMODCC_clr_cdf)/TMODCC_clr_cdf[799]

	pdf2cdf,reform(Tmodcldclr_MODCC_num[*,1]),TMODcld_CCclr_cdf
	TMODcld_CCclr_cdfre=fltarr(800)
	TMODcld_CCclr_cdfre=float(TMODcld_CCclr_cdf)/TMODcld_CCclr_cdf[799]

	pdf2cdf,reform(Tmodcldclr_MODCC_num[*,2]),TMODclr_CCcld_cdf
	TMODclr_CCcld_cdfre=fltarr(800)
	TMODclr_CCcld_cdfre=float(TMODclr_CCcld_cdf)/TMODclr_CCcld_cdf[799]

	pdf2cdf,reform(Tmodcldclr_MODCC_num[*,3]),TMODcld_CCcld_cdf
	TMODcld_CCcld_cdfre=fltarr(800)
	TMODcld_CCcld_cdfre=float(TMODcld_CCcld_cdf)/TMODcld_CCcld_cdf[799]


	; CC liquid vs. MODIS-CC liquid
	modice_CCice_pdf=float(Tmodice_CCice)/total(Tmodice_CCice)
	CCice_pdf=float(TCC_hetero_pdf[*,1])/total(TCC_hetero_pdf[*,1])
	;CC liquid vs. MODIS-CCl liquid
	modliq_CCliq_pdf=float(Tmodliq_satcld[4,*])/total(Tmodliq_satcld[4,*])
	CCliq_pdf=float(TCC_hetero_pdf[*,4])/total(TCC_hetero_pdf[*,4])
		

	lnthk=2.0

	c=plot(x,TCC_hetero_fre*100,dim=[500,400],name='CC clr',xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency (%)',$
		xrange=[-3,0],yrange=[0,2.5],thick=lnthk)
	c1=plot(x,TMODCC_clr_fre*100,overplot=c,name='MODIS clr, CC clr',color='red',thick=lnthk)
;	c3=plot(x,TMODcld_CCclr_fre*100,overplot=c,name='MODIS cld, CC clr',color='green',thick=lnthk)
;	c2=plot(x,TMODclr_CCcld_fre*100,overplot=c,name='MODIS clr, CC cld',color='purple',thick=lnthk)
;	c3=plot(x,TMODcld_CCcld_fre*100,overplot=c,name='MODIS cld, CC cld',color='purple',thick=lnthk)
	ld=legend(target=[c,c1],position=[0.8,0.86],transparency=100)
	c.save,'MODIS_CC_clearhsigma_collocated_R05.png'


	p=plot(x,TCC_hetero_cdfre*100,dim=[500,400],name='CC clr',xtitle='$H_{\sigma}$',ytitle='Frequency (%)',$
		xrange=[-3,0],yrange=[0,100],thick=lnthk)
	p1=plot(x,TMODCC_clr_cdfre*100,overplot=p,name='MODIS clr,CC clr ',color='red',thick=lnthk)
	p3=plot(x,TMODcld_CCclr_cdfre*100,overplot=p,name='MODIS cld,CC clr ',color='green',thick=lnthk)
	p2=plot(x,TMODclr_CCcld_cdfre*100,overplot=p,name='MODIS clr, CC cld',color='purple',thick=lnthk)
;	p3=plot(x,TMODcld_CCcld_cdfre*100,overplot=p,name='MODIS cld, CC cld',color='purple',thick=lnthk)
	ld=legend(target=[p,p1,p2,p3],position=[0.6,0.86],transparency=100)
	p.save,'MODIS_CC_clearhsigma_cdf_collocated_R05.png'

	c=plot(x,CCice_pdf*100,dim=[500,400],name='CC ice',xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency (%)',$
		xrange=[-3,0],yrange=[0,1.5],thick=lnthk)
	c1=plot(x,modice_CCice_pdf*100,overplot=c,name='MODIS ice, CC ice',color='red',thick=lnthk)
	ld=legend(target=[c,c1],position=[0.8,0.86],transparency=100)
	c.save,'MODIS_CC_icehsigma_collocated_R05.png'

	c=plot(x,CCliq_pdf*100,dim=[500,400],name='CC liquid',xtitle='$log_{10}(H_{\sigma})$',ytitle='Frequency (%)',$
		xrange=[-3,0],yrange=[0,1.5],thick=lnthk)
	c1=plot(x,modliq_CCliq_pdf*100,overplot=c,name='MODIS liquid, CC liquid',color='red',thick=lnthk)
	ld=legend(target=[c,c1],position=[0.8,0.86],transparency=100)
	c.save,'MODIS_CC_liquidhsigma_collocated_R05.png'
	stop
end
