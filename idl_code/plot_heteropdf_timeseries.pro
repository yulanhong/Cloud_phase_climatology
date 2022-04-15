pro plot_heteropdf_timeseries

 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis'

 allfname=file_search(datadir,'*.hdf')

 Nf=n_elements(allfname)
 pdf_time=fltarr(Nf,800)
 Nf=1 
 for fi=0,Nf-1 do begin
	read_dardar,allfname[fi],'subarea_hetero_pdf',hetero_pdf
	read_dardar,allfname[fi],'hetero_interval',y
 ;   pdf_time[fi,*]= hetero_pdf[*,2]/float(total(hetero_pdf[*,2]))
   
 endfor 


 NH=n_elements(y)

 openw,u,'H_sigma_interval.txt',/get_lun

 for i=0, NH-1 do begin
	printf,u,y[i]
 endfor

 free_lun,u
; x=findgen(Nf)
; im=image(pdf_time,x,y,yrange=[-2,0],rgb_table=33)
stop
end

