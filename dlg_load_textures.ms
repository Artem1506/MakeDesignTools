rollout dlg_load_textures "" width:346 height:512
(
    label 'lbl_00' "Material ID: " width:80 height:18 align:#left offset:[2, 12] across:2
    dropdownlist 'lst_mat_id' "" items:#() width:60 height:10 align:#left offset:[-96, 11] selection:1
    button 'btn_update' "Update" width:100 height:CTRL_HEIGHT_1 align:#right pos:[(dlg_load_textures.width - 120), 16]

    spinner 'spn_chnl' "Map Channel: " fieldwidth:42 type:#integer range:[1, 10, 1] height:24 align:#left offset:[2, 2] enabled:false
    spinner 'spn_tile' "Tiling: " fieldwidth:42 type:#float range:[-10000.0, 10000.0, 1.0] height:24 align:#left offset:[40, -6] enabled:false

    groupBox 'grp_01' " Basic Maps: " width:(dlg_load_textures.width - 10) height:108 align:#center offset:[0, 0]
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

        checkbutton 'chbtn_n_t' "Normal" width:84 height:CTRL_HEIGHT_1 align:#left offset:[8, 0] across:3
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
    
    -- button 'btn_assign' "Assign Maps" width:(dlg_load_textures.width - 42) height:CTRL_HEIGHT_2 align:#center offset:[0, 16] enabled:false

    local controls_arr = #(btn_d, btn_srm, btn_n, btn_d_t, btn_srm_t, btn_n_t, btn_e, btn_mx, btn_sss, btn_dp) -- Массив объектов кнопок
    local texts_suffixes = #("_D", "_SRM", "_N", "_D", "_SRM", "_N", "_E", "_M", "_SSS", "_DP")
    local text_names = #() -- Многомерный массив. Хранит названия текстур
    local source_text_files = #() -- Многомерный массив. Хранит пути текстур
    local active_mat = undefined -- Активный материал (Multi-Sub mat)
    local active_map_index = 0
    local bbox_checked_state = false

    fn SwitchStates current_ctrl state =
    (
        if state then 
        (
            for ctrl in dlg_load_textures.Controls where (classOf ctrl == CheckButtonControl and ctrl != current_ctrl) do ctrl.checked = false
        )
        spn_chnl.enabled = state
        spn_tile.enabled = false
    )

    fn InitMaps mat =
    (
        -- Получить количество id материала
        -- local mat = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]
        text_names = #()

        for s = 1 to mat.MultiMat.materialList.count do
        (
            append text_names #()
            append source_text_files #()

            -- Пройти по всем типам карт
            for i = 1 to controls_arr.count do
            (
                local text_name = ""
                -- mat = MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex]

                if i != 4 and i != 5 and i != 6 then
                text_name = "T_" + mat.MultiMat.name + "_" + (s as string) + texts_suffixes[i]
                else
                text_name = "TL_" + mat.MultiMat.name + "_" + (s as string) + texts_suffixes[i]

                text_names[s][i] = text_name

                local map_file_name = ""
                local map_obj = mat.MultiMat.materialList[s].diffuseMap.mapList[i]

                if classOf map_obj == Bitmaptexture then
                map_file_name = mat.MultiMat.materialList[s].diffuseMap.mapList[i].fileName
                else if classOf map_obj == RGB_Tint then
                map_file_name = mat.MultiMat.materialList[s].diffuseMap.mapList[i].map1.fileName

                source_text_files[s][i] = map_file_name

                -- local task_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.InWorkTask.File)
                -- local text_name = "T_" + MD_Data.InWorkTask.Materials[MD_Data.ActiveTaskAddIndex].Article + TEXTURES_SIFFIXES[i]
                -- local lib_tex_file = (pathConfig.appendPath task_dir text_name)
            )
        )
    )

    fn InitExistTextures mat =
    (
        -- Получить количество id материала
        -- local mat = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]
        local mat_ids = for i = 1 to mat.MultiMat.materialList.count collect i as string

        -- Задать заголовок окна
        dlg_load_textures.title = ("Assign maps to material " + mat.MultiMat.name)
        
        -- btn_assign.enabled = false

        -- Задать список id материала
        lst_mat_id.items = mat_ids
        SetFocus lst_mat_id

        -- Инициализировать текстуры
        InitMaps mat

        SetFocus dlg_load_textures 
    )

    fn AssignMapToMaterial mat map_slot_index =
    (
        /*
        Назначает карты текстур в слои композитной текстуры материала
        mat = Стандартный материал в слоте мульти саб материала. 
        Он должен содержать композитную карту в диффузном канале, созданный при помощи функции struct_task.CreateComposeMap
        Допустимые значения map_slot_index:
            1 - Diffuse
            2 - SRM
            3 - Normal
            4 - Diffuse (Tile)
            5 - SRM (Tile)
            6 - Normal (Tile)
            7 - Emission
            8 - Mixing
            9 - SSS
            10 - Displace
        Параметры композитной текстуры (для всех тип = array)
            mapEnabled
            maskEnabled
            layerName
            mapList
            mask
        */

        local result = undefined
        local map_file = getOpenFileName caption:"Set Texture Map File ..." types:"Targa (*.tga)|*.tga"

        if map_file != undefined then 
        (
            -- Условие для карты SRM или SRM (Tile)
            if map_slot_index == 2 or map_slot_index == 5 then
            (
                mat.diffusemap.mapList[map_slot_index].map1.fileName = map_file
            )

            -- Условие для карты Mixing
            else if map_slot_index == 8 then
            (
                mat.diffuseMap.mask[4].fileName = map_file
                mat.diffuseMap.mask[5].fileName = map_file
                mat.diffuseMap.mask[6].fileName = map_file
            )
            else mat.diffuseMap.mapList[map_slot_index].fileName = map_file

            result = map_file
        )
        
        result
    )

    fn RemoveMapFromMaterial mat map_slot_index =
    (
        local result = false

        if map_slot_index == 2 or map_slot_index == 5 then
        (
            mat.diffusemap.mapList[map_slot_index].map1.fileName = ""
        )        

        else if map_slot_index == 8 then
        (
            mat.diffuseMap.mask[4].fileName = ""
            mat.diffuseMap.mask[5].fileName = ""
            mat.diffuseMap.mask[6].fileName = ""
        )
        else mat.diffuseMap.mapList[map_slot_index].fileName = ""

        result = true
    )

    fn ShowMapInViewport mat map_slot_index state sub_map:#none =
    (
        local map = mat.diffuseMap.mapList[map_slot_index]

        for i = 1 to 10 do 
        (
            mat.diffuseMap.mapEnabled[i] = false
            mat.diffuseMap.maskEnabled[i] = false
        )

        if map_slot_index == 2 or map_slot_index == 5 then
        (
            map.red = color 0 0 0
            map.green = color 0 0 0
            map.blue = color 0 0 0

            case sub_map of
            (
                #specular:(map.red = color 255 255 255)
                #roughness:(map.green = color 255 255 255)
                #metallic:(map.blue = color 255 255 255)
            )
        )
        else if map_slot_index == 7 then -- emission
        (
            mat.diffuseMap.mapEnabled[1] = state

        )
        else
        (
            map.rgbOutput = 0
            map.alphaSource = 2
        )

        if sub_map == #opacity then
        (
            map.rgbOutput = 1
            map.alphaSource = 0
        )

        mat.diffuseMap.mapEnabled[map_slot_index] = state

        case state of
        (
            false:(SetViewShading 0)
            true:(SetViewShading 1)
        )
    )

    fn UpdateDialog =
    (
        -- Задать имена текстур на кнопках
        for i = 1 to controls_arr.count do
        (
            map_obj = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[i]

            if classOf map_obj == Bitmaptexture and map_obj.fileName != "" then 
            controls_arr[i].text = text_names[lst_mat_id.selection][i]
            else if classOf map_obj == RGB_Tint and map_obj.map1.fileName != "" then
            controls_arr[i].text = text_names[lst_mat_id.selection][i]
            else controls_arr[i].text = EMPTY_TEXT
        )

        -- Переключить видимость текстур во вьюпорте
        if active_map_index > 0 then
        (
            for i = 1 to lst_mat_id.items.count do ShowMapInViewport active_mat.materialList[i] active_map_index false
            ShowMapInViewport active_mat.materialList[lst_mat_id.selection] active_map_index true
        )
    )

    fn SetMapTiling mat map_slot_index tiling_val =
    (
        local map = mat.diffuseMap.mapList[map_slot_index]
        if classOf map == Bitmaptexture then
        (
            map.coords.U_Tiling = tiling_val
            map.coords.V_Tiling = tiling_val
        )
        else if classOf map == RGB_Tint then
        (
            map.map1.coords.U_Tiling = tiling_val
            map.map1.coords.V_Tiling = tiling_val
        )
    )

    fn SetMapChannel mat map_slot_index map_channel show_in_viewport:true =
    (
        local map = mat.diffuseMap.mapList[map_slot_index]
        if classOf map == Bitmaptexture then
        (
            map.coords.mapChannel = map_channel
            showTextureMap mat map show_in_viewport
        )
        else if classOf map == RGB_Tint then
        (
            map.map1.coords.mapChannel = map_channel
            showTextureMap mat map show_in_viewport            
        )
    )
