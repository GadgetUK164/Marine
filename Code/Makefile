PROJECT=Marine
PART=XC95144XL-10-TQ100
WORKDIR=tmp
CABLE=usb21

#CPLDFITFLAGS=-loc on -slew slow -init low -terminate keeper  -unused ground -power std  -optimize speed -keepio
CPLDFITFLAGS=-loc on -slew fast -init low -terminate keeper  -unused float -power std  -optimize speed -keepio

.PHONY:	all clean timing fit flash

all:	$(PROJECT).jed timing

$(PROJECT).prj: *.vhd
	@rm -f $@
	@for f in $^; do echo "vhdl work $$f" >> $@; done

$(WORKDIR)/$(PROJECT).ngc:	*.vhd $(PROJECT).prj
	@mkdir -p $(WORKDIR)
	@sed -r "s#^(-ofn).*#\1 ..\/$@#g;s#^(-ifn).*#\1 ../$(PROJECT).prj#g;s#^(-define).*#\1 {$(DEFINES)}#g" template.xst > $@.xst
	cd $(WORKDIR) && xst -ifn ../$@.xst -ofn $(PROJECT)-xst.log

$(WORKDIR)/%.ngd:	$(WORKDIR)/%.ngc pins.ucf
	cd $(WORKDIR) && ngdbuild -p $(PART) -uc ../pins.ucf ../$< ../$@

$(WORKDIR)/%.rpt $(WORKDIR)/%.vm6:	$(WORKDIR)/%.ngd pins.ucf
	cd $(WORKDIR) && cpldfit $(CPLDFITFLAGS) -p $(PART) ../$< | egrep -v "^CS: block|^$$"
	cp $(WORKDIR)/$(PROJECT).rpt .

%.jed:	$(WORKDIR)/%.vm6
	hprep6 -i $<
	cp $@ ../Binary/

fit:	$(WORKDIR)/$(PROJECT).vm6


%.tim:	$(WORKDIR)/%.vm6
	cd $(WORKDIR) && taengine -l ../$@ -f $(PROJECT)


timing:	$(PROJECT).tim

clean:
	-rm -rvf tmp
	-rm *.jed
	-rm *.prj

flash:	$(PROJECT).jed
	@echo "setMode -bs\n"\
	"setCable -p $(CABLE)\n"\
	"identify\n"\
	"assignfile -p 1 -file $<\n"\
	"erase -p 1\n"\
	"program -p 1\n"\
	"verify -p 1" | LD_PRELOAD=/opt/Xilinx/usb-driver/libusb-driver.so impact -batch
