
rollout rlt_catalog_general "General"
(
    groupBox 'grp_01' " Layers: " width:(rlt_catalog_general.width - 8) height:97 align:#center offset:[0, -4]
    -- button 'btn_vis_switch' "Show All Layers" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, -83] enabled:false tooltip:MD_Tooltips.tools_cat_11_a
    checkbutton 'chbtn_show_work' "Work" width:70 height:CTRL_HEIGHT_1 align:#center offset:[-2, -83] across:3 checked:true
    checkbutton 'chbtn_show_scene' "Scene" width:69 height:CTRL_HEIGHT_1 align:#center offset:[2, -83] checked:false
    checkbutton 'chbtn_show_all' "All" width:69 height:CTRL_HEIGHT_1 align:#center offset:[6, -83] checked:false
    button 'btn_attach_to_task' "Attach Selected" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_01
    
    -- button 'btn_assign_mat' "Assign Material" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_03
	-- checkbutton 'btn_edit_icon' "Edit Icon Mode" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_04
	button 'btn_clear' "Clear Work Layer" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:true

    groupBox 'grp_02' " Meshes: " width:(rlt_catalog_general.width - 8) height:97 align:#center offset:[0, 4]
    button 'btn_set_pivot' "Set Pivot" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, -83] enabled:false tooltip:MD_Tooltips.tools_cat_02
    button 'btn_main_mesh' "Set Main Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_07_a
    button 'btn_add_mesh' "Set Add Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_07_b
    button 'btn_mesh_switch' ">> Switch To Additional Mesh" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_08
   
    groupBox 'grp_03' " Material: " width:(rlt_catalog_general.width - 8) height:48 align:#center offset:[0, 4]
    button 'btn_update_mat' "Update Material" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, -34] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_07_a
    button 'btn_edit_mat' "Edit Material" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -34] enabled:false tooltip:MD_Tooltips.tools_cat_07_b
    -- button 'btn_mesh_switch' ">> Switch To Additional Mesh" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_08

    groupBox 'grp_04' " Working Files: " width:(rlt_catalog_general.width - 8) height:48 align:#center offset:[0, 5]
    button 'btn_save_work' "Save Work" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[16, -34] across:3 enabled:false tooltip:MD_Tooltips.tools_cat_05
    button 'btn_load_work' "Load Last" width:(CTRL_WIDTH_02 - CTRL_HEIGHT_1 - 4) height:CTRL_HEIGHT_1 align:#center offset:[44, -34] enabled:false tooltip:MD_Tooltips.tools_cat_06_a
    button 'btn_work_list' "…" width:CTRL_HEIGHT_1 height:CTRL_HEIGHT_1 align:#center offset:[30, -34] enabled:false tooltip:MD_Tooltips.tools_cat_06_b
    button 'btn_export' "Validation And Export" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_2 align:#center offset:[1, 8] enabled:false tooltip:MD_Tooltips.tools_cat_10

    -- button 'btn_assign_texts' "Assign Textures" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_04

    fn SwitchMeshes =
    (
        clearSelection()
        if MD_Data.InWorkTask != undefined then
        (
            MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name

            case MD_Data.InWorkTask.ActiveMeshIndex of
            (
                1:(
                    MD_Data.InWorkTask.ActiveMeshIndex = 2
                    try (for n in MD_Data.WorkLayerNodes do n.IsHidden = true) catch()
                    try MD_Data.InWorkTask.AddMesh.IsHidden = false catch()
                    try select MD_Data.InWorkTask.AddMesh catch()
                )
                2:(
                    MD_Data.InWorkTask.ActiveMeshIndex = 1
                    try (for n in MD_Data.WorkLayerNodes do n.IsHidden = false) catch()
                    try MD_Data.InWorkTask.AddMesh.IsHidden = true catch()
                    try select MD_Data.InWorkTask.MainMesh catch()
                )
            )

            MD_UI.UpdateCatalogGeneralRlt()
            try MD_BBox.Update() catch()
            MD_UI.UpdateCatalogInfoRlt()
        )
    )

    on rlt_catalog_general open do
    (
        try (GetINISettings rlt_catalog_general MDT_CONFIG_FILE rlt_catalog_general.name onlyRollState:true) catch()
        -- rlt_catalog_general.height = 350
    )
    
    on rlt_catalog_general close do
    (
        SetINISettings rlt_catalog_general MDT_CONFIG_FILE rlt_catalog_general.name
    )

    on chbtn_show_work changed state do
    (
        if state and (MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask == MD_Data.InWorkTask) then MD_Data.ShowLayers mode:#work_only

        chbtn_show_work.checked = true
        chbtn_show_scene.checked = false
        chbtn_show_all.checked = false
    )

    on chbtn_show_scene changed state do
    (
        if state then MD_Data.ShowLayers mode:#scene_only

        chbtn_show_work.checked = false
        chbtn_show_scene.checked = true
        chbtn_show_all.checked = false
    )

    on chbtn_show_all changed state do
    (
        if state and (MD_Data.ActiveTask != undefined and MD_Data.InWorkTask != undefined and MD_Data.ActiveTask == MD_Data.InWorkTask) then MD_Data.ShowLayers mode:#all

        chbtn_show_work.checked = false
        chbtn_show_scene.checked = false
        chbtn_show_all.checked = true
    )

    on btn_update_mat pressed do
    (
        -- try(
            
            MD_Callbacks.Destruct()

            for i = 1 to MD_Data.InWorkTask.Materials.Count do
            (
                MD_Data.ActiveTaskMatIndex = i
                MD_Data.UpdateMaterial MD_Data.InWorkTask.MainMesh i

            )
            
            MD_Data.InWorkTask.ActiveMatIndex = 1
            MD_Data.AssignMaterial MD_Data.InWorkTask.MainMesh 1
            try MD_Data.AssignMaterial MD_Data.InWorkTask.AddMesh 1 catch()
            MD_Data.ActiveTaskMatIndex = 1
            MD_Callbacks.Add()

            try select MD_Data.InWorkTask.MainMesh catch()
            if MD_UI.Dialogs.EditMaterial.Visible then 
            (
                MD_UI.Dialogs.EditMaterial.InitExistTextures MD_Data.InWorkTask.Materials[MD_Data.InWorkTask.ActiveMatIndex]
                MD_UI.Dialogs.EditMaterial.UpdateDialog()
            )
            
            -- if DoesFileExist (pathConfig.appendPath MD_Data.InWorkTask.InWorkDir TASK_MAT_NAME) then 
            -- ( 
            --     MD_Data.InWorkTask.LoadMaterial()  
                    
            -- )else MD_Data.InWorkTask.CreateMaterial()
            -- Set material
            
            -- MD_Data.UpdateMaterial MD_Data.InWorkTask.MainMesh
            -- MD_Data.AssignMaterial MD_Data.InWorkTask.MainMesh
        -- )catch()
    )

    -- on btn_vis_switch pressed do
    -- (
    --     -- MD_Data.CreateWorkLayer()
    --     case btn_vis_switch.text of
    --     (
    --         "Show All Layers":(
    --             MD_Data.ShowLayers mode:#scene_only
    --             btn_vis_switch.text = "Show Work Layer"
    --             btn_vis_switch.tooltip = MD_Tooltips.tools_cat_11_b
    --         )
    --         "Show Work Layer":(
    --             MD_Data.ShowLayers mode:#work_only
    --             btn_vis_switch.text = "Show All Layers"
    --             btn_vis_switch.tooltip = MD_Tooltips.tools_cat_11_a
    --         )
    --     )
    -- )

    on btn_main_mesh pressed do
    (
        MD_Data.SetMesh selection[1]
        try (
            FixObject MD_Data.InWorkTask.MainMesh
        ) catch()

        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()

        for i = 1 to MD_Data.InWorkTask.Materials.Count do
        (
            -- MD_Data.InWorkTask.Materials[i].MultiMat
            MD_Data.UpdateMaterial MD_Data.InWorkTask.MainMesh i
            MD_Data.AssignMaterial MD_Data.InWorkTask.MainMesh i
            -- try MD_Data.UpdateMaterial MD_Data.InWorkTask.AddMesh i catch()
            try MD_Data.AssignMaterial MD_Data.InWorkTask.AddMesh i catch()
        )
        SetViewShading 0
        -- try(
        --     if DoesFileExist (pathConfig.appendPath MD_Data.InWorkTask.InWorkDir TASK_MAT_NAME) then 
        --     ( 
        --         MD_Data.InWorkTask.LoadMaterial()  
                    
        --     )else MD_Data.InWorkTask.CreateMaterial()
        --     -- Set material
            
        --     MD_Data.UpdateMaterial MD_Data.InWorkTask.MainMesh
        --     MD_Data.AssignMaterial MD_Data.InWorkTask.MainMesh
        -- )catch()
    )

    on btn_add_mesh pressed do
    (
        if MD_Data.InWorkTask != undefined and selection[1] != undefined then 
        (
            if MD_Data.InWorkTask.AddMesh == undefined and MD_Data.InWorkTask.MainMesh == selection[1] then
            (
                if (queryBox "Создать дополнительный объект (меш) путём копирования основного?\n" title:"Внимание!" icon:#question) then 
                (
                    MD_Data.SetAddMesh (copy selection[1])
                )
            )
            else MD_Data.SetAddMesh selection[1]
        )
        
        MD_UI.UpdateCatalogGeneralRlt()
        try MD_BBox.Update() catch()
    )

    on btn_mesh_switch pressed do
    (
        SwitchMeshes()
    )

    on btn_set_pivot pressed do
    (
        try destroyDialog MD_UI.Dialogs.PivotParams catch()
        createDialog MD_UI.Dialogs.PivotParams 340 100 modal:false
        try MD_BBox.Update() catch()
    )

    on btn_set_pivot rightclick do
    (
        MD_BBox.ResetPivot()
        MD_BBox.ResetPivot()
    )

    on btn_save_work pressed do
    (
        MD_Data.InWorkTask.SaveWork()
        MD_UI.UpdateCatalogGeneralRlt()
    )

    on btn_load_work pressed do
    (
        -- if MD_Data.ActiveTask.Group == undefined then
        -- (
            MD_Data.CreateWorkLayer()
        -- )

        MD_Data.InWorkTask.LoadWork \
        MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:false
        MD_Data.FullUpdate()
        -- MD_UI.UpdateCatalogGeneralRlt()
        
        MD_Data.InWorkTask.ActiveMeshIndex = 2
        SwitchMeshes()
        
        try MD_Callbacks.Add() catch()
    )

    on btn_work_list pressed do
    (
        try destroyDialog MD_UI.Dialogs.LoadWork catch()

        if MD_Data.ActiveTask.SavedWorks.count != 0 then
        (
           createDialog MD_UI.Dialogs.LoadWork 628 398 modal:true
           MD_UI.UpdateCatalogGeneralRlt()
        )
    )

    on btn_export pressed do
    (
        MD_Callbacks.Add()
        try(destroyDialog MD_UI.Dialogs.Export)catch()
        CreateDialog MD_UI.Dialogs.Export style:#(#style_sysmenu, #style_titlebar)
    )

    on btn_attach_to_task pressed do
    (
        MD_Data.AttachSelectedToWorkLayer()
        MD_Data.ShowLayers mode:#work_only

        -- btn_vis_switch.text = "Show All Layers"
        -- btn_vis_switch.tooltip = MD_Tooltips.tools_cat_11_a
    )

	-- on btn_edit_icon changed arg do
	-- (
	-- 	case arg of
	-- 	(
	-- 		true:(
    --             MD_Callbacks.Destruct()

	-- 			MD_BBox.Layer.on = false
	-- 			MD_BBox.Layer.lock = false
	-- 			MD_BBox.Layer.ishidden = false
	-- 			MD_BBox.Layer.current = true

    --             for i = 0 to LayerManager.count - 1 do
	-- 			(
	-- 				lr = LayerManager.getLayer i
	-- 				if lr != MD_BBox.Layer then lr.ishidden = true
	-- 			)

	-- 			for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = false
	-- 			for ctrl in MD_UI.TasksCatalogRoll.Controls do ctrl.enabled = false
	-- 			for ctrl in MD_UI.GeneralCatalogRoll.Controls do ctrl.enabled = false
    --             btn_edit_icon.enabled = true

    --             try MD_Data.ActiveCategoryIcon.Icon.IsHidden = false catch()
    --             try select MD_Data.ActiveCategoryIcon.Icon catch()
    --             max modify mode
    --             subobjectLevel = 1
    --             -- try (polyop.setVertSelection MD_Data.ActiveCategoryIcon.Icon #{}) catch()
	-- 		)
	-- 		false:(
    --             try MD_BBox.Update() catch()

    --             try MD_Data.ActiveCategoryIcon.Icon.IsHidden = not MD_UI.SettingsRoll.ckbx_show_icon.checked catch()

	-- 			if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
	-- 			MD_Data.ShowLayers mode:#work_only else MD_Data.ShowLayers mode:#scene_only

	-- 			for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true
	-- 			for ctrl in MD_UI.TasksCatalogRoll.Controls do ctrl.enabled = true
	-- 			MD_UI.UpdateCatalogTasksRlt()
	-- 			MD_UI.UpdateCatalogGeneralRlt()
                
    --             -- Сохранить дефолтную иконку для текущей категории
    --             local file_path = pathconfig.appendpath MD_Data.InWorkTask.InWorkDir TASK_ICON_NAME
    --             gc()
    --             save_nodes MD_Data.ActiveCategoryIcon.Icon file_path
                
    --             -- MD_Callbacks.Add()
	-- 		)
	-- 	)
	-- 	completeRedraw()
	-- 	MD_Data.edit_icon_mode = arg
	-- )

    on btn_edit_mat pressed do
    (
        try (destroyDialog MD_UI.Dialogs.EditMaterial) catch()
        CreateDialog MD_UI.Dialogs.EditMaterial modal:false
    )

    on btn_clear pressed do
    (
        if (queryBox "Все объкты на рабочем слое будут удалены.\n\nПродолжить?\n" title:"Внимание!" icon:#question) then
        MD_Data.ClearWorkLayer()
    )
)
