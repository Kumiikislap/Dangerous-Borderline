extends Character_sprite
class_name Luka          # -- needs to be registered class to access class methods
var resource = preload("res://Assets/Dialogue/sample.dialogue")

const RUK_BACK = preload("res://Assets/Characters/Luka/RUK_back.png")
const RUK_BLINK = preload("res://Assets/Characters/Luka/RUK_blink.png")
const RUK_BLUSH = preload("res://Assets/Characters/Luka/RUK_blush.png")
const RUK_NEUTRAL = preload("res://Assets/Characters/Luka/RUK_neutral.png")

enum {neutral, blush, blink, back}

@onready var first_sprite: Sprite2D = $first_sprite
@onready var second_sprite: Sprite2D = $Second_sprite

var next_sprite = back   # -- default expr
@onready var animator: AnimationPlayer = $Animator

@onready var new_sprite : Sprite2D = $Second_sprite  # both sprite needs to be visible
@onready var last_sprite : Sprite2D = $first_sprite

var current_sprite 
var is_first_on := true       #-- animations ----- true = first sprite
var next := true              # -- for changing sprite

func _ready() -> void:
	#enter_character()
	change_Fadesprite(blush)


# TODO
# -- test second call of change
# -- auto-complete in func arguments

#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_up"):
		#change_Fadesprite(back)            
	#if event.is_action_pressed("ui_down"):
		#change_Fadesprite(blush)
	#if event.is_action_pressed("ui_right"):
		#change_Fadesprite(blink)
	#if event.is_action_pressed("ui_accept"):
		#enter_character()

func change_Fadesprite(sprite):
	next_sprite = sprite
	current_sprite = sprite
	if is_first_on:
		second_sprite.z_index = 0   # -- new sprite should be always on bottom
		first_sprite.z_index = 1
		animator.play("first_toggle")
		is_first_on = false
	else:
		first_sprite.z_index = 0
		second_sprite.z_index = 1
		animator.play("second_toggle")
		is_first_on = true
	change_sprite()

func change_sprite():
	if next:
		match next_sprite:
			blush:     # 1 Blush
				second_sprite.texture = RUK_BLUSH
			back:      # 3 Back
				second_sprite.texture = RUK_BACK
			neutral:   # 0 Neutral
				second_sprite.texture = RUK_NEUTRAL
			blink:     # 2 Blink
				second_sprite.texture = RUK_BLINK
			_:
				print(str(new_sprite) + " isn't found!")   # -- error handling when str isnt found
		next = false
	elif !next:
		match next_sprite:
			blush:
				first_sprite.texture = RUK_BLUSH
			back:
				first_sprite.texture = RUK_BACK
			neutral:
				first_sprite.texture = RUK_NEUTRAL
			blink:
				first_sprite.texture = RUK_BLINK
			_:
				print(str(next_sprite) + " isn't found!")
		next = true

func enter_character():
	animator.play("character_enter")

func exit_character():
	animator.play("character_exit")
