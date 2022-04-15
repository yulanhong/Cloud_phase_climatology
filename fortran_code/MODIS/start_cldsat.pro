
; use to start cloudsat 

pro start_cldsat

	year=['2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018']
	mon=['01','02','03','04','05','06','07','08','09','10','11','12']

    ny=n_elements(year)
    nx=n_elements(mon)
	
	datadir='/u/sciteam/yulanh/scratch/MODIS/MYD03/'
	
    for yi=0, ny-1 do begin
	for xi=0, nx-1 do begin
	datadir1=datadir+year[yi]+'/'+year[yi]+mon[xi]
 
	fname=file_search(datadir1,'*.hdf')
	nodes=n_elements(fname)
	nodes=string(nodes)
	nodes=strcompress(nodes,/rem)
	print,year[yi]+mon[xi],' ',nodes

	IF (nodes gt 1 ) Then Begin 
		stra='sed s/myjob10/myjob'+year[yi]+mon[xi]+'/'+' submit2.sh > submit1.sh'	
		spawn,stra
		spawn,'sed s/200702/'+year[yi]+mon[xi]+'/'+' submit1.sh > submit.sh' 	
		spawn,'sed s/Nnodes/'+nodes+'/'+' submit.sh > submit11.sh' 	
		spawn,'qsub submit11.sh'
	EndIf
	end	
    end
stop
end
