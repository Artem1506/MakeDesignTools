rollout dlg_load_textures "" width:346 height:512
(
    label 'lbl_00' "Material ID: " width:80 height:18 align:#left offset:[2, 12] across:2
    dropdownlist 'lst_mat_id' "" items:#() width:60 height:10 align:#left offset:[-96, 11] selection:1
    button 'btn_update' "Update" width:100 height:CTRL_HEIGHT_1 align:#right pos:[(dlg_load_textures.width - 120), 16]

    spinner 'spn_chnl' "Map Channel: " fieldwidth:42 type:#integer range:[1, 10, 1] height:24 align:#left offset:[2, 2] enabled:false
    spinner 'spn_tile' "Tiling: " fieldwidth:42 type:#float range:[-10000.0, 10000.0, 1.0] height:24 align:#left offset:[40, -6] enabled:false

    groupBox 'grp_01' " Basic Maps: " width:(dlg_load_textures.width - 10) height:108 align:#center offset:[0, 2]
        checkbutton 'chbtn_d' "Color" width:56 height:CTRL_HEIGHT_1 align:#left offset:[8, -92] across:4
        checkbutton 'chbtn_o' "O" width:27 height:CTRL_HEIGHT_1 align:#left offset:[-15, -92]
        button 'btn_d' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[-5, -92]
        button 'btn_d_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[19, -92]
        
        checkbutton 'chbtn_s' "S" width:27 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:5
        checkbutton 'chbtn_r' "R" width:28 height:CTRL_HEIGHT_1 align:#left offset:[-28, 0]
        checkbutton 'chbtn_m' "M" width:27 height:CTRL_HEIGHT_1 align:#left offset:[-63, 0]
        button 'btn_srm' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[-29, 0]
        button 'btn_srm_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[11, 0]

        checkbutton 'chbtn_n' "Normal" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
        button 'btn_n' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[36, 0]
        button 'btn_n_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[34, 0]

    groupBox 'grp_02' " Basic Tiled Maps: " width:(dlg_load_textures.width - 10) height:108 align:#center offset:[0, 10]
        checkbutton 'chbtn_d_t' "Color" width:56 height:CTRL_HEIGHT_1 align:#left offset:[8, -92] across:4
        checkbutton 'chbtn_o_t' "O" width:27 height:CTRL_HEIGHT_1 align:#left offset:[-15, -92]
        button 'btn_d_t' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[-5, -92]
        button 'btn_d_t_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[19, -92]

        checkbutton 'chbtn_s_t' "S" width:27 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:5
        checkbutton 'chbtn_r_t' "R" width:28 height:CTRL_HEIGHT_1 align:#left offset:[-28, 0]
        checkbutton 'chbtn_m_t' "M" width:27 height:CTRL_HEIGHT_1 align:#left offset:[-63, 0]
        button 'btn_srm_t' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[-29, 0]
        button 'btn_srm_t_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[11, 0]

        checkbutton 'chbtn_01_n_t' "Normal" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
        button 'btn_n_t' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[36, 0]
        button 'btn_n_t_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[34, 0]

    groupBox 'grp_03' " Additional Maps: " width:(dlg_load_textures.width - 10) height:134 align:#center offset:[0, 10]
        checkbutton 'chbtn_e' "Emission" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, -118] across:3
        button 'btn_e' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[36, -118]
        button 'btn_e_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[34, -118]

        checkbutton 'chbtn_mx' "Mixing" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
        button 'btn_mx' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[36, 0]
        button 'btn_mx_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[34, 0]

        checkbutton 'chbtn_sss' "SSS" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
        button 'btn_sss' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[36, 0]
        button 'btn_sss_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[34, 0]

        checkbutton 'chbtn_dp' "Displace" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
        button 'btn_dp' EMPTY_TEXT width:(dlg_load_textures.width - 170) height:CTRL_HEIGHT_1 align:#center offset:[36, 0]
        button 'btn_dp_del' "X" width:24 height:CTRL_HEIGHT_1 align:#center offset:[34, 0]
    
    button 'btn_load' "Assign Maps" width:(dlg_load_textures.width - 42) height:CTRL_HEIGHT_2 align:#center offset:[0, 16] enabled:false

    -- local controls_arr = #(#(btn_d, ckbx_d), #(btn_srm, ckbx_srm), #(btn_n, ckbx_n), #(btn_d_t, ckbx_d_t), #(btn_srm_t, ckbx_srm_t), #(btn_n_t, ckbx_n_t), #(btn_e, ckbx_e), #(btn_m, ckbx_m), #(btn_sss, ckbx_sss))
    local textures = #(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)
    local source_files = #(undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined, undefined)

    fn SwitchStates current_ctrl state =
    (
        if state then 
        (
            for ctrl in dlg_load_textures.Controls where (classOf ctrl == CheckButtonControl and ctrl != current_ctrl) do ctrl.checked = false
        )
        spn_chnl.enabled = state
        spn_tile.enabled = state
    )
