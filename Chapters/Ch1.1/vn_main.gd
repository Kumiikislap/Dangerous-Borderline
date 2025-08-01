extends CanvasLayer
var resource = preload("res://Assets/Dialogue/sample.dialogue")
const TEST = preload("res://Assets/Dialogue/test.dialogue")
const BG_107A = preload("res://Assets/BGs/BG107A.png")
const BG = preload("res://Assets/BGs/BG.png")
var sea = BG
var room = BG_107A
var next_bg 

@onready var k_angle_test_2: Luka = %KAngle_test2
@onready var k_angle_test: Luka = %KAngle_test
@onready var example_balloon: CanvasLayer = %ExampleBalloon
@onready var animations: AnimationPlayer = $Animations
@onready var bg: TextureRect = %BG

var blank = " "  # works to make dialogue look empty
var characters : Dictionary = {}
# --- BG Manager -- import BG per chapters, 1 ch = 1 VN scene
signal transition_finished

func _ready() -> void:
	#DialogueManager.show_dialogue_balloon_scene(example_balloon ,resource, "start")
	DialogueManager.show_dialogue_balloon(TEST, "start")   
	#example_balloon.enter_dialogue() -- works
	#fade_transition(room)
	#transition_finished.connect(enter_uis)

func enter_uis():
	example_balloon.enter_dialogue()
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
	await get_tree().create_timer(0.5).timeout
	example_balloon.exit_dialogue()

func fade_transition(next_bg_input): # func to call when changing bg with fade animation
	next_bg = next_bg_input
	exit_uis()
	await get_tree().create_timer(0.7).timeout
	animations.play("fade_transition")

# -- used by animator
func transition_fade_finished():   # --- what
	transition_finished.emit()

func fade_in_play_finished():
	# advance the script once to change next sprite ---- text should have delay after dialouge is shown or just add blank space
	# change bg here
	bg.texture = next_bg
