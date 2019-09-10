set projDir "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/planAhead"
set projName "time-frequency_analyzer"
set topName top
set device xc6slx9-2tqg144
if {[file exists "$projDir/$projName"]} { file delete -force "$projDir/$projName" }
create_project $projName "$projDir/$projName" -part $device
set_property design_mode RTL [get_filesets sources_1]
set verilogSources [list "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/verilog/mojo_top_0.v" "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/verilog/timeing_1.v" "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/verilog/Signal_ROM_2.v" "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/verilog/serial_TX_3.v" "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/verilog/SFTransform_4.v" "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/work/verilog/SumSRAM_5.v" ]
import_files -fileset [get_filesets sources_1] -force -norecurse $verilogSources
set ucfSources [list "/home/cory/alchitry-labs-1.0.8/time-frequency_analyzer/constraint/Tx.ucf" "/home/cory/alchitry-labs-1.0.8/library/components/mojo.ucf" ]
import_files -fileset [get_filesets constrs_1] -force -norecurse $ucfSources
set_property -name {steps.bitgen.args.More Options} -value {-g Binary:Yes -g Compress} -objects [get_runs impl_1]
set_property steps.map.args.mt on [get_runs impl_1]
set_property steps.map.args.pr b [get_runs impl_1]
set_property steps.par.args.mt on [get_runs impl_1]
update_compile_order -fileset sources_1
launch_runs -runs synth_1
wait_on_run synth_1
launch_runs -runs impl_1
wait_on_run impl_1
launch_runs impl_1 -to_step Bitgen
wait_on_run impl_1
