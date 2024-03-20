from asyncio.windows_events import NULL
from genericpath import exists
from unicodedata import name
import unreal
import json
import os

# import pathlib
editor_level_sys = unreal.LevelEditorSubsystem()
editor_actor_sys = unreal.EditorActorSubsystem()
filter = unreal.EditorFilterLibrary()
asset_lib = unreal.EditorAssetLibrary()
zero_location = unreal.Vector(0.0, 0.0, 0.0)
zero_rotation = unreal.Rotator(0.0, 0.0, 0.0)

def import_texture(texture_path, asset_name, asset_path):
    asset_tools = unreal.AssetToolsHelpers.get_asset_tools()
    import_task = unreal.AssetImportTask()
    import_task.filename = texture_path
    import_task.automated = True # Блокировка вызова окна свойств импорта
    import_task.replace_existing = True # Перезапись существующих активов
    import_task.save = True
    asset_tools.import_asset_tasks([import_task])
    asset_tools.create_asset(asset_name, asset_path, unreal.Texture2D, unreal.ReimportTextureFactory())
    
def import_fbx(fbx_path, asset_path, lods = False):
    '''
    description:
        Импорт fbx файла
    parameters:
        str fbx_path: Путь к fbx файлу
        str asset_path: Полный путь ассета с именем
        bool lods:  Наличие лодов
    return:
        unreal.load_asset
    '''
    # Создать задание для импорта
    import_task = unreal.AssetImportTask()

    # Устанавливаем базовые параметры для импорта
    import_task.filename = fbx_path
    import_task.destination_path = os.path.dirname(asset_path)
    import_task.destination_name = os.path.basename(asset_path)
    import_task.automated = True # Блокировка вызова окна свойств импорта
    import_task.replace_existing = True # Перезапись существующих активов
    import_task.save = True  
    # import_task.replace_existing_settings = False 

    # Устанавливаем параметры для импорта static mesh
    import_task.options = set_static_mesh_import_data(lods)

    # Импорт статик меша
    asset_tools = unreal.AssetToolsHelpers.get_asset_tools()
    asset_tools.import_asset_tasks([import_task])
    imported_asset = import_task.get_editor_property('imported_object_paths')

    if not imported_asset:
        unreal.log_warning('No asset were imported!')
    else:
        asset = unreal.load_asset(imported_asset[0])

        # save_asset(asset)
        return asset

def set_static_mesh_import_data(lods = False):
    '''
    description:
        Задаёт параметры импорта fbx файла
    parameters:
        bool lods: Наличие лодов
    return:
        unreal.FbxImportUI
    '''
    import_options = unreal.FbxImportUI()
    sm_import_options = unreal.FbxStaticMeshImportData()

    # Задаём базовые параметры импорта
    import_options.import_as_skeletal = False
    import_options.mesh_type_to_import = unreal.FBXImportType.FBXIT_STATIC_MESH
    import_options.import_materials = False
    import_options.import_textures = False

    # Задаём параметры импорта для объетов типа static mesh
    sm_import_options.generate_lightmap_u_vs = False
    sm_import_options.convert_scene = True
    sm_import_options.convert_scene_unit = True
    sm_import_options.normal_import_method = unreal.FBXNormalImportMethod.FBXNIM_IMPORT_NORMALS_AND_TANGENTS
    sm_import_options.import_mesh_lo_ds = lods
    sm_import_options.vertex_color_import_option = unreal.VertexColorImportOption.REPLACE
    # Так же можно установить параметры таким способом:
    # import_options.static_mesh_import_data.generate_lightmap_u_vs = False

    import_options.static_mesh_import_data = sm_import_options
    return import_options


def set_meta_tag_on_asset(asset, tags):
    for tag in tags:
        asset_lib.set_metadata_tag(asset, tag, tags[tag])
    # save_asset(asset)

def get_meta_tag_on_asset(asset, tag):
    return asset_lib.get_metadata_tag(asset, tag)

def save_asset(asset):
    asset_lib.save_loaded_asset(asset, False)

# Создать эктора на основе ассета
def spawn_actor_from_asset(asset_path, loc_data, rot_data):
    actor_class = asset_lib.load_asset(asset_path)
    actor_location = unreal.Vector(float(loc_data[0]), float(loc_data[1]), float(loc_data[2]))
    actor_rotation = unreal.Rotator(float(rot_data[0]), float(rot_data[1]), float(rot_data[2]))
    actor = editor_actor_sys.spawn_actor_from_object(actor_class, actor_location, actor_rotation)
    return actor

