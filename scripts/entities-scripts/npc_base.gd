extends Area2D
class_name NPC

@export var npc_name: String
@onready var name_label = $Label

func _ready() -> void:
	$Label.text = npc_name

func _on_body_entered(_body: Node2D) -> void:
	NpcManager.register_body(self)

func _on_body_exited(_body: Node2D) -> void:
	NpcManager.unregister_body(self)
