
rollout dlg_request MD_Client.request_dlg_title width:350 height:100
(
    local dots = "."
    local index = 1
    local process = dotNetObject "System.Diagnostics.Process"
    local resp = #()
    local proc

    label 'lbl_01' "Waiting " align:#left offset:[30, 37] across:2
    label 'lbl_02' "." align:#left offset:[-90, 37]

    timer clock "Clock" interval:250

    on dlg_request open do
    (
		process.StartInfo.RedirectStandardOutput = true
		process.StartInfo.RedirectStandardError = true

        MD_Client.response_data = #()

        if MD_Client.dialog_mode == false then 
        (
            dlg_request.visible = false
            dlg_request.height = 0
            dlg_request.height = 0
        )
        else
        (
            dlg_request.visible = true
            dlg_request.height = 350
            dlg_request.height = 100
        )
    )

    on clock tick do
    (
		proc = process.GetProcessesByName("md_requests")

        if proc.count == 0 then 
        (
            MD_Data.TempArticlesList = #()

            try resp = (FilterString (getclipboardText()) SEPAR_1) catch()
            
            try MD_Client.response_status = resp[1] catch()
            try MD_Client.response_msg = resp[2] catch()
            try MD_Client.response_data = (execute resp[3]) catch()
            try MD_Data.TempArticlesList = MD_Client.ExistTasksFilter() catch()

            destroyDialog dlg_request
        )

        if (mod index 5) == 0 then (index = 1; dots = ".") else (index += 1; dots += ".")
        lbl_02.text = dots
    )

    on dlg_request close do
    (
        MD_UI.FillTempData()
        MD_UI.TasksRltUpdate()
    )
)