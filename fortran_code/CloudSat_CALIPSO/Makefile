HDFEOSHOME=/u/sciteam/yulanh/software_installed
HDFHOME=/sw/xe/hdf4/4.2.10/cle5.2_gnu4.8.2

FFLAGS = -g -I$(HDFHOME)/include
LDFLAGS = -L$(HDFEOSHOME)/hdfeos/lib -L$(HDFHOME)/lib -lhdfeos -lGctp -lmfhdf -ldf -ljpeg -lz -lm

FC = ftn

SOURCES= global.f90 inquire_info.f90 read_cloudsat.f90 read_ecmwf.f90 main_cloudsat_climatology_serial.f90 Julday2month.f90 calculate_core.f90 write_cloudsat_clim.f90

OBJECTS=$(SOURCES:.f90=.f90.o)

all: test08

clean:
	rm -f *.o test08

test08: $(OBJECTS)
	$(FC) $(OBJECTS) $(FFLAGS) $(LDFLAGS) -o $@

%.f90.o:
	$(FC) $(FFLAGS) -c $(@:.o=) -o $@

