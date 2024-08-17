extends Node

signal experience_updated(current_experience: float, target_experience: float)

const TARGET_EXPERIENCE_GROWTH = 5

var current_level = 0
var target_experience = 5

var current_experience = 0
# увеличение за каждый опыт
@export var growth_factor: float = 0.01  
# макс размер 
@export var max_scale: float = 2.0  

func _ready():
	GameEvents.experience_vial_collected.connect(on_experience_vial_collected)
	
func increment_experience(number: float):
	current_experience = min(current_experience + number, target_experience)
	experience_updated.emit(current_experience, target_experience)
	if current_experience == target_experience:
		current_level += 1
		target_experience += TARGET_EXPERIENCE_GROWTH
		current_experience = 0
		experience_updated.emit(current_experience, target_experience)
	
	print(current_experience)
	increase_player_size(number)

func on_experience_vial_collected(number: float):
	increment_experience(number)

func increase_player_size(experience_gained: float):
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var new_scale = player.scale + Vector2.ONE * (experience_gained * growth_factor)
		new_scale = new_scale.clamp(Vector2.ONE, Vector2.ONE * max_scale)
		player.scale = new_scale
