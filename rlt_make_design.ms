
rollout rlt_make_design ("MakeDesignTools v" + version)
(
    subrollout 'sub_rlt' "" width:(MAIN_RLT_WIDTH + 8) align:#center

    on rlt_make_design open do
    (
        -- try(
        --     GetINISettings rlt_settings MDT_CONFIG_FILE rlt_settings.name
        --     GetINISettings rlt_tasks MDT_CONFIG_FILE rlt_tasks.name onlyRollState:true
        --     GetINISettings rlt_info_catalog MDT_CONFIG_FILE rlt_info_catalog.name onlyRollState:true
        --     GetINISettings rlt_utilities MDT_CONFIG_FILE rlt_utilities.name onlyRollState:true
        --     GetINISettings rlt_tools_catalog MDT_CONFIG_FILE rlt_tools_catalog.name onlyRollState:true
        -- )catch ()
        -- Установить расположение главного роллаута
        -- Имеет смысл только, если роллаут не втроенный 
        try(
            dialog_pos = execute (getINISetting MDT_CONFIG rlt_make_design.name "pos")
            SetDialogPos rlt_make_design dialog_pos
        )catch()
    )

    on rlt_make_design close do
    (
        -- Закрыть все диалоговый окна
        try(destroyDialog dlg_configure)catch()
        try(destroyDialog dlg_check_tasks)catch()
        try(destroyDialog dlg_pivot_params)catch()
        try(destroyDialog dlg_load_work)catch()
        try(destroyDialog dlg_export)catch()
        try(destroyDialog dlg_request)catch()
        try(destroyDialog dlg_load_textures)catch()

        try FullUpdate() catch()

        -- Запись текущего состояния интерфейса
        SetINISettings MD_UI.Settings MDT_CONFIG_FILE MD_UI.Settings.name
        SetINISettings MD_UI.Tasks MDT_CONFIG_FILE MD_UI.Tasks.name include_list:#(MD_UI.Tasks.lst_basic_catalog, MD_UI.Tasks.lst_sub_catalog, MD_UI.Tasks.lv_main)
        SetINISettings MD_UI.InfoCatalog MDT_CONFIG_FILE MD_UI.InfoCatalog.name onlyRollState:true
        SetINISettings MD_UI.UtilsCatalog MDT_CONFIG_FILE MD_UI.UtilsCatalog.name onlyRollState:true
        SetINISettings MD_UI.ToolsCatalog MDT_CONFIG_FILE MD_UI.ToolsCatalog.name onlyRollState:true

        -- Очистить рабочую сцену
        try MD_Callbacks.Destruct() catch()
        try MD_BBox.Remove() catch()
        try MD_Data.ClearWorkLayer() catch()
        try MD_Data.DeleteWorkLayer() catch()
        try MD_Data.ClearTrashLayers() catch()

        -- Сделать открытыми все слои
        for i = 0 to LayerManager.count - 1 do
        (
            lr = LayerManager.getLayer i
            lr.on = true
        )
    )
)