# Задать трансформации эктору
def set_actor_data(actor, loc_data, rot_data, scl_data, folder):
    actor_location = unreal.Vector(float(loc_data[0]), float(loc_data[1]), float(loc_data[2]))
    actor_rotation = unreal.Rotator(float(rot_data[0]), float(rot_data[1]), float(rot_data[2]))
    actor_scale = unreal.Vector(float(scl_data[0]), float(scl_data[1]), float(scl_data[2]))
    new_transform = unreal.Transform(actor_location, actor_rotation, actor_scale)
    if actor.get_actor_transform() != new_transform:
        actor.set_actor_transform ( new_transform , False , True )
    # if actor.get_actor_label() != label:
    #     actor.set_actor_label(label)
    if actor.get_folder_path() != folder:
        actor.set_folder_path(folder)

# Задать тэги для эктора
def set_actor_tags(actor, tag0, tag1, tag2 = 'unlock'):
    tags = actor.get_editor_property('tags')
    if len(tags) > 0:
        tags[0] = tag0
        tags[1] = str(tag1)
        tags[2] = tag2
    else:
        tags = []
        tags.append(tag0)
        tags.append(str(tag1))
        tags.append(tag2)
    actor.set_editor_property('tags', tags)
    
# Считать данные из файла json
def get_json_data(data_file):
    with open(data_file) as file:
        data = json.load(file)
    return data
    
# Записать данные в файл json
def set_json_data(data, data_file):
	data = json.dumps(data)
	data = json.loads(str(data))
	with open(data_file, 'w', encoding = 'utf-8') as file:
		json.dump(data, file, indent = 4)

