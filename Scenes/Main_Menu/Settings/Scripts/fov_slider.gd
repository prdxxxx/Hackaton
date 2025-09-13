extends Control

@onready var fov_slider: HSlider = $HBoxContainer/FOV_Slider
@onready var fov_num: Label = $HBoxContainer/FOV_num

var fov = 80  # default FOV

func _ready() -> void:
	# Load FOV from config safely
	fov = load_config("user://config.cfg", "Graphics", "fov", 80)
	
	# Update UI
	fov_num.text = str(fov)
	fov_slider.value = fov

func _on_h_slider_value_changed(value: float) -> void:
	fov = value
	fov_num.text = str(fov)
	save_fov_data(fov)

# Safe config loader with default
func load_config(path: String, section: String, key: String, default_value) -> Variant:
	var cfg = ConfigFile.new()
	if cfg.load(path) != OK:
		return default_value
	return cfg.get_value(section, key, default_value)

# Save FOV to config
func save_fov_data(s_fov):
	var cfg = ConfigFile.new()
	
	# Load existing config or start fresh
	cfg.load("user://config.cfg")
	
	# Set and save FOV
	cfg.set_value("Graphics", "fov", s_fov)
	cfg.save("user://config.cfg")
