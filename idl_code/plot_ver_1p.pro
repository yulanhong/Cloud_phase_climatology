pro plot_ver_1p,data,xdata,ydata,fname,plot_levs,bar_levs,yrange,ytitle,bartitle

  entry_device=!D.name

   SET_PLOT, 'ps'


    DEVICE, FILE=fname,XOFFSET=0.01, YOFFSET=0.01,xsize=6,ysize=8,/inches, /COLOR

   r=[255,  0,255,0  ,0  ,0  ,0  ,0  ,19 ,83 ,155,223,255,255,255,255,224,153]
   g=[255,  0,255,0  ,31 ,95 ,163,227,255,255,255,255,223,159,99 ,31 ,0  ,0]
   b=[255,  0,255,235,255,255,255,255,235,171,99 ,31 ,0  ,0  ,0  ,0  ,0  ,   0]


   TVLCT,r,g,b
   n=15

   !P.color=1
   !P.font=0
   !P.thick=2.0
   !X.THICK=1.0
   !Y.THICK=1.0

     axsize=0.9
     versize=.950
     subsize=1.05
     barsize=1.


   pos=[0.3,0.35,0.72,0.8]
   barpos=[0.22,0.1,0.8,0.30]

   myticks=['90!Eo!NS','45!Eo!NS','0!Eo', '45!Eo!NN','90!Eo!NN ']
   n1=n_elements(myticks) 
   xtickv=findgen(n1)/(n1-1)
   

   contour,data,xdata,ydata,levels=plot_levs,c_colors=findgen(n)+3,/cell_fill,$
                background=255,ytitle=xtitle,xtitle=' ',$
                charsize=versize,charthick=2.0,ticklen=0.02,$
                xstyle=1,xticks=n1-1,xtickv=xtickv,xtickname=myticks,$
                position=pos,yrang=yrange


 colbar,barpos,bar_levs,''
 device,/close
 set_plot,entry_device


end