/*
    fn ChangeMaterial =
    (
        -- MatLib = materialLibrary()
        if textures[1] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[1]
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].diffuseMap = bm
            showproperties MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex]
            -- bm.rgbOutput - Alpha
            -- bm.coords.mapChannel
            bm.reload()
        )
        else MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].diffuseMap = undefined

        if textures[2] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[2]
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].specularMap = bm
            bm.reload()
        )
        else MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].specularMap = undefined

        if textures[3] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[3]
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].bumpMap = bm
            bm.reload()
        )
        else MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].bumpMap = undefined

        if textures[4] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[4]
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].glossinessMap = bm
            bm.reload()
        )
        else MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].glossinessMap = undefined

        if textures[5] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[5]
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].selfillumMap = bm
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].selfillumMapEnable = off
            bm.reload()
        )
        else MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].selfillumMap = undefined

        if textures[6] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[6]
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].opacityMap = bm
            MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].opacityMapEnable = off
            bm.reload()
        )
        else MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat.materialList[MD_Data.ActiveTaskAddIndex].opacityMap = undefined

        -- append MatLib MD_Data.InWorkTask.MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat
        MD_Data.InWorkTask.MatLib[1] = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat
        saveTempMaterialLibrary MD_Data.InWorkTask.MatLib MD_Data.InWorkTask.MatLibFile
        MD_Data.InWorkTask.MatLib = loadTempMaterialLibrary MD_Data.InWorkTask.MatLibFile
        MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat = MD_Data.InWorkTask.MatLib[1]
        UpdateSceneMaterialLib()
        actionMan.executeAction 0 "63545" -- Views: Viewport Materials Display as Shaded with Maps

        if MD_Data.InWorkTask != undefined then
        (
            if MD_Data.InWorkTask.Group == undefined then MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Article
            else MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Group

            for obj in MD_Data.WorkLayerNodes do
            (
                try(
                    if obj == MD_Data.InWorkTask.MainMesh or obj == MD_Data.InWorkTask.AddMesh then
                    MD_Data.AssignMaterial obj MD_Data.InWorkTask.ActiveMatIndex
                )catch()
            )
        )
    )

    fn GetCheckedItems =
    (
        local checked_items = #()

        for i = 1 to controls_arr.count where controls_arr[i][2].checked == true do append checked_items controls_arr[i][2]

        return checked_items
    )

    fn InitExistTextures =
    (
        if MD_Data.ActiveTaskAddIndex == undefined then dlg_load_textures.title = ("Assign Textures")
        else 
        (
            dlg_load_textures.title = ("Assign Textures to Material-" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].MatIndex)

            btn_clear.enabled = false
            btn_assign.enabled = false

            for i = 1 to controls_arr.count do
            (
                local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.InWorkTask.File)
                local text_name = "T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + TEXTURES_SIFFIXES[i]
                local lib_tex_file = (pathConfig.appendPath task_dir text_name)

                if DoesFileExist lib_tex_file then
                (
                    controls_arr[i][1].text = text_name
                    controls_arr[i][2].checked = false
                    controls_arr[i][2].enabled = true
                    textures[i] = lib_tex_file
                    btn_clear.enabled = false
                    btn_assign.enabled = false
                )
                else
                (
                    controls_arr[i][1].text = EMPTY_TEXT
                    controls_arr[i][2].checked = false
                    controls_arr[i][2].enabled = false
                    textures[i] = undefined
                )
            )
        )
        SetFocus dlg_load_textures 
    )

    fn OpenFile btn lbl def_text =
    (
        -- Вызов диалогового окна для выбора директории локальной базы
        local file = getOpenFileName caption:"Set Texture File ..." types:"Targa (*.tga)|*.tga|"
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.InWorkTask.File)
        local suffix = ""
        local text_name = ""
        btn_clear.enabled = false
        btn_assign.enabled = false
        
        if file != undefined then 
        (
            case def_text of
            (
                "Diffuse":(suffix = TEXTURES_SIFFIXES[1]; textures[1] = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[1] = file)
                "Mixing":(suffix = TEXTURES_SIFFIXES[2]; textures[2] = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[2] = file)
                "Normal":(suffix = TEXTURES_SIFFIXES[3]; textures[3] = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[3] = file)
                "SRM":(suffix = TEXTURES_SIFFIXES[4]; textures[4] = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[4] = file)
                "Emissive":(suffix = TEXTURES_SIFFIXES[5]; textures[5] = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[5] = file)
                "SSS":(suffix = TEXTURES_SIFFIXES[6]; textures[6] = (pathConfig.appendPath task_dir ("T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[6] = file)
            )

            text_name = "T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix

            btn.text = text_name
            lbl.checked = true
            lbl.enabled = true
            btn_clear.enabled = true
            btn_assign.enabled = true
        )
        -- else 
        -- (
        --     btn.text = EMPTY_TEXT
        --     lbl.checked = false
        --     lbl.enabled = false
        -- )
    )

    fn CopyTextsToLib = 
    (
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.InWorkTask.File)

        for i = 1 to controls_arr.count where controls_arr[i][2].checked do
        (
            try (dosCommand ("copy " + source_files[i] + " " + textures[i] + " /Y /Z"))catch()                
        )
    )
*/

	on dlg_load_textures open do
    (
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos")
            SetDialogPos dlg_load_textures dialog_pos
        )catch()

        -- Получить количество id материала
        local mat = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat
        local mat_ids = for i = 1 to mat.materialList.count collect i as string

        -- Задать список id материала
        lst_mat_id.items = mat_ids

        -- Инициализация имеющихся текстур в материале
        -- InitExistTextures()
    )

    on dlg_load_textures close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos" ((GetDialogPos dlg_load_textures) as string)
    )

