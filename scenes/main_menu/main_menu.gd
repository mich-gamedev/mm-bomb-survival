extends Control

func _on_host_pressed() -> void:
	await get_tree().create_timer(.25).timeout
	Lobby.local_data.name = %Name.text
	var err = Lobby.host_game()
	if err: %ErrorLabel.text = error_string(err)
	else: get_tree().change_scene_to_file("res://scenes/world/world.tscn")

func _on_join_pressed() -> void:
	await get_tree().create_timer(.25).timeout
	Lobby.local_data.name = %Name.text
	var err = Lobby.join_game(%IP.text if String(%IP.text).is_valid_ip_address() else "")
	if err: %ErrorLabel.text = error_string(err)
	else: get_tree().change_scene_to_file("res://scenes/world/world.tscn")
