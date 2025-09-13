extends Resource
class_name SaveDataResourse

@export var player_position: Vector3 = Vector3(3.221, 3.642, 2.048)
@export var rotation: Dictionary = {
	"player_rotation": Vector3.ZERO,
	"camera_rotation": Vector3.ZERO
	}

@export var main_light_switch: bool = true
@export var lights_walls: bool = true
@export var lights_2_floor: bool = true
@export var lights_hall: bool = true
@export var lights_stairs: bool = true
@export var lights_storage: bool = true

@export var desktop_txt: String = " "

@export var money = 0

@export var world_obj: Dictionary = {
	"Sofa1" = true,
	"Sofa2" = true,
	"Sofa3" = true,
	"Minecraft" = true,
	"Roblox" = true
	}