-------------------------------------------------------------
	on dlg_load_textures open do
    (
        -- Установит положение диалога
        try(
            dialog_pos = execute (GetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos")
            SetDialogPos dlg_load_textures dialog_pos
        )catch()

        -- Инициализация имеющихся текстур в материале
        InitExistTextures MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]

        -- Активный материал
        try (active_mat = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat) catch()

        UpdateDialog()
        bbox_checked_state = rlt_settings.ckbx_show_bb.checked
        rlt_settings.ckbx_show_bb.checked = false
        try MD_BBox.Update() catch()
    )

    on btn_update pressed do
    (
        -- Инициализация имеющихся текстур в материале
        InitExistTextures MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]

        -- Активный материал
        try (active_mat = MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex].MultiMat) catch()

        UpdateDialog()
        bbox_checked_state = rlt_settings.ckbx_show_bb.checked
        rlt_settings.ckbx_show_bb.checked = false
        try MD_BBox.Update() catch()
    )

    on dlg_load_textures close do
    (
        -- Сохранить положение диалога
        SetINISetting MDT_CONFIG_FILE dlg_load_textures.name "pos" ((GetDialogPos dlg_load_textures) as string)

        SetViewShading 0
        rlt_settings.ckbx_show_bb.checked = bbox_checked_state
        try MD_BBox.Update() catch()
    )

    on lst_mat_id selected arg do
    (
        UpdateDialog()
    )

