rollout dlg_configure "Configure" width:400 height:164
(
    Label 'lbl_6' "Directory: " width:62 offset:[8, 20] align:#left across:3
    Label 'lbl_md_lib_dir' "                     < is not specified >" width:224 offset:[-58, 20] align:#left
    Button 'btn_md_lib_dir' "Browse" width:64 height:CTRL_HEIGHT_1 offset:[0, 16] align:#right

    Label 'lbl_8' "Login:" width:32 offset:[-132, 34] align:#right across:2
    editText 'etxt_log' "" width:160 height:20 offset:[-160, 32] align:#right

    Label 'lbl_9' "Password:" width:48 offset:[-136, 2] align:#right across:2
    editText 'etxt_pass' "" width:160 height:20 offset:[-160, 0] align:#right

    button 'btn_test' "Test Request" width:150 height:CTRL_HEIGHT_1 offset:[-2, -51] align:#right enabled:false
    button 'btn_get_struct' "Get database structure" width:150 height:CTRL_HEIGHT_1 offset:[-2, -2] align:#right enabled:false

    Label 'lbl_info' "" width:388 offset:[-4, 12] align:#left

    groupBox 'gbx_1' " Local Base " width:388 height:50 pos:[6, 4] align:#left
    groupBox 'gbx_2' " Remote Base " width:388 height:82 pos:[6, 56] align:#left

    on dlg_configure close do
    (

    )

    on dlg_configure open do
    (     

    )

    on btn_md_lib_dir pressed do
    (

    )

    on etxt_log entered arg do
    (
       
    )

    on etxt_log changed arg do (if arg != "" and etxt_pass.text != "" then btn_test.enabled = true else btn_test.enabled = false)

    on etxt_pass changed arg do (if arg != "" and etxt_log.text != "" then btn_test.enabled = true else btn_test.enabled = false)

    on etxt_pass entered arg do
    (
        
    )

    on btn_test pressed do
    (

    )

    on btn_get_struct pressed do 
    (

    )
)