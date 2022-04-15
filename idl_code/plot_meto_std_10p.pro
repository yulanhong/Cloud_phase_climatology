
 pro plot_meto_std_10p,data1,data2,xdata1,xdata2,ydata,subtitle

   posx1=[0.06,0.25,0.44,0.63,0.82]
   posx2=[0.22,0.41,0.60,0.79,0.98]
   posy1=[0.70,0.70,0.70,0.70,0.70,0.40,0.40,0.40,0.40,0.40]-0.02
   posy2=[0.90,0.90,0.90,0.90,0.90,0.60,0.60,0.60,0.60,0.60]-0.02
 
   fontsz=10
   
   n=11
   index=findgen(n)*25
   horlevs=findgen(n)*0.005+0.005
   tickname=['','0.01','','0.02',' ','0.03','','0.04',' ','0.05','']
 
   For i=0,9 Do Begin

   pi=i-(i/5)*5
   pos=[posx1[pi],posy1[i],posx2[pi],posy2[i]]

   title=['a) Ice Cloud','b) Mixed-phase Cloud','c) Liquid Cloud','d) Ice-liquid Cloud','e) Ice-mixed Cloud',$
	  'f)', 'g)', 'h)','i)','j)']

   if i eq 0 then begin
	c=contour(data1[*,*,i],xdata1,ydata,c_value=horlevs,n_levels=n,$
       	dim=[1000,500],rgb_table=68,rgb_indices=index,/fill,axis_style=2,$
      	position=pos,font_size=fontsz,xrange=[280,300],yrange=[0,20],$
	xtitle='Temperature (K)',ytitle='Altitude (km)')
	t=text(pos[0],pos[3],title[i],font_size=fontsz,/normal)
   endif


    if i ge 1 and i le 4 then begin 
	c1=contour(data1[*,*,i],xdata1,ydata,c_value=horlevs,n_levels=n,$
       	rgb_table=68,rgb_indices=index,/fill,/current,axis_style=2,$
      	position=pos,font_size=fontsz,xrange=[280,300],yrange=[0,20],$
	xtitle='Temperature (K)')
	t=text(pos[0],pos[3],title[i],font_size=fontsz,/normal)
   endif

    if i ge 5 then begin 
	if i eq 5 then ytitle='Altitude (km)' else ytitle=''
	c1=contour(data2[*,*,i-5],xdata2,ydata,c_value=horlevs,n_levels=n,$
       	rgb_table=68,rgb_indices=index,/fill,/current,axis_style=2,$
      	position=pos,font_size=fontsz,xrange=[3,7],yrange=[0,20],$
	xtitle='Stability ($K km^{-1}$)',ytitle=ytitle)
	t=text(pos[0],pos[3],title[i],font_size=fontsz,/normal)
   endif

   EndFor

     t=text(0.15,0.93,subtitle,font_size=fontsz+2,/normal)

     barpos=[posx1[1],pos[1]-0.13,posx1[4],pos[1]-0.10]
     ct=colorbar(target=c,title='Cloud Frequency',taper=0,border=1,$
        orientation=0,position=barpos,tickname=tickname)
     ct.font_size=fontsz

     c.save,'cldsat_temp_stat_'+subtitle+'_newdomain.png'   
  
 end
