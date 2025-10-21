extends Area2D

@onready var holder = $".."
@onready var faction = get_faction(holder)

func _process(delta: float) -> void:
	if $AttackCooldown.is_stopped() and not holder.is_attacking:
		var bodies = get_overlapping_bodies()
		for body in bodies:
			if faction != get_faction(body):
				holder.trigger_attack()
				$AttackCooldown.start()

func get_faction(body):
	var groups = body.get_groups()
	if "Red" in groups:
		return "Red"
	elif "Blue" in groups:
		return "Blue"
	elif "Green" in groups:
		return "Green"
	return "Neutral"

func _on_body_entered(body: Node2D) -> void:
	print($AttackCooldown.time_left)
	
