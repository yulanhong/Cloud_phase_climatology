
; use to start cloudsat 

pro start_cldsat

	year=['2007','2008','2009','2010']
	mon=['01','02','03','04','05','06','07','08','09','10','11','12']

    ny=n_elements(year)
    nx=n_elements(mon)
	
	datadir='/u/sciteam/yulanh/scratch/CLDCLASS/'
	
    for yi=0, 3 do begin
	for xi=0, 11 do begin
	datadir1=datadir+year[yi]+'/'+year[yi]+mon[xi]
 
	fname=file_search(datadir1,'*.hdf')
	nodes=n_elements(fname)
	nodes=string(nodes)
	nodes=strcompress(nodes,/rem)
	print,year[yi]+mon[xi],' ',nodes
	stra='sed s/myjob10/myjob'+year[yi]+mon[xi]+'/'+' submit2.sh > submit1.sh'	
	spawn,stra
	spawn,'sed s/200702/'+year[yi]+mon[xi]+'/'+' submit1.sh > submit.sh' 	
	spawn,'sed s/Nnodes/'+nodes+'/'+' submit.sh > submit11.sh' 	

	spawn,'qsub submit11.sh'
	
	end	
    end
stop
end
