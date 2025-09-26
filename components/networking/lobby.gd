extends Node

const LOCALHOST := "127.0.0.1"
const PORT := 7986
const MAX_CONNECTIONS := 4

signal peer_connected(id: int, data: Dictionary)
signal peer_disconnected(id: int)
signal lobby_left


var local_data: Dictionary[String, Variant] = {
	"name": "",
}
var players: Dictionary[int, Dictionary] = {}

func _ready() -> void:
	multiplayer.peer_connected.connect(_peer_connected)
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.connection_failed.connect(quit)
	multiplayer.connected_to_server.connect(_connected_to_server)
	multiplayer.server_disconnected.connect(quit)

func host_game() -> Error:
	var peer = ENetMultiplayerPeer.new()
	var err := peer.create_server(PORT, MAX_CONNECTIONS) ; if err: return err
	multiplayer.multiplayer_peer = peer
	players[1] = local_data

	return OK

func join_game(ip: String = "") -> Error:
	var peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(ip if ip else LOCALHOST, PORT) ; if err: return err
	multiplayer.multiplayer_peer = peer

	return OK

func quit() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players.clear()
	lobby_left.emit()

@rpc("any_peer", "reliable") func _register_player(data):
	var id = multiplayer.get_remote_sender_id()
	players[id] = data
	peer_connected.emit(id, data)


#region signal funcs

func _peer_connected(id: int) -> void:
	_register_player.rpc_id(id, local_data)

func _connected_to_server() -> void:
	players[multiplayer.get_unique_id()] = local_data

func _peer_disconnected(id: int) -> void:
	players.erase(id)
	peer_disconnected.emit(id)
#endregion
