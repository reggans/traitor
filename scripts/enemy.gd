extends CharacterBody2D
class_name Enemy

@export var HP = 100
@export var immune_time = 0.3
@export var speed = 50

@onready var nav: NavigationAgent2D = $NavigationAgent2D
@onready var player: CharacterBody2D = $"../Player"
@onready var sprite_animation = $AnimatedSprite2D

var knockback = Vector2.ZERO
var immune = false
var hitbox_flipped = false
var is_attacking = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	actor_setup.call_deferred()
	nav.velocity_computed.connect(_velocity_computed)
	
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	
	$Attack/Hitbox.set_deferred("disabled", true)

func _physics_process(delta: float) -> void:
	_move_towards_player()

func _process(delta: float) -> void:
	if $AttackImmunityTimer.is_stopped():
		immune = false
	
	if immune:
		$AnimatedSprite2D.modulate = Color(1, 0, 0)
	else:
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
	
	# Movement animation
	if not is_attacking:
		if velocity == Vector2.ZERO:
			sprite_animation.animation = "idle"
		else:
			sprite_animation.animation = "run"
			sprite_animation.flip_h = velocity.x < 0
	
		sprite_animation.play()
	
	if HP <= 0:
		queue_free()
		
func trigger_damage() -> bool:
	if not immune:
		$AttackImmunityTimer.start(immune_time)
		immune = true
		HP -= 20
		return true
	return false

func trigger_attack() -> void:
	is_attacking = true
	
	# Windup animation
	sprite_animation.animation = "windup"
	#await sprite_animation.animation_finished
	#sprite_animation.stop()
	$AttackWindup.start()
	await $AttackWindup.timeout
	
	sprite_animation.animation = "attack"
	sprite_animation.play()
	
	$Attack/Hitbox.set_deferred("disabled", false)
	if hitbox_flipped != sprite_animation.flip_h:
		$Attack/Hitbox.position.x *= -1
		hitbox_flipped = not hitbox_flipped
	
	await sprite_animation.animation_finished
	is_attacking = false
	$Attack/Hitbox.set_deferred("disabled", true)

func actor_setup():
	await get_tree().physics_frame
	
	set_movement_target(player.position)

func set_movement_target(movement_target: Vector2):
	nav.target_position = movement_target
	
func _move_towards_player():
	set_movement_target(player.position)
	
	if nav.is_navigation_finished():
		return
		
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = nav.get_next_path_position()
	
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed
	
	# Compute knockback
	new_velocity += knockback
	knockback = lerp(knockback, Vector2.ZERO, 0.1)
	
	if nav.avoidance_enabled:
		nav.set_velocity(new_velocity)
	else:
		_velocity_computed(new_velocity)
	
	move_and_slide()

func _velocity_computed(safe_velocity: Vector2):
	velocity = safe_velocity
