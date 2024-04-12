(
    units.DisplayType = #metric
    units.systemType = #centimeters
    units.MetricType = #centimeters

    clearListener()

    if ::rlt_make_design_tools == undefined OR ::rlt_make_design_tools.IsDisplayed == false then
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
        include "rlt_catalog_info.ms"
        include "rlt_projects_info.ms"
        include "rlt_catalog_tasks.ms"
        include "rlt_projects_tasks.ms"
        include "rlt_catalog_tools.ms"
        include "rlt_catalog_general.ms"
        include "rlt_projects_general.ms"
        include "rlt_about.ms"
        include "rlt_make_design_tools.ms"

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

        -- try MD_UI.Categories.Selection = 1 catch()
        -- try MD_UI.SubCategories.Selection = 1 catch()
        -- Инициализация пути к локальной базе
        -- try MD_LIB_DIR = GetUserEnvVar "MD_LIB_DIR" catch ()

        -- Инициализация артикула текущего проекта
        -- try (
        --     MD_CURRENT_PROJECT = GetUserEnvVar "MD_CURRENT_PROJECT"
        --     MD_CATALOG_DATA_FILE = pathConfig.appendPath MD_LIB_DIR MD_CATEGS[2][2]
        --     MD_CATALOG_DATA_FILE = pathConfig.appendPath MD_CATALOG_DATA_FILE MD_CURRENT_PROJECT
        --     MD_CATALOG_DATA_FILE = pathConfig.appendPath MD_CATALOG_DATA_FILE (MD_CURRENT_PROJECT + CATALOG_DATA_FILE_NAME)
        --     MD_DATA_DIR = pathConfig.appendPath MD_LIB_DIR DATA_DIR_NAME
        --     if not doesDirectoryExist MD_DATA_DIR then makeDir MD_DATA_DIR
        --     MD_USERS_DATA_FILE = pathConfig.appendPath MD_DATA_DIR USERS_DATA_FILE_NAME
        --     MD_PROJECTS_DATA_FILE = pathConfig.appendPath MD_DATA_DIR PROJECTS_DATA_FILE_NAME
        --     RESOURCES_DIR = pathConfig.appendPath MD_LIB_DIR RESOURCES_DIR_NAME
        --     if not doesDirectoryExist RESOURCES_DIR then makeDir RESOURCES_DIR
        --     DECALS_DIR = pathConfig.appendPath RESOURCES_DIR DECALS_DIR_NAME
        --     if not doesDirectoryExist DECALS_DIR then makeDir DECALS_DIR
        -- )catch ()

        -- Инициализация логина и пароля
        try(
            login = GetUserEnvVar "MD_USER_LOGIN"
            etxt_log.text = login
        )catch()

        try(
            password = GetUserEnvVar "MD_USER_PASS"
            etxt_pass.text = password
        )catch()

        MD_Callbacks.Destruct()
        MD_Data.Init()
        MD_Data.CheckedTasks = #()
        MD_Data.ActiveList = 1
        MD_Data.ActiveTaskAddIndex = undefined
        -- MD_Data.Update()
        -- MD_Data.FullUpdate()
        MD_UI.FillCategoriesLists()
        try MD_BBox.Update() catch()

        MD_Data.ShowLayers mode:#none
        for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true
        
        try (
			MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
			icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
			-- Установить иконку для текущей категории
			MD_Data.ActiveCategoryIcon.SetIcon icon_file
		)catch()

        -- Попытаться выбрать последнее активное задание
		if MD_Data.Tasks.Count != 0 then
		(
            local exist_task_index = undefined

            try (exist_task_index = execute (GetINISetting MDT_CONFIG_FILE MD_UI.TasksCatalogRoll.Name (MD_UI.CatalogListMain.name + "_selection")) + 1) catch()

            if exist_task_index != undefined and exist_task_index > 0 then
            (
                MD_Data.ActiveTaskIndex = exist_task_index
                MD_Data.ActiveTask = MD_Data.Tasks[exist_task_index]
            )
            
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

                    MD_UI.UpdateCatalogGeneralRlt()
                    MD_Data.ShowLayers mode:#work_only
                )
            )
		)

        MD_Data.FullUpdate()
        MD_UI.Init()

        -- Создать рабочий слой, если есть задание в работе
        try if MD_Data.InWorkTask.file != undefined and MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer() catch()

        -- Обновить рабочий слой, если он есть
        if MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then 
        MD_Data.ShowLayers mode:#work_only
        else MD_Data.ShowLayers mode:#scene_only

        -- Попытаться выбрать первый элемент в списке
        if MD_Data.ActiveTaskIndex == undefined then try MD_UI.CatalogListMain.Items.Item[0].selected = true catch()

        

        try (
            if MD_Data.InWorkTask != undefined then
            (
                if MD_Data.InWorkTask.Group != undefined and MD_Data.InWorkTask.Group == MD_Data.ActiveTask.Group then
                MD_Data.ShowLayers mode:#work_only
            )
        )catch()
        
        -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
        if MD_UI.SettingsRoll.ckbx_load_last.checked then
        (
            try(
                if MD_Data.WorkLayerNodes.count == 0 then
                (
                    MD_Data.InWorkTask.LoadWork \
                    MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                    MD_Data.FullUpdate()
                    MD_UI.UpdateCatalogGeneralRlt()
                )
            ) catch()    
        )

        -- Обновить материал
        -- try(
        --     if DoesFileExist (pathConfig.appendPath MD_Data.InWorkTask.InWorkDir TASK_MAT_NAME) then 
        --     ( 
        --         MD_Data.InWorkTask.LoadMaterial()  
                    
        --     )else MD_Data.InWorkTask.CreateMaterial()
        --     -- Set material
            
        --     MD_Data.UpdateMaterial MD_Data.InWorkTask.Mesh
        --     MD_Data.AssignMaterial MD_Data.InWorkTask.Mesh
        -- )catch()

        -- Добавить функции обратного вызова
        try MD_Callbacks.Add() catch()
    )
    else
    (
        try(cui.UnRegisterDialogBar ::rlt_make_design_tools)catch()
        try(destroyDialog ::rlt_make_design_tools)catch()
    )
    
	ok
    
)