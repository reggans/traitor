extends Area2D

@onready var holder: CharacterBody2D = $".."
var faction

const knockback_force = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	faction = get_faction(holder)
	
func _on_body_entered(body: Node2D) -> void:
	if faction != get_faction(body):
		var damaged = body.trigger_damage()
		if damaged and "knockback" in body: 	
			var direction = global_position.direction_to(body.global_position)
			var force = direction * knockback_force
			body.knockback = force

func get_faction(body):
	var groups = body.get_groups()
	if "Red" in groups:
		return "Red"
	elif "Blue" in groups:
		return "Blue"
	elif "Green" in groups:
		return "Green"
	return "Neutral"