def main():
    level_actors = editor_actor_sys.get_all_level_actors()
    # script_dir = pathlib.Path(__file__).parent.resolve()                      # Путь к текущему python файлу 
    stub_actor_path = '/Engine/BasicShapes/Cube'                                # Путь к мэшу - "заглушке"
    my_documens_folder = os.path.expanduser(' \\Documents')                     # Путь к системной папке MyDocuments
    common_data_directory = my_documens_folder + '\\StanzzaToolsDataFiles\\'    # Путь к общей директории StanzzaToolsDataFiles
    max_data_file = common_data_directory + 'MaxData.json'                      # Путь к максовскому json файлу
    text_label = "Importer is working!"
    scatter_asset_path = '/Game/BaseContent/Blueprints/BP_Scatter'
    scatter_asset = asset_lib.load_asset(scatter_asset_path)

    data = get_json_data(max_data_file)
    total_count = len(data['geometry'])
    imported_assets = []
    asset = unreal.AssetData()
    actor = unreal.Actor()
    actor.modify(True)

    with unreal.ScopedSlowTask(total_count, text_label) as slow_task:
        slow_task.make_dialog(True)
        i = 0

        for geom in data['geometry']:
            asset_exist = asset_lib.does_asset_exist(geom['asset_path'])   
            
            if asset_exist:
                asset = asset_lib.find_asset_data(geom['asset_path']).get_asset()
                reimport_asset_tag = get_meta_tag_on_asset(asset, 'reimport_count')

                if reimport_asset_tag == "":
                    reimport_asset_tag = 0
                else:
                    reimport_asset_tag = int(str(reimport_asset_tag))
                
                if geom['reimport_count'] > reimport_asset_tag:
                    if not geom['is_basic']:
                        asset = import_fbx(geom['fbx_path'], geom['asset_path'], geom['lods'])
                        imported_assets.append(asset)
            else:
                asset = import_fbx(geom['fbx_path'], geom['asset_path'], geom['lods'])
                imported_assets.append(asset)
                
            set_meta_tag_on_asset(asset, {'reimport_count': str(geom['reimport_count'])})

            filter_actors = filter.by_actor_tag(level_actors, unreal.Name(geom['asset_path']))
            inst_count = geom['instances_count']

            if len(list(filter_actors)) > 0:
                actor = filter_actors[0]
                actor_tags = actor.get_editor_property('tags')

                if inst_count == 0:
                    if len(actor_tags) > 0:
                        if actor_tags[2] == 'unlock':
                            set_actor_data(actor, geom['location'], geom['rotation'], geom['scale'], geom['folder'])
                            actor.set_folder_path(geom['folder'])
                    if geom['color_id'] != None:
                        id = geom['color_id']
                        comp = actor.root_component
                        comp.set_custom_primitive_data_float(0, id)
                    # if geom['basecolor']:
                    #     bc = geom['basecolor']
                    #     comp = actor.root_component
                    #     clr = unreal.Vector(bc[0], bc[1], bc[2])
                    #     comp.set_vector_parameter_value_on_materials(unreal.Name('Base Color'), clr)
                else:
                    if len(actor_tags) > 0:
                        if actor_tags[2] == 'unlock':
                            arr_inst = unreal.Array(unreal.Transform)
                            for tr in geom['instances_transforms']:
                                loc = unreal.Vector(tr['loc'][0], tr['loc'][1], tr['loc'][2])
                                rot = unreal.Rotator(tr['rot'][0], tr['rot'][1], tr['rot'][2])
                                scl = unreal.Vector(tr['scl'][0], tr['scl'][1], tr['scl'][2])
                                tr = unreal.Transform(loc, rot, scl)
                                arr_inst.append(tr)
                            scatter_root_comp = actor.root_component
                            try:
                                exist_count = scatter_root_comp.get_instance_count()
                                if inst_count == exist_count:
                                    scatter_root_comp.batch_update_instances_transforms(0, arr_inst, world_space=True, mark_render_state_dirty=True, teleport=True)
                                    actor.set_folder_path(geom['folder'])
                                else:
                                    scatter_root_comp.clear_instances()
                                    scatter_root_comp.add_instances(arr_inst, True)
                            except:
                                pass
            else:
                if inst_count == 0:
                    actor = spawn_actor_from_asset(geom['asset_path'], geom['location'], geom['rotation'])
                    set_actor_data(actor, geom['location'], geom['rotation'], geom['scale'], geom['folder'])
                    set_actor_tags(actor, geom['asset_path'], geom['actor_changes'])
                    if geom['color_id'] != None:
                        id = geom['color_id']
                        comp = actor.root_component
                        comp.set_custom_primitive_data_float(0, id)
                    # bc = geom['basecolor']
                    # if bc:
                    #     comp = actor.root_component
                    #     clr = unreal.Vector(bc[0], bc[1], bc[2])
                    #     try:
                    #         comp.set_vector_parameter_value_on_materials(unreal.Name('Base Color'), clr)
                    #     except:
                    #         unreal.log_warning("Base Color didn't change!")

                if inst_count > 0 and geom['as_hisma'] == True:
                    actor = editor_actor_sys.spawn_actor_from_object(scatter_asset, zero_location, zero_rotation)
                    # actor.set_actor_label('Foliage', mark_dirty=True)
                    actor.set_folder_path(geom['folder'])
                    scatter_root_comp = actor.root_component
                    arr_inst = unreal.Array(unreal.Transform)
                    tr = unreal.Transform()
                    for tr in geom['instances_transforms']:
                        loc = unreal.Vector(tr['loc'][0], tr['loc'][1], tr['loc'][2])
                        rot = unreal.Rotator(tr['rot'][0], tr['rot'][1], tr['rot'][2])
                        scl = unreal.Vector(tr['scl'][0], tr['scl'][1], tr['scl'][2])
                        tr = unreal.Transform(loc, rot, scl)
                        # scatter_root_comp.add_instance(tr, True)
                        arr_inst.append(tr)
                    scatter_root_comp.add_instances(arr_inst, True)
                    static_mesh = asset_lib.load_asset(geom['asset_path'])
                    scatter_root_comp.set_editor_property('static_mesh', static_mesh)
                    set_actor_tags(actor, geom['asset_path'], geom['actor_changes'])

                if inst_count > 0 and geom['as_hisma'] == False:
                    for tr in geom['instances_transforms']:
                        actor = spawn_actor_from_asset(geom['asset_path'], tr['loc'], tr['rot'])
                        set_actor_data(actor, tr['loc'], tr['rot'], tr['scl'], geom['folder'])
                        set_actor_tags(actor, geom['asset_path'], geom['actor_changes'])
                        if geom['color_id'] != None:
                            id = geom['color_id']
                            comp = actor.root_component
                            comp.set_custom_primitive_data_float(0, id)
                        # bc = geom['basecolor']
                        # if bc:
                        #     comp = actor.root_component
                        #     clr = unreal.Vector(bc[0], bc[1], bc[2])
                        #     try:
                        #         comp.set_vector_parameter_value_on_materials(unreal.Name('Base Color'), clr)
                        #     except:
                        #         unreal.log_warning("Base Color didn't change!")

            slow_task.enter_progress_frame(i + 1)

    cur_selection = editor_actor_sys.get_selected_level_actors()
    editor_actor_sys.set_selected_level_actors([])
    editor_actor_sys.set_selected_level_actors(cur_selection)

    if len(imported_assets) > 0:
        asset_lib.save_loaded_assets(imported_assets, True)
    editor_level_sys.save_all_dirty_levels()

if __name__ == "__main__":
    main()