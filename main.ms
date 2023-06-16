(
    clearListener()

    if ::rlt_make_design == undefined OR ::rlt_make_design.IsDisplayed == false then
    (
        -- Подключение основных модулей
        include "lib_dotnet.ms"
        include "header.ms"
        include "lib_fns.ms"
        include "struct_log_sys.ms"
        include "struct_tooltips.ms"
        include "struct_task_material.ms"
        include "struct_task.ms"
        include "struct_task_icon.ms"
        include "struct_global_data.ms"
        include "struct_ui_dialogs.ms"
        include "struct_ui.ms"
        include "struct_bounding_box.ms"
        include "struct_callback.ms"
        include "struct_http_client.ms"
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
        include "rlt_general_catalog.ms"
        include "rlt_general_projects.ms"
        include "rlt_about.ms"
        include "rlt_make_design.ms"

        -- Функция для обновления данных и интерфейса
        fn FullUpdate =
        (
            -- Обновить данные
            MD_UI.Sort = false
            MD_Data.ActiveList = 1
            try MD_Data.ActiveTask = MD_Data.Tasks[MD_Data.ActiveTaskIndex] catch()

            -- Обновить интерфейс
            MD_UI.FillMainList()
            MD_UI.FillAddList()
            MD_UI.UpdateCatalogTasksRlt()
            MD_UI.UpdateCatalogInfoRlt()
            MD_UI.UpdateCatalogToolsRlt()

            -- Обновить габаритный контейнер
            try WithoutRedraw MD_BBox.Update catch()

            -- Создать рабочий слой, если есть задание в работе
            try if MD_Data.InWorkTask.file != undefined and MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer() catch()

            -- Обновить рабочий слой, если он есть
            try WithoutRedraw MD_Data.SwitchWorkLayer catch()

            -- Попытаться выбрать первый элемент в списке
            if MD_Data.ActiveTaskIndex == undefined then try MD_UI.ListMain.Items.Item[0].selected = true catch()
        )

        clearSelection()
        try MD_Data.ClearTrashLayers() catch()

        MD_Log = LogSys source:"MAKE_DESIGN_TOOLS"
        Client_Log = LogSys source:"HTTP_CLIENT"
        MD_Tooltips = UI_Tooltips()
        MD_Data = GlobalData()
        MD_UI = UI()
        MD_BBox = BoundingBox()
        MD_Callbacks = Callback()
        MD_Client = HTTPClient()

        MD_Data.ShowLayers mode:#none
        for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true

        try (
			MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
			icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
			-- Установить иконку для текущей категории
			MD_Data.ActiveCategoryIcon.SetIcon icon_file
		)catch()

        -- Попытаться выбрать последнее активное задание
		if MD_Data.Tasks.Count != 0 then
		(
            local exist_task_index = undefined

            try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE MD_UI.TasksRoll.Name (MD_UI.ListMain.name + "_selection")) + 1) catch()

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
                    if MD_UI.SettingsRoll.ckbx_load_last.checked then
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
