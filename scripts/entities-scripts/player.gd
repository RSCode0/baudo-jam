extends CharacterBody2D

var direction: Vector2
var speed: int = 2000
var current_animation: String = ""

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	animation()
	update_torche_rotation()
	move_and_slide()

func _input(_event: InputEvent) -> void:
	direction = Input.get_vector("left", "right", "up", "down")

func animation():
	$AnimatedSprite2D.play(current_animation)
	if direction:
		if direction.y > 0:
			current_animation = "front_walk"
		elif direction.y < 0:
			current_animation = "back_walk"

func update_torche_rotation():
	$Torche.look_at(get_global_mouse_position())
	$Torche.rotation_degrees += 90
