extends Node

# спавн говна рандомно по карте, надо настройки подшаманить, взял виалы как говно

@export var vial_scene: PackedScene
@export var number_of_vials: int = 20
@export var spawn_area: Rect2 = Rect2(0, 0, 500, 500) 

func _ready():
	call_deferred("spawn_initial_vials")
	if vial_scene == null:
		return
	
	if not owner is Node2D:
		return

func spawn_initial_vials():
	for i in range(number_of_vials):
		var vial_instance = vial_scene.instantiate()
		var entities_layer = get_tree().get_first_node_in_group("entities_layer")
		entities_layer.add_child.call_deferred(vial_instance)
		var random_position = Vector2(
			randf_range(spawn_area.position.x, spawn_area.end.x),
			randf_range(spawn_area.position.y, spawn_area.end.y)
		)
		vial_instance.global_position = random_position
