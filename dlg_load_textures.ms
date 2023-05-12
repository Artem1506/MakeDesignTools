rollout dlg_load_textures ("Load Textures " + "[" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Material + "]") width:300 height:250
(
	button 'btn_d' "Diffuse" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 24] across:2
		dotnetcontrol 'lbl_d' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 28] align:#right
	button 'btn_m' "Metallic" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 0] across:2
		dotnetcontrol 'lbl_m' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 4] align:#right
	button 'btn_n' "Normal" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 0] across:2
		dotnetcontrol 'lbl_n' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 4] align:#right
	button 'btn_ard' "ARD (AO, Roughness, Displacement)" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 0] across:2
		dotnetcontrol 'lbl_ard' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 4] align:#right
	
	button 'btn_auto_load' "Package Load" width:(dlg_load_textures.width/2 - 20) height:CTRL_HEIGHT_1 align:#center offset:[1, 26] across:2 
    button 'btn_rename' "Rename" width:(dlg_load_textures.width/2 - 20) height:CTRL_HEIGHT_1 align:#center offset:[-1, 26] enabled:false
	
	groupBox 'grp_01' " Textures: " width:(dlg_load_textures.width - 20) height:134 align:#center offset:[0, -180]
	groupBox 'grp_02' " Tools: " width:(dlg_load_textures.width - 20) height:50 align:#center offset:[0, -2]
	
	button 'btn_load' "Add Textures To Material" width:(dlg_load_textures.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 2] enabled:false

	on dlg_load_textures open do
    (
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos")
            SetDialogPos dlg_load_textures dialog_pos
        )catch()

        -- Инициализация элементов "OK/X"
        for i = 2 to 8 by 2 do
        (
            dlg_load_textures.controls[i].BackColor = DN_MAX_UI_CLR
            dlg_load_textures.controls[i].ForeColor = DN_CLR_X
            dlg_load_textures.controls[i].font = DN_LIB.Font 5 10 3 
            dlg_load_textures.controls[i].TextAlign = DN_LIB.MiddleCenter      
        )
        MD_Callbacks.Add()
    )

    on dlg_load_textures close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos" ((GetDialogPos dlg_load_textures) as string)
    )
)