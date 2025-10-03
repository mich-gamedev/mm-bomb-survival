@tool extends Button

@onready var anim: AnimationPlayer = $AnimationPlayer

@export var button_text: String:
	set(v):
		if !is_node_ready(): await ready
		button_text = v
		%Text.text = v
		await %Text.resized
		custom_minimum_size = %Text.size
		reset_size()

func _on_mouse_entered() -> void:
	anim.play(&"mouse_entered")

func _on_mouse_exited() -> void:
	anim.play(&"mouse_exited")

func _on_button_down() -> void:
	anim.play(&"pressed")

func _on_button_up() -> void:
	anim.play(&"released")
