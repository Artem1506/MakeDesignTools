
rollout rlt_projects_tasks "Tasks"
(
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
)