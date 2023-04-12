
rollout rlt_info_catalog "Info"
(
    imgTag 'img_prev' "" offset:[1, V_MARGIN] bitmap:undefined width:CTRL_WIDTH_1 height:CTRL_WIDTH_1 align:#center style:#bmp_center
    label 'lbl_site' "Website:" width:50 offset:[-3, 2] align:#left across:2
    hyperLink 'hpl_site' "" address:"" width:166 offset:[-50, 2] align:#left visitedColor:(color 100 160 255) enabled:false
    label 'lbl_size' "Size(cm):" width:50 offset:[-4, 0] align:#left across:2
    label 'lbl_size_txt' "" width:165 offset:[-50, 0] align:#left

    on rlt_info_catalog open do 
    (

    )

    on img_prev lbuttondblclk point_click args do 
    (

    )
)