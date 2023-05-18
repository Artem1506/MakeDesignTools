
rollout rlt_tools_catalog "Tools"
(
    -- Common
    groupBox 'grp_01' " Common: " width:(rlt_tools_catalog.width - 8) height:106 align:#center offset:[0, -4]
    button 'btn_vis_switch' "Show Scene Objects" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, -93] enabled:false tooltip:""
    button 'btn_save_work' "Save Work" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[16,V_MARGIN] across:3 enabled:false tooltip:MD_Tooltips.tools_cat_05
    button 'btn_load_work' "Load Last" width:(CTRL_WIDTH_02 - CTRL_HEIGHT_1 - 4) height:CTRL_HEIGHT_1 align:#center offset:[44, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_06_a
    button 'btn_work_list' "…" width:CTRL_HEIGHT_1 height:CTRL_HEIGHT_1 align:#center offset:[30, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_06_b
    button 'btn_export' "Validation And Export" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_2 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_10
    
    -- Objects
    groupBox 'grp_03' " Objects: " width:(rlt_tools_catalog.width - 8) height:120 align:#center offset:[0, 4]
    button 'btn_attach_to_task' "Attach Selected" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, -108] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_01
    button 'btn_set_pivot' "Set Pivot" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -108] enabled:false tooltip:MD_Tooltips.tools_cat_02
    button 'btn_main_mesh' "Main Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_07_a
    button 'btn_add_mesh' "Additional Mesh" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_07_b
    button 'btn_mesh_switch' ">> Switch To Additional Mesh" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_08
    button 'btn_assign_mat_id' "Assign Material" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_03
    button 'btn_assign_texts' "Assign Textures" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_04

    on rlt_tools_catalog open do
    (

    )
    
    on rlt_tools_catalog close do
    (
        -- SetINISettings rlt_tools_catalog MDT_CONFIG_FILE rlt_tools_catalog.name
    )  

    on btn_assign_mat_id pressed do
    (
        case btn_assign_mat_id.text of
        (
            "Assign Material":(
                MD_Data.AssignMaterial selection[1]
            )
            "Assign Mat ID":(
                MD_Data.AssignMatID selection[1]
            )
        )
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
        if selection[1] != undefined then 
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
        MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.InWorkTask.Article

        case MD_Data.ActiveTask.ActiveMesh of
        (
            1:(
                MD_Data.ActiveTask.ActiveMesh = 2
                try (for n in MD_Data.WorkLayerNodes do n.IsHidden = true) catch()
                try MD_Data.ActiveTask.AddMesh.IsHidden = false catch()
                try select MD_Data.ActiveTask.AddMesh catch()
            )
            2:(
                MD_Data.ActiveTask.ActiveMesh = 1
                try (for n in MD_Data.WorkLayerNodes do n.IsHidden = false) catch()
                try MD_Data.ActiveTask.AddMesh.IsHidden = true catch()
                try select MD_Data.ActiveTask.Mesh catch()
            )
        )

        MD_UI.UpdateCatalogToolsRlt()
        MD_BBox.Update()
        MD_UI.UpdateCatalogInfoRlt()
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
        MD_Data.CreateWorkLayer()
        MD_Data.InWorkTask.LoadWork \
        MD_Data.ActiveTask.SavedWorks[MD_Data.ActiveTask.SavedWorks.count] quiet_mode:false
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

    on btn_assign_texts pressed do
    (
        try (destroyDialog MD_UI.Dialogs.LoadTextures) catch()
        CreateDialog MD_UI.Dialogs.LoadTextures modal:false
    )
)