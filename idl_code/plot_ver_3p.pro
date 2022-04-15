pro plot_ver_3p,data1,data2,data3,xdata,ydata,plot_levs,xrange,yrange
  n=15
  
 pos1=[0.1,0.72,0.78,0.93]
 pos2=[0.1,0.42,0.78,0.63]
 pos3=[0.1,0.12,0.78,0.33]
 barpos=[0.92,0.2,0.95,0.8]

 c=contour(data1,xdata,ydata,c_value=plot_levs,n_levels=n,dim=[550,450],$
        rgb_table=33,rgb_indices=index,/fill,title='(a) All cloud frequency',$
        position=pos1,xrange=xrange,yrange=yrange)

 c1=contour(data2,xdata,ydata,c_value=plot_levs,n_levels=n,$
        rgb_table=33,rgb_indices=index,/fill,title='(b) One layer cloud frequency',$
        position=pos2,/current,xrange=xrange,yrange=yrange)

 c2=contour(data3,xdata,ydata,c_value=plot_levs,n_levels=n,$
        rgb_table=33,rgb_indices=index,/fill,title='(c) Multi-layer cloud frequency',$
        position=pos3,/current,xrange=xrange,yrange=yrange)

 ct=colorbar(target=c,title='Cloud Frequency',taper=1,border=1,$
        orientation=1,position=barpos)

 stop
end
