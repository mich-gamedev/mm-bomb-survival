class_name Player extends Node2D

@onready var sprite: Node2D = $Sprite
@onready var left_eye: RingDraw = $Sprite/LeftEye
@onready var right_eye: RingDraw = $Sprite/RightEye

@onready var left_eye_facing_right: Node2D = $Sprite/LeftEyeFacingRight
@onready var left_eye_facing_left: Node2D = $Sprite/LeftEyeFacingLeft
@onready var right_eye_facing_right: Node2D = $Sprite/RightEyeFacingRight
@onready var right_eye_facing_left: Node2D = $Sprite/RightEyeFacingLeft

var twn: Tween

func _ready() -> void:
	sprite.top_level = true
	sprite.global_position = global_position

func _unhandled_input(event: InputEvent) -> void:
	if get_multiplayer_authority() == multiplayer.get_unique_id():
		for i in get_tree().current_scene.get_node(^"%Positions").get_children():
			if event.is_action_pressed(i.name):
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
