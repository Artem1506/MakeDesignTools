
rollout rlt_settings "Settings"
(
    button 'btn_paths' "Configure" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN]
    button 'btn_fbx_sets' "FBX Settings" width:CTRL_WIDTH_1 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN]
    checkbox 'ckbx_show_bb' "Show Bounding Box" width:150 offset:[0, 0] align:#left checked:true tooltip:MD_Tooltips.settings_01
    checkbox 'ckbx_auto_pivot' "Auto Pivot" width:150 offset:[0, 0] align:#left checked:true tooltip:MD_Tooltips.settings_02
    checkbox 'ckbx_auto_prev' "Auto Preview" width:150 offset:[0, 0] align:#rigth checked:true tooltip:MD_Tooltips.settings_03
    spinner 'spn_save_count' "Max Saving Count: " width:90 offset:[2, 1] range:[0, 100, 10] type:#integer fieldwidth:50 align:#left tooltip:MD_Tooltips.settings_04
    checkbox 'ckbx_load_last' "Load Last Saved Work" width:150 offset:[0, 0] align:#left checked:true tooltip:MD_Tooltips.settings_05
    checkbox 'ckbx_tooltips' "Tooltips" width:150 offset:[0, 0] align:#left checked:false tooltip:MD_Tooltips.settings_06
   
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
        MD_BBox.Update()
    )

    on ckbx_auto_pivot changed arg do 
    (
        MD_BBox.Update()
    ) 

    on ckbx_tooltips changed arg do 
    (
   
    ) 
)