
rollout rlt_settings "Settings"
(
    button 'btn_paths' "Configure User Data" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN]
    button 'btn_fbx_sets' "FBX Settings" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN]
    checkbox 'ckbx_show_bb' "Show Bounding Box" width:120 offset:[0, 0] align:#left checked:true across:4 tooltip:MD_Tooltips.settings_01_a
    colorpicker 'clr_bb_main' fieldWidth:36 color:CLR_BBOX_MAIN height:16 align:#center offset:[62, 0] modal:false tooltip:MD_Tooltips.settings_01_b
    colorpicker 'clr_bb_add' fieldWidth:36 color:CLR_BBOX_ADD height:16 align:#center offset:[48, 0] modal:false tooltip:MD_Tooltips.settings_01_c
    button 'btn_clr_reset' "R" width:17 height:16 align:#right offset:[10, 0] tooltip:MD_Tooltips.settings_01_d
    checkbox 'ckbx_show_icon' "Show Icon" width:120 offset:[0, V_MARGIN] align:#left checked:false tooltip:MD_Tooltips.settings_06
    checkbox 'ckbx_auto_pivot' "Auto Pivot" width:150 offset:[0, 0] align:#left checked:true tooltip:MD_Tooltips.settings_02
    checkbox 'ckbx_auto_prev' "Auto Preview" width:150 offset:[0, 0] align:#rigth checked:true tooltip:MD_Tooltips.settings_03
    spinner 'spn_save_count' "Max Saving Count: " width:90 offset:[2, 1] range:[0, 100, 10] type:#integer fieldwidth:50 align:#left tooltip:MD_Tooltips.settings_04
    checkbox 'ckbx_load_last' "Auto Load Last Saving" width:150 offset:[0, 0] align:#left checked:false tooltip:MD_Tooltips.settings_05
    checkbox 'ckbx_tooltips' "Tooltips" width:150 offset:[0, 0] align:#left checked:false

    on rlt_settings open do
    (
      
    )

    on rlt_settings close do 
    (
    
    )

    on btn_paths pressed do
    (
		try(destroyDialog MD_UI.Dialogs.Configure)catch()
        CreateDialog MD_UI.Dialogs.Configure style:#(#style_sysmenu, #style_titlebar) modal:true
    )

    on btn_fbx_sets pressed do OpenFbxSetting()
    
    on ckbx_show_bb changed arg do 
    (
        try MD_BBox.Update() catch()
    )

    on ckbx_show_icon changed arg do 
    (               
        try MD_BBox.Update() catch()
    )

    on ckbx_auto_pivot changed arg do 
    (
        try MD_BBox.Update() catch()
    )

    on ckbx_tooltips changed arg do 
    ( 
    )

    on clr_bb_main changed arg do try MD_BBox.ChangeColor() catch()

    on clr_bb_add changed arg do try MD_BBox.ChangeColor() catch()

    on btn_clr_reset pressed do 
    (
        clr_bb_main.color = CLR_BBOX_MAIN
        clr_bb_add.color = CLR_BBOX_ADD
        try MD_BBox.ChangeColor() catch()
    )
)