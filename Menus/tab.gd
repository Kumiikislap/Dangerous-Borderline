extends Control


@onready var tab_content: VBoxContainer = %Tab_content
@onready var tab_content_2: VBoxContainer = %Tab_content2
@onready var tab_content_3: VBoxContainer = %Tab_content3

@onready var _1: TextureButton = %"1"
@onready var _2: TextureButton = %"2"
@onready var _3: TextureButton = %"3"


func _ready() -> void:
	set_up_connections()
	on_tab_pressed("2") # default tab



func set_up_connections():
	var tab_buttons = get_tree().get_nodes_in_group("tab_number_group")
	
	for button in tab_buttons:
		button.connect("pressed", Callable(self, "on_tab_button_pressed").bind(button))


func on_tab_button_pressed(tab_button):
	#print(tab_button.name)
	
	match tab_button.name:
		"1":
			on_tab_pressed("1")
		"2":
			on_tab_pressed("2")
		"3":
			on_tab_pressed("3")
		


func on_tab_pressed(button):
	# add estetiks // pressed
	
	
	tab_content.visible = false
	tab_content_2.visible = false
	tab_content_3.visible = false

	match button: 
		"1":
			tab_content.visible = true
		"2":
			tab_content_2.visible = true
		"3":
			tab_content_3.visible = true
