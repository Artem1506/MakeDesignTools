
rollout dlg_export "Validation And Export" width:300  height:210
(
    label 'lbl_one_mesh' "1 - Objects Count" width:210 align:#left offset:[6, 24] across:2 tooltip:MD_Tooltips.val_exp_01
        dotnetcontrol 'lbl_one_mesh_txt' "System.Windows.Forms.Label" text:"X" width:24 offset:[-4, 24] align:#right
    label 'lbl_epoly' "2 - Object(s) Type" width:160 align:#left offset:[6, 2] across:2 tooltip:MD_Tooltips.val_exp_02
        dotnetcontrol 'lbl_epoly_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_bounds' "3 - Bounds And Position" width:160 align:#left offset:[6, 2] across:2 tooltip:MD_Tooltips.val_exp_03
        dotnetcontrol 'lbl_bounds_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_cor_mat' "4 - Correct Material" width:160 align:#left offset:[6, 2] across:2 tooltip:MD_Tooltips.val_exp_04
        dotnetcontrol 'lbl_cor_mat_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_mat_id' "5 - Material IDs Count" width:190 align:#left offset:[6, 2] across:2 tooltip:MD_Tooltips.val_exp_05
        dotnetcontrol 'lbl_mat_id_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_uvs' "6 - UV Channels Count" width:160 align:#left offset:[6, 2] across:2 tooltip:MD_Tooltips.val_exp_06
        dotnetcontrol 'lbl_uvs_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]

    groupBox 'grp_01' " Validation " pos:[8,8] width:284 height:152 align:#center
    button 'btn_export' "EXPORT" width:284 height:CTRL_HEIGHT_2 align:#center offset:[0, 4] enabled:false

    timer 'clock' "Clock" interval:500
    
    on clock tick do
    (
        local val_result = MD_Data.validation()

        --Переключение состояния кнопки "EXPORT"
		if val_result[1] then btn_export.enabled = true
		else btn_export.enabled = false
    )

    on dlg_export open do
    (
        -- Инициализация элементов "OK/X"
        for i = 2 to 12 by 2 do
        (
            dlg_export.controls[i].BackColor = DN_MAX_UI_CLR
            dlg_export.controls[i].ForeColor = DN_CLR_X
            dlg_export.controls[i].font = DN_LIB.Font 5 10 3 
            dlg_export.controls[i].TextAlign = DN_LIB.MiddleCenter      
        )
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_export.name "pos")
            SetDialogPos dlg_export dialog_pos
        )catch()

        MD_Callbacks.Add()
    )

    on dlg_export close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_export.name "pos" ((GetDialogPos dlg_export) as string)
    )

    on btn_export pressed do
    (
        -- Экспорт валидного задания
        MD_Data.ExportTask()
        destroyDialog dlg_export
    )
)