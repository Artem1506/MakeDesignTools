rollout dlg_load_textures "" width:400 height:310
(
    label 'lbl_00' "Material ID: " width:80 height:18 align:#left offset:[0, 10] across:2
    dropdownlist 'lst_mat_id' "" items:#() width:100 height:10 offset:[-126, 7] align:#left selection:1
    -- dropdownlist 'lst_pac_type' "Packaging Type: " items:PACK_TEXTS_TYPES width:100 height:50 offset:[0, 8] align:#left selection:1

groupBox 'grp_01' " Basic Textures: " width:(dlg_load_textures.width - 10) height:108 align:#center offset:[0, 2]
	-- groupBox 'grp_02' " Tools: " width:(dlg_load_textures.width - 170) height:70 align:#left offset:[-3, -2]

    -- label 'lbl_01' "Diffuse:" width:70 height:18 align:#left offset:[8, -166] across:3
    checkbutton 'lbl_01' "Color" width:56 height:CTRL_HEIGHT_1 align:#left offset:[8, -92] across:4
    checkbutton 'lbl_01o' "O" width:27 height:CTRL_HEIGHT_1 align:#center offset:[-61, -92]
	button 'btn_d' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[-12, -92]
        checkbox 'ckbx_d' "" width:20 offset:[-3, -88] align:#right checked:false enabled:false

    -- label 'lbl_04' "SRM:" width:70 height:18 align:#left offset:[20, 4] across:3
    -- checkbutton 'lbl_04' "SRM" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
	-- button 'btn_ard' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[34, 0]
    --     checkbox 'ckbx_ard' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false

    checkbutton 'lbl_04s' "S" width:27 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:5
    checkbutton 'lbl_04r' "R" width:28 height:CTRL_HEIGHT_1 align:#center offset:[-61, 0]
    checkbutton 'lbl_04m' "M" width:27 height:CTRL_HEIGHT_1 align:#center offset:[-107, 0]
	button 'btn_ard' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[-39, 0]
        checkbox 'ckbx_ard' "" width:20 offset:[-1, 4] align:#right checked:false enabled:false

    -- label 'lbl_03' "Normal:" width:70 height:18 align:#left offset:[9, 4] across:3
    checkbutton 'lbl_03' "Normal" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
	button 'btn_n' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[34, 0]
        checkbox 'ckbx_n' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false

groupBox 'grp_02' " Masks: " width:(dlg_load_textures.width - 10) height:108 align:#center offset:[0, 10]

    -- label 'lbl_05' "Emission:" width:70 height:18 align:#left offset:[1, 4] across:3
    checkbutton 'lbl_05' "Emission" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, -92] across:3
	button 'btn_e' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[34, -92]
        checkbox 'ckbx_e' "" width:20 offset:[-3, -88] align:#right checked:false enabled:false

    -- label 'lbl_02' "Metallic:" width:70 height:18 align:#left offset:[7, 4] across:3
    checkbutton 'lbl_02' "Mixing" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
	button 'btn_m' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[34, 0]
        checkbox 'ckbx_m' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false

    -- label 'lbl_06' "SSS:" width:70 height:18 align:#left offset:[22, 4] across:3
    checkbutton 'lbl_06' "SSS" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
	button 'btn_sss' EMPTY_TEXT width:(dlg_load_textures.width - 152) height:CTRL_HEIGHT_1 align:#center offset:[34, 0]
        checkbox 'ckbx_sss' "" width:20 offset:[-3, 4] align:#right checked:false enabled:false
	
	-- button 'btn_auto_load' "Package Load" width:((dlg_load_textures.width - 13)/2) height:CTRL_HEIGHT_1 align:#center offset:[-5, 10] across:2 enabled:false
    
	button 'btn_load' "Add Textures To Material" width:(dlg_load_textures.width - 118) height:CTRL_HEIGHT_2 align:#left offset:[-8, 14] enabled:false across:2
    button 'btn_delete' "Clear" width:104 height:CTRL_HEIGHT_2 align:#center offset:[50, 14] enabled:false

    local controls_arr = #(#(btn_d, ckbx_d), #(btn_m, ckbx_m), #(btn_n, ckbx_n), #(btn_ard, ckbx_ard), #(btn_e, ckbx_e), #(btn_sss, ckbx_sss))
    local textures = #(undefined, undefined, undefined, undefined, undefined, undefined)
    local source_files = #(undefined, undefined, undefined, undefined, undefined, undefined)

    fn SwitchStates current_ctrl =
    (
        for ctrl in dlg_load_textures.Controls where (classOf ctrl == CheckButtonControl and ctrl != current_ctrl) do ctrl.checked = false
    )

    fn ChangeMaterial =
    (
        -- MatLib = materialLibrary()
        if textures[1] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[1]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].diffuseMap = bm
            showproperties MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex]
            -- bm.rgbOutput - Alpha
            -- bm.coords.mapChannel
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].diffuseMap = undefined

        if textures[2] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[2]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].specularMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].specularMap = undefined

        if textures[3] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[3]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].bumpMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].bumpMap = undefined

        if textures[4] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[4]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].glossinessMap = bm
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].glossinessMap = undefined

        if textures[5] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[5]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].selfillumMap = bm
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].selfillumMapEnable = off
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].selfillumMap = undefined

        if textures[6] != undefined then 
        (
            bm = Bitmaptexture fileName:textures[6]
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].opacityMap = bm
            MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].opacityMapEnable = off
            bm.reload()
        )
        else MD_Data.ActiveTask.Material.materialList[MD_Data.ActiveTaskAddIndex].opacityMap = undefined

        -- append MatLib MD_Data.InWorkTask.Material
        MD_Data.ActiveTask.MatLib[1] = MD_Data.ActiveTask.Material
        saveTempMaterialLibrary MD_Data.ActiveTask.MatLib MD_Data.ActiveTask.MatLibFile
        MD_Data.ActiveTask.MatLib = loadTempMaterialLibrary MD_Data.ActiveTask.MatLibFile
        MD_Data.ActiveTask.Material = MD_Data.ActiveTask.MatLib[1]
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
                    MD_Data.AssignMaterial obj
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
            dlg_load_textures.title = ("Assign Textures to Material-" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].MatIndex)

            btn_delete.enabled = false
            btn_load.enabled = false

            for i = 1 to controls_arr.count do
            (
                local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File)
                local text_name = "T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + TEXTURES_SIFFIXES[i]
                local lib_tex_file = (pathConfig.appendPath task_dir text_name)

                if DoesFileExist lib_tex_file then
                (
                    controls_arr[i][1].text = text_name
                    controls_arr[i][2].checked = false
                    controls_arr[i][2].enabled = true
                    textures[i] = lib_tex_file
                    btn_delete.enabled = false
                    btn_load.enabled = false
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
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File)
        local suffix = ""
        local text_name = ""
        btn_delete.enabled = false
        btn_load.enabled = false
        
        if file != undefined then 
        (
            case def_text of
            (
                "Diffuse":(suffix = TEXTURES_SIFFIXES[1]; textures[1] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[1] = file)
                "Mixing":(suffix = TEXTURES_SIFFIXES[2]; textures[2] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[2] = file)
                "Normal":(suffix = TEXTURES_SIFFIXES[3]; textures[3] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[3] = file)
                "SRM":(suffix = TEXTURES_SIFFIXES[4]; textures[4] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[4] = file)
                "Emissive":(suffix = TEXTURES_SIFFIXES[5]; textures[5] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[5] = file)
                "SSS":(suffix = TEXTURES_SIFFIXES[6]; textures[6] = (pathConfig.appendPath task_dir ("T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix)); source_files[6] = file)
            )

            text_name = "T_" + MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].Article + suffix

            btn.text = text_name
            lbl.checked = true
            lbl.enabled = true
            btn_delete.enabled = true
            btn_load.enabled = true
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
        local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File)

        for i = 1 to controls_arr.count where controls_arr[i][2].checked do
        (
            try (dosCommand ("copy " + source_files[i] + " " + textures[i] + " /Y /Z"))catch()                
        )
    )

	on dlg_load_textures open do
    (
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos")
            SetDialogPos dlg_load_textures dialog_pos
        )catch()

        MD_Callbacks.Add()
        mat = MD_Data.ActiveTask.Material
        mat_ids = for i = 1 to mat.materialList.count collect i as string
        lst_mat_id.items = mat_ids
        InitExistTextures()
    )

    on dlg_load_textures close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos" ((GetDialogPos dlg_load_textures) as string)
    )

    on ckbx_d changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )

    on ckbx_m changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )

    on ckbx_n changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )

    on ckbx_ard changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )

    on ckbx_e changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )

    on ckbx_sss changed arg do (
        if (GetCheckedItems()).count == 0 
        then (btn_delete.enabled = false; btn_load.enabled = false)
        else (btn_delete.enabled = true; btn_load.enabled = true)
    )

    on btn_d pressed do OpenFile btn_d ckbx_d "Diffuse"

    on btn_m pressed do OpenFile btn_m ckbx_m "Mixing"

    on btn_n pressed do OpenFile btn_n ckbx_n "Normal"

    on btn_ard pressed do OpenFile btn_ard ckbx_ard "SRM"

    on btn_e pressed do OpenFile btn_e ckbx_e "Emissive"

    on btn_sss pressed do OpenFile btn_sss ckbx_sss "SSS"

    on btn_load pressed do
    (
        CopyTextsToLib()
        ChangeMaterial()
        MD_Data.ActiveTask.Update()
        MD_UI.FillAddList()
        CompleteRedraw()
    )

    on btn_delete pressed do
    (
        if (queryBox "Действительно удалить отмеченные текстуры из локальной базы?" title:"Внимание!" icon:#question) then
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
            MD_Data.ActiveTask.Update()
            MD_UI.FillAddList()
            CompleteRedraw()
        )
    )

    on lbl_01 changed state do
    (
        if state then SwitchStates lbl_01

        setFocus dlg_load_textures
    )

    on lbl_01o changed state do
    (
        if state then SwitchStates lbl_01o
        setFocus dlg_load_textures
    )

    on lbl_04s changed state do
    (
        if state then SwitchStates lbl_04s
        setFocus dlg_load_textures
    )

    on lbl_04r changed state do
    (
        if state then SwitchStates lbl_04r
        setFocus dlg_load_textures
    )

    on lbl_04m changed state do
    (
        if state then SwitchStates lbl_04m
        setFocus dlg_load_textures
    )

    on lbl_03 changed state do
    (
        if state then SwitchStates lbl_03
        setFocus dlg_load_textures
    )

    on lbl_05 changed state do
    (
        if state then SwitchStates lbl_05
        setFocus dlg_load_textures
    )

    on lbl_02 changed state do
    (
        if state then SwitchStates lbl_02
        setFocus dlg_load_textures
    )

    on lbl_06 changed state do
    (
        if state then SwitchStates lbl_06
        setFocus dlg_load_textures
    )
)
/*
actionMan.executeAction 0 "63545" -- Views: Viewport Materials Display as Shaded with Maps

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