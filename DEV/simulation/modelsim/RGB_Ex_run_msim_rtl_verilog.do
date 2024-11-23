transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/Project/Quartus/T-core/project/RGB_Ex/RTL {E:/Project/Quartus/T-core/project/RGB_Ex/RTL/TimePlues.v}
vlog -vlog01compat -work work +incdir+E:/Project/Quartus/T-core/project/RGB_Ex/RTL {E:/Project/Quartus/T-core/project/RGB_Ex/RTL/RGB_Ex_Top.v}
vlog -vlog01compat -work work +incdir+E:/Project/Quartus/T-core/project/RGB_Ex/RTL {E:/Project/Quartus/T-core/project/RGB_Ex/RTL/RGB_Data_tram.v}
vlog -vlog01compat -work work +incdir+E:/Project/Quartus/T-core/project/RGB_Ex/RTL {E:/Project/Quartus/T-core/project/RGB_Ex/RTL/Divider_Clock.v}
vlog -vlog01compat -work work +incdir+E:/Project/Quartus/T-core/project/RGB_Ex/IP {E:/Project/Quartus/T-core/project/RGB_Ex/IP/Pll_40MHz.v}
vlog -vlog01compat -work work +incdir+E:/Project/Quartus/T-core/project/RGB_Ex/DEV/db {E:/Project/Quartus/T-core/project/RGB_Ex/DEV/db/pll_40mhz_altpll.v}
vlib Dual_Config
vmap Dual_Config Dual_Config
vlog -vlog01compat -work Dual_Config +incdir+e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config {e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/dual_config.v}
vlog -vlog01compat -work Dual_Config +incdir+e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/submodules {e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/submodules/altera_dual_boot.v}
vlog -vlog01compat -work Dual_Config +incdir+e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/submodules {e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/submodules/altera_reset_controller.v}
vlog -vlog01compat -work Dual_Config +incdir+e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/submodules {e:/project/quartus/t-core/project/rgb_ex/dev/db/ip/dual_config/submodules/altera_reset_synchronizer.v}

