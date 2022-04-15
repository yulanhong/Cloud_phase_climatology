pro modcld_mismatch

 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat'

 allfname=file_search(datadir,'*newdomain*')


 Nf=n_elements(allfname)
 Tmisnum=0L
 Tclrnum=0L

 for fi=0, Nf-1 do begin
	read_dardar,allfname[fi],'subarea_hetero_pdf',hetero_pdf
	read_dardar,allfname[fi],'number_cldsatclr_mod',misnum
    read_dardar,allfname[fi],'hetero_invertal',hetero_interval
	Tmisnum=Tmisnum+misnum
	Tclrnum=Tclrnum+hetero_pdf[*,0]
 endfor

 p=plot(hetero_interval,Tmisnum,title='cloudsat clear, modis cloudy',xtitle='H_${\sigma}$',ytitle='number')

 p.save,'cloudsat_clear_modis_cloudy_fouryear.png'

 stop

end
