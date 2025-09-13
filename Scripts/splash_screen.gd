extends CanvasLayer

@onready var logo = $MarginContainer/SplashScreen

func _ready():
	# If you're using an AnimatedSprite2D
	if logo is AnimatedSprite2D:
		logo.play("default") # play your animation name
		logo.connect("animation_finished", Callable(self, "_on_animation_finished"))
	# If you're using an AnimationPlayer instead
	elif logo is AnimationPlayer:
		logo.play("splash")
		logo.connect("animation_finished", Callable(self, "_on_animation_finished"))
	# If it's a plain Sprite with sprite sheet frame animation
	elif logo is Sprite2D:
		# You’d need a Timer or AnimationPlayer to flip frames
		var timer = Timer.new()
		add_child(timer)
		timer.wait_time = 0.1 # speed per frame
		timer.one_shot = false
		timer.connect("timeout", Callable(self, "_on_next_frame"))
		timer.start()

var current_frame := 0

func _on_next_frame():
	if logo is Sprite2D:
		var hframes = logo.hframes
		current_frame += 1
		if current_frame >= hframes:
			# End splash
			_on_animation_finished()
		else:
			logo.frame = current_frame

func _on_animation_finished():
	await get_tree().create_timer(1.0).timeout
	var error = get_tree().change_scene_to_file("res://Scenes/Main_Menu/start_menu.tscn")
