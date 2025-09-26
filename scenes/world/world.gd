extends Node2D

const PLAYER = preload("uid://vvtltf1wnwk0")

func _ready() -> void:
	if multiplayer.is_server():
		print("is server")
		for i in Lobby.players:
			print(i)
			var inst = PLAYER.instantiate()
			inst.name = str(i)
			%Players.add_child(inst, true)
		Lobby.peer_connected.connect(_create_player)
		Lobby.lobby_left.connect(_on_left)
	elif !multiplayer.multiplayer_peer or multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		var inst = PLAYER.instantiate()
		%Players.add_child(inst)

func _create_player(id: int, _data: Dictionary) -> void:
	var inst = PLAYER.instantiate()
	inst.name = str(id)
	%Players.add_child(inst, true)

func _on_left() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
