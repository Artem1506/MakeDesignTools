
rollout dlg_request MD_Client.RequestDialogTitle width:350 height:100
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

        MD_Client.ResponseData = #()

        if MD_Client.RequestDialogShow == false then 
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
		proc = process.GetProcessesByName(HTTP_CLIENT_NAME)

        if proc.count == 0 then 
        (
            MD_Data.TempArticlesList = #()

            try resp = (FilterString (getclipboardText()) SEPAR_1) catch()
            
            try MD_Client.ResponseStatus = resp[1] catch()
            try MD_Client.ResponseMessage = resp[2] catch()
            try MD_Client.ResponseData = (execute resp[3]) catch()
            try MD_Data.TempArticlesList = MD_Client.ExistTasksFilter() catch()

            destroyDialog dlg_request
        )

        if (mod index 5) == 0 then (index = 1; dots = ".") else (index += 1; dots += ".")
        lbl_02.text = dots
    )

    on dlg_request close do
    (
        MD_UI.FillTempData()
        MD_Data.ActiveTask = undefined
        MD_UI.UpdateCatalogTasksRlt()
        MD_UI.UpdateCatalogInfoRlt()
        MD_UI.UpdateCatalogToolsRlt()
        WithoutRedraw MD_BBox.Update
        MD_Data.SwitchWorkLayer()
    )
)