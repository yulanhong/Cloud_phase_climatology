
pro plot_distance_pdfcdf

 datadir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat'
   
 fname=file_search(datadir,'*newdomain*')
  
 Nf=n_elements(fname)
 
 Tdistance=0

 for fi=0,Nf-1 do begin
	read_dardar,fname[fi],'distance_pdf',distance
	Tdistance=Tdistance+distance
 endfor
 
 pdf2cdf,Tdistance,Tcdf
 x=findgen(101)*10
 fontsz=12
 lnthk=3
 pdffre=100*float(Tdistance)/total(Tdistance)
 cdffre=100*Tcdf/float(Tcdf[100])
 p=plot(x,pdffre,dim=[550,400],xtitle='Distance of CC-MODIS pixels (m)',ytitle='Frequency(%)',$
	font_size=fontsz,thick=lnthk,position=[0.12,0.1,0.85,0.9])

 ax=p.axes
 ax[3].hide=1
 
 p1=plot(x,cdffre,position=p.position,color='r',axis_style=0,/current,thick=lnthk)
 a1=axis('y',target=p1,location=[max(p.xrange),0,0],textpos=1,title='Frequency(%)',color='r')

 p.save,'distance_pdfcdf.png'
 stop

end
