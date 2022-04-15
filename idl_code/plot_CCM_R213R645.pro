pro plot_CCM_R213R645

	datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/CCM_Radiation'

	fname=file_search(datadir,'*wholedomain*')

	Nf=n_elements(fname)

	TR213=0L
	TR64521_pdf=0L
	TR64521_ratio=0.0

	for fi=0,Nf-1 do begin
		read_dardar,fname[fi],'reflect213_pdf',R213
		TR213=TR213+R213
		read_dardar,fname[fi],'reflect1621_2dpdf',R64521_pdf
		TR64521_pdf=TR64521_pdf+R64521_pdf
		read_dardar,fname[fi],'reflect1621_ratio',R64521_ratio
		TR64521_ratio=TR64521_ratio+R64521_ratio
	endfor

    p=plot(TR213[*,1]/float(total(TR213[*,1])),name='Mixed only')
	p1=plot(TR213[*,4]/float(total(TR213[*,4])),color='r',name='Ice above mixed',overplot=p)
	p1=plot(TR213[*,5]/float(total(TR213[*,5])),color='g',name='Clear',overplot=p)
	p.save,'Reflect213_mixed_iceabovemix_clear.png
	stop
end
