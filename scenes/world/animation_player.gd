extends AnimationPlayer

func _ready() -> void:
	play(&"waiting_for_players")
	Lobby.peer_connected.connect(_on_peer_joined)

func _on_peer_joined(_id: int, _data: Dictionary) -> void:
	if Lobby.players.size() > 1:
		play(&"RESET")
		play(&"start")

func _on_start_anim_finished() -> void:
	if multiplayer.is_server(): BombManager.start_bombs()
