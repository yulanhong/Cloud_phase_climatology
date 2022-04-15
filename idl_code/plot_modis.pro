
pro plot_modis

  fname='/u/sciteam/yulanh/scratch/MODIS/MYD021KM/2007/MYD021KM.A2007258.0545.061.2018041132232.hdf'
;  allfname=file_search('/u/sciteam/yulanh/scratch/MODIS/MYD021KM/2007/','*258*')

;  Ns=n_elements(allfname)
  Ns=1
  fname1='/u/sciteam/yulanh/scratch/MODIS/MYD06/2007/MYD06_L2.A2007258.0545.061.2018043072343.hdf'
  read_modis_1,fname1,'Cloud_Mask_SPI',cldspi
  a1=image(reform(cldspi[0,*,*]),rgb_table=33,title='cldspi')

  for fi=0,Ns-1 do begin

  read_modis,fname,red,'EV_250_Aggr1km_RefSB',band=1,refl=1,dims
  read_modis,fname,grn,'EV_500_Aggr1km_RefSB',band=4,refl=1,dims
  read_modis,fname,blu,'EV_500_Aggr1km_RefSB',band=3,refl=1,dims

  nsize=size(red)
  xdim=nsize[1]
  ydim=nsize[2]

  image1=fltarr(3,xdim,ydim)
  image1[0,*,*]=red
  image1[1,*,*]=grn
  image1[2,*,*]=blu

  a2=image(blu,rgb_table=33,title='blue radiance') 

;  red=0 & grn=0 & blu=0

;  device,decomposed=1
 
;  TV,image1*300,true=1 ;have to make the pixel values between 0-255

;  wait,2 
 
  endfor
  stop 

end
