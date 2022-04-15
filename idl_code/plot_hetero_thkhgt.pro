
pro plot_hetero_thkhgt

 	dir='/u/sciteam/yulanh/mydata/radar-lidar_out/heterogeneity/parallel/modis_cloudsat/'

	fname=file_search(dir,'*newdomain*')

	Nf=n_elements(fname)

	Thetero_top=0
	Thetero_thk=0

	for fi=0,Nf-1 do begin
		read_dardar,fname[fi],'hetero_mixtop_2dpdf',hetero_xtop_2dpdf
		read_dardar,fname[fi],'hetero_cloudthick_2d',hetero_thk_2dpdf
		Thetero_top=Thetero_top+hetero_xtop_2dpdf
		Thetero_thk=Thetero_thk+hetero_thk_2dpdf
	stop
	endfor

	x=findgen(800)*0.01-6
	xtickv=[200,300,400,500,600]
	xname=['-4','-3','-2','-1','0']
	y=findgen(41)*0.5
	ytickv=[0,8,16,24,32,40]
	yname=['0','4','8','12','16','20']

	a1=image(reform(Thetero_top[*,*,0]),rgb_table=33,title='mixed top ice above mixed',axis_style=0,xrange=[200,600])
	xaxis=axis('X',location=0,target=a1,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='$log_{10}(H_{\sigma})$')
	yaxis=axis('y',location=200,target=a1,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Mixed top (km)')
	a1.scale,0.8,4
	a1.save,'Mixedtop_hsigma_icemixed.png'
	
	a2=image(reform(Thetero_top[*,*,1]),rgb_table=33,title='mixed top ice only',xrange=[200,600])
	xaxis=axis('X',location=0,target=a2,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='$log_{10}(H_{\sigma})$')
	yaxis=axis('y',location=200,target=a2,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Mixed top (km)')
	a2.scale,0.8,4
	a2.save,'Mixedtop_hsigma_mixed.png'
	

	a3=image(reform(Thetero_top[*,*,2]),rgb_table=33,title='mixed top mixed above liquid',xrange=[200,600])
	xaxis=axis('X',location=0,target=a3,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='$log_{10}(H_{\sigma})$')
	yaxis=axis('y',location=200,target=a3,tickdir=0,textpos=0,tickvalues=ytickv,tickname=yname,title='Mixed top (km)')
	a3.scale,0.8,4
	a3.save,'Mixedtop_hsigma_mixliq.png'

	a4=image(reform(Thetero_thk[*,*,0]),rgb_table=33,title='thick ice only')

	a5=image(reform(Thetero_thk[*,*,1]),rgb_table=33,title='thick ice-liquid')
	a6=image(reform(Thetero_thk[*,*,2]),rgb_table=33,title='thick liquid-only')
	a7=image(reform(Thetero_thk[*,*,3]),rgb_table=33,title='thick ice-mixed')

	stop
end
