
rollout rlt_catalog_info "Info"
(
    label 'lbl_site' "Website:" width:50 offset:[-3, V_MARGIN] align:#left across:2
    hyperLink 'hpl_site' "" address:"" width:155 offset:[-50, V_MARGIN] align:#left visitedColor:(color 110 180 255) Color:(color 110 180 255) hoverColor:(color 120 190 255) enabled:false
    label 'lbl_size' "Size:" width:30 offset:[17, 0] align:#left across:2
    label 'lbl_size_txt' "" width:175 offset:[-50, 0] align:#left
    imgTag 'img_prev' "" offset:[1, 2] bitmap:undefined width:CTRL_WIDTH_1 height:CTRL_WIDTH_1 align:#center style:#bmp_center

    on rlt_catalog_info open do
    (
        rlt_catalog_info.height = 280
    )

    on img_prev lbuttondblclk point_click args do 
    (
        case MD_Data.ActiveList of
		(
			1:(HiddenDOSCommand MD_Data.ActiveTask.RefFile donotwait:true)
			2:(HiddenDOSCommand MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefFile donotwait:true)
        )
    )

    on img_prev rightclick do 
    (
        try (
            activ_dir = pathConfig.appendPath (MD_Data.sub_categ_lib_dirs[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) MD_Data.ActiveTask.Article
            ShellLaunch activ_dir ""
        ) catch()
    )
)