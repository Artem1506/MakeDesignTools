
rollout rlt_make_design ("MakeDesignTools v" + version)
(
    subrollout 'sub_rlt' "" width:(MAIN_RLT_WIDTH + 8) align:#center

    on rlt_make_design open do
    (
        try(
            dialog_pos = execute (getINISetting MDT_CONFIG rlt_make_design.name "pos")
            SetDialogPos rlt_make_design dialog_pos
        )catch()
    )

    on rlt_make_design close do
    (
        try(destroyDialog dlg_mdt_configure_path)catch()
        try(destroyDialog dlg_check_tasks)catch()
        try(destroyDialog dlg_pivot_params)catch()
        try(destroyDialog dlg_load_work)catch()
        try(destroyDialog dlg_validation)catch()

        -- for sr in sub_rlt.rollouts do SetINISettings sr MDT_CONFIG_FILE sr.name
        MD_BBox.Remove()
        MD_Callbacks.Destruct()
    )
)