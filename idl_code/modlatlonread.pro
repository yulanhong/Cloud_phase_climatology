pro modlatlonread,filename, lat,lon, geodimvector


fileID = hdf_sd_start(filename,/read)

latindex = hdf_sd_nametoindex(fileID,'Latitude')
latID = hdf_sd_select(fileID,latindex)
hdf_sd_getdata, latID, lat

lonindex = hdf_sd_nametoindex(fileID,'Longitude')
lonID = hdf_sd_select(fileID,lonindex)
hdf_sd_getdata, lonID, lon

hdf_sd_getinfo, latID,  dims=geodimvector

hdf_sd_endaccess, latID
hdf_sd_endaccess, lonID
hdf_sd_end, fileID

end