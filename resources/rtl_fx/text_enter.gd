@tool
# Having a class name is handy for picking the effect in the Inspector.
class_name RichTextTextEnter
extends RichTextEffect


# To use this effect:
# - Enable BBCode on a RichTextLabel.
# - Register this effect on the label.
# - Use [text_enter param=2.0]hello[/text_enter] in text.
var bbcode := "enter"



func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	char_fx.offset = (Vector2.ONE * (20 ** (-char_fx.elapsed_time + char_fx.relative_index/20. + 1)))
	if char_fx.offset.x > 5:
		char_fx.visible = false
	return true
