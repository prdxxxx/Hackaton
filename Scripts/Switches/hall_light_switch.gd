extends Node3D

@onready var lights_hall: Node3D = $"../../ElectricBox/Lights/Lights_Hall"
@onready var lights_hall_2: Node3D = $"../../ElectricBox/Lights/Lights_Hall2"

var onoff = false

func _ready() -> void:
	SaveLoad._load()
	var onoff2 = SaveLoad.SaveFileData.lights_hall
	onoff = onoff2
	$off.visible = onoff
	$on.visible = !onoff
	lights_hall.visible = onoff
	lights_hall_2.visible = onoff
	
func toggle_light() -> void:
	onoff = !onoff
	$off.visible = onoff
	$on.visible = !onoff
	lights_hall.visible = onoff
	lights_hall_2.visible = onoff
	SaveLoad.SaveFileData.lights_hall = onoff
