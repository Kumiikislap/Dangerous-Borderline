extends CanvasLayer

var resource = preload("res://Assets/Dialogue/sample.dialogue")
@export
var prefab:PackedScene

@onready var scroll_container: ScrollContainer = %ScrollContainer
@onready var scrollbar = scroll_container.get_v_scroll_bar()
#@onready var example_balloon: CanvasLayer = %ExampleBalloon
#@onready var get_dialogue_signal = example_balloon.get_node("Balloon/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/DialogueLabel")
var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start") 

var max_scroll_length = 0 

var initial_log = true
# TODO instantiate the log_text --done
# add to trigger the first line --done
# add shortcut/button to show log history
# Log history design
# bug on getting the dialog texts in repeat -- log cant get multiple choices log

func _ready() -> void:
	#GlobalSignals.finished_typing.connect(process_logs)
	scrollbar.changed.connect(handle_scrollbar_changed)
	GlobalSignals.added_next_line.connect(process_logs)
	#dialogue_line = await DialogueManager.get_next_dialogue_line(resource, dialogue_line.next_id)
	#get_dialogue_signal.added_next_line.connect(process_logs)
	#add_logs()
	#print(dialogue_line)

# ----- logic to automatically scroll to bottom
func handle_scrollbar_changed(): 
	if max_scroll_length != scrollbar.max_value: 
		max_scroll_length = scrollbar.max_value 
		scroll_container.scroll_vertical = max_scroll_length

## gets the dialogue lines and add it to log history
func process_logs():  # only get triggered when finished typing
	if initial_log:
		dialogue_line = await DialogueManager.get_next_dialogue_line(resource, dialogue_line.id)
		initial_log = false
		add_logs()
	elif !initial_log:
		dialogue_line = await DialogueManager.get_next_dialogue_line(resource, dialogue_line.next_id) 
		add_logs()
	#await get_tree().create_timer(1.5).timeout  # fixes the bug dia not showing after transitions
	#dialogue_line = await DialogueManager.get_next_dialogue_line(resource, dialogue_line.next_id)
	#print(dialogue_line.next_id)   # what is that bug my guy, when printing
	#await get_tree().create_timer(1.5).timeout  # fixes the bug dia not showing after transitions
	#add_logs()


func add_logs():
	#relative to the node where the script is on
	var container:VBoxContainer = get_node("Control/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/VBoxContainer") 
	var log_text: VBoxContainer
	
	log_text = prefab.instantiate() as VBoxContainer
	var chara = log_text.get_node("Character")
	var chara_lines = log_text.get_node("MarginContainer/Line_text")
	
	if dialogue_line.character != "":   # doesnt add empty lines --- bug on repeated lines, crashes
		container.add_child(log_text)   # check if the line is repeated or go back to saved moment
		
		chara.text =   dialogue_line.character 
		chara_lines.text = '"' + dialogue_line.text + '"'
	
	
