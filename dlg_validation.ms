
rollout dlg_validation "Validation" width:300  height:170
(
    label 'lbl_one_mesh' "1 - Number of objects on the working layer" width:210 align:#left offset:[6, 10] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_one_mesh_txt' "System.Windows.Forms.Label" text:"X" width:24 offset:[-4, 10] align:#right
    label 'lbl_epoly' "2 - Object type is Geometry" width:160 align:#left offset:[6, 2] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_epoly_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_bounds' "3 - Bounds and position" width:160 align:#left offset:[6, 2] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_bounds_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_mat' "4 - Has material" width:160 align:#left offset:[6, 2] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_mat_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2] 
    label 'lbl_cor_mat' "5 - Correct material" width:160 align:#left offset:[6, 2] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_cor_mat_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_mat_id' "6 - Mat IDs num = parts num" width:190 align:#left offset:[6, 2] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_mat_id_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_uvs' "7 - Number of UV channels = 2" width:160 align:#left offset:[6, 2] across:2 tooltip:"Tooltip"
        dotnetcontrol 'lbl_uvs_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]

    on dlg_validation open do
    (
        for i = 2 to dlg_validation.controls.count by 2 do
        (
            dlg_validation.controls[i].BackColor = dn_max_ui_bg_color
            dlg_validation.controls[i].ForeColor = DN_CLR_X
            dlg_validation.controls[i].font = DN_LIB.Font 5 10 3 
            dlg_validation.controls[i].TextAlign = DN_LIB.MiddleCenter      
        )
    )

    on dlg_validation close do
    (

    )
)