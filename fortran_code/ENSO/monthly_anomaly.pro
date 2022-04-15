
pro monthly_anomaly,data,anomaly

  Nf=n_elements(data)
  clima_monthly=fltarr(12)
  clima_data=intarr(12)
  nanai=0
  ;==== get monthly climatology =====
  for i=0,Nf-1 do begin
	mi=i-(i/12)*12
	if (finite(data[i]) eq 0) then begin
		data[i]=0.0
		nanai=i
	endif
	clima_monthly[mi]=clima_monthly[mi]+data[i]
	if (finite(data[i]) gt 0) then clima_data[mi] = clima_data[mi] +1
  endfor 

  clima_ave=clima_monthly/clima_data
  ;==== get anomaly ====
  anomaly=fltarr(Nf)
  for i=0,Nf-1 do begin
	mi=i-(i/12)*12
	anomaly[i]=data[i]-clima_ave[mi]
  endfor
  if nanai ne 0 then anomaly[nanai]=!values.f_nan

end
