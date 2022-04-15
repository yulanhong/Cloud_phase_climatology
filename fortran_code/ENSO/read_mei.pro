pro read_mei,data3
  fname='MEI_index.txt'
  data=read_ascii(fname)
  data=data.(0)

  year=data[0,*]
  ind=where(year ge 2002)
  data1=data[*,ind]
  data2=data1[1:12,*]
 
  size=size(data2)
  nsz=size[4]
  data3=fltarr(nsz)
  data3=data2[6:nsz-1] 

end
