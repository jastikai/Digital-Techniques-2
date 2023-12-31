onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /acs_tb/DUT/abm_in
add wave -noupdate -radix unsigned /acs_tb/DUT/apm_in
add wave -noupdate -radix unsigned /acs_tb/DUT/bbm_in
add wave -noupdate -radix unsigned /acs_tb/DUT/bpm_in
add wave -noupdate -radix unsigned /acs_tb/DUT/pm_out
add wave -noupdate -radix unsigned /acs_tb/DUT/d_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {161 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1 ns}
