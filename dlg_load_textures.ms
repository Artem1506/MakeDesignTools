rollout dlg_load_textures ("Load Textures " + "[" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Material + "]") width:350 height:250
(
	button 'btn_d' "Diffuse" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 24] across:2
		dotnetcontrol 'lbl_d' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 28] align:#right
	button 'btn_m' "Metallic" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 0] across:2
		dotnetcontrol 'lbl_m' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 4] align:#right
	button 'btn_n' "Normal" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 0] across:2
		dotnetcontrol 'lbl_n' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 4] align:#right
	button 'btn_ard' "ARD" width:(dlg_load_textures.width - 58) height:CTRL_HEIGHT_1 align:#left offset:[4, 0] across:2
		dotnetcontrol 'lbl_ard' "System.Windows.Forms.Label" text:"X" width:20 offset:[-3, 4] align:#right
	
	button 'btn_auto_load' "Package Load" width:(dlg_load_textures.width/2 - 20) height:CTRL_HEIGHT_1 align:#center offset:[1, 26] across:2 
    button 'btn_rename' "Rename" width:(dlg_load_textures.width/2 - 20) height:CTRL_HEIGHT_1 align:#center offset:[-1, 26] enabled:false
	
	groupBox 'grp_01' " Textures: " width:(dlg_load_textures.width - 20) height:134 align:#center offset:[0, -180]
	groupBox 'grp_02' " Tools: " width:(dlg_load_textures.width - 20) height:50 align:#center offset:[0, -2]
	
	button 'btn_load' "Add Textures To Material" width:(dlg_load_textures.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 2] enabled:false
    
    local suf_arr = #("_D.tga", "_M.tga", "_N.tga", "_ARD.tga")
    local controls_arr = #(#(btn_d, lbl_d), #(btn_m, lbl_m), #(btn_n, lbl_n), #(btn_ard, lbl_ard))
    local textures = #(undefined, undefined, undefined, undefined)

    fn InitExistTextures =
    (
        for i = 1 to 4 do
        (
            local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.InWorkTask.File)
            local text_name = "T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suf_arr[i]
            local lib_tex_file = (pathConfig.appendPath task_dir text_name)

            if DoesFileExist lib_tex_file then
            (
                controls_arr[i][1].text = text_name
                controls_arr[i][2].text = "OK"
                controls_arr[i][2].ForeColor = DN_CLR_OK
                textures[i] = lib_tex_file
            )
        )
    )

    fn OpenFile btn lbl def_text =
    (
        -- Вызов диалогового окна для выбора директории локальной базы
        local file = getOpenFileName caption:"Set Texture File ..." types:"Targa (*.tga)|*.tga|"
        local suffix = ""
        local text_name = ""

        if file != undefined then 
        (
            case def_text of
            (
                "Diffuse":(suffix = suf_arr[1]; textures[1] = file)
                "Metallic":(suffix = suf_arr[2]; textures[2] = file)
                "Normal":(suffix = suf_arr[3]; textures[2] = file)
                "ARD":(suffix = suf_arr[4]; textures[4] = file)
            )

            text_name = "T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix

            btn.text = text_name
            lbl.text = "OK"
            lbl.ForeColor = DN_CLR_OK
        )
        else 
        (
            btn.text = def_text
            lbl.text = "X"
            lbl.ForeColor = DN_CLR_X
        )
    )

    fn CopyTextsToLib = 
    (
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.InWorkTask.File)

        for i = 1 to 4 do
        (
            try (
                local lib_tex_file = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suf_arr[i]))
                -- Скопировать папку с заданием в корзину
				dosCommand ("xcopy " + textures[i] + " " + lib_tex_file + " /S /E /I /Y /R /C")
                -- copyFile textures[i] lib_tex_file
                print textures[i]
            )catch()
        )
    )

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

        InitExistTextures()
    )

    on dlg_load_textures close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos" ((GetDialogPos dlg_load_textures) as string)
    )

    on btn_d pressed do 
    (
        OpenFile btn_d lbl_d "Diffuse"
        CopyTextsToLib()
    )
)