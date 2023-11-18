extends CharacterBody2D

signal game_over

@export var radius: float = 10.
@export var counter: Label
@export var audio_player: AudioStreamPlayer2D


func _ready() -> void:
	var main_node = get_parent()
	if main_node != null:
		$Timer.wait_time = main_node.find_child("Timer").wait_time
		$Timer.start()
	$CollisionShape2D.shape.radius = radius
	self.scale = Vector2(0., 0.)


func _process(_delta: float) -> void:
	var lifetime: float = $Timer.time_left / $Timer.wait_time
	self.scale = Vector2(1 - lifetime, 1 - lifetime)
	$MeshInstance2D.material.set_shader_parameter("lifetime", lifetime)


func _on_timer_timeout() -> void:
	queue_free()
	game_over.emit()

func get_radius() -> float:
	return radius

func _unhandled_input(event) -> void:
	if event.is_action_pressed("hitball_kill"):
		var mouse_pos: Vector2 = get_local_mouse_position() * self.scale
		var size: Vector2 = radius * scale
		
		# We will assume that the hitball can be in an ellipse shape as well.
		# To calculate if a point is inside an ellipse we can use this formula:
		# (x / a) ^ 2 + (y / b) ^ 2 <= 1
		# (x, y) is local coordinates.
		# (a, b) is the size of the ellipse.
		if (mouse_pos / size).length_squared() <= 1:
			queue_free()
			counter.text = str(int(counter.text) + 1)
			audio_player.play()
