extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25

@onready var health_component: HealthComponent = $HealthComponent


# Called when the node enters the scene tree for the first time.
func _ready():
	#добавил в группу, чтобы считывать урон
	add_to_group("player")
	(health_component as HealthComponent).died.connect(on_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	var target_velocity = direction * MAX_SPEED
	
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING))
	
	move_and_slide()

# returns input state
func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)

func take_damage(amount: float):
	health_component.damage(amount)

func on_died():
	print("Игрок умер")
	queue_free()
