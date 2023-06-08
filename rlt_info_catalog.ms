
rollout rlt_info_catalog "Info"
(
    imgTag 'img_prev' "" offset:[1, V_MARGIN] bitmap:undefined width:CTRL_WIDTH_1 height:CTRL_WIDTH_1 align:#center style:#bmp_center
    label 'lbl_site' "Website:" width:50 offset:[-3, 2] align:#left across:2
    hyperLink 'hpl_site' "" address:"" width:166 offset:[-50, 2] align:#left visitedColor:(color 110 180 255) Color:(color 110 180 255) hoverColor:(color 120 190 255) enabled:false
    label 'lbl_size' "Size:" width:50 offset:[17, 0] align:#left across:2
    label 'lbl_size_txt' "" width:165 offset:[-50, 0] align:#left

    on rlt_info_catalog open do 
    (
        rlt_info_catalog.height = 280
    )

    on img_prev lbuttondblclk point_click args do 
    (
        case MD_Data.ActiveList of
		(
			1:(HiddenDOSCommand MD_Data.ActiveTask.RefFile donotwait:true)
			2:(HiddenDOSCommand MD_Data.ActiveTask.Materials[MD_Data.ActiveTaskAddIndex].RefFile donotwait:true)
        )
    )
)