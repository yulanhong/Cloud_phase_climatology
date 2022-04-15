
pro read_modis,filename, variable, variablename, band=band, refl=refl, dimvector
; set refl=1 for reflectance, 0 for radiance

if refl then begin
  scalestr = 'reflectance_scales'
  offsetstr = 'reflectance_offsets'
endif else begin
  scalestr = 'radiance_scales'
  offsetstr = 'radiance_offsets'
endelse
fillstr = '_FillValue'

fileID = hdf_sd_start(filename,/read)
varindex = hdf_sd_nametoindex(fileID,variablename)
varID = hdf_sd_select(fileID,varindex)
hdf_sd_getdata, varID, vararr

bandsindex = hdf_sd_attrfind(varID,'band_names')
hdf_sd_attrinfo, varID,bandsindex,data=bandstr

; to find the band index, we need to count commas
onebandstr = string(band)
onebandstr = strtrim(band,2)
commacount = 0
comma_position = 0
comma_position_old = 0
;locate position of the single band in the string of bands
band_position = strpos(bandstr,onebandstr)
; trim end off bandstr
bandstr = strmid(bandstr,0,band_position+1)
if (band_position ne -1) then begin
; now we count commas up to this band position
 while (comma_position lt band_position) do begin
    comma_position = strpos(bandstr,',',comma_position_old+1)
    if (comma_position eq -1) then $
      comma_position=band_position $
    else commacount = commacount+1
    comma_position_old = comma_position
 endwhile
endif else print, 'no band match!'
variable = vararr[*,*,commacount]
vararr=0

fillindex = hdf_sd_attrfind(varID,fillstr)
hdf_sd_attrinfo, varID, fillindex, data=fill
bad = where(variable eq fill)

scaleID = hdf_sd_attrfind(varID,scalestr)
hdf_sd_attrinfo, varID, scaleID, data=scale
offsetID = hdf_sd_attrfind(varID,offsetstr)
hdf_sd_attrinfo, varID, offsetID, data=offset

variable = scale[commacount]*(temporary(variable)-offset[commacount])
if (bad[0] ne -1) then variable(bad) = !values.f_NaN

hdf_sd_getinfo, varID, dims=dimvector

hdf_sd_endaccess, varID
hdf_sd_end, fileID
end

