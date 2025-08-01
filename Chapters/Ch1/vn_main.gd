extends CanvasLayer
var resource = preload("res://Assets/Dialogue/sample.dialogue")
const TEST = preload("res://Assets/Dialogue/test.dialogue")
const BG_107A = preload("res://Assets/BGs/BG107A.png")
const BG = preload("res://Assets/BGs/BG.png")

var sea = BG
var room = BG_107A
var next_bg 

const BALLOON = preload("res://Assets/Dialogue/balloon.tscn")
@onready var log_history : CanvasLayer = $Log

@onready var k_angle_test_2: Luka = %KAngle_test2
@onready var k_angle_test: Luka = %KAngle_test
@onready var animations: AnimationPlayer = $Animations
@onready var bg: TextureRect = %BG


var blank = ""  # works to make dialogue look empty
var characters : Dictionary = {}


# --- BG Manager -- import BG per chapters, 1 ch = 1 VN scene
signal transition_finished


func _ready() -> void:
	DialogueManager.show_dialogue_balloon_scene(BALLOON ,resource, "start")
	#await get_tree().create_timer(0.5).timeout
	#print(dialogue_line["character"]) # omg it works 
	#print(dialogue_line["text"])
	



func enter_uis():
	GlobalSignals.balloon_fade_enter.emit()
	await get_tree().create_timer(0.5).timeout
	for child in get_node("%Character").get_children():
		if child is Character_sprite:
			characters[child.name.to_lower()] = child
			child.enter_character()

func exit_uis():
	for child in get_node("%Character").get_children():
		if child is Character_sprite:
			characters[child.name.to_lower()] = child
			child.exit_character()
	#await get_tree().create_timer(0.5).timeout
	GlobalSignals.balloon_fade_exit.emit()

func fade_transition(next_bg_input): # func to call when changing bg with fade animation
	next_bg = next_bg_input
	exit_uis()
	await get_tree().create_timer(0.7).timeout
	animations.play("fade_transition")

# -- used by animator
func transition_fade_finished():   # --- what
	enter_uis()

func fade_in_play_finished(new_bg = null): ## --- change bg
	# advance the script once to change next sprite ---- text should have delay after dialouge is shown or just add blank space
	# change bg here
	if new_bg != null:
		next_bg = new_bg
	bg.texture = next_bg