-- Diffise
    on btn_d pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 1

        if map_file != undefined then 
        (
            btn_d.text = text_names[lst_mat_id.selection][1]
            source_text_files[lst_mat_id.selection][1] = map_file
        )
    )

    on btn_d_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 1
        active_map_index = 0

        if val then 
        (
            btn_d.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][1] = ""
        )
    )
-- SRM
    on btn_srm pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 2

        if map_file != undefined then 
        (
            btn_srm.text = text_names[lst_mat_id.selection][2]
            source_text_files[lst_mat_id.selection][2] = map_file
        )
    )

    on btn_srm_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 2
        active_map_index = 0

        if val then 
        (
            btn_srm.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][2] = ""
        )
    )
-- Normal
    on btn_n pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 3

        if map_file != undefined then 
        (
            btn_n.text = text_names[lst_mat_id.selection][3]
            source_text_files[lst_mat_id.selection][3] = map_file
        )
    )

    on btn_n_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 3
        active_map_index = 0

        if val then 
        (
            btn_n.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][3] = ""
        )
    )
-- Diffise (Tile)
    on btn_d_t pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 4

        if map_file != undefined then 
        (
            btn_d_t.text = text_names[lst_mat_id.selection][4]
            source_text_files[lst_mat_id.selection][4] = map_file
        )
    )

    on btn_d_t_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 4
        active_map_index = 0

        if val then 
        (
            btn_d_t.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][4] = ""
        )
    )
