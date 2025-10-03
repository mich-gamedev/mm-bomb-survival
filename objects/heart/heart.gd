extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group(&"player_hitbox") and area.is_multiplayer_authority():
		if area is Hitbox:
			area.health.heal.rpc(1)
			_collected.rpc()

@rpc("any_peer", "call_local", "reliable")
func _collected():
	queue_free()
