pro plot_modisCC_clearhsigma

	datadir1='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat'

	fname1=file_search(datadir1,'*newdomain*')

	Nf1=n_elements(fname1)
	
	TCC_hetero_pdf=0.0

	for fi=0,Nf1-1 do begin
		read_dardar,fname1[fi],'hetero_invertal',x
		read_dardar,fname1[fi],'subarea_hetero_pdf',CC_hetero_pdf
		TCC_hetero_pdf=TCC_hetero_pdf+CC_hetero_pdf
	endfor	

	datadir2='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis/'
	fname2=file_search(datadir2,'*_newdomain.hdf')
	Nf2=n_elements(fname2)
	TMOD_hetero_pdf=0.0
	for fi=0,Nf2-1 do begin
		year=strmid(fname2[fi],19,4,/rev)
		year1=fix(year)
		IF year1 ge 2007 and year le 2010 Then Begin
		read_dardar,fname2[fi],'subarea_hetero_pdf',MOD_hetero_pdf
		TMOD_hetero_pdf=TMOD_hetero_pdf+MOD_hetero_pdf
		EndIf
	endfor


	fname3=file_search(datadir2,'*_newdomain_0.5.hdf')
	Nf3=n_elements(fname3)
	TMOD1_hetero_pdf=0.0
	for fi=0,Nf3-1 do begin
		year=strmid(fname3[fi],23,4,/rev)
		year1=fix(year)
		IF year1 ge 2007 and year le 2010 Then Begin
		read_dardar,fname3[fi],'subarea_hetero_pdf',MOD1_hetero_pdf
		TMOD1_hetero_pdf=TMOD1_hetero_pdf+MOD1_hetero_pdf
		EndIf
	endfor

	TCC_hetero_fre=float(TCC_hetero_pdf[*,0])/total(TCC_hetero_pdf[*,0])
	TMOD_hetero_fre=float(TMOD_hetero_pdf[*,0])/total(TMOD_hetero_pdf[*,0])
	TMOD1_hetero_fre=float(TMOD1_hetero_pdf[*,0])/total(TMOD1_hetero_pdf[*,0])
	save,TCC_hetero_fre,filename='CC_clear_pdf.sav'
	save,TMOD_hetero_fre,filename='Aqua_modisclear_pdf.sav'
	pdf2cdf,reform(TCC_hetero_pdf[*,0]),TCC_hetero_cdf
	TCC_hetero_cdfre=float(TCC_hetero_cdf)/total(TCC_hetero_cdf[799])
	pdf2cdf,reform(TMOD_hetero_pdf[*,0]),TMOD_hetero_cdf
	TMOD_hetero_cdfre=float(TMOD_hetero_cdf)/total(TMOD_hetero_cdf[799])

	pdf2cdf,reform(TMOD1_hetero_pdf[*,0]),TMOD1_hetero_cdf
	TMOD1_hetero_cdfre=float(TMOD1_hetero_cdf)/total(TMOD1_hetero_cdf[799])

	lnthk=2.0

	c=plot(x,TCC_hetero_fre*100,dim=[500,400],name='CC clear',xtitle='$H_{\sigma}$',ytitle='Frequency (%)',$
		xrange=[-3,0],yrange=[0,2.5],thick=lnthk)
	c1=plot(x,TMOD_hetero_fre*100,overplot=c,name='MODIS clear whole swath',color='red',thick=lnthk)
	c2=plot(x,TMOD1_hetero_fre*100,overplot=c,name='MODIS clear Sensor Zenith angle <= 0.5',color='purple',thick=lnthk)
	ld=legend(target=[c,c1,c2],position=[0.8,0.86],transparency=100)
	c.save,'MODIS_CC_clearhsigma.png'

	p=plot(x,TCC_hetero_cdfre*100,dim=[500,400],name='CC clear',xtitle='$H_{\sigma}$',ytitle='Frequency (%)',$
		xrange=[-3,0],yrange=[0,100],thick=lnthk)
	p1=plot(x,TMOD_hetero_cdfre*100,overplot=p,name='MODIS clear whole swath',color='red',thick=lnthk)
	p2=plot(x,TMOD1_hetero_cdfre*100,overplot=p,name='MODIS clear Sensor Zenith angle <= 0.5',color='purple',thick=lnthk)
	ld=legend(target=[p,p1,p2],position=[0.8,0.86],transparency=100)
	p.save,'MODIS_CC_clearhsigma_cdf.png'

	stop
end
