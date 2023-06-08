(
    clearListener()

    if ::rlt_make_design == undefined OR ::rlt_make_design.IsDisplayed == false then
    (
        -- Подключение основных модулей
        include "dn_lib.ms"
        include "header.ms"
        include "functions.ms"
        include "structures.ms"
        include "dlg_check_tasks.ms"
        include "dlg_configure.ms"
        include "dlg_pivot_params.ms"
        include "dlg_load_work.ms"
        include "dlg_export.ms"
        include "dlg_request.ms"
        include "dlg_load_textures.ms"
        include "rlt_settings.ms"
        include "rlt_info_catalog.ms"
        include "rlt_info_projects.ms"
        include "rlt_tasks.ms"
        include "rlt_tools_catalog.ms"
        include "rlt_tools_projects.ms"
        include "rlt_about.ms"
        include "rlt_make_design.ms"
        include "rlt_utilities.ms"
        
        clearSelection()
        try MD_Data.ClearTrashLayers() catch()
        
        MD_Data = GlobalData()
        MD_UI = UI()
        MD_BBox = BoundingBox()
        MD_Callbacks = Callback()
        MD_Client = HTTPClient()

        MD_Data.ShowLayers mode:#none

        -- Попытаться выбрать последнее активное задание
		if MD_Data.Tasks.Count != 0 then
		(
            local exist_task_index = undefined

            try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE MD_UI.Tasks.Name (MD_UI.ListMain.name + "_selection")) + 1) catch()

            if exist_task_index != undefined and exist_task_index > 0 then
            (
                MD_Data.ActiveTaskIndex = exist_task_index
                MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
            )
            
            -- переключить видимость слоёв
            if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined then
            (
                if MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
                (
                    -- Создать рабочее состояние
                    MD_Data.CreateWorkState()

                    -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
                    if MD_UI.Settings.ckbx_load_last.checked then
                    (
                        try(
                            if MD_Data.WorkLayerNodes.count == 0 then
                            (
                                MD_Data.InWorkTask.LoadWork \
                                MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                                
                            )
                        ) catch()    
                    )

                    MD_UI.UpdateCatalogToolsRlt()
                    MD_Data.ShowLayers mode:#work_only
                )
            )
		)
        
        try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()

        -- Обновить габаритный контейнер
        try WithoutRedraw MD_BBox.Update catch()

        -- Создать рабочий слой, если есть задание в работе
        try if MD_Data.InWorkTask.file != undefined and MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer() catch()

        -- Обновить рабочий слой, если он есть
        try WithoutRedraw MD_Data.SwitchWorkLayer catch()

        -- Попытаться выбрать первый элемент в списке
        if MD_Data.ActiveTaskIndex == undefined then try MD_UI.ListMain.Items.Item[0].selected = true catch()

        try MD_Callbacks.Add() catch()

        try (
            if MD_Data.InWorkTask != undefined then
            (
                if MD_Data.InWorkTask.Group != undefined and MD_Data.InWorkTask.Group == MD_Data.ActiveTask.Group then
                MD_Data.ShowLayers mode:#work_only
            )
        )catch()
    )
    else
    (
        try(cui.UnRegisterDialogBar ::rlt_make_design)catch()
        try(destroyDialog ::rlt_make_design)catch()
    )

	ok
)
