
pro average_property,onenum,onetop,onebase,mul1num,mul1top,mul1base,mulnnum,mullowtop,mullowbase,mulupbase,muluptop,obsnum,winum,witop,lat,lon

  subarea=[0,105,25,130]
;  subarea=[10,110,20,120]
;  region_map,lat,lon
  indlat=where(lat ge subarea[0] and lat le subarea[2])
  indlon=where(lon ge subarea[1] and lon le subarea[3])
  onenum1=onenum[*,indlat,*,*]
  onenum2=onenum1[indlon,*,*,*]
 
  onetop1=onetop[*,indlat,*,*]
  onetop2=onetop1[indlon,*,*,*]

  onebase1=onebase[*,indlat,*,*]
  onebase2=onebase1[indlon,*,*,*]

  mul1num1=mul1num[*,indlat,*,*]
  mul1num2=mul1num1[indlon,*,*,*]
  
  mul1top1=mul1top[*,indlat,*,*]
  mul1top2=mul1top1[indlon,*,*,*]
  mul1base1=mul1base[*,indlat,*,*]
  mul1base2=mul1base1[indlon,*,*,*]
 
  mulnnum1=mulnnum[*,indlat,*,*]
  mulnnum2=mulnnum1[indlon,*,*,*]

  mullowtop1=mullowtop[*,indlat,*,*]
  mullowtop2=mullowtop1[indlon,*,*,*]
  mullowbase1=mullowbase[*,indlat,*,*]
  mullowbase2=mullowbase1[indlon,*,*,*]

  mulupbase1=mulupbase[*,indlat,*,*]
  mulupbase2=mulupbase1[indlon,*,*,*]

  muluptop1=muluptop[*,indlat,*,*]
  muluptop2=muluptop1[indlon,*,*,*]

  obsnum1=obsnum[*,indlat,*,*]
  obsnum2=obsnum1[indlon,*,*,*]

  witop1=witop[*,indlat,*,*]
  witop2=witop1[indlon,*,*,*]

  winum1=winum[*,indlat,*,*]
  winum2=winum1[indlon,*,*,*]

  monind=[6,7,8]
  onenum3=onenum2[*,*,*,monind]
  onetop3=onetop2[*,*,*,monind]
  onebase3=onebase2[*,*,*,monind]
  mul1num3=mul1num2[*,*,*,monind]
  mul1top3=mul1top2[*,*,*,monind]
  mul1base3=mul1base2[*,*,*,monind]
  mulnnum3=mulnnum2[*,*,*,monind]
  mullowtop3=mullowtop2[*,*,*,monind]
  mullowbase3=mullowbase2[*,*,*,monind]
  mulupbase3=mulupbase2[*,*,*,monind]
  muluptop3=muluptop2[*,*,*,monind]
  obsnum3=obsnum2[*,*,monind]  

  witop3=witop2[*,*,*,monind]
  winum3=winum2[*,*,*,monind]
  
  for i=0,2 do begin
  print,i
  print,'onelayer freq',total(onenum3[*,*,i,*])/float(total(obsnum3))
  print,'onelayer top',$
       total(onenum3[*,*,i,*]*onetop3[*,*,i,*])/float(total(onenum3[*,*,i,*]))
  print,'onelayer base',$
       total(onenum3[*,*,i,*]*onebase3[*,*,i,*])/float(total(onenum3[*,*,i,*]))
  print,'mullayer onephase freq',total(mul1num3[*,*,i,*])/float(total(obsnum3))
  print,'mullay onephase top',$
	total(mul1num3[*,*,i,*]*mul1top3[*,*,i,*],/nan)/float(total(mul1num3[*,*,i,*]))

  print,'mullay onephase base',$
	total(mul1num3[*,*,i,*]*mul1base3[*,*,i,*],/nan)/float(total(mul1num3[*,*,i,*]))

  print,'mullayer nphase freq',total(mulnnum3[*,*,i,*])/float(total(obsnum3))
  print,'mullay nphase low top',$
	total(mulnnum3[*,*,i,*]*mullowtop3[*,*,i,*])/float(total(mulnnum3[*,*,i,*]))

  print,'mullay nphase low base',$
	total(mulnnum3[*,*,i,*]*mullowbase3[*,*,i,*])/float(total(mulnnum3[*,*,i,*]))
  print,'mullay nphase up top',$
	total(mulnnum3[*,*,i,*]*muluptop3[*,*,i,*])/float(total(mulnnum3[*,*,i,*]))
  print,'mullay nphase up base',$
	total(mulnnum3[*,*,i,*]*mulupbase3[*,*,i,*])/float(total(mulnnum3[*,*,i,*]))
  endfor
 print,'total winum one layer',total(winum3[*,*,0,*])/total(winum3)
 print,'total winum multi layer',total(winum3[*,*,1,*])/total(winum3)
 print,'total winum one-layer top',total(winum3[*,*,0,*]*witop3[*,*,0,*])/total(winum3[*,*,0,*])
 print,'total winum multi layer',total(winum3[*,*,1,*]*witop3[*,*,1,*])/total(winum3[*,*,1,*])

 print,'total one-lay fre',total(onenum3)/float(total(obsnum3)) 
 print,'total multilay 1 fre',total(mul1num3)/float(total(obsnum3)) 
 print,'total multilay n fre',total(mulnnum3)/float(total(obsnum3)) 

 stop
end

pro region_map,lat,lon
   maplimit=[-10,75,35,155]
   subarea=[0,105,25,130]
   subarea1=[10,110,20,120]
   fontsz=12

   mp=map('Geographic',limit=maplimit, overplot=c,transparency=30,position=[0.1,0.2,0.9,0.85],$
	font_size=fontsz)

   grid=mp.MAPGRID
   grid.label_position=0
   grid.linestyle='dotted'
   grid.box_axes=1
 
   mc=mapcontinents(/continents,transparency=30)

   x=fltarr(10)
   x[*]=subarea[1]
   y=findgen(6)*5
   p=plot(x,y,overplot=mp,color='r',/current,thick=3) 
   x[*]=subarea1[1]
   y=findgen(3)*5+10
   p=plot(x,y,overplot=mp,color='b',/current,thick=3) 

   x=fltarr(10)
   x[*]=subarea[3]
   y=findgen(6)*5
   p1=plot(x,y,overplot=mp,color='r',/current,thick=3) 
   x[*]=subarea1[3]
   y=findgen(3)*5+10
   p1=plot(x,y,overplot=mp,color='b',/current,thick=3) 
  
   y=fltarr(10)
   y[*]=subarea[0]
   x=findgen(6)*5+105
   p2=plot(x,y,overplot=mp,color='r',/current,thick=3) 
   x=findgen(3)*5+110
   y[*]=subarea1[0]
   p2=plot(x,y,overplot=mp,color='b',/current,thick=3) 

   y=fltarr(10)
   x=findgen(6)*5+105
   y[*]=subarea[2]
   p2=plot(x,y,overplot=mp,color='r',/current,thick=3) 
   x=findgen(3)*5+110
   y[*]=subarea1[2]
   p2=plot(x,y,overplot=mp,color='b',/current,thick=3) 
  stop 
end 
