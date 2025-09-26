class_name Player extends Node2D

const SELF_COLOR := Color("8ec07c")
const OPP_COLOR  := Color("98971a")

@onready var sprite: Node2D = $Sprite
@onready var left_eye: RingDraw = $Sprite/LeftEye
@onready var right_eye: RingDraw = $Sprite/RightEye
@onready var auth_label: Label = %AuthLabel

@onready var left_eye_facing_right: Node2D = $Sprite/LeftEyeFacingRight
@onready var left_eye_facing_left: Node2D = $Sprite/LeftEyeFacingLeft
@onready var right_eye_facing_right: Node2D = $Sprite/RightEyeFacingRight
@onready var right_eye_facing_left: Node2D = $Sprite/RightEyeFacingLeft

@onready var rpc_timer: Timer = $RpcTimer

var twn: Tween

var last_pos : NodePath = "1"

func _ready() -> void:
	global_position.y = 316
	if name.is_valid_int():
		set_multiplayer_authority(name.to_int())

	if is_multiplayer_authority():
		sprite.set_color(SELF_COLOR)
		auth_label.label_settings.font_size = 16
		auth_label.label_settings.font_color = SELF_COLOR
		auth_label.text = "YOU (%s)" % Lobby.local_data.name
		#await auth_label.resized
		#auth_label.position.x = auth_label.size.x/2
		z_index = 10
		rpc_timer.start()
	else:
		if !Lobby.players.has(get_multiplayer_authority()): await Lobby.peer_connected
		sprite.set_color(OPP_COLOR)
		auth_label.label_settings.font_size = 12
		auth_label.label_settings.font_color = OPP_COLOR
		auth_label.text = Lobby.players[get_multiplayer_authority()].name
		#await auth_label.resized
		#auth_label.position.x = auth_label.size.x/2
		z_index = 0
	sprite.top_level = true
	sprite.global_position = global_position


func _unhandled_input(event: InputEvent) -> void:
	if is_multiplayer_authority():
		for i in get_tree().current_scene.get_node(^"%Positions").get_children():
			if event.is_action_pressed(i.name):
				move_to(str(i.name))
				last_pos = str(i.name)

func _on_timer_timeout() -> void:
	move_to.rpc(last_pos)

@rpc("any_peer", "call_local", "unreliable_ordered") func move_to(id: NodePath) -> void:
	var i = get_tree().current_scene.get_node(^"%Positions").get_node(id)
	if is_equal_approx(global_position.x, i.global_position.x + (i.size.x / 2)): return
	var right = i.global_position.x > global_position.x
	global_position.x = i.global_position.x + (i.size.x / 2)
	sprite.scale = Vector2(2, .25)
	if twn: twn.kill()
	twn = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	twn.tween_property(sprite, ^"global_position", global_position, .5)
	twn.tween_property(sprite, ^"scale", Vector2.ONE, .75).set_trans(Tween.TRANS_ELASTIC)
	twn.tween_property(
		left_eye,
		^"position",
		(left_eye_facing_right if right else left_eye_facing_left).position,
		1
	)
	twn.tween_property(
		right_eye,
		^"position",
		(right_eye_facing_right if right else right_eye_facing_left).position,
		1
	)
	return
