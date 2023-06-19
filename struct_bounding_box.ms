
struct BoundingBox
(
	Layer = undefined,
	bbox_size = [0, 0, 0],
	pivot_pos = [0, 0, 0],
	bb = undefined,
	arrow = undefined,
	pp = undefined,
	clr_main = MD_UI.SettingsRoll.clr_bb_main.color,
	clr_add = MD_UI.SettingsRoll.clr_bb_add.color,
	arrow_offset = ConvertCentimeterToSysUnits 10.0,
	arrow_rad = ConvertCentimeterToSysUnits 20.0,

	fn Remove =
	(
		try(delete (execute ("$" + HELPER_OBJECTS[1] + "*")))catch()
		try(delete (execute ("$" + HELPER_OBJECTS[2] + "*")))catch()
		try(delete (execute ("$" + HELPER_OBJECTS[3] + "*")))catch()
		try(delete (execute ("$" + HELPER_OBJECTS[4] + "*")))catch()
		try(LayerManager.deleteLayerByName mdt_temp_layer)catch()

		gc()
	),

	fn CreateBBox =
	(
		-- Bounding box
		this.bb = Box name:HELPER_OBJECTS[1] length:0.0 width:0.0 height:0.0 isSelected:off
		this.arrow = Ngon name:HELPER_OBJECTS[2] radius:0.0 cornerRadius:0 nsides:3 circular:off scribe:1 pos:[0, 0, 0] isSelected:off
		this.pp = Point name:HELPER_OBJECTS[3] isSelected:off
		cur_sel = selection

		setTransformLockFlags this.bb #all
		setTransformLockFlags this.arrow #all
		setTransformLockFlags this.pp #all

		this.bb.boxmode = on
		this.bb.showFrozenInGray = this.arrow.showFrozenInGray = off
		this.bb.isFrozen = this.arrow.isFrozen = on
		this.bb.isSelected = this.arrow.isSelected = off
		this.bb.renderable = this.arrow.renderable = off
		this.bb.wireColor = this.arrow.wireColor = clr_main
		this.arrow.render_renderable = false
		this.arrow.render_useViewportSettings = false
		this.arrow.render_displayRenderMesh = false

		this.pp.centermarker = on
		this.pp.Box = off
		this.pp.cross = off
		this.pp.axistripod = off
		this.pp.drawontop = on
		this.pp.showFrozenInGray = off
		this.pp.isFrozen = on
		this.pp.wireColor = CLR_BBOX_PIVOT
		this.pp.ishidden = on

		this.Layer.addnode bb
		this.Layer.addnode arrow
		this.Layer.addnode pp

		select cur_sel
		snapMode.toFrozen = true
		completeRedraw()

		MD_Data.TempLayerNodes = GetAllLayerNodes this.Layer.Name
	),

	fn CreateLayer =
	(
		LayerManager.newLayerFromName mdt_temp_layer
		this.Layer = LayerManager.getLayerFromName mdt_temp_layer
		Layer.on = false
		Layer.lock = on
		Layer.ishidden = MD_UI.SettingsRoll.ckbx_show_bb.checked
	),

	fn WritePivotData task:MD_Data.InWorkTask =
	(
		if task != undefined then
		(
			ReadDataFile task.File
			data["pivot"] = #(
				ConvertSysUnitsToCentimeters pivot_pos[1], 
				ConvertSysUnitsToCentimeters pivot_pos[2], 
				ConvertSysUnitsToCentimeters pivot_pos[3]
			)
			WriteDataFile task.File
		)
	),
	
	fn ReadPivotData =
	(
		if MD_Data.ActiveTask != undefined then
		(
			ReadDataFile MD_Data.ActiveTask.File
			pivot_pos = [ConvertCentimeterToSysUnits data["pivot"][1], \
			ConvertCentimeterToSysUnits data["pivot"][2], \
			ConvertCentimeterToSysUnits data["pivot"][3]]
		)
	),

	fn SetPivotPos =
	(
		try(
			bb_x = [bb.min.x, bb.center.x, bb.max.x]
			bb_y = [bb.min.y, bb.center.y, bb.max.y]
			bb_z = [bb.min.z, bb.center.z, bb.max.z]

			pivot_pos = [bb_x[MD_UI.Dialogs.PivotParams.lst_x.selection], \
			bb_y[MD_UI.Dialogs.PivotParams.lst_y.selection], \
			bb_z[MD_UI.Dialogs.PivotParams.lst_z.selection]]
			
			this.pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
		)catch()
		completeRedraw()
	),

	fn ResetPivot =
	(
		try(
			pivot_pos = [0.0, 0.0, 0.0]
			this.pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]]
			WritePivotData()
		)catch()
		completeRedraw()
	),

	fn Update =
	(
		case MD_Data.ActiveSection of
		(
			1:(
				local arrow_offset = ConvertCentimeterToSysUnits 10.0
				
				try ReadPivotData() catch()
				try this.pp.pos = [pivot_pos[1], pivot_pos[2], pivot_pos[3]] 
				catch(
					Remove()
					CreateLayer()
					CreateBBox()
				)
				this.Layer.on = false
				arrow_rad = 0.0
				bbox_size = [0, 0, 0]
				this.bb.isHidden = false
				this.arrow.isHidden = false
				this.pp.isHidden = true
				this.bb.wireColor = clr_main
				this.arrow.wireColor = clr_main

				if MD_Data.InWorkTask != undefined then
				(
					case MD_Data.InWorkTask.ActiveMesh of
					(
						1:(
							bb_w = MD_Data.InWorkTask.Size[1]
							bb_d = MD_Data.InWorkTask.Size[2]
							bb_h = MD_Data.InWorkTask.Size[3]

							bbox_size = [bb_w, bb_d, bb_h]

							this.bb.wireColor = clr_main
							this.arrow.wireColor = clr_main
						)
						2:(
							bt_w = MD_Data.InWorkTask.SizeTrans[1]
							bt_d = MD_Data.InWorkTask.SizeTrans[2]
							bt_h = MD_Data.InWorkTask.SizeTrans[3]

							bbox_size = [bt_w, bt_d, bt_h]

							this.bb.wireColor = clr_add
							this.arrow.wireColor = clr_add
						)
					)

					if MD_UI.SettingsRoll.ckbx_auto_pivot.checked == true then this.pp.isHidden = false
					else this.pp.isHidden = true
					
					arrow_rad = ConvertCentimeterToSysUnits 10.0
				)
				this.Layer.on = MD_UI.SettingsRoll.ckbx_show_bb.checked

				this.bb.length = bbox_size[1]
				this.bb.width = bbox_size[2]
				this.bb.height = bbox_size[3]
				this.arrow.radius = arrow_rad
				this.arrow.pos.x = (this.bb.width/2.0 + arrow_rad/2.0 + arrow_offset)
				try (
					MD_Data.ActiveCategoryIcon.FitSizeToBBox this.bb
					MD_Data.ActiveCategoryIcon.icon.isHidden = not MD_UI.SettingsRoll.ckbx_show_icon.checked
				)catch()
			)
			2:(
				this.bb.isHidden = true
				this.arrow.isHidden = true
				this.pp.isHidden = true
			)
		)
		completeRedraw()
	),

	fn ChangeColor =
	(
		clr_main = MD_UI.SettingsRoll.clr_bb_main.color
		clr_add = MD_UI.SettingsRoll.clr_bb_add.color

		case MD_Data.ActiveTask.ActiveMesh of
		(
			1:(
				this.bb.wireColor = clr_main
				this.arrow.wireColor = clr_main
			)
			2:(
				this.bb.wireColor = clr_add
				this.arrow.wireColor = clr_add
			)
		)
		completeRedraw()
	),

	fn Init =
	(
		this.Remove()
		this.CreateLayer()
		this.CreateBBox()
	),
	on create do Init()
)