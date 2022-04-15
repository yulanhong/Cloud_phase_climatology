pro plot_ze_re_relation

 restore,'ze_re_ice_200708.sav'

 restore,'ze_re_icenum_200708.sav'
 restore,'hsigma_vsre_200708.sav'
 restore,'hsigma_square_vsre_200708.sav'
 restore,'hsigma_vsrenum_200708.sav'

 avehsigma=hsigma_re/hsigma_re_num
 stdhsigma=sqrt(hsigma_re_square/hsigma_re_num-avehsigma*avehsigma)
 xvalue=findgen(120)

 p=errorplot(xvalue,avehsigma[*,0],stdhsigma[*,0],$
	xtitle='MODIS re',ytitle='H$_\sigma$',title='ice',xrange=[0,70],yrange=[0,0.4],thick=2)
 p.save,'ice_modis_re_simga.png'
 p1=errorplot(xvalue,avehsigma[*,1],stdhsigma[*,1],$
	xtitle='MODIS re',ytitle='H$_\sigma$',title='liquid',xrange=[0,30],yrange=[0,0.4],thick=2)
 p1.save,'liquid_modis_re_simga.png'
stop
 hgt=25-findgen(125)*0.24

 Tzere=total(ze_re_ice,1)
 Tzere=total(Tzere,1)
 Tzerenum=total(ze_re_ice_num,1)
 Tzerenum=total(Tzerenum,1)

 xtick=[0,10,20,30,40,50,60,70]
 xname=['0','10','20','30','40','50','60','70']
 ztickv=[5,10,15,20]
 zname=['5','10','15','20']

 avezere=Tzere/Tzerenum
 im=image(avezere,xvalue,hgt,rgb_table=33,min_value=-28,max_value=9,xrange=[0,70],$
	yrange=[3,20])
 im.scale,2,5
 xaxis=axis('X',location=3,target=im,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='MODIS Re')
 yaxis=axis('Y',location=0,target=im,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname,title='Altitude')
 pos=im.position
 ct=colorbar(target=im,title='Radar Reflectivity (dBz)',position=[pos[0],pos[1]-0.1,pos[2],pos[1]-0.07])
 im.save,'ice_modisre_dbz_relation.png'

 restore,'ze_re_liquid_200708.sav'
 restore,'ze_re_liquidnum_200708.sav'

 Twczere=total(ze_re_liquid,1)
 Twczere=total(Twczere,1)
 Twczerenum=total(ze_re_liquid_num,1)
 Twczerenum=total(Twczerenum,1)
 avewczere=Twczere/Twczerenum

 xtick=[0,5,10,20,30,40]
 xname=['0','5','10','20','30','40']
 ztickv=[1,2,3,4,5]
 zname=['1','2','3','4','5']
 im=image(avewczere,xvalue,hgt,rgb_table=33,min_value=-28,max_value=9,xrange=[0,40],$
	yrange=[1,6])
 im.scale,2,8
 xaxis=axis('X',location=1,target=im,tickdir=0,textpos=0,tickvalues=xtickv,tickname=xname,title='MODIS Re')
 yaxis=axis('Y',location=0,target=im,tickdir=0,textpos=0,tickvalues=ztickv,tickname=zname,title='Altitude')
 pos=im.position
 ct=colorbar(target=im,title='Radar Reflectivity (dBz)',position=[pos[0],pos[1]-0.1,pos[2],pos[1]-0.08])
 im.save,'liquid_modisre_dbz_relation.png'




 stop

end
