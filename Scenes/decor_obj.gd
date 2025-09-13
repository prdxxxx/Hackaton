extends Node3D
@onready var minecraft_cube_hackathon: Node3D = $MinecraftCubeHackathon
@onready var minecraft_cd: Node3D = $MinecraftCD
@onready var canapea_: Node3D = $Canapea_
@onready var canapea_2: Node3D = $Canapea_2
@onready var futuristic_canapea: Node3D = $futuristic_canapea
@onready var mi_tv: Node3D = $"mi tv"
@onready var coffee_table: Node3D = $coffee_table



func _ready() -> void:
	refresh()

func refresh() -> void:
	minecraft_cube_hackathon.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]
	minecraft_cd.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]
	canapea_.visible = SaveLoad.SaveFileData.world_obj["Sofa1"]
	canapea_2.visible = SaveLoad.SaveFileData.world_obj["Sofa2"]
	futuristic_canapea.visible = SaveLoad.SaveFileData.world_obj["Sofa3"]
	mi_tv.visible = SaveLoad.SaveFileData.world_obj["tv"]
	coffee_table.visible = SaveLoad.SaveFileData.world_obj["tv"]

func _on_player_exit_pc() -> void:
	refresh()
