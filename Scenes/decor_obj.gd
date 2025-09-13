extends Node3D
@onready var minecraft_cube_hackathon: Node3D = $MinecraftCubeHackathon
@onready var minecraft_cd: Node3D = $MinecraftCD
@onready var canapea_: Node3D = $Canapea_
@onready var canapea_2: Node3D = $Canapea_2
@onready var futuristic_canapea: Node3D = $futuristic_canapea

func _ready() -> void:
	refresh()

func refresh() -> void:
	minecraft_cube_hackathon.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]
	minecraft_cd.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]
	canapea_.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]
	canapea_2.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]
	futuristic_canapea.visible = SaveLoad.SaveFileData.world_obj["Minecraft"]


func _on_player_exit_pc() -> void:
	refresh()
