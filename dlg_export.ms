
rollout dlg_export "Validation And Export" width:210  height:230
(
    label 'lbl_one_mesh' "1 - Objects Count" width:160 align:#left offset:[8, 24] across:2 tooltip:MD_Tooltips.val_exp_01
        dotnetcontrol 'lbl_one_mesh_txt' "System.Windows.Forms.Label" text:"X" width:24 offset:[-4, 24] align:#right
    label 'lbl_epoly' "2 - Object(s) Type" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_02
        dotnetcontrol 'lbl_epoly_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_bounds' "3 - Bounds And Position" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_03
        dotnetcontrol 'lbl_bounds_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_cor_mat' "4 - Material" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_04
        dotnetcontrol 'lbl_cor_mat_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_mat_id' "5 - Material IDs Count" width:190 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_05
        dotnetcontrol 'lbl_mat_id_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_uvs' "6 - UVs" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_06
        dotnetcontrol 'lbl_uvs_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]
    label 'lbl_icon' "7 - Icon" width:160 align:#left offset:[8, 2] across:2 tooltip:MD_Tooltips.val_exp_06
        dotnetcontrol 'lbl_icon_txt' "System.Windows.Forms.Label" text:"X" width:24 align:#right offset:[-4, 2]

    groupBox 'grp_01' " Validation " width:(dlg_export.width - 20) height:174 align:#center offset:[0, -166]
    button 'btn_export' "EXPORT" width:(dlg_export.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 0] enabled:false

    timer 'clock' "Clock" interval:250
    
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
        for i = 2 to 14 by 2 do
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
        destroyDialog dlg_export
        if MD_Data.InWorkTask.Group == undefined then MD_Data.ExportTask()
        else(
            local cur_active_task = MD_Data.ActiveTask

            for t in MD_Data.Tasks where t.group == MD_Data.InWorkTask.Group do
            (
                MD_Data.ActiveTask = t
                MD_Data.ExportTask()
            )
            
            MD_Data.ActiveTask = cur_active_task
        )

        -- Рендер иконки
        if MD_Data.ActiveCategoryIcon.Icon != undefined then
        (
            local frame_size = MAX_TEX_SIZE / 16
            local max_size = amax #(MD_Data.InWorkTask.Size[1], MD_Data.InWorkTask.Size[2])
            local icon_out_file = "T_" + MD_Data.InWorkTask.Article + TEXTURES_SIFFIXES[7]

            if max_size >= (ConvertCentimeterToSysUnits 200.0) then frame_size = MAX_TEX_SIZE / 2
            else if max_size >= (ConvertCentimeterToSysUnits 100.0) then frame_size = MAX_TEX_SIZE / 4
            else if max_size >= (ConvertCentimeterToSysUnits 50.0) then frame_size = MAX_TEX_SIZE / 8

            icon_out_file = pathconfig.appendpath (pathconfig.removePathLeaf MD_Data.InWorkTask.InWorkDir) icon_out_file
            try (
                MD_Data.ActiveCategoryIcon.IconRender MD_Data.ActiveCategoryIcon.Icon frame_size:frame_size out_file:icon_out_file
            )catch()            
        )
    )
)