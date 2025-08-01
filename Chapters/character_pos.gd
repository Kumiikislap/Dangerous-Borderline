extends Node2D

# TODO 3 pos, animations, zoom presets

@onready var k_angle_test: Luka = %KAngle_test
@onready var k_angle_test_2: Luka = %KAngle_test2

var chara_y_pos : int                      #-- depends on chara?
var center  = DisplayServer.screen_get_size().x / 2
var left = DisplayServer.screen_get_size().x / 3.5
var right = DisplayServer.screen_get_size().x  - left

var chara_present_on_current_cut = {}
var chapter = 1



# -- sets chara position
func what_position(chara: Luka, Cposition: int = center, animation = null):
	chara.position.x = Cposition
	if animation != null:
		c_animation(chara, animation)
	get_visible_chara()

func get_visible_chara(): # data struct: Chara(dict):= dict { pos: name: } 
	for child in get_children():
		if child is Character_sprite and child.visible:    # dont fing touch the chara scene visibility
			chara_present_on_current_cut.clear()
			chara_present_on_current_cut[child.name.to_lower()] = { "position": child.position, "expr": child.current_sprite}
			print(chara_present_on_current_cut)
			#print(copy)
func _ready() -> void:
	k_angle_test.position.x = right
	k_angle_test_2.position.x = center
	#get_visible_chara()
	#print(center)
	#print(left)
	#what_position(k_angle_test, right, )
	

func c_animation(charac, animation_type):      # -- modular animations
	charac.animator.play(animation_type)
			# chara animation logic is on chara script
	# -- add customize animations
