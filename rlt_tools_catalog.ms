
rollout rlt_tools_catalog "General"
(
    groupBox 'grp_01' " Common: " width:(rlt_tools_catalog.width - 8) height:97 align:#center offset:[0, -4]
    button 'btn_vis_switch' "Show Scene Objects" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, -82] across:2 enabled:false tooltip:""
    button 'btn_attach_to_task' "Attach Selected" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -82] enabled:false tooltip:MD_Tooltips.tools_cat_01
    button 'btn_set_pivot' "Set Pivot" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_03
    button 'btn_assign_mat' "Assign Material" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_02
	checkbutton 'btn_edit_icon' "Edit Icon Mode" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false

    groupBox 'grp_02' " Mesh: " width:(rlt_tools_catalog.width - 8) height:72 align:#center offset:[0, 4]
    button 'btn_main_mesh' "Main Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, -57] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_07_a
    button 'btn_add_mesh' "Additional Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -57] enabled:false tooltip:MD_Tooltips.tools_cat_07_b
    button 'btn_mesh_switch' ">> Switch To Additional Mesh" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_08

    groupBox 'grp_03' " Files: " width:(rlt_tools_catalog.width - 8) height:80 align:#center offset:[0, 4]
    button 'btn_save_work' "Save Work" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[16, -67] across:3 enabled:false tooltip:MD_Tooltips.tools_cat_05
    button 'btn_load_work' "Load Last" width:(CTRL_WIDTH_02 - CTRL_HEIGHT_1 - 4) height:CTRL_HEIGHT_1 align:#center offset:[44, -67] enabled:false tooltip:MD_Tooltips.tools_cat_06_a
    button 'btn_work_list' "…" width:CTRL_HEIGHT_1 height:CTRL_HEIGHT_1 align:#center offset:[30, -67] enabled:false tooltip:MD_Tooltips.tools_cat_06_b
    button 'btn_export' "Validation And Export" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_2 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_10

    -- button 'btn_assign_texts' "Assign Textures" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_04

    on rlt_tools_catalog open do
    (

    )
    
    on rlt_tools_catalog close do
    (
        -- SetINISettings rlt_tools_catalog MDT_CONFIG_FILE rlt_tools_catalog.name
    )

    on btn_assign_mat pressed do
    (
        MD_Data.AssignMaterial selection[1]
    )

    on btn_vis_switch pressed do
    (
        MD_Data.CreateWorkLayer()
        case btn_vis_switch.text of
        (
            "Show Scene Objects":(
                MD_Data.ShowLayers mode:#all
                btn_vis_switch.text = "Isolate Task Layer"
            )
            "Isolate Task Layer":(
                MD_Data.ShowLayers mode:#work_only
                btn_vis_switch.text = "Show Scene Objects"
            )
        )
        
    )

    on btn_main_mesh pressed do
    (
        MD_Data.SetMesh selection[1]
        MD_UI.UpdateCatalogToolsRlt()
        MD_BBox.Update()
    )

    on btn_add_mesh pressed do
    (
        if MD_Data.InWorkTask != undefined and selection[1] != undefined then 
        (
            if MD_Data.InWorkTask.AddMesh == undefined and MD_Data.InWorkTask.Mesh == selection[1] then
            (
                if (queryBox "Создать дополнительный меш путём копирования основного?" title:"Внимание!" icon:#question) then 
                (
                    MD_Data.SetAddMesh (copy selection[1])
                )
                -- else MD_Data.SetAddMesh selection[1]
            )
            else MD_Data.SetAddMesh selection[1]
        )
        
        MD_UI.UpdateCatalogToolsRlt()
        MD_BBox.Update()
    )

    on btn_mesh_switch pressed do
    (
        clearSelection()
        if MD_Data.InWorkTask != undefined then
        (
            MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name

            case MD_Data.InWorkTask.ActiveMesh of
            (
                1:(
                    MD_Data.InWorkTask.ActiveMesh = 2
                    try (for n in MD_Data.WorkLayerNodes do n.IsHidden = true) catch()
                    try MD_Data.InWorkTask.AddMesh.IsHidden = false catch()
                    try select MD_Data.InWorkTask.AddMesh catch()
                )
                2:(
                    MD_Data.InWorkTask.ActiveMesh = 1
                    try (for n in MD_Data.WorkLayerNodes do n.IsHidden = false) catch()
                    try MD_Data.InWorkTask.AddMesh.IsHidden = true catch()
                    try select MD_Data.InWorkTask.Mesh catch()
                )
            )

            MD_UI.UpdateCatalogToolsRlt()
            MD_BBox.Update()
            MD_UI.UpdateCatalogInfoRlt()
        )
    )

    on btn_set_pivot pressed do
    (
        try destroyDialog MD_UI.Dialogs.PivotParams catch()
        createDialog MD_UI.Dialogs.PivotParams 340 100 modal:false
        MD_BBox.Update()
    )

    on btn_set_pivot rightclick do
    (
        MD_BBox.ResetPivot()
        MD_BBox.ResetPivot()
    )

    on btn_save_work pressed do
    (
        MD_Data.InWorkTask.SaveWork()
        MD_UI.UpdateCatalogToolsRlt()
    )

    on btn_load_work pressed do
    (
        if MD_Data.ActiveTask.Group == undefined then
        (
            MD_Data.CreateWorkLayer()
        )

        MD_Data.InWorkTask.LoadWork \
        MD_Data.InWorkTask.SavedWorks[MD_Data.InWorkTask.SavedWorks.count] quiet_mode:false
        MD_UI.UpdateCatalogToolsRlt()    
    )

    on btn_work_list pressed do
    (
        try destroyDialog MD_UI.Dialogs.LoadWork catch()

        if MD_Data.ActiveTask.SavedWorks.count != 0 then
        (
           createDialog MD_UI.Dialogs.LoadWork 628 398 modal:true
           MD_UI.UpdateCatalogToolsRlt()
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
    )

	on btn_edit_icon changed arg do
	(
		case arg of
		(
			true:(
                MD_Callbacks.Destruct()

				MD_BBox.Layer.on = false
				MD_BBox.Layer.lock = false
				MD_BBox.Layer.ishidden = false
				MD_BBox.Layer.current = true

                for i = 0 to LayerManager.count - 1 do
				(
					lr = LayerManager.getLayer i
					if lr != MD_BBox.Layer then lr.ishidden = true
				)

				for ctrl in MD_UI.Settings.Controls do ctrl.enabled = false
				for ctrl in MD_UI.Tasks.Controls do ctrl.enabled = false
				for ctrl in MD_UI.ToolsCatalog.Controls do ctrl.enabled = false
                btn_edit_icon.enabled = true

                try MD_Data.ActiveCategoryIcon.Icon.IsHidden = false catch()
                try select MD_Data.ActiveCategoryIcon.Icon catch()
                max modify mode
                subobjectLevel = 1
                -- try (polyop.setVertSelection MD_Data.ActiveCategoryIcon.Icon #{}) catch()
			)
			false:(
                MD_BBox.Update()

                try MD_Data.ActiveCategoryIcon.Icon.IsHidden = not MD_UI.Settings.ckbx_show_icon.checked catch()

				if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
				MD_Data.ShowLayers mode:#work_only else MD_Data.ShowLayers mode:#scene_only

				for ctrl in MD_UI.Settings.Controls do ctrl.enabled = true
				for ctrl in MD_UI.Tasks.Controls do ctrl.enabled = true
				MD_UI.UpdateCatalogTasksRlt()
				MD_UI.UpdateCatalogToolsRlt()
                
                -- Сохранить дефолтную иконку для текущей категории
                local file_path = pathconfig.appendpath MD_Data.InWorkTask.InWorkDir TASK_ICON_NAME
                gc()
                save_nodes MD_Data.ActiveCategoryIcon.Icon file_path
                
                MD_Callbacks.Add()
			)
		)
		completeRedraw()
		MD_Data.edit_icon_mode = arg
	)

    -- on btn_assign_texts pressed do
    -- (
    --     try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
    --     CreateDialog MD_UI.Dialogs.LoadTextures modal:false
    -- )
)