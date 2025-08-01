class_name SaverLoader extends Node

# TODO  --- confirmation when save/loading
# save log history
# display slot reloads all slots when saving

# main menu and in-game save menu is the same

@onready var bg: TextureRect = %BG
@onready var characters = %Character
@onready var example_balloon: CanvasLayer = %ExampleBalloon

var is_save := true  # -- how do i knnow when its on menu or not
var is_on_menu : bool


func _ready() -> void:
	set_up_connections()
	display_slot_info()

func set_up_connections():
	var save_slots = get_tree().get_nodes_in_group("save_slots")
	
	for slots in save_slots:
		slots.connect("gui_input", Callable(self, "on_slot_pressed").bind(slots))

# -- display the saved slots
func display_slot_info():
	var slots = get_tree().get_nodes_in_group("save_slots")

	var target_slot = null

	var dir = DirAccess.get_directories_at("user://Saved_Games")
	for files in dir:
		var load_info : SavedGame = load("user://Saved_Games/" + files + "/" + files + "_saved_info.tres") as SavedGame 
		
		var Sname = load_info.save_info["name"]
		var Spath = load_info.save_info["imgPath"]
		var Stime = load_info.save_info["dateTime"]
		var Schapter


		for i in slots:   # --- get the saved slots / prone to error 
			if i.name  == files:
				target_slot = i
				break
		print(target_slot)

		 # --- ill be damned if slots changes structure
		var slot_name = target_slot.get_node("HBoxContainer/VBoxContainer/MarginContainer2/VBoxContainer/Slot_number")
		var slot_img = target_slot.get_node("HBoxContainer/SS")
		var slot_time = target_slot.get_node("HBoxContainer/VBoxContainer/MarginContainer2/VBoxContainer/MarginContainer/Date")

		slot_name.text = Sname
		slot_time.text = Stime
		slot_img.texture = LoadImageTexture(Spath)


		# print()
# -- process the gui_input logic

func LoadImageTexture(path: String):
	var loadedImage = Image.new()
	var error = loadedImage.load(path)

	if error != OK:
		print("image failed to load")
		return
	return ImageTexture.create_from_image(loadedImage)


func on_slot_pressed(event, slots):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("I've been clicked D:", slots.name)
			slot_file(slots.name)
			display_slot_info()


func slot_file(file_name_slot):
	# -- call the saverloader(?)
	if is_save:
#		var date = str(Time.get_datetime_string_from_system())
#		date = date.replace(":", "-")
		save_game(file_name_slot)
	else:
		load_game(file_name_slot)


func save_game(slot_name):
	var saved_game:SavedGame = SavedGame.new()

	var dir = DirAccess.open("user://")
	if !dir.dir_exists("Saved_Games"):
		dir.make_dir("Saved_Games")
	dir = DirAccess.open("user://Saved_Games")
	if !dir.dir_exists(slot_name):      # -- make sub dir per slot
		dir.make_dir(slot_name)

	
	saved_game.chapter = characters.chapter
	saved_game.Dialogue_ID = GameStates.Saved_Dialogue_line
	saved_game.backgound = bg.texture
	get_visible_chara()
	
	
	ResourceSaver.save(saved_game, "user://Saved_Games/" + slot_name + "/" + slot_name + ".tres")
	print(saved_game.Character, saved_game.backgound, saved_game.Dialogue_ID)

	var saved_info:SavedGame = SavedGame.new()
	var screenshot = get_viewport().get_texture().get_image()

	screenshot.save_png("user://Saved_Games" + "/" + slot_name + "/" + slot_name + ".png")


	saved_info.save_info = {
		"name" : slot_name,
		"imgPath" : "user://Saved_Games" + "/" + slot_name + "/" + slot_name + ".png",
		"dateTime" : Time.get_datetime_string_from_system(false, true) 
	}
	ResourceSaver.save(saved_info, "user://Saved_Games/" + slot_name + "/" + slot_name + "_saved_info.tres")


func get_visible_chara(): # data struct: Chara(dict):= dict { pos: name: } 
	var saved_game:SavedGame = SavedGame.new()
	for child in get_tree().get_nodes_in_group("Characters"):
		if child is Character_sprite and child.visible:    # dont fing touch the chara scene visibility
			saved_game.Character[child.name.to_lower()] = { "position": child.position, "expr": child.current_sprite}
			#print(saved_game.Character)


func load_game(load_game):
	var saved_game:SavedGame = load("user://savegame.tres") as SavedGame
	
	
	# clear sprites then load them from file
	
