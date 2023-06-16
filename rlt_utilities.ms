
rollout rlt_utilities "Tools"
(
    groupBox 'grp_01' " Transform: " width:(rlt_utilities.width - 8) height:120 align:#center offset:[0, -4]
    button 'btn_up' "▲" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -104]
	button 'btn_left' "◄" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[37, -2] across:3
	button 'btn_center' "•" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[0, -2]
    button 'btn_right' "►" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-37, -2]
	button 'btn_down' "▼" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -2] 

	groupBox 'grp_02' " Icon: " width:(rlt_utilities.width - 8) height:146 align:#center offset:[0, 4]
	checkbutton 'btn_create_icon' "Create Icon Mode" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, -132]
	button 'btn_create_sel_set' "Create Select Set" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[-2, V_MARGIN] across:2 enabled:false
    dropdownlist 'lst_sel_sets' "" items:SELECTION_SET_NAMES width:CTRL_WIDTH_02 height:50 offset:[4, V_MARGIN] align:#center selection:1 enabled:false
	spinner 'spn_w' "Width:" width:CTRL_WIDTH_02 fieldWidth:56 offset:[5, 3] range:[ConvertCentimeterToSysUnits 10.0, ConvertCentimeterToSysUnits 500.0, ConvertCentimeterToSysUnits 100.0] type:#WorldUnits fieldwidth:50 align:#left across:2 enabled:false
	button 'btn_fit' "Fit" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, -3] enabled:false
	spinner 'spn_d' "Depth:" width:CTRL_WIDTH_02 fieldWidth:56 offset:[4, -1] range:[ConvertCentimeterToSysUnits 10.0, ConvertCentimeterToSysUnits 500.0, ConvertCentimeterToSysUnits 100.0] type:#WorldUnits fieldwidth:50 align:#left across:2 enabled:false
	button 'btn_render' "Render" width:CTRL_WIDTH_02 height:CTRL_HEIGHT_1 align:#center offset:[4, V_MARGIN] enabled:false
	button 'btn_save' "Save As Default Icon" width:CTRL_WIDTH_0 height:CTRL_HEIGHT_1 align:#center offset:[1, V_MARGIN] enabled:false

	local icon_controls = #(btn_create_sel_set, lst_sel_sets, spn_w, btn_fit, spn_d, btn_render, btn_save)
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
	
	fn AlignBoundings obj bound_box dir =
	(
		local vcs = getViewCoordSys()
		local move_dist = [0,0,0]
		local val = undefined

		case dir of
		(
			#left:(
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

    on btn_up pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #up catch(); CompleteRedraw()))
	
	on btn_down pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #down catch(); CompleteRedraw()))
	
    on btn_left pressed do (undo on for o in selection do (try AlignBoundings o MD_BBox.bb #left catch(); CompleteRedraw()))

	on btn_right pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #right catch(); CompleteRedraw()))
		
	on btn_up rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #vcenter catch(); CompleteRedraw()))
	
	on btn_down rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #vcenter catch(); CompleteRedraw()))
		
	on btn_left rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #hcenter catch(); CompleteRedraw()))
	
	on btn_right rightclick do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #hcenter catch(); CompleteRedraw()))
		
	on btn_center pressed do (undo on for obj in selection do (try AlignBoundings obj MD_BBox.bb #center catch(); CompleteRedraw()))

	on btn_create_icon changed arg do
	(
		case arg of
		(
			true:(
				MD_Data.ActiveCategoryIcon.SetEditIconMode arg
				for ctrl in icon_controls do ctrl.enabled = true
				MD_Data.ActiveCategoryIcon.New()
			)
			false:(
				MD_Data.ActiveCategoryIcon.Destruct()
				MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
				local icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (MD_Data.active_catalog_article + (ICON_POSTFIX + ".max"))
				try MD_Data.ActiveCategoryIcon.Create icon_file catch()
				for ctrl in icon_controls do ctrl.enabled = false
				MD_Data.ActiveCategoryIcon.SetEditIconMode arg
				spn_w.value = ConvertCentimeterToSysUnits 100.0
				spn_d.value = ConvertCentimeterToSysUnits 100.0
			)
		)
		completeRedraw()
		MD_Data.edit_icon_mode = arg
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
		try MD_Data.ActiveCategoryIcon.IconRender MD_Data.ActiveCategoryIcon.Icon catch()
	)

	on btn_save pressed do (
		-- Сохранить дефолтную иконку для текущей категории
		local file_path = (pathconfig.appendpath SOURCE_ICONS_DIR (MD_Data.active_catalog_article + "_icon.max"))
		gc()
		save_nodes MD_Data.ActiveCategoryIcon.Icon file_path
	)
)