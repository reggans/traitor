extends StaticBody2D

@export var HP = 100
@export var immune_time = 0.3

@onready var sprite = $Sprite2D

signal destroyed
var immune = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AttackImmunityTimer.is_stopped():
		immune = false
	
	if immune:
		sprite.modulate = Color(1, 0, 0)
	else:
		sprite.modulate = Color(1, 1, 1)
	
	if HP <= 0:
		$CollisionShape2D.set_deferred("disabled", true)
		destroyed.emit()
		queue_free()

func trigger_damage() -> bool:
	if not immune:
		$AttackImmunityTimer.start(immune_time)
		immune = true
		HP -= 20
		return true
	return false
