
rollout rlt_tools_catalog "Tools"
(
    button 'btn_attach_to_task' "Attach Selected" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_01
    button 'btn_set_pivot' "Set Pivot" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_02
    button 'btn_assign_mat' "Assign Material" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_03
    button 'btn_assign_texts' "Assign Textures" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_04
    button 'btn_save_work' "Save Work" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5,V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_05
    button 'btn_load_work' "Load Work" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_06
    button 'btn_main_mesh' "Main Mesh" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[-5, V_MARGIN] across:2 enabled:false tooltip:MD_Tooltips.tools_cat_07
    button 'btn_add_mesh' "Additional Mesh" width:CTRL_WIDTH_2 height:CTRL_HEIGHT_1 align:#center offset:[7, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_07
    button 'btn_mesh_switch' ">> Switch Between Meshes" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_08
    button 'btn_valid' "Validation" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_09
    button 'btn_export' "Export Task" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_2 align:#center offset:[1, V_MARGIN] enabled:false tooltip:MD_Tooltips.tools_cat_10

    on rlt_tools_catalog open do
    (

    )
    
    on rlt_tools_catalog close do
    (
  
    )  

    on btn_main_mesh pressed do
    (
        MD_Data.SetMesh()
        MD_UI.ToolsRltUpdate()
        MD_BBox.Update()
    )

    on btn_add_mesh pressed do
    (
        MD_Data.SetAddMesh()
        MD_UI.ToolsRltUpdate()
        MD_BBox.Update()
    )

    on btn_mesh_switch pressed do
    (
        case MD_Data.ActiveTask.ActiveMesh of
        (
            1:(MD_Data.ActiveTask.ActiveMesh = 2)
            2:(MD_Data.ActiveTask.ActiveMesh = 1)
        )
        MD_UI.ToolsRltUpdate()
        MD_BBox.Update()
    )

    on btn_set_pivot pressed do
    (

    )

    on btn_set_pivot rightclick do
    (

    )

    on btn_save_work pressed do
    (
  
    )

    on btn_load_work pressed do
    (
  
    )

    on btn_load_work rightClick do
    (
 
    )

    on btn_valid pressed do
    (
        try(destroyDialog MD_UI.Dialogs.Validation)catch()
        CreateDialog MD_UI.Dialogs.Validation style:#(#style_sysmenu, #style_titlebar)
    )

    on btn_export pressed do
    (
 
    )

    on btn_attach_to_task pressed do
    (
        MD_Data.AttachSelectedToWorkLayer()
    )
)