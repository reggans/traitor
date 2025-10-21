extends Area2D

@export var mob_scene: PackedScene

@onready var actor_layer = $"../../../ActorLayer"

func _on_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	mob.position = global_position
	
	actor_layer.add_child(mob)
