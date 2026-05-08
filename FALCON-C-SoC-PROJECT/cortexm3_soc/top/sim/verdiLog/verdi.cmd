wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 \
           {/remote/vgvips1/globaluser/akashs/FALCON-C-SoC-PROJECT/cortexm3_soc/top/sim/test_top.fsdb}
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSelectGroup -win $_nWave2 {G1}
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_\$novas_unit__1"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_if"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/uinf_master"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/cortexm3_soc_i0"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf"
wvSetPosition -win $_nWave2 {("G1" 14)}
wvSetPosition -win $_nWave2 {("G1" 14)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWRITE} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 11 12 13 14 )} 
wvSetPosition -win $_nWave2 {("G1" 14)}
wvGetSignalClose -win $_nWave2
wvGoToGroup -win $_nWave2 "G2"
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/_\$novas_unit__1"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]"
wvGetSignalSetScope -win $_nWave2 \
           "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/ahb_mas_mon_cb"
wvGetSignalSetScope -win $_nWave2 \
           "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/ahb_mas_mon_cb"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]"
wvSetPosition -win $_nWave2 {("G1" 28)}
wvSetPosition -win $_nWave2 {("G1" 28)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWRITE} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 15 16 17 18 19 20 21 22 23 24 25 26 27 28 \
           )} 
wvSetPosition -win $_nWave2 {("G1" 28)}
wvSetCursor -win $_nWave2 975.850381 -snap {("G1" 14)}
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]"
wvGetSignalSetScope -win $_nWave2 \
           "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/ahb_mas_drv_cb"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[2\]"
wvGetSignalSetScope -win $_nWave2 "/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]"
wvSetPosition -win $_nWave2 {("G1" 42)}
wvSetPosition -win $_nWave2 {("G1" 42)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HWRITE} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 29 30 31 32 33 34 35 36 37 38 39 40 41 42 \
           )} 
wvSetPosition -win $_nWave2 {("G1" 42)}
wvSetPosition -win $_nWave2 {("G1" 42)}
wvSetPosition -win $_nWave2 {("G1" 42)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HWRITE} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 29 30 31 32 33 34 35 36 37 38 39 40 41 42 \
           )} 
wvSetPosition -win $_nWave2 {("G1" 42)}
wvSetPosition -win $_nWave2 {("G1" 42)}
wvSetPosition -win $_nWave2 {("G1" 42)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[0\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[1\]/HWRITE} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HADDR\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HBURST\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HMASTER\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HMASTLOCK} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HNONSEC} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HPROT\[3:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HRDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HREADY} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HRESP\[0:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HSEL} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HSIZE\[2:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HTRANS\[1:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HWDATA\[31:0\]} \
{/cortexm3_soc_tb/sram_ahb_inf/mas_if\[3\]/HWRITE} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 29 30 31 32 33 34 35 36 37 38 39 40 41 42 \
           )} 
wvSetPosition -win $_nWave2 {("G1" 42)}
wvGetSignalClose -win $_nWave2
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvScrollDown -win $_nWave2 0
wvSetWindowTimeUnit -win $_nWave2 1.000000 s
debExit
