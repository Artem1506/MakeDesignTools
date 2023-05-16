
rollout rlt_make_design ("MakeDesignTools v" + version)
(
    subrollout 'sub_rlt' "" width:(MAIN_RLT_WIDTH + 8) align:#center

    on rlt_make_design open do
    (
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
        for sr in sub_rlt.rollouts do SetINISettings sr MDT_CONFIG_FILE sr.name

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