-- SRM (Tile)
    on btn_srm_t pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 5

        if map_file != undefined then 
        (
            btn_srm_t.text = text_names[lst_mat_id.selection][5]
            source_text_files[lst_mat_id.selection][5] = map_file
        )
    )

    on btn_srm_t_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 5
        active_map_index = 0

        if val then 
        (
            btn_srm_t.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][5] = ""
        )
    )
-- Normal (Tile)
    on btn_n_t pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 6

        if map_file != undefined then 
        (
            btn_n_t.text = text_names[lst_mat_id.selection][6]
            source_text_files[lst_mat_id.selection][6] = map_file
        )
    )

    on btn_n_t_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 6
        active_map_index = 0

        if val then 
        (
            btn_n_t.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][6] = ""
        )
    )
-- Emission
    on btn_e pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 7

        if map_file != undefined then 
        (
            btn_e.text = text_names[lst_mat_id.selection][7]
            source_text_files[lst_mat_id.selection][7] = map_file
        )
    )

    on btn_e_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 7
        active_map_index = 0

        if val then 
        (
            btn_e.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][7] = ""
        )
    )
-- Mixing
    on btn_mx pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 8

        if map_file != undefined then 
        (
            btn_mx.text = text_names[lst_mat_id.selection][8]
            source_text_files[lst_mat_id.selection][8] = map_file
        )
    )

    on btn_mx_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 8
        active_map_index = 0

        if val then 
        (
            btn_mx.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][8] = ""
        )
    )
-- SSS
    on btn_sss pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 9

        if map_file != undefined then 
        (
            btn_sss.text = text_names[lst_mat_id.selection][9]
            source_text_files[lst_mat_id.selection][9] = map_file
        )
    )

    on btn_sss_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 9
        active_map_index = 0

        if val then 
        (
            btn_sss.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][9] = ""
        )
    )
