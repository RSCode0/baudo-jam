extends CharacterBody2D

var direction: Vector2
var speed: int = 1000
var current_animation: String = "front_idle"

func _physics_process(delta: float) -> void:
	velocity = direction * speed * delta
	animation()
	move_and_slide()

func _input(event: InputEvent) -> void:
	direction = Input.get_vector("left", "right", "up", "down")

func animation():
	$AnimatedSprite2D.play(current_animation)
