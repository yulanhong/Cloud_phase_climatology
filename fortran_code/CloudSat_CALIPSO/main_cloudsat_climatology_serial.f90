
        program main_cloudsat_climatology_serial
                
        use global

        implicit none

        !****** initialize for directory, fname********************
        character(len=200) :: datadir,cwcfname,writedir,&
                writefname,ecmwf_fname
        character(len=120),allocatable :: fname_list(:)

	logical :: ecmwf_flag
     
        integer (kind=2) :: Nfname
        integer (kind=4) :: status
        integer :: yi,fi,i,values(8)

        character (len=4) :: stryr,yrindex(4)
        character (len=3) :: strday

        call date_and_time(values=values)
        print *,values

	Do i=1,dimh 
		height(i)=25-i*0.25
	EndDo

        yrindex=(/"2007","2008","2009","2010"/)

        Do yi=1,1

        datadir="/u/sciteam/yulanh/scratch/CLDCLASS/"//yrindex(yi)&
                //"/"

        writedir=&
        "/u/sciteam/yulanh/mydata/radar-lidar_out/cloud/radar-lidar/output/"
        !*****list file into a text file, and then count the file
        ! length using cat, and finally read file name into array
        call system("ls "//trim(datadir)//">& filename",status)

        call system("cat filename | wc -l > count.txt")

        open(100,file="count.txt")
        read(100,*) Nfname
        close(100)
        print *,Nfname

        allocate(fname_list(Nfname))
    
        open(200,file="filename")
        read(200,fmt=*,iostat=status) fname_list
        close(200)

        ! loop for file calculation 
        Do fi=1,1!Nfname
 
        cwcfname=trim(datadir)//trim(fname_list(fi))
	
        stryr =trim(cwcfname(41:44))
        strday=trim(cwcfname(45:47))
        read(stryr,'(i4)') year  ! convert string to int
        read(strday,'(i3)') Julday
	!print *,fname_list(fi),stryr
        !print *,cwcfname,stryr,strday,year,Julday
	ecmwf_fname="/u/sciteam/yulanh/scratch/ECMWF/"//stryr//"/"&
	//cwcfname(41:60)//"CS_ECMWF-AUX_GRANULE_P_R05_E02_F00.hdf"

	INQUIRE (file=ecmwf_fname,exist=ecmwf_flag)
	IF (ecmwf_flag) THEN
        call Julday2month() 

        call inquire_info(cwcfname)

        call read_cloudsat(cwcfname) 

	call read_ecmwf(ecmwf_fname)
	!print *,ecmwf_fname

        call calculate_core() 

        !**** add results from each file
        Tobsnum=Tobsnum+obsnum
!        Tpreci_fre=Tpreci_fre+preci_fre
        TOneLay_fre=TOneLay_fre+oneLay_fre
        TMulLay_1fre=TMulLay_1fre+MulLay_1fre
        TMulLay_nfre=TMulLay_nfre+MulLay_nfre

	allmean_surf_p= allmean_surf_p + mean_surf_p
	allmean_surf_t= allmean_surf_t + mean_surf_t
	allmean_surf_u= allmean_surf_u + mean_surf_u
	allmean_surf_v= allmean_surf_v + mean_surf_v

	allDem_elevation=allDem_elevation+DEM_elevation

	allonelay_surf_p= allonelay_surf_p + onelay_surf_p
	allonelay_surf_t= allonelay_surf_t + onelay_surf_t
	allonelay_surf_u= allonelay_surf_u + onelay_surf_u
	allonelay_surf_v= allonelay_surf_v + onelay_surf_v

	allmullay_1surf_p= allmullay_1surf_p + mullay_1surf_p
	allmullay_1surf_t= allmullay_1surf_t + mullay_1surf_t
	allmullay_1surf_u= allmullay_1surf_u + mullay_1surf_u
	allmullay_1surf_v= allmullay_1surf_v + mullay_1surf_v

	allmullay_nsurf_p= allmullay_nsurf_p + mullay_nsurf_p
	allmullay_nsurf_t= allmullay_nsurf_t + mullay_nsurf_t
	allmullay_nsurf_u= allmullay_nsurf_u + mullay_nsurf_u
	allmullay_nsurf_v= allmullay_nsurf_v + mullay_nsurf_v

        All_onelaytopH=All_onelaytopH+sum_onelaytopH
        All_onelaybaseH=All_onelaybaseH+sum_onelaybaseH
      
        All1_mullaytopH=All1_mullaytopH+sum1_mullaytopH
        All1_mullaybaseH=All1_mullaybaseH+sum1_mullaybaseH

        Alln_lowlaytopH=Alln_lowlaytopH+sumn_lowlaytopH
        Alln_lowlaybaseH=Alln_lowlaybaseH+sumn_lowlaybaseH
        Alln_uplaytopH=Alln_uplaytopH+sumn_uplaytopH
        Alln_uplaybaseH=Alln_uplaybaseH+sumn_uplaybaseH

	Tobsnumv=Tobsnumv+obsnumv
	Tonelay_frev=Tonelay_frev+onelay_frev
	Tonelayic_frev=Tonelayic_frev+onelayic_frev
	Tonelaymc_frev=Tonelaymc_frev+onelaymc_frev

	Tmullay_frev=Tmullay_frev+mullay_frev
	Tmullayic_frev=Tmullayic_frev+mullayic_frev	

	Tliqnoice_frev=Tliqnoice_frev+liqnoice_frev
	Tliqice_frev=Tliqice_frev+liqice_frev
	Ticemix_frev=Ticemix_frev+icemix_frev

	Tliqice_freh=Tliqice_freh+liqice_freh

	allliqice_liqtop=allliqice_liqtop+liqice_liqtop

        include 'deallocate_array.file' 
	ENDIF ! end if ecmwf file exists
        EndDo ! end file loop

        deallocate(fname_list)


        writefname="cldsat_cldclimotology25_meterology"//yrindex(yi)//".hdf"
        call write_cloudsat_clim(writefname)

        call date_and_time(values=values)
        print *,values

        EndDo ! end year
        !print *,sum(obsnum)

        stop
        end 
