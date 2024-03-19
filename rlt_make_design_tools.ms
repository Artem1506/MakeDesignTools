
rollout rlt_make_design_tools ("MakeDesignTools v" + version)
(
    subrollout 'sub_rlt' "" width:(MAIN_RLT_WIDTH + 8) align:#center

    on rlt_make_design_tools open do
    (
        -- Установить расположение главного роллаута
        -- Имеет смысл только, если роллаут не втроенный 
        try(
            dialog_pos = execute (getINISetting MDT_CONFIG rlt_make_design_tools.name "pos")
            SetDialogPos rlt_make_design_tools dialog_pos
        )catch()
    )

    on rlt_make_design_tools close do
    (
        -- Закрыть все диалоговый окна
        try(destroyDialog dlg_configure)catch()
        try(destroyDialog dlg_check_tasks)catch()
        try(destroyDialog dlg_pivot_params)catch()
        try(destroyDialog dlg_load_work)catch()
        try(destroyDialog dlg_export)catch()
        try(destroyDialog dlg_request)catch()
        try(destroyDialog dlg_load_textures)catch()

        MD_Data.FullUpdate()

        -- Запись текущего состояния интерфейса
        SetINISettings MD_UI.SettingsRoll MDT_CONFIG_FILE MD_UI.SettingsRoll.name
        SetINISettings MD_UI.TasksCatalogRoll MDT_CONFIG_FILE MD_UI.TasksCatalogRoll.name include_list:#(MD_UI.TasksCatalogRoll.lst_basic_catalog, MD_UI.TasksCatalogRoll.lst_sub_catalog, MD_UI.TasksCatalogRoll.lv_main)
        SetINISettings MD_UI.InfoCatalogRoll MDT_CONFIG_FILE MD_UI.InfoCatalogRoll.name onlyRollState:true
        try SetINISettings MD_UI.ToolsCatalogRoll MDT_CONFIG_FILE MD_UI.ToolsCatalogRoll.name onlyRollState:true catch()
        SetINISettings MD_UI.GeneralCatalogRoll MDT_CONFIG_FILE MD_UI.GeneralCatalogRoll.name onlyRollState:true

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