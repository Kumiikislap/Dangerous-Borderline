extends VBoxContainer


@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var example_balloon: CanvasLayer = $"../.."


 # -- auto
func _on_skip_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		example_balloon.is_auto = true
		example_balloon.auto_next()
	else:
		example_balloon.is_auto = false
	print(example_balloon.is_auto)
