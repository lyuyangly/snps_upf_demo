all:	clean comp run vcov

clean:
	\rm -rf simv*
	\rm -rf csrc*
	\rm -rf *log *Log
	\rm -rf mvsim_native_reports
	\rm -rf vc_hdrs.h ucli.key rtl.fsdb
	\rm -rf novas.conf novas_dump.log novas.rc

verdi:
	verdi -sverilog -f run.f -upf demo.upf

comp:
	vcs -sverilog -f run.f -P ${NOVAS_HOME}/share/PLI/VCS/LINUX/novas.tab \
	${NOVAS_HOME}/share/PLI/VCS/LINUX/pli.a -debug_pp \
	-cm assert+branch+cond+fsm+line+tgl -power=coverage+dump_hvp

run:
	./simv -cm branch+cond+fsm+line+tgl

vcov:
	verdi -cov -covdir simv.vdb -sv +define+NOVAS_UPF_PKG -f run.f -upf2.0 demo.upf -ssf rtl.fsdb -nologo
