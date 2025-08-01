extends MarginContainer


var is_save := true  # -- how do i know when its on menu or not
var is_on_menu : bool


func _ready() -> void:
	set_up_connections()


func set_up_connections():
	var save_slots = get_tree().get_nodes_in_group("save_slots")
	
	for slots in save_slots:
		slots.connect("gui_input", Callable(self, "on_slot_pressed").bind(slots))


# -- process the gui_input logic


func on_slot_pressed(event, slots):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("I've been clicked D:", slots.name)
#			slot_file(slots.name)


#func slot_file(file_name_slot):
#	# -- call the saverloader(?)
#	if is_save:
#		saver.save_game(file_name_slot)
#	else:
#		saver.load(file_name_slot)