-- Displace
    on btn_dp pressed do (
        local map_file = AssignMapToMaterial active_mat.materialList[lst_mat_id.selection] 10

        if map_file != undefined then 
        (
            btn_dp.text = text_names[lst_mat_id.selection][10]
            source_text_files[lst_mat_id.selection][10] = map_file
        )
    )

    on btn_dp_del pressed do (
        local val = RemoveMapFromMaterial active_mat.materialList[lst_mat_id.selection] 10
        active_map_index = 0

        if val then 
        (
            btn_dp.text = EMPTY_TEXT
            source_text_files[lst_mat_id.selection][10] = ""
        )
    )

    on chbtn_d changed state do
    (
        SwitchStates chbtn_d state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 1 state
        if state then active_map_index = 1 else active_map_index = 0 
    )

    on chbtn_o changed state do
    (
        SwitchStates chbtn_o state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 1 state sub_map:#opacity
        if state then active_map_index = 1 else active_map_index = 0
    )

    on chbtn_s changed state do
    (
        SwitchStates chbtn_s state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 2 state sub_map:#specular
        if state then active_map_index = 2 else active_map_index = 0
    )

    on chbtn_r changed state do
    (
        SwitchStates chbtn_r state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 2 state sub_map:#roughness
        if state then active_map_index = 2 else active_map_index = 0
    )

    on chbtn_m changed state do
    (
        SwitchStates chbtn_m state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 2 state sub_map:#metallic
        if state then active_map_index = 2 else active_map_index = 0
    )

    on chbtn_n changed state do
    (
        SwitchStates chbtn_n state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 3 state
        if state then active_map_index = 3 else active_map_index = 0
    )

    on chbtn_d_t changed state do
    (
        SwitchStates chbtn_d_t state
        spn_tile.enabled = state
        spn_tile.value = 1.0
        try (spn_tile.value = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[4].coords.U_Tiling) catch ()
        setFocus dlg_load_textures
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 4 state
        if state then active_map_index = 4 else active_map_index = 0
    )

    on chbtn_o_t changed state do
    (
        SwitchStates chbtn_o_t state
        spn_tile.enabled = state
        spn_tile.value = 1.0
        try (spn_tile.value = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[4].coords.U_Tiling) catch ()
        setFocus dlg_load_textures
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 4 state sub_map:#opacity
        if state then active_map_index = 4 else active_map_index = 0
    )

    on chbtn_s_t changed state do
    (
        SwitchStates chbtn_s_t state
        spn_tile.enabled = state
        spn_tile.value = 1.0
        try (spn_tile.value = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[5].map1.coords.U_Tiling) catch ()
        setFocus dlg_load_textures
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 5 state sub_map:#specular
        if state then active_map_index = 5 else active_map_index = 0
    )

    on chbtn_r_t changed state do
    (
        SwitchStates chbtn_r_t state
        spn_tile.enabled = state
        spn_tile.value = 1.0
        try (spn_tile.value = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[5].map1.coords.U_Tiling) catch ()
        setFocus dlg_load_textures
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 5 state sub_map:#roughness
        if state then active_map_index = 5 else active_map_index = 0
    )

    on chbtn_m_t changed state do
    (
        SwitchStates chbtn_m_t state
        spn_tile.enabled = state
        spn_tile.value = 1.0
        try (spn_tile.value = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[5].map1.coords.U_Tiling) catch ()
        setFocus dlg_load_textures

        if state then active_map_index = 5 else active_map_index = 0
    )

    on chbtn_n_t changed state do
    (
        SwitchStates chbtn_n_t state
        spn_tile.enabled = state
        spn_tile.value = 1.0
        try (spn_tile.value = active_mat.materialList[lst_mat_id.selection].diffuseMap.mapList[6].coords.U_Tiling) catch ()
        setFocus dlg_load_textures
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 6 state
        if state then active_map_index = 6 else active_map_index = 0
    )

    on chbtn_e changed state do
    (
        SwitchStates chbtn_e state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 7 state
        if state then active_map_index = 7 else active_map_index = 0
    )

    on chbtn_mx changed state do
    (
        SwitchStates chbtn_mx state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 8 state
        if state then active_map_index = 8 else active_map_index = 0
    )

    on chbtn_sss changed state do
    (
        SwitchStates chbtn_sss state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 9 state
        if state then active_map_index = 9 else active_map_index = 0
    )

    on chbtn_dp changed state do
    (
        SwitchStates chbtn_dp state
        setFocus dlg_load_textures
        spn_tile.value = 1.0
        ShowMapInViewport active_mat.materialList[lst_mat_id.selection] 10 state
        if state then active_map_index = 10 else active_map_index = 0
    )

    on spn_tile changed val do
    (
        try (SetMapTiling active_mat.materialList[lst_mat_id.selection] 4 val) catch()
        try (SetMapTiling active_mat.materialList[lst_mat_id.selection] 5 val) catch()
        try (SetMapTiling active_mat.materialList[lst_mat_id.selection] 6 val) catch()
        completeredraw()
    )

    on spn_chnl changed val do
    (
        SetMapChannel active_mat.materialList[lst_mat_id.selection] active_map_index val
        mat = active_mat.materialList[lst_mat_id.selection]
        completeredraw()
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


m = $.material.diffuseMap
showproperties m
comp_map = CompositeTexturemap \
mapEnabled:#(false, false, false) \
maskEnabled:#(false, false, false) \
layerName:#("Diffuse", "SRM", "Normal")


  .mapEnabled (Map_1_Enable) : boolean array
  .maskEnabled (Map_2_Enable) : boolean array
  .blendMode : integer array
  .layerName : string array
  .dlgOpened : boolean array
  .opacity (Map_Opacity) : float array
  .mapList (Maps) : texturemap array
  .mask (Map_Mask) : texturemap array

s = $.material
s.diffuseMap = comp_map
*/