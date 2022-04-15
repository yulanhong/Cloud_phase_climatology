pro plot_cloudphase_rad

 numflag=0
 aveflag=1
 stdflag=0

 xvalue=findgen(7)
 xtickv=xvalue+0.5
 wv=['0.55','0.645','0.858','1.375','1.6','8.5','12.02']
 SZA=findgen(70)
 ztickv=[20,30,40,50]
 zname=['20','30','40','50']

 title=['Clear','Ice','Ice-liquid','Ice-mix','Liquid','Mix']

 restore,'spectral_rad_num.sav'
 
 if numflag eq 1 then begin
 for i=0,5 do begin
	a=image(reform(SPECTRAL_RAD_SZA_NUM[*,*,i]),rgb_table=33,min_value=0,max_value=7800)
	a.scale,10,2
 endfor
 endif

 restore,'spectral_rad_sza.sav'

 averad1=spectral_rad_sza/spectral_rad_sza_num
 averad=alog(averad1)

 yrange=[20,50]
 if aveflag eq 1 then begin
 for i=0,5 do begin
	a=image(reform(averad[*,*,i]),xvalue,SZA,rgb_table=33,min_value=-3.5,$
		max_value=6.5,title=title[i],yrange=yrange)
 	 xaxis=axis('X',location=min(yrange),target=a,tickdir=0,textpos=0,tickvalues=xtickv,tickname=wv,title='Wavelength($\mu$m)')
	yaxis=axis('Y',location=0,target=a,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname,title='SZA')
	a.scale,50,6
	pos=a.position
    ct=colorbar(target=a,title='Radiance (W m$^{-2}$ $\mum^{-1}$ sr$^{-1}$',position=[pos[0],pos[1]-0.11,pos[2],pos[1]-0.08])
    a.save,'radiance_wv_SZA'+title[i]+'.png'
 
 endfor
 endif


 restore,'spectral_rad_square.sav'

 spectral_rad_sza_square1=spectral_rad_sza_square/spectral_rad_sza_num

 stdrad=sqrt(spectral_rad_sza_square1-averad1*averad1)

 if stdflag eq 1 then begin
 for i=0,5 do begin
	a=image(alog(reform(stdrad[*,*,i])),rgb_table=33,min_value=-3.4,max_value=5,title=title[i])
	a.scale,20,2
 endfor
 endif

 stop

end
