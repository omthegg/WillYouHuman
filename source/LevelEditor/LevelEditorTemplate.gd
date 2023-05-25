extends Resource

class_name LevelEditorTemplate

export var name:String
export var scene:PackedScene
export var spawn_using_entity_spawner:bool = false
export var entity_spawner_color:Color = Color.white
export var entity_spawner_offset:Vector3 = Vector3(0, 0, 0)
export var rotation_step:int = 90 # degrees
export var y_rotation_only:bool = false # the object can only turn left and right
export var enabled:bool = true
export var editable_variables:PoolStringArray = []
