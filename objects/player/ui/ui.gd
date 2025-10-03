class_name UI extends Control

static var node: UI

@onready var self_ui: Control = $Self
@onready var opp_ui: Control = $Opp

func _ready() -> void:
	node = self
	Lobby.peer_connected.connect(_peer_connected, CONNECT_DEFERRED)
	_peer_connected()

func _peer_connected(_id: int = -1, _data: Dictionary = {}) -> void:
	for i in get_tree().get_nodes_in_group(&"player"):
		if i.is_multiplayer_authority():
			%SelfLabel.text = Lobby.players[i.get_multiplayer_authority()].name
		else:
			%OppLabel.text = Lobby.players[i.get_multiplayer_authority()].name

@rpc("any_peer", "call_local", "reliable")
func display_my_health(hp: int) -> void:
	var remote = multiplayer.get_remote_sender_id()
	var self_id = multiplayer.get_unique_id()

	var ui = self_ui if remote == self_id else opp_ui
	ui.get_node(^"AnimationPlayer").play(&"hurt")
	for i in 3:
		i += 1
		var anim : AnimationPlayer = ui.get_node("Hp%d/AnimationPlayer" % i)
		if i <= hp:
			if anim.current_animation != &"shown":
				anim.play(&"show")
				anim.queue(&"shown")
		else:
			if anim.current_animation != &"hidden":
				anim.play(&"hide")
				anim.queue(&"hidden")