/*
    on ckbx_d changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_clear.enabled = false; btn_assign.enabled = false)
        else (btn_clear.enabled = true; btn_assign.enabled = true)
    )

    on ckbx_m changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_clear.enabled = false; btn_assign.enabled = false)
        else (btn_clear.enabled = true; btn_assign.enabled = true)
    )

    on ckbx_n changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_clear.enabled = false; btn_assign.enabled = false)
        else (btn_clear.enabled = true; btn_assign.enabled = true)
    )

    on ckbx_srm changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_clear.enabled = false; btn_assign.enabled = false)
        else (btn_clear.enabled = true; btn_assign.enabled = true)
    )

    on ckbx_e changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_clear.enabled = false; btn_assign.enabled = false)
        else (btn_clear.enabled = true; btn_assign.enabled = true)
    )

    on ckbx_sss changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_clear.enabled = false; btn_assign.enabled = false)
        else (btn_clear.enabled = true; btn_assign.enabled = true)
    )

    on btn_d pressed do OpenFile btn_d ckbx_d "Diffuse"

    on btn_m pressed do OpenFile btn_m ckbx_m "Mixing"

    on btn_n pressed do OpenFile btn_n ckbx_n "Normal"

    on btn_srm pressed do OpenFile btn_srm ckbx_srm "SRM"

    on btn_e pressed do OpenFile btn_e ckbx_e "Emissive"

    on btn_sss pressed do OpenFile btn_sss ckbx_sss "SSS"

    on btn_assign pressed do
    (
        CopyTextsToLib()
        ChangeMaterial()
        MD_Data.InWorkTask.Update()
        MD_UI.FillAddList()
        CompleteRedraw()
    )

    on btn_clear pressed do
    (
        if (queryBox "Действительно удалить отмеченные текстуры из локальной базы?\n" title:"Внимание!" icon:#question) then
        (
            for i = 1 to controls_arr.count do
            (
                if controls_arr[i][2].checked then 
                (
                    dosCommand ("del + " + textures[i] + " /F")
                )
            )
            InitExistTextures()
            ChangeMaterial()
            MD_Data.InWorkTask.Update()
            MD_UI.FillAddList()
            CompleteRedraw()
        )
    )
*/
    on chbtn_d changed state do
    (
        SwitchStates chbtn_d state

        setFocus dlg_load_textures
    )

    on chbtn_o changed state do
    (
        SwitchStates chbtn_o state
        setFocus dlg_load_textures
    )

    on chbtn_s changed state do
    (
        SwitchStates chbtn_s state
        setFocus dlg_load_textures
    )

    on chbtn_r changed state do
    (
        SwitchStates chbtn_r state
        setFocus dlg_load_textures
    )

    on chbtn_m changed state do
    (
        SwitchStates chbtn_m state
        setFocus dlg_load_textures
    )

    on chbtn_n changed state do
    (
        SwitchStates chbtn_n state
        setFocus dlg_load_textures
    )

    on chbtn_e changed state do
    (
        SwitchStates chbtn_e state
        setFocus dlg_load_textures
    )

    on chbtn_mx changed state do
    (
        SwitchStates chbtn_mx state
        setFocus dlg_load_textures
    )

    on chbtn_sss changed state do
    (
        SwitchStates chbtn_sss state
        setFocus dlg_load_textures
    )

    on chbtn_d_t changed state do
    (
        SwitchStates chbtn_d_t state
        setFocus dlg_load_textures
    )

    on chbtn_o_t changed state do
    (
        SwitchStates chbtn_o_t state
        setFocus dlg_load_textures
    )

    on chbtn_s_t changed state do
    (
        SwitchStates chbtn_s_t state
        setFocus dlg_load_textures
    )

    on chbtn_r_t changed state do
    (
        SwitchStates chbtn_r_t state
        setFocus dlg_load_textures
    )

    on chbtn_m_t changed state do
    (
        SwitchStates chbtn_m_t state
        setFocus dlg_load_textures
    )

    on chbtn_01_n_t changed state do
    (
        SwitchStates chbtn_01_n_t state
        setFocus dlg_load_textures
    )

    on chbtn_dp changed state do
    (
        SwitchStates chbtn_dp state
        setFocus dlg_load_textures
    )
)
/*
-- Texture shading view
actionMan.executeAction 0 "63545" -- Views: Viewport Materials Display as Shaded with Maps
actionMan.executeAction 0 "554"  -- Views: Viewport Visual Style Consistent Colors

-- Default shading view
actionMan.executeAction 0 "63544"  -- Views: Viewport Materials Display as Shaded
actionMan.executeAction 0 "63566"  -- Views: Default Shading

-- Show material textures
showTextureMap mat true

-- Show SRM
    
    local rgb_tint_map = RGB_Tint map1:mat.glossinessMap red:(color 0 0 0) green:(color 0 0 0) blue:(color 0 0 0)
    local cur_dif_map = mat.diffuseMap

    -- Swap diffuse and glossiness maps
    mat.diffuseMap = rgb_tint_map

    -- Show Specular
    rgb_tint_map.red = color 255 255 255
    rgb_tint_map.green = color 0 0 0
    rgb_tint_map.blue = color 0 0 0

    -- Show Roughness
    rgb_tint_map.red = color 0 0 0
    rgb_tint_map.green = color 255 255 255
    rgb_tint_map.blue = color 0 0 0

    -- Show Metallic
    rgb_tint_map.red = color 0 0 0
    rgb_tint_map.green = color 0 0 0
    rgb_tint_map.blue = color 255 255 255

    -- Return diffuse
    mat.diffuseMap = cur_dif_map

-- Show diffuse
showTextureMap mat mat.diffuseMap true

-- Show opacity on
showTextureMap mat mat.diffuseMap true
mat.diffuseMap.rgbOutput = 1
mat.diffuseMap.alphaSource = 0

-- Show opacity off
showTextureMap mat mat.diffuseMap true
mat.diffuseMap.rgbOutput = 0
mat.diffuseMap.alphaSource = 2

-- Show normal map
showTextureMap mat mat.bumpMap true

-- Show emission map
showTextureMap mat mat.selfillumMap true

redrawViews()
*/