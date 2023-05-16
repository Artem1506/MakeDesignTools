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
        
        clearSelection()

        MD_Data = GlobalData()
        MD_UI = UI()
        MD_BBox = BoundingBox()
        MD_Callbacks = Callback()
        MD_Client = HTTPClient()

        -- MD_Data.Update()
        -- MD_UI.FillCategoriesLists()

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
            if MD_Data.ActiveTask != undefined then
            (
                if MD_Data.ActiveTask.File == MD_Data.InWorkTask.File then
                (
                    -- Попытаться загрузить последнюю сохранённую работу, если рабочий слой пустой
                    if MD_UI.Settings.ckbx_load_last.checked then
                    (
                        -- Создать рабочий слой, если есть задание в работе
                        if MD_Data.WorkLayer == undefined then MD_Data.CreateWorkLayer()
                        try(
                            if MD_Data.WorkLayerNodes.count == 0 then
                            (
                                MD_Data.InWorkTask.LoadWork \
                                MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:true
                            )
                        ) catch()      
                    )
                )
            )
		)

        try MD_Callbacks.Add() catch()
        try FullUpdate() catch()
    )
    else
    (
        try(cui.UnRegisterDialogBar ::rlt_make_design)catch()
        try(destroyDialog ::rlt_make_design)catch()
    )

	ok
)
