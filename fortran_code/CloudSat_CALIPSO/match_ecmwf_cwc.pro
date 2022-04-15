
pro match_ecmwf_cwc

 ecmwfname=file_search("/u/sciteam/yulanh/scratch/ECMWF/2008/","*.hdf")
 cwcfname=file_search("/u/sciteam/yulanh/scratch/CLDCLASS/2008/","*.hdf")

 nf=n_elements(cwcfname)
 stop
 for fi=0,nf-1 do begin
     tpcwcfname=cwcfname[fi]
     tpecfname=strcompress('/u/sciteam/yulanh/scratch/ECMWF/2008/'+strmid(tpcwcfname,40,19)+'_CS_ECMWF-AUX_GRANULE_P_R05_E02_F00.hdf',/rem)
     ind=where(tpecfname eq ecmwfname)
     if ind[0] eq -1 then print,'file not exist ',tpecfname
     if ind[0] ne -1 then read_cloudsat,tpecfname,'ECMWF-AUX','Latitude',lat
   
 endfor

 stop

end
