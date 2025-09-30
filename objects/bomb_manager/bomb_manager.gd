extends Node

@onready var timer: Timer = $Timer

var active: bool = false
var round = 0

var bombs: Array[BombPattern]

func initialize() -> void:
	if multiplayer.is_server():
		round = 0
		const BOMB_PATH := "res://resources/bomb_pattern/res/"
		for i in ResourceLoader.list_directory(BOMB_PATH):
			if i.ends_with("/"): continue
			var resource = load(BOMB_PATH + i)
			if resource is BombPattern:
				for j in resource.likelyhood: bombs.append(resource)
		active = false

func get_available_bombs() -> Array[BombPattern]:
	return bombs.filter(func(i: BombPattern):
		return round >= i.cycles_before_spawnable
	)

func _on_timer_timeout() -> void:
	if multiplayer.is_server():
		round += 1
		var pattern = get_available_bombs().pick_random()
		spawn_bomb_pattern(pattern)
		timer.start(pattern.minimum_time)

func spawn_bomb_pattern(pattern: BombPattern) -> void:
	if !multiplayer.is_server(): return
	for i in pattern.data:
		var possible: Array[int]
		for j in 10:
			var result = 1 << j
			if i.possible_positions & (1 << j):
				possible.append(j)
		spawn_bomb.rpc(i.scene.resource_path, possible.pick_random(), Time.get_unix_time_from_system(), i.delay_sec)


@rpc("authority", "call_local", "reliable")
func spawn_bomb(scene_path: String, pos: int, start_unix: float, delay: float) -> void:
	await get_tree().create_timer(delay).timeout
	var inst : Node2D = (load(scene_path) as PackedScene).instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position.x = get_tree().current_scene.get_node(^"Positions").get_child(pos).global_position.x + 27

func start_bombs() -> void:
	if !multiplayer.is_server(): return
	active = true
	_on_timer_timeout()
