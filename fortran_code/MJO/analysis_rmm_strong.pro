pro analysis_rmm_strong

	fname='RMM_MJO.txt'

	Nl=file_lines(fname)

	var=''
	i=0L
	Phase_fre=ulonarr(8,4) ; in four season
	Phase_amp=fltarr(8,4)
	phase_diffamp=fltarr(8,4)

	Phase_freyr=ulonarr(8,48) ; in order to obtain time series of mjo
	mi=0

	monthflag=-1
;	restore, 'MJO_phase_amplitude.sav'

	openr,u,fname,/get_lun
	while ~eof(u) do begin
	readf,u,var
;	print,var
	i=i+1L
	IF (i gt 2) then begin
		var1=strsplit(var,' ',/ext)
 		year=fix(var1[0])
		month=fix(var1[1])
		day=fix(var1[2])
		rmm1=float(var1[3])
		rmm2=float(var1[4])
		phase=fix(var1[5])
		amplitude=float(var1[6])

		If month ge 3 and month le 5 then monthflag=0 
		If month ge 6 and month le 8 then monthflag=1 
		If month ge 9 and month le 11 then monthflag=2
		If month eq 1 or month eq 2 or month eq 12 then monthflag=3
	
		IF year ge 2007 and year le 2010  then begin 
		IF (rmm1*rmm1+rmm2*rmm2) ge 1 and phase le 8 Then begin
			Phase_fre[phase-1,monthflag]=Phase_fre[phase-1,monthflag]+1
			Phase_amp[phase-1,monthflag]=Phase_amp[phase-1,monthflag]+amplitude

			if year eq 2007 and mi eq 0 and month eq 1 then begin
				 mi=0
				 premonth=month
			endif
			if month ne premonth then mi=mi+1
;			print,mi,month,premonth	
			phase_freyr[phase-1,mi]=phase_freyr[phase-1,mi]+1
			
			premonth=month

			days=Julday(month,day,year)-Julday(1,1,year)+1
		endif
		endif ; end year
	
	EndIf

	endwhile

	free_lun,u

	;to save mjo time series
	save,phase_freyr,filename='MJO_07_10_stat.sav'
	stop
	xname=['1','2','3','4','5','6','7','8']	
    x=findgen(8)+1
	;p=barplot(x,phase_fre[*,0],index=0,Nbars=4,fill_color='blue',dim=[550,500],position=[0.2,0.6,0.9,0.95],xtitle='MJO phase',$
	;	ytitle='Occurrence',xtickname=xname,xtickvalues=x,xminor=0,yminor=0,yticklen=1,yrange=[0,80],ygridstyle=1)
	;p1=barplot(x,phase_fre[*,1],index=1,Nbars=4,fill_color='red',overplot=p)
	;p2=barplot(x,phase_fre[*,2],index=2,Nbars=4,fill_color='cyan',overplot=p)
	;p3=barplot(x,phase_fre[*,3],index=3,Nbars=4,fill_color='dark orange',overplot=p)
	p=plot(x,phase_fre[*,0],color='blue',dim=[550,400],position=[0.2,0.6,0.9,0.95],xtitle='MJO phase',$
		ytitle='Occurrence',xtickname=xname,xtickvalues=x,xminor=0,yminor=0,yticklen=1,yrange=[0,80],$
		ytickvalues=[0,10,20,30,40,50,60,70,80],ygridstyle=1,xrange=[0,9],symbol='circle',sym_size=1.5,$
		sym_filled=1,sym_fill_color='blue',thick=2)
	p1=plot(x,phase_fre[*,1],color='red',overplot=p,symbol='circle',sym_size=1.5,sym_fill_color='red',sym_filled=1,thick=2)
	p2=plot(x,phase_fre[*,2],color='cyan',overplot=p,symbol='circle',sym_size=1.5,sym_fill_color='cyan',sym_filled=1,thick=2)
	p3=plot(x,phase_fre[*,3],color='dark orange',overplot=p,symbol='circle',sym_size=1.5,sym_fill_color='dark orange',$
		sym_filled=1,thick=2)
	
	pos1=p.position
	t1=text(pos1[0]+0.015,pos1[3]-0.04,'a)')
	t11=text(pos1[0]+0.22,pos1[3]-0.07,'MAM',color='blue')
	t12=text(pos1[0]+0.22,pos1[3]-0.11,'JJA',color='red')
	t13=text(pos1[0]+0.22,pos1[3]-0.15,'SON',color='cyan')
	t13=text(pos1[0]+0.22,pos1[3]-0.19,'DJF',color='dark orange')
	;phase_dev=sqrt(phase_diffamp/phase_fre)	
	ave_amp=Phase_amp/Phase_fre

	;b=barplot(x,ave_amp[*,0],index=0,Nbars=4,fill_color='blue',position=[0.2,0.15,0.9,0.50],/current,xtitle='MJO phase',$
	;	ytitle='Amplitude',xtickname=xname,xtickvalues=x,xminor=0,yminor=0,yticklen=1,yrange=[0,2.5],ygridstyle=1)
;	er1=errorplot(x,ave_amp[*,0],phase_dev[*,0],overplot=b)
	;b1=barplot(x,ave_amp[*,1],index=1,Nbars=4,fill_color='red',overplot=b)
	;b2=barplot(x,ave_amp[*,2],index=2,Nbars=4,fill_color='cyan',overplot=b)
	;b3=barplot(x,ave_amp[*,3],index=3,Nbars=4,fill_color='dark orange',overplot=b)
	b=plot(x,ave_amp[*,0],color='blue',position=[0.2,0.15,0.9,0.5],xtitle='MJO phase',/current,$
		ytitle='Amplitude',xtickname=xname,xtickvalues=x,xminor=0,yminor=0,yticklen=1,yrange=[1.0,2.5],$
		ytickvalues=[1,1.5,2.0,2.5],ygridstyle=1,xrange=[0,9],symbol='circle',sym_size=1.5,$
		sym_filled=1,sym_fill_color='blue',thick=2)
	b1=plot(x,ave_amp[*,1],color='red',overplot=b,symbol='circle',sym_size=1.5,sym_fill_color='red',sym_filled=1,thick=2)
	b2=plot(x,ave_amp[*,2],color='cyan',overplot=b,symbol='circle',sym_size=1.5,sym_fill_color='cyan',sym_filled=1,thick=2)
	b3=plot(x,ave_amp[*,3],color='dark orange',overplot=b,symbol='circle',sym_size=1.5,sym_fill_color='dark orange',$
		sym_filled=1,thick=2)
	pos2=b.position
	t2=text(pos2[0]+0.01,pos2[3]-0.05,'b)')

	p.save,'MJO_phase_amplitude_strong07-10_curve.png'
;	save,Phase_fre,filename='MJO_phase_frequency.sav'
;	save,ave_amp,filename='MJO_phase_amplitude.sav'

	stop
end
