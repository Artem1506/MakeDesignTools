try(destroydialog ::dlg_install)catch()
(
	target_dir = (GetDir #userScripts) + "\\HotScripts\\MakeDesignTools"
	target_resources_dir = (GetDir #userScripts) + "\\HotScripts\\MakeDesignTools\\Resources"
	target_client_dir = (GetDir #userScripts) + "\\HotScripts\\MakeDesignTools\\md_client"
	target_main_file = (GetDir #userScripts) + "\\HotScripts\\MakeDesignTools\\mdt.mse"
	icon_file = (GetDir #userScripts) + "\\HotScripts\\MakeDesignTools\\Resources\\mdt_48.png"
	autorun_file = (GetDir #userStartupScripts) + "\\mdt_autorun.ms"
	mcr_file = (GetDir #userMacros) + "\\HotScripts-MakeDesignTools.mcr"
	user_icon_file = (GetDir #userIcons) + "\\mdt_48.png"
	source_dir = pathConfig.removePathLeaf (getThisScriptFilename())
	source_resources_dir = pathConfig.appendPath source_dir "Resources"
	source_client_dir = pathConfig.appendPath source_dir "md_client"
	source_main_file = pathConfig.appendPath source_dir "mdt.mse"
	logo_file = pathConfig.appendPath source_resources_dir "mdt_cm_logo.png"

	-- color_theme = colorMan.getColorTheme()

	rollout dlg_install "Install MDT_ContentMaker"
	(
		-- imgTag 'img_logo' opacity:0.0 transparent:(color 0 0 0 0) iconName:logo_file iconSize:[300, 56] align:#center offset:[0, -6] applyUIScaling:false
		checkbox 'chk_dock' "Dock Panel" align:#left offset:[100, 20] checked:True
		checkbox 'chk_auto' "Autorun" align:#left offset:[100, 0] checked:False tooltip:"ON = Autorun at the start of the 3Ds Max"
		button 'btn_install' "Install" align:#left offset:[-7, 18] width:142 height:28 across:2
		button 'btn_uninstall' "Uninstall" align:#right offset:[7, 18] width:142 height:28 enabled:false

		groupBox 'gbx_1' " Options: " width:288 height:70 pos:[6, 4] align:#center

		fn uninstall =
		(
			local uninstall_result = 0
			local return_result = false
			local files = getFiles (target_dir + "\\*.mse")
			local dirs = getDirectories (target_dir + "\\*")
			try(deleteFile mcr_file; uninstall_result += 1)catch()
			try(deleteFile autorun_file; uninstall_result += 1)catch()
			try(deleteFile user_icon_file; uninstall_result += 1)catch()
			for f in files do (deleteFile f; uninstall_result += 1)
			try (DOSCommand ("rmdir " + "\"" + target_dir + "\"" + " /S /Q"); uninstall_result += 1) catch()
			try(cui.UnRegisterDialogBar ::rlt_MakeDesign)catch()
			try(destroyDialog ::rlt_MakeDesign; uninstall_result += 1)catch()

			if uninstall_result >= 5 then return_result = true

			return_result
		)

		fn create_toolbar_macros =
		(
			macros_txt = ""	
			macros_txt += "macroScript MDT_ContentMaker" + "\n"
			macros_txt += "category:\"HotScripts\"" + "\n"
			macros_txt += "tooltip:\"MDT_ContentMaker\"" + "\n"
			macros_txt += "buttontext:\"MDT_CM\"" + "\n"
			macros_txt += "iconName:\"" + user_icon_file +"\"" + "\n"
			macros_txt += "(" + "\n"
			macros_txt += "local checked = false" + "\n"
			macros_txt += "on execute do(" + "\n"
			macros_txt += "filein \"" + target_main_file + "\" quiet:true" + "\n"

			if chk_dock.checked then
			(
				macros_txt += "try cui.RegisterDialogBar ::rlt_make_design_tools minSize:[252, 600] style:#(#cui_dock_vert, #cui_handles) catch()" + "\n"
				macros_txt += "try cui.DockDialogBar ::rlt_make_design_tools #cui_dock_right catch()" + "\n"
			)

			macros_txt += "try checked = rlt_make_design_tools.visible catch()" + "\n"
			macros_txt += ")" + "\n"
			macros_txt += "on isChecked return checked" + "\n"
			macros_txt += ")"

			execute macros_txt
		)

		fn create_startup_script =
		(
			script_file = createfile autorun_file encoding:#utf8 writeBOM:false
			format "filein \"%\" quiet:true\n" target_main_file to:script_file

			if chk_dock.checked then
			(
				format "cui.RegisterDialogBar ::rlt_make_design_tools minSize:[252, 600] style:#(#cui_dock_vert, #cui_handles)\n" to:script_file
				format "cui.DockDialogBar ::rlt_make_design_tools #cui_dock_right\n" to:script_file
			)
			close script_file
		)

		fn install =
		(
			DOSCommand ("xcopy " + "\""+ source_resources_dir + "\""+ " " + "\""+ target_resources_dir + "\" /y /q /h /e /i")
			DOSCommand ("xcopy " + "\""+ source_client_dir + "\""+ " " + "\""+ target_client_dir + "\" /y /q /h /e /i")
			-- DOSCommand ("xcopy " + "\""+ source_main_file + "\""+ " " + "\""+ target_main_file + "\" /y /q /h /e /i")
			-- DOSCommand ("xcopy " + "\""+ icon_file + "\""+ " " + "\""+ (GetDir #userIcons) + "\" /y /q /h /e /i")
			copyFile source_main_file target_main_file
			copyFile icon_file user_icon_file
			try(deleteFile icon_file)catch()

			create_toolbar_macros()

			if doesDirectoryExist target_dir then
			(
				msg = "Successful! The MDT_ContenMaker plugin has been installed.\nToolbar path: Customize>Toolbars>HotScripts>MDT_ContentMaker"
				messageBox msg title:"Installation Info" icon:#information
			)
			else 
			(
				msg = "The MDT_ContenMaker plugin has not been installed."
				messageBox msg title:"Error" icon:#critical
			)
		)

		on dlg_install open do
		(
			if doesDirectoryExist target_dir then 
			(
				btn_install.text = "Reinstall"
				btn_uninstall.enabled = true
			)
			else
			(
				btn_install.text = "Install"
				btn_uninstall.enabled = False
			)
		)
		
		on btn_install pressed do 
		(
			uninstall()
			try(cui.UnRegisterDialogBar ::rlt_make_design_tools)catch()
			try(destroyDialog ::rlt_make_design_tools)catch()
			sleep .5
			if chk_auto.checked then create_startup_script()
			destroyDialog dlg_install
			install()
			try(filein target_main_file quiet:true)catch()

			if chk_dock.checked then
			(
				cui.RegisterDialogBar ::rlt_make_design_tools minSize:[252, 600] style:#(#cui_dock_vert, #cui_handles)
				cui.DockDialogBar ::rlt_make_design_tools #cui_dock_right
			)
		)

		on btn_uninstall pressed do 
		(
			local uninstall_result = uninstall()
			if uninstall_result then
			(
				msg = "The MDT_ContenMaker plugin has been removed."
				messageBox msg title:"Uninstall" icon:#information
			)
			else 
			(
				msg = "The MDT_ContenMaker plugin has not been removed."
				messageBox msg title:"Error" icon:#critical
			)
			btn_install.text = "Install"
			btn_uninstall.enabled = false
			try(cui.UnRegisterDialogBar ::rlt_make_design_tools)catch()
			try(destroyDialog ::rlt_make_design_tools)catch()
		)
	)

	createDialog dlg_install 300 122 modal:true
)