
pro compare_modcld_satcld

	dir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat/R05'

	fname=file_search(dir,'*R05*')

	Nf=n_elements(fname)

	Tmodcld_satcld=ulonarr(7,5) ;1-clear,2-iceonly,3-iceliq,4-icemixed,5-liquid,6-mixed only
	Tmodliq_satcld=ulonarr(6,800) ;1-clear,2 water, 3 ice, 4 mixed, 5 undetermined

	for fi=0,Nf-1 do begin
		print,fname[fi]
		read_dardar,fname[fi],'cldsatcld_modiscld',modcld_satcld
		read_dardar,fname[fi],'cldsatcld_modisliq',modliq_satcld
		Tmodcld_satcld=Tmodcld_satcld+modcld_satcld
		Tmodliq_satcld=Tmodliq_satcld+modliq_satcld
	stop
	endfor

	stop

end

