
rollout rlt_catalog_info "Info"
(
    label 'lbl_site' "Website:" width:50 offset:[-3, V_MARGIN] align:#left across:2
    hyperLink 'hpl_site' "" address:"" width:155 offset:[-50, V_MARGIN] align:#left visitedColor:(color 110 180 255) Color:(color 110 180 255) hoverColor:(color 120 190 255) enabled:false
    label 'lbl_size' "Size:" width:30 offset:[17, 0] align:#left across:2
    label 'lbl_size_txt' "" width:175 offset:[-50, 0] align:#left
    imgTag 'img_prev' "" offset:[1, 4] bitmap:undefined width:CTRL_WIDTH_1 height:CTRL_WIDTH_1 align:#center style:#bmp_center

    label 'lbl_mats' "Materials:" width:50 offset:[-7, 2] align:#left
    checkbutton 'chbtn_m1' "1" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false  across:10
    checkbutton 'chbtn_m2' "2" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m3' "3" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m4' "4" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m5' "5" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m6' "6" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m7' "7" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m8' "8" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m9' "9" checked:false border:false width:19 height:19 offset:[0, 0] align:#left enabled:false
    checkbutton 'chbtn_m10' "10" checked:false border:false width:19 height:19 offset:[-1, 0] align:#center enabled:false
    -- checkbutton 'chbtn_m11' "11" checked:false border:false width:19 height:19 offset:[0, 0] align:#center enabled:false
    -- checkbutton 'chbtn_m12' "12" checked:false border:false width:19 height:19 offset:[0, 0] align:#center enabled:false
    local mats = #(chbtn_m1, chbtn_m2, chbtn_m3, chbtn_m4, chbtn_m5, chbtn_m6, chbtn_m7, chbtn_m8, chbtn_m9, chbtn_m10)

    on rlt_catalog_info open do
    (
        try (GetINISettings rlt_catalog_info MDT_CONFIG_FILE rlt_catalog_info.name onlyRollState:true) catch()
        -- rlt_catalog_info.height = 320
    )

    on img_prev lbuttondblclk point_click args do 
    (
        case MD_Data.ActiveList of
		(
			1:(HiddenDOSCommand MD_Data.ActiveTask.RefFile donotwait:true)
			2:(HiddenDOSCommand MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskMatIndex].RefFile donotwait:true)
        )
    )
    
    on img_prev rightclick do 
    (
        try (
            activ_dir = pathConfig.appendPath (MD_Data.sub_categ_lib_dirs[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) MD_Data.ActiveTask.Article
            ShellLaunch activ_dir ""
        ) catch()
    )

    on chbtn_m1 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m1 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 1
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m2 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m2 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 2
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m3 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m3 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 3
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m4 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m4 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 4
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m5 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m5 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 5
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m6 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m6 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 6
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m7 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m7 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 7
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m8 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m8 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 8
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m9 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m9 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 9
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

    on chbtn_m10 changed arg do (
        for i=1 to mats.count where mats[i] != chbtn_m10 do mats[i].checked = false
        MD_Data.ActiveTaskMatIndex = 10
        case arg of
        (
            true:(MD_Data.ActiveList = 2)
            false:(MD_Data.ActiveList = 1)
        )
        try MD_UI.UpdateCatalogInfoRlt() catch()
    )

)