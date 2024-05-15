
rollout rlt_catalog_tools "Tools"
(
    groupBox 'grp_01' " Transform: " width:(rlt_catalog_tools.width - 8) height:120 align:#center offset:[0, -4]
    button 'btn_up' "▲" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -104]
	button 'btn_left' "◄" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[37, -2] across:3
	button 'btn_center' "•" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[0, -2]
    button 'btn_right' "►" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-37, -2]
	button 'btn_down' "▼" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -2] 

	groupBox 'grp_02' " Decal: " width:(rlt_catalog_tools.width - 8) height:108 align:#center offset:[0, 4]
	checkbutton 'btn_create_icon' "Decal Creation Mode" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, -93] enabled:false
	button 'btn_reset' "Reset" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] enabled:false across:2
	checkbutton 'btn_show' "Hide Work Layer" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] checked:true enabled:false
	button 'btn_render' "Render" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_2 align:#center offset:[1, V_MARGIN] enabled:false
	button 'btn_fit' "Fit" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false visible:false

	-- Не используются!
	button 'btn_save' "Save as Default Decal for Category" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_2 align:#center offset:[-2, V_MARGIN] enabled:false  visible:false
	button 'btn_create_sel_set' "Create Select Set" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false visible:false
    dropdownlist 'lst_sel_sets' "" items:SELECTION_SET_NAMES width:CTRL_WIDTH_02 height:50 offset:[4, V_MARGIN] align:#center selection:1 enabled:false visible:false
	spinner 'spn_w' "Width:" width:CTRL_WIDTH_02 fieldWidth:56 offset:[5, 3] range:[ConvertCentimeterToSysUnits 10.0, ConvertCentimeterToSysUnits 500.0, ConvertCentimeterToSysUnits 100.0] type:#WorldUnits fieldwidth:50 align:#left across:2 enabled:false visible:false
	spinner 'spn_d' "Depth:" width:CTRL_WIDTH_02 fieldWidth:56 offset:[4, -1] range:[ConvertCentimeterToSysUnits 10.0, ConvertCentimeterToSysUnits 500.0, ConvertCentimeterToSysUnits 100.0] type:#WorldUnits fieldwidth:50 align:#left across:2 enabled:false visible:false

	local icon_controls = #(btn_create_sel_set, btn_reset, btn_show, lst_sel_sets, spn_w, btn_fit, spn_d, btn_render, btn_save)
	local icon_layer = undefined
	local layer_nodes = #()

	fn getViewCoordSys =
	(
		local coordSysTM = undefined
		local result = #()
		
		coordSysTM = Inverse(viewport.GetTM())
		coordSysTM.row3 *= -1

		for i = 1 to 3 do
		(
			local val = coordSysTM[i]
			local max_num = 0
			local max_num_index = undefined
			local new_vector = [0, 0, 0]
				
			for k = 1 to 3 where abs val[k] > abs max_num do
			(	
				max_num = val[k]		
				max_num_index = k
			)
			
			new_vector[max_num_index] = floor (max_num + 0.5)
			append result new_vector
		)
		
		return result
	)

	fn ConvertSelectedToVerts obj =
	(
		local verts = BitArray()
		
		if obj != undefined then
		(
			obj = snapshotAsMesh obj
			
			case subobjectLevel of
			(
				undefined:(verts = #{1..(getNumVerts obj)})
				0:(verts = #{1..(getNumVerts obj)})
				1:(verts = getVertSelection obj)
				2:(verts = meshop.getVertsUsingEdge obj (getEdgeSelection obj))
				3:(verts = meshop.getVertsUsingEdge obj (getFaceSelection obj))
				4:(verts = meshop.getVertsUsingFace obj (getFaceSelection obj))
				5:(verts = meshop.getVertsUsingFace obj (getFaceSelection obj))
			)
		)

		return verts
	)

	fn MinOfSelected obj =
	(
		local verts = ConvertSelectedToVerts obj
		local sel_min = undefined
		
		if obj != undefined and verts.count != 0 then
		(
			obj = snapshotAsMesh obj
			local sel_min = meshop.getVert obj (verts as array)[1]
			
			for i in verts do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x < sel_min.x then sel_min.x = vert_pos.x
				if vert_pos.y < sel_min.y then sel_min.y = vert_pos.y
				if vert_pos.z < sel_min.z then sel_min.z = vert_pos.z
			)
		)
		
		return sel_min
	)
	
	fn MaxOfSelected obj =
	(
		local verts = ConvertSelectedToVerts obj
		local sel_max = undefined
		
		if obj != undefined and verts.count != 0 then
		(
			obj = snapshotAsMesh obj
			local sel_max = meshop.getVert obj (verts as array)[1]
			
			for i in verts do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x > sel_max.x then sel_max.x = vert_pos.x
				if vert_pos.y > sel_max.y then sel_max.y = vert_pos.y
				if vert_pos.z > sel_max.z then sel_max.z = vert_pos.z
			)
		)
		
		return sel_max
	)
	
	fn MinByGeom obj =
	(
		local sel_min = undefined
		
		if obj != undefined then
		(
			obj = snapshotAsMesh obj
			local verts_count = getNumVerts obj
			local sel_min = meshop.getVert obj 1
			
			for i = 1 to verts_count do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x < sel_min.x then sel_min.x = vert_pos.x
				if vert_pos.y < sel_min.y then sel_min.y = vert_pos.y
				if vert_pos.z < sel_min.z then sel_min.z = vert_pos.z
			)
		)
		
		return sel_min
	)

	fn MaxByGeom obj =
	(
		local sel_max = undefined
		
		if obj != undefined then
		(
			obj = snapshotAsMesh obj
			local verts_count = getNumVerts obj
			local sel_max = meshop.getVert obj 1
			
			for i = 1 to verts_count do
			(
				vert_pos = meshop.getVert obj i
				if vert_pos.x > sel_max.x then sel_max.x = vert_pos.x
				if vert_pos.y > sel_max.y then sel_max.y = vert_pos.y
				if vert_pos.z > sel_max.z then sel_max.z = vert_pos.z
			)
		)
		
		return sel_max
	)
	
	fn AlignSplineKnots spl bound_box dir = 
	(
		case dir of
		(
			#left:(MoveSlineSelectedKnots spl [0, bound_box.max.y - spl.max.y, 0])
			#right:(MoveSlineSelectedKnots spl [0, bound_box.min.y - spl.min.y, 0])
			#up:(MoveSlineSelectedKnots spl [bound_box.max.x - spl.max.x, 0, 0])
			#down:(MoveSlineSelectedKnots spl [bound_box.min.x - spl.min.x, 0, 0])
		)
		completeRedraw()
	)

	fn AlignBoundings obj bound_box dir =
	(
		local vcs = getViewCoordSys()
		local move_dist = [0,0,0]
		local val = undefined

		case dir of
		(
			#left:(
				if keyboard.shiftPressed then
				(

				)
				else if keyboard.controlPressed then
				(

				)
				else if keyboard.altPressed then
				(

				)
				else
				(
					if (vcs[1].x +  vcs[1].y +  vcs[1].z) > 0 then
					(
						if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) 
						else if subobjectLevel > 0 then val = (MinOfSelected obj)
						move_dist = ((bound_box.min * vcs[1])-(val * vcs[1]))
					)
					else 
					(
						if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
						move_dist = ((((bound_box.max * vcs[1])-(val * vcs[1]))) * -1)
					)
				)
			)
			#right:(
				if (vcs[1].x +  vcs[1].y +  vcs[1].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((bound_box.max * vcs[1])-(val * vcs[1]))	
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) else val = (MinOfSelected obj)
					move_dist = ((((bound_box.min * vcs[1])-(val * vcs[1]))) * -1)
				)
			)
			#up:(
				if (vcs[2].x +  vcs[2].y +  vcs[2].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((bound_box.max * vcs[2])-(val * vcs[2]))
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) else val = (MinOfSelected obj)
					move_dist = ((((bound_box.min * vcs[2])-(val * vcs[2]))) * -1)
				)
			)
			#down:(
				if (vcs[2].x +  vcs[2].y +  vcs[2].z) > 0 then
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MinByGeom obj) else val = (MinOfSelected obj)
					move_dist = ((bound_box.min * vcs[2])-(val * vcs[2]))
				)
				else 
				(
					if subobjectLevel == 0 or subobjectLevel == undefined then val = (MaxByGeom obj) else val = (MaxOfSelected obj)
					move_dist = ((((bound_box.max * vcs[2])-(val * vcs[2]))) * -1)
				)
                CompleteRedraw()
			)
			#center:(
				if subobjectLevel == 0 or subobjectLevel == undefined then val = (((MaxByGeom obj) + (MinByGeom obj))/2) else val = (((MaxOfSelected obj) + (MinOfSelected obj))/2)
				move_dist = bound_box.center - val
			)
			#vcenter:(
				if subobjectLevel == 0 or subobjectLevel == undefined then val = (((MaxByGeom obj) + (MinByGeom obj))/2) else val = (((MaxOfSelected obj) + (MinOfSelected obj))/2)
				if (vcs[2].x +  vcs[2].y +  vcs[2].z) > 0 then
				move_dist = ((bound_box.center * vcs[2])-(val * vcs[2]))
				else move_dist = ((((bound_box.center * vcs[2])-(val * vcs[2]))) * -1)
			)
			#hcenter:(
				if subobjectLevel == 0 or subobjectLevel == undefined then val = (((MaxByGeom obj) + (MinByGeom obj))/2) else val = (((MaxOfSelected obj) + (MinOfSelected obj))/2)
				if (vcs[1].x +  vcs[1].y +  vcs[1].z) > 0 then 
				move_dist = ((bound_box.center * vcs[1])-(val * vcs[1]))
				else move_dist = ((((bound_box.center * vcs[1])-(val * vcs[1]))) * -1)
			)
		)

		case superClassOf obj of
		(
			GeometryClass:(
				if subobjectLevel == 0 or subobjectLevel == undefined then (move obj move_dist)
				case classOf obj of
				(
					Editable_Poly:(
							if subobjectLevel > 0 then (
								if obj.useSoftSel == off then polyop.moveVert obj (ConvertSelectedToVerts obj) move_dist
								else polyop.moveVert obj #all move_dist useSoftSel:true
							)
						)
					Editable_mesh:(
							if subobjectLevel > 0 then (
								if meshop.getSoftSel obj == off then meshop.moveVert obj (ConvertSelectedToVerts obj) move_dist
								else (meshop.moveVert obj #all useSoftSel:true; update obj)
							)
						)
				)				
			)
			Shape:(
				if subobjectLevel == 0 or subobjectLevel == undefined then (move obj move_dist)
-- 				else if subobjectLevel == 1 then
-- 				(
-- 					getKnotSelection <shape> <spline_index_integer>
-- 					setKnotPoint obj 1 1 move_dist
-- 				)
			)
		)
	)
    on rlt_catalog_tools open do
    (
		try (GetINISettings rlt_catalog_tools MDT_CONFIG_FILE rlt_catalog_tools.name onlyRollState:true) catch()
        rlt_catalog_tools.height = 240
    )

    on btn_up pressed do (
		case MD_Data.edit_icon_mode of 
		(
			-- true:(try MD_Data.ActiveCategoryIcon.SetNamedSelSet SELECTION_SET_NAMES[3] catch())
			true:(AlignSplineKnots MD_Data.ActiveCategoryIcon.Icon MD_BBox.bb #up)
			false:(
				undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #up catch(); CompleteRedraw())
			)
		)
	)
	
	on btn_down pressed do (
		case MD_Data.edit_icon_mode of 
		(
			-- true:(try MD_Data.ActiveCategoryIcon.SetNamedSelSet SELECTION_SET_NAMES[4] catch())
			true:(AlignSplineKnots MD_Data.ActiveCategoryIcon.Icon MD_BBox.bb #down)
			false:(
				undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #down catch(); CompleteRedraw())
			)
		)
	)
	
    on btn_left pressed do (
		case MD_Data.edit_icon_mode of 
		(
			-- true:(try MD_Data.ActiveCategoryIcon.SetNamedSelSet SELECTION_SET_NAMES[1] catch())
			true:(AlignSplineKnots MD_Data.ActiveCategoryIcon.Icon MD_BBox.bb #left) 
			false:(
				undo on for o in selection do (try AlignBoundings o MD_BBox.bb #left catch(); CompleteRedraw())
			)
		)
	)

	on btn_right pressed do (
		case MD_Data.edit_icon_mode of 
		(
			-- true:(try MD_Data.ActiveCategoryIcon.SetNamedSelSet SELECTION_SET_NAMES[2] catch())
			true:(AlignSplineKnots MD_Data.ActiveCategoryIcon.Icon MD_BBox.bb #right)
			false:(
				undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #right catch(); CompleteRedraw())
			)
		)
	)
		
	on btn_up rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #vcenter catch(); CompleteRedraw()))
	
	on btn_down rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #vcenter catch(); CompleteRedraw()))
		
	on btn_left rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #hcenter catch(); CompleteRedraw()))
	
	on btn_right rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #hcenter catch(); CompleteRedraw()))
		
	on btn_center pressed do (
		case MD_Data.edit_icon_mode of 
		(
			true:(try FixObject MD_Data.ActiveCategoryIcon.Icon catch())
			false:(
				undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #center catch(); CompleteRedraw())
			)
		)
	)

	on btn_create_icon changed arg do
	(
		if MD_Data.InWorkTask != undefined and MD_Data.InWorkTask == MD_Data.ActiveTask then
		(
			try destroyDialog MD_UI.Dialogs.EditMaterial catch()
			try destroyDialog MD_UI.Dialogs.Export catch()
			btn_show.checked = true
			btn_show.text = "Hide Work Layer"

			case arg of
			(
				true:(
					MD_Data.ActiveCategoryIcon.SetEditIconMode arg
					for ctrl in icon_controls do ctrl.enabled = true
					
					MD_Data.ShowLayers mode:#work_only
					MD_BBox.Layer.lock = false
					MD_Data.WorkLayer.lock = true
					MD_Data.InWorkTask.ActiveMeshIndex = 2
					MD_UI.GeneralCatalogRoll.SwitchMeshes()
					MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
					for obj in MD_Data.WorkLayerNodes do (
						obj.xray = true
						obj.showFrozenInGray = true
					)
					
					-- MD_Data.InWorkTask.MainMesh.xray = true

					-- if MD_Data.InWorkTask.Icon == undefined then
					-- (
						-- Установить иконку (декаль)
						local main_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File) 
						local task_decal_file = pathConfig.appendPath main_dir (MD_Data.ActiveTask.Article + (ICON_POSTFIX + ".max"))

						if (DoesFileExist task_decal_file) then
						MD_Data.ActiveCategoryIcon.SetIcon task_decal_file
						else MD_Data.ActiveCategoryIcon.New()

						MD_Data.ActiveCategoryIcon.Icon.IsHidden = false
						completeRedraw()

						MD_Data.InWorkTask.Icon = MD_Data.ActiveCategoryIcon.Icon
					-- )
				)
				false:(
					try MD_Data.ActiveCategoryIcon.Destruct() catch()
					try MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory]) catch()
					-- local icon_file = pathConfig.appendPath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
					-- try MD_Data.ActiveCategoryIcon.Create icon_file catch()
					for ctrl in icon_controls do ctrl.enabled = false
					try MD_Data.ActiveCategoryIcon.SetEditIconMode arg catch()
					spn_w.value = ConvertCentimeterToSysUnits 100.0
					spn_d.value = ConvertCentimeterToSysUnits 100.0
					MD_Data.WorkLayerNodes = GetAllLayerNodes MD_Data.WorkLayer.Name
					for obj in MD_Data.WorkLayerNodes do 
					(
						obj.xray = false
						obj.showFrozenInGray = false
						obj.isFrozen = false
					)
					MD_Data.ShowLayers mode:#work_only
					MD_Data.WorkLayer.lock = false
					-- MD_Data.InWorkTask.MainMesh.xray = false
				)
			)

			MD_Data.edit_icon_mode = arg
			EnableSceneRedraw()
			completeRedraw()
		)else btn_create_icon.checked = false
	)

	on btn_reset pressed do 
	(
		try MD_Data.ActiveCategoryIcon.Destruct() catch()

		-- if MD_Data.InWorkTask.Icon == undefined then
		-- (
			-- Установить иконку (декаль)
			local main_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File) 
			local task_decal_file = pathConfig.appendPath main_dir (MD_Data.ActiveTask.Article + (ICON_POSTFIX + ".max"))

			if (DoesFileExist task_decal_file) then
			MD_Data.ActiveCategoryIcon.SetIcon task_decal_file
			else MD_Data.ActiveCategoryIcon.New()
			MD_Data.ActiveCategoryIcon.Icon.IsHidden = false
			completeRedraw()

			MD_Data.InWorkTask.Icon = MD_Data.ActiveCategoryIcon.Icon
		-- )
	)

	on btn_create_sel_set pressed do 
	(
		try MD_Data.ActiveCategoryIcon.SetNamedSelSet lst_sel_sets.items[lst_sel_sets.selection] catch()
	)

	on spn_w changed arg do (MD_BBox.bb.length = arg; completeRedraw())

	on spn_d changed arg do 
	(
		MD_BBox.bb.width = arg
		arrow_offset = ConvertCentimeterToSysUnits 10.0
		arrow_rad = ConvertCentimeterToSysUnits 20.0
		MD_BBox.arrow.radius = arrow_rad
		MD_BBox.arrow.pos.x = (MD_BBox.bb.width/2.0 + arrow_rad/2.0 + arrow_offset)

		completeRedraw()
	)

	on btn_fit pressed do (
		undo on
		MD_Data.ActiveCategoryIcon.Icon.Pivot = MD_Data.ActiveCategoryIcon.Icon.Center
		MD_Data.ActiveCategoryIcon.Icon.Pos = [0, 0, 0]
		try MD_Data.ActiveCategoryIcon.FitSizeToBBox MD_BBox.bb catch()

		completeRedraw()
	)

	on btn_render pressed do (
		-- try MD_Data.ActiveCategoryIcon.IconRender MD_Data.ActiveCategoryIcon.Icon catch()
		-- Рендер иконки
		if MD_Data.ActiveCategoryIcon.Icon != undefined then
		(
			local frame_size = MAX_TEX_SIZE / 16
			local max_size = amax #(MD_Data.InWorkTask.Size[1], MD_Data.InWorkTask.Size[2])
			local icon_out_file = "T_" + MD_Data.InWorkTask.Article + TEXTURES_SIFFIXES[7]

			if max_size >= (ConvertCentimeterToSysUnits 200.0) then frame_size = MAX_TEX_SIZE / 2
			else if max_size >= (ConvertCentimeterToSysUnits 100.0) then frame_size = MAX_TEX_SIZE / 4
			else if max_size >= (ConvertCentimeterToSysUnits 50.0) then frame_size = MAX_TEX_SIZE / 8

			MD_Data.WorkLayer.on = false

			icon_out_file = pathconfig.appendpath (pathconfig.removePathLeaf MD_Data.InWorkTask.InWorkDir) icon_out_file
			try (
				MD_Data.ActiveCategoryIcon.IconRender MD_Data.ActiveCategoryIcon.Icon frame_size:frame_size out_file:icon_out_file
			)catch()

			local main_dir = pathConfig.removePathLeaf (getFilenamePath MD_Data.ActiveTask.File) 
			local task_decal_file = pathConfig.appendPath main_dir (MD_Data.ActiveTask.Article + (ICON_POSTFIX + ".max"))
			SaveSelectedObjects #(MD_Data.ActiveCategoryIcon.Icon) task_decal_file

			MD_Data.WorkLayer.on = true
			EnableSceneRedraw()
			completeRedraw()
		)
	)

	on btn_save pressed do (
		-- Сохранить дефолтную иконку для текущей категории
		local file_path = (pathconfig.appendpath DECALS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max")))
		gc()
		save_nodes MD_Data.ActiveCategoryIcon.Icon file_path
	)

	on btn_show changed arg do
	(
		MD_Data.WorkLayer.on = arg
		completeRedraw()
		case arg of 
		(
			true:(btn_show.text = "Hide Work Layer")
			false:(btn_show.text = "Show Work Layer")
		)
	)
)