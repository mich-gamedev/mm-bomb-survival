extends Control

func _on_host_pressed() -> void:
	Lobby.local_data.name = %Name.text
	Lobby.host_game()
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")

func _on_join_pressed() -> void:
	Lobby.local_data.name = %Name.text
	Lobby.join_game(%IP.text)
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")
