extends CharacterBody2D

const MAX_SPEED = 40
@export var vial_scene: PackedScene
@onready var health_component: HealthComponent = $HealthComponent
var spawn_timer: Timer

func _ready():
	$Area2D.area_entered.connect(on_area_entered)
	setup_spawn_timer()

func _process(delta):
	var direction = get_direction_to_player()
	velocity = direction * MAX_SPEED
	move_and_slide()

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO

func on_area_entered(other_area: Area2D):
	health_component.damage(100)

# спавн какашек от лягушек, надо подшаманить частоту
func setup_spawn_timer():
	spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.connect("timeout", Callable(self, "spawn_vial"))
	start_new_spawn_timer()

func start_new_spawn_timer():
	var random_time = randf_range(5.0, 15.0)
	spawn_timer.start(random_time)

func spawn_vial():
	if vial_scene == null:
		return
	
	var vial_instance = vial_scene.instantiate() as Node2D
	get_parent().add_child(vial_instance)
	vial_instance.global_position = global_position
	
	start_new_spawn_timer()
