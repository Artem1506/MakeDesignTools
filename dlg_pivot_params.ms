
rollout dlg_pivot_params "Pivot settings"
(
    label 'lbl_x' "X" width:20 height:20 align:#left offset:[46, 8] across:3
    label 'lbl_y' "Y" width:20 height:20 align:#center offset:[6, 8]
    label 'lbl_z' "Z" width:20 height:20 align:#right offset:[-36, 8]

    dropdownlist 'lst_x' "" items:PIVOT_POS_X width:100 height:20 align:#left offset:[0, -6] selection:2 across:3
    dropdownlist 'lst_y' "" items:PIVOT_POS_Y width:100 height:20 align:#center offset:[0, -6] selection:2
    dropdownlist 'lst_z' "" items:PIVOT_POS_Z width:100 height:20 align:#right offset:[0, -6] selection:1
    
    button 'btn_ok' "OK" width:100 height:24 align:#center offset:[0, 4]

    on dlg_pivot_params close do
    (

    )

    on btn_ok pressed do
    (

    )

    on lst_x selected arg do 
    (

    )

    on lst_y selected arg do 
    (

    )

    on lst_z selected arg do
    (

    )
)