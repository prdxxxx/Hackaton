extends Node

# Stores volumes in linear scale (0.0 – 1.0)
var volumes = {
	"Master": 1.0,
	"Music": 1.0,
	"SFX": 1.0
}

const SAVE_FILE := "user://audio.cfg"

func _ready() -> void:
	load_volumes()
	apply_all_volumes()

# Apply saved volumes to AudioServer
func apply_all_volumes() -> void:
	for bus_name in volumes.keys():
		var idx = AudioServer.get_bus_index(bus_name)
		if idx != -1:
			AudioServer.set_bus_volume_db(idx, linear_to_db(volumes[bus_name]))

# Get volume for a bus
func get_volume(bus_name: String) -> float:
	if volumes.has(bus_name):
		return volumes[bus_name]
	return 1.0

# Set volume for a bus
func set_volume(bus_name: String, value: float) -> void:
	volumes[bus_name] = clamp(value, 0.0, 1.0)
	var idx = AudioServer.get_bus_index(bus_name)
	if idx != -1:
		# Always convert linear to dB and set
		AudioServer.set_bus_volume_db(idx, linear_to_db(volumes[bus_name]))
	save_volumes()

# Save volumes to disk
func save_volumes() -> void:
	var cfg = ConfigFile.new()
	for bus_name in volumes.keys():
		cfg.set_value("volume", bus_name, volumes[bus_name])
	cfg.save(SAVE_FILE)

# Load volumes from disk
func load_volumes() -> void:
	var cfg = ConfigFile.new()
	if cfg.load(SAVE_FILE) == OK:
		for bus_name in volumes.keys():
			volumes[bus_name] = float(cfg.get_value("volume", bus_name, 1.0))
