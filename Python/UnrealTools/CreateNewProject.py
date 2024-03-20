import unreal
import os
import pathlib
import shutil

AssetLib = unreal.EditorAssetLibrary()
# @unreal.uclass()
# class AssetLib(unreal.EditorAssetLibrary):
#     pass

# copy_asset = AssetLib().duplicate_asset('/Game/BaseContent/Maps/Day', '/Game/NewProject/Maps/Day')

# bpName = "NewLevel"
# bpPath = "/Game/NewProject/Maps"
# factory = unreal.LevelFactory()
# factory.set_editor_property("context_class", unreal.Level)
# assetTools = unreal.AssetToolsHelpers.get_asset_tools()
# myFile = assetTools.create_asset(bpName, bpPath, None, factory)
# unreal.EditorAssetLibrary.save_loaded_asset(myFile)
AssetLib.make_directory('\\Game\\NewProject\\Meshes')
AssetLib.make_directory('\\Game\\NewProject\\Materials')
AssetLib.make_directory('\\Game\\NewProject\\Textures')


my_documens_folder = os.path.expanduser('~\\Documents')
base_content_path = str(pathlib.Path(__file__).parent.resolve().parents[0]) + '\\Content\\BaseContent\\Maps'
target_path = str(pathlib.Path(__file__).parent.resolve().parents[0]) + '\\Content\\NewProject\\Maps'
files = os.listdir(base_content_path)
arr = unreal.Array(unreal.AssetData)
aaa = []
bbb = []
for f in files:
    filename = os.path.basename(f)
    f_name = filename.split('.')[0] + 'New'
    ext = filename.split('.')[1]
    source_file = base_content_path + '\\' + filename
    copy_file = target_path + '\\' + filename
    rename_file = target_path + '\\' + f_name + '.' + ext
    temp_file = my_documens_folder + '\\' + f_name + '.' + ext
    shutil.copyfile(source_file, temp_file)
    # shutil.copyfile(source_file, rename_file)
    shutil.move(temp_file, rename_file)
    ff = '\\Game\\NewProject\\Maps\\'+ f_name + '.' + ext
    ass = unreal.AssetData(ff)
    arr.append(ass)
    
    aaa.append(ff)
    ff = '\\Game\\NewProject\\Maps\\'+ filename.split('.')[0]
    bbb.append(ff)
print(aaa)   

# unreal.EditorValidatorSubsystem.validate_assets(arr)
AssetLib.sync_browser_to_objects(bbb)
for f in aaa:
    AssetLib.checkout_asset(f)
# @unreal.uclass()
# class ValidSubSys(unreal.EditorValidatorSubsystem):
#     pass
# ValidSubSys.validate_assets(unreal.EditorValidatorSubsystem(),arr)

# print(arr)
    # ff = '\\Game\\NewProject\\Maps\\'+ f_name + '.' + ext
    # unreal.EditorAssetLibrary.load_asset(ff)
    # unreal.load_object(None, ff)
    # unreal.EditorLevelLibrary.save_all_dirty_levels()
    
    # unreal.EditorValidatorBase.validate_loaded_asset(ff, validation_errors)
    # arr.append(unreal.AssetData())
# ss = unreal.EditorAssetLibrary.list_assets('\\Game\\NewProject\\Maps\\')
# unreal.EditorValidatorSubsystem.validate_assets()

    # unreal.EditorValidatorSubsystem()
    # os.rename(source_file, rename_file)
    # copyfile(item[0], os.path.join("/Users/username/Desktop/testPhotos", filename))
    # os.rename('a.txt', 'b.kml')
# print(script_dir)


