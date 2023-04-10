
rollout dlg_check_tasks "Parameters" width:200 height:150
(
    radiobuttons 'rbtn_check_vars' labels:TASK_PARAMS_LIST default:1 columns:1 offsets:#([0, 10], [0, 16], [0, 22], [0, 28])\
        tooltip:#(MD_Tooltips.chk_01, MD_Tooltips.chk_02, MD_Tooltips.chk_03, MD_Tooltips.chk_04)
    button 'btn_check' "Check" width:(dlg_check_tasks.width - 20) height:CTRL_HEIGHT_2 align:#center offset:[0, 8]

    on dlg_check_tasks open do 
    (
        
    )

    on dlg_check_tasks close do 
    (
  
    )

    on btn_check pressed do
    (
        -- Закрыть текущее диалоговое окно
        DestroyDialog dlg_check_tasks
        -- Вызвать окно ожидания
        try(DestroyDialog ::dlg_progress)catch()
        CreateDialog dlg_progress modal:true style:#(#style_toolwindow) escapeEnable:True
    )
)