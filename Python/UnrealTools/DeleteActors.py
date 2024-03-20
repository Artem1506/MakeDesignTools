import unreal

@unreal.uclass()
class EditorUtils(unreal.GlobalEditorUtilityBase):
    pass

selectedAssets = EditorUtils().get_selection_set()

with unreal.ScopedEditorTransaction("Delete All Actors") as trans:
    for actor in selectedAssets:
        unreal.log(actor.get_name())
        unreal.log('*********************')
        actor.destroy_actor()
        EditorUtils().clear_actor_selection_set()