
rollout rlt_utils "Tools"
(
    groupBox 'grp_02' " Transformations: " width:(rlt_utils.width - 8) height:120 align:#center offset:[0, -4]
    button 'btn_up' "▲" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -104]
	button 'btn_left' "◄" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[37, -2] across:3
	button 'btn_center' "•" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[0, -2]
    button 'btn_right' "►" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-37, -2]
	button 'btn_down' "▼" width:CTRL_MANIP_SIZE height:CTRL_MANIP_SIZE align:#center offset:[-1, -2] 

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
)