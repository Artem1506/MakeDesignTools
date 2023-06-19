
struct TaskIcon
(
	icon = undefined,

	fn New =
	(
		mergeMAXFile ICON_TEMPLATE_FILE #deleteOldDups #useSceneMtlDups #neverReparent
		this.icon = (getLastMergedNodes())[1]
		this.icon.IsHidden = false
		setTransformLockFlags this.icon #all
		max modify mode
		modPanel.setCurrentObject this.icon.BaseObject node:this.icon
		enableShowEndRes true
	),

	fn Create icon_file =
	(
		-- local icon_file = pathConfig.appendPath SOURCE_ICONS_DIR (categ_article + (ICON_POSTFIX + ".max"))
		mergeMAXFile icon_file #deleteOldDups #useSceneMtlDups #neverReparent
		this.icon = (getLastMergedNodes())[1]
		this.icon.IsHidden = true
		setTransformLockFlags this.icon #all
	),

	fn FitSizeToBBox bbox =
	(
		local offset_d = undefined
		local offset_w = undefined

		if bbox != undefined then
		(
			offset_d = (bbox.max.x - bbox.min.x)/2 - (this.icon.max.x - this.icon.min.x)/2
			offset_w = (bbox.max.y - bbox.min.y)/2 - (this.icon.max.y - this.icon.min.y)/2					
		)

		if (bbox.max.x - bbox.min.x) != 0.0 and (bbox.max.y - bbox.min.y) != 0.0 then
		(
			MoveVertsInNamedSet this.icon "Left_side" [0.0, -offset_w, 0.0]
			MoveVertsInNamedSet this.icon "Right_side" [0.0, offset_w, 0.0]
			MoveVertsInNamedSet this.icon "Back_side" [-offset_d, 0.0, 0.0]
			MoveVertsInNamedSet this.icon "Front_side" [offset_d, 0.0, 0.0]			
		)

		CompleteRedraw()		
	),

	fn SetNamedSelSet set_name =
	(
		if classOf this.icon == Editable_Poly and subobjectLevel == 1 then
		(
			this.icon.Verts[set_name] = polyop.getVertSelection this.icon
		)
	),

	fn IconRender obj frame_size:2048 out_file:undefined frame_is_quad:false =
	(
		cur_view_tm = viewport.GetTM()
		cur_view_type = viewport.getType()
		cur_obj_state = obj.IsHidden
		-- Switch to Scanline render
		if classof renderers.current != Default_Scanline_Renderer then
		renderers.current = RendererClass.classes[1]()

		-- Prepare the environment
		useEnvironmentMap = off
		backgroundColor = color 0 0 0
		ambientColor = color 0 0 0
		lightTintColor = color 255 255 255

		-- Targa settings
		Targa.setColorDepth 16
		Targa.setCompressed true
		Targa.setAlphaSplit false

		local layer_states = #()
		local obj_cur_layer = obj.layer
		local targ_dist = ConvertCentimeterToSysUnits 100
		local obj_w = (obj.max.y - obj.min.y)
		local obj_d = (obj.max.x - obj.min.x)
		local fov = (atan ((ConvertSysUnitsToCentimeters obj_w/2.0)/targ_dist)) * 2.0
		local main_camera = undefined

		-- Save current layers states and hide them all
		for i = 0 to LayerManager.count - 1 do
		(
			lr = LayerManager.getLayer i
			append layer_states lr.ishidden
			lr.ishidden = true
		)
		obj.IsHidden = false
		-- Move icon object to the temp layer
		obj.Layer.on = true

		-- Calculate the rendering frame size
		if frame_is_quad then
		(
			renderWidth = frame_size
			renderHeight = frame_size
		)else(
			local aspect = obj_w / obj_d

			if aspect >= 1.0 then
			(
				renderWidth = frame_size
				renderHeight = (ceil ((frame_size as float)/aspect)) as integer
			)else(
				renderWidth = (ceil ((frame_size as float)*aspect)) as integer
				renderHeight = frame_size
			)		
		)

		-- Create the camera
		main_camera = Freecamera orthoProjection:true targetDistance:targ_dist fov:fov
		main_camera.transform = matrix3 [0, 1, 0] [-1, 0, 0] [0, 0, 1] [0, 0, targ_dist]

		-- Switch to the camera view
		max vpt camera
		
		if out_file != undefined then
		(
			-- Start rendering
			vfb = render outputfile:out_file vfb:true
			close vfb
		)else(
			render vfb:true
		)

		-- Recover the layers visibility state
		for i = 0 to LayerManager.count - 1 do
		(
			lr = LayerManager.getLayer i
			append layer_states lr.ishidden
			lr.ishidden = layer_states[i + 1]
		)
		
		delete main_camera
		free layer_states
		viewport.SetType cur_view_type
		viewport.SetTM cur_view_tm
		obj.IsHidden = cur_obj_state
		completeRedraw()
	),

	fn Destruct =
	(
		delete this.icon
		this.icon = undefined
		gc()
	),

	fn SetIcon icon_file =
    (
        try MD_Callbacks.Destruct() catch()
        try this.Destruct() catch()
        -- MD_Data.active_catalog_article = (MD_Data.main_categ_ids[MD_Data.ActiveCategory][MD_Data.ActiveSubCategory])
        try this.Create icon_file catch()
		try MD_Callbacks.Add() catch()

        completeRedraw()
    ),

	fn SetEditIconMode state =
	(
		case state of
		(
			true:(
				MD_Callbacks.Destruct()

				cur_view_tm = viewport.GetTM()
				cur_view_type = viewport.getType()
				max vpt iso user
				viewport.SetTM (matrix3 [0,-1,0] [1,0,0] [0,0,1] [0.0, 0.0, ConvertCentimeterToSysUnits -100.0])

				for i = 0 to LayerManager.count - 1 do
				(
					lr = LayerManager.getLayer i
					if lr != MD_BBox.Layer then lr.ishidden = true
				)

				MD_BBox.Layer.on = false
				MD_BBox.Layer.lock = false
				MD_BBox.Layer.ishidden = false
				MD_BBox.Layer.current = true
				MD_BBox.bb.isHidden = false
				MD_BBox.bb.length = ConvertCentimeterToSysUnits 100.0
				MD_BBox.bb.width = ConvertCentimeterToSysUnits 100.0
				MD_BBox.bb.height = 0.0
				arrow_offset = ConvertCentimeterToSysUnits 10.0
				arrow_rad = ConvertCentimeterToSysUnits 20.0
				MD_BBox.arrow.radius = arrow_rad
				MD_BBox.arrow.pos.x = (MD_BBox.bb.width/2.0 + arrow_rad/2.0 + arrow_offset)
				MD_BBox.bb.wireColor = CLR_BBOX_PIVOT
				MD_BBox.arrow.wireColor = CLR_BBOX_PIVOT
				completeRedraw()

				for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = false
				for ctrl in MD_UI.TasksRoll.Controls do ctrl.enabled = false
				for ctrl in MD_UI.GeneralCatalogRoll.Controls do ctrl.enabled = false
			)
			false:(
				viewport.SetType cur_view_type
				viewport.SetTM cur_view_tm

				MD_BBox.Update()
				MD_BBox.bb.wireColor = CLR_BBOX_MAIN
				MD_BBox.arrow.wireColor = CLR_BBOX_MAIN
				completeRedraw()
				
				if MD_Data.InWorkTask != undefined and MD_Data.ActiveTask != undefined and MD_Data.ActiveTask.Article == MD_Data.InWorkTask.Article then
				MD_Data.ShowLayers mode:#work_only else MD_Data.ShowLayers mode:#scene_only

				for ctrl in MD_UI.SettingsRoll.Controls do ctrl.enabled = true
				for ctrl in MD_UI.TasksRoll.Controls do ctrl.enabled = true
				MD_UI.UpdateCatalogTasksRlt()
				MD_UI.UpdateCatalogToolsRlt()

				MD_Callbacks.Add()
			)
		)
	)
)