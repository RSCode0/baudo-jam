extends Node
class_name NPC_MANAGER

var active_dialogue = false
var active_npc: NPC
var active_dialogues
var dialogues = NPCData.new()
@onready var player = get_tree().get_first_node_in_group("Player")

var dialogue_index = 0
var current_dialogue
var current_text = ""
var current_speaker: String

var typewritter_speed: int = 20
var typewritter_index: int = 0
var typewritter_timer: float = 0.0
 
func register_body(body: NPC):
	active_npc = body
	body.name_label.hide()

func unregister_body(body: NPC):
	if active_npc:
		body.name_label.show()
		active_npc.panel.hide()
		active_npc = null

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact"):
		if active_npc:
			if not active_dialogue:
				player.can_move = false
				active_dialogue = true
				player.current_animation = "idle"
				if not SaveLoad.SaveFile.dialogues[active_npc.npc_name.remove_chars(" ")]:
					active_dialogues = dialogues[active_npc.npc_name.remove_chars(" ")]["dialogue"]
				else:
					active_dialogues = dialogues[active_npc.npc_name.remove_chars(" ")]["base_dialogue"]
			advance_dialogue()

func _process(delta: float) -> void:
	if active_npc:
		if active_dialogue:
			player.current_animation = "idle"
			player.health_bar.hide()
			active_npc.panel.show()
			active_npc.label.show()
			active_npc.interact_text.hide()
			dialogue(delta)
		else:
			active_npc.interact_text.show()
			active_npc.panel.show()
			active_npc.label.hide()

func dialogue(_delta):
	var current_time = Time.get_ticks_msec()
	if typewritter_index <= len(current_text):
		if current_time - typewritter_timer > typewritter_speed:
			typewritter_index += 1
			typewritter_timer = current_time
	update_label()

func advance_dialogue():
	if typewritter_index < len(current_text):
		typewritter_index = len(current_text)
		return
			
	if dialogue_index >= len(active_dialogues):
		if active_npc:
			SaveLoad.SaveFile.dialogues[active_npc.npc_name.remove_chars(" ")] = true
			SaveLoad.save()
		dialogue_index = 0
		active_dialogue = false
		player.can_move = true
		current_text = ""
		current_speaker = ""
		return

	current_dialogue = active_dialogues[dialogue_index]
	current_text = handle_action_tag(current_dialogue["text"])
	current_speaker = current_dialogue["speaker"]
	dialogue_index += 1
	typewritter_index = 0

func handle_action_tag(text:String):
	if not text:
			return text
	
	var start = text.find("[")
	var end = text.find("]", start + 1)
	
	if start != -1 and end != -1:
		text = (text.substr(0, start) + text.substr(end + 1, -1))
	
	return text

func update_label():
	var text = current_text.substr(0, typewritter_index)
	if current_speaker != "player":
		active_npc.label.text = text
		player.dialogue_panel.hide()
	else:
		player.dialogue_panel.show()
		player.dialogue_label.text = text
		if active_npc:
			active_npc.panel.hide()
