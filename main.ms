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
        include "dlg_validation.ms"
        include "dlg_progress.ms"
        include "rlt_settings.ms"
        include "rlt_info_catalog.ms"
        include "rlt_info_projects.ms"
        include "rlt_tasks.ms"
        include "rlt_tools_catalog.ms"
        include "rlt_tools_projects.ms"
        include "rlt_about.ms"
        include "rlt_make_design.ms"
        
        MD_Data = GlobalData()
        MD_UI = UI()
        MD_BBox = BoundingBox()
        MD_Callbacks = Callback()

        -- MD_Data.Update()
        try MD_UI.FillAddList() catch()
        try MD_Callbacks.Add() catch()
        try MD_BBox.Update() catch()

        include "print_data.ms"
        -- PrintData structs:#(#active_task)
        -- try PrintData structs:#(#global_data) catch()

    )
    else
    (
        try(cui.UnRegisterDialogBar ::rlt_make_design)catch()
        try(destroyDialog ::rlt_make_design)catch()
    )

	ok
)
