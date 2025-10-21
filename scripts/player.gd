extends CharacterBody2D

@export var HP = 200
@export var immune_time = 0.3

@onready var player_animation = $AnimatedSprite2D

const SPEED = 300.0
var immune = false

func _ready() -> void:
	player_animation.animation = "idle"
	player_animation.play()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	if $AttackImmunityTimer.is_stopped():
		immune = false
	
	if immune:
		$AnimatedSprite2D.modulate = Color(1, 0, 0)
	else:
		$AnimatedSprite2D.modulate = Color(1, 1, 1)
	
	var is_attacking = player_animation.animation == "attack1" and player_animation.is_playing()
	var flipped = player_animation.flip_h
	# Movement animation
	if not is_attacking:
		$Attack/Hitbox.set_deferred("disabled", true)
		if velocity == Vector2.ZERO:
			player_animation.animation = "idle"
		else:
			player_animation.animation = "run"
			player_animation.flip_h = velocity.x < 0
	
	# Attack
	var attack = Input.is_action_pressed("ui_attack")
	if attack:
		player_animation.animation = "attack1"
		$Attack/Hitbox.set_deferred("disabled", false)
	if flipped != player_animation.flip_h:
		$Attack/Hitbox.position.x *= -1
		
	player_animation.play()

func trigger_damage() -> bool:
	if not immune:
		$AttackImmunityTimer.start(immune_time)
		immune = true
		HP -= 20
		return true
	return false
