extends Node

var current_ennemis = []
@onready var player = get_tree().get_first_node_in_group("Player")

func register_ennemi(ennemi):
	current_ennemis.append(ennemi)

func _process(delta: float) -> void:
	pass

func update_ennemis_position(delta):
	for ennemi in current_ennemis:
		ennemi.direction = ennemi.global_position.direction_to(player.global_position)
		ennemi.position += ennemi.direction * ennemi.speed * delta
