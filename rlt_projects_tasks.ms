
rollout rlt_projects_tasks "Tasks"
(
    -- dropdownlist 'lst_sections' "" items:MD_CATEGS[1] width:CTRL_WIDTH_1 offset:[1, V_MARGIN] align:#center selection:2 enabled:true
    dotNetControl 'lv_main' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:176 align:#center offset:[1, 0] enabled:true
    dotNetControl 'lv_add' "System.Windows.Forms.ListView" width:(CTRL_WIDTH_1) height:110 align:#center offset:[1, 0] enabled:true
  
    on rlt_projects_tasks open do
    (
        if MD_Data.ProjectsRollLoadState then
        (
            -- Очистить рабочую сцену
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
            try MD_Callbacks.Destruct() catch()
            MD_UI.InitProjectsLists()
        )
    )
/*
    on lst_sections selected arg do 
    (
        if MD_Data.ActiveSection != arg then
        (
            MD_Data.ActiveSection = arg
            MD_UI.SwitchRollouts()
            try MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) catch()

            -- Попытаться установить иконку
            try (
                icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))

                MD_Data.ActiveCategoryIcon.SetIcon icon_file
            )catch(MD_Data.ActiveCategoryIcon.Icon = undefined)
            
            MD_Callbacks.Add()
        )
    )
    */
)