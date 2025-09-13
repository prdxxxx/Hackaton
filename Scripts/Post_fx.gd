extends CanvasLayer

@onready var rect := $PostFXRect
@onready var mat : ShaderMaterial = rect.material

func _ready():
	mat.set_shader_parameter("enabled", true)

func _unhandled_input(event):
	if Input.is_action_just_pressed("DEV"):
		var current = mat.get_shader_parameter("enabled")
		mat.set_shader_parameter("enabled", !current)
