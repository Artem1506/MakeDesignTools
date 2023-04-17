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

        -- MD_Data.ActiveTaskIndex = 1
        MD_Data.Update()
        MD_UI.Update()
        MD_Callbacks.Add()

        -- MD_Data.ActiveCategory = MD_UI.Categories.selection
        -- MD_Data.ActiveSubCategory = MD_UI.SubCategories.selection
        -- try MD_Data.ActiveTask = MD_Data.Tasks[MD_UI.ListMain.Item[0].Index + 1] catch()
        MD_Data.Update()
        MD_UI.Update()
        MD_BBox.Update()

    )
    else
    (
        try(cui.UnRegisterDialogBar ::rlt_make_design)catch()
        try(destroyDialog ::rlt_make_design)catch()
    )

	ok
)
