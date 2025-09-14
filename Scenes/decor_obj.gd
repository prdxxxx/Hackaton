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

# Recursive helper
func set_node_active(node: Node, active: bool) -> void:
	if node == null:
		return
	
	if active:
		node.show()
	else:
		node.hide()
	
	# Check this node if it's a collider
	if node is CollisionShape3D:
		node.disabled = not active
	elif node is CollisionObject3D:
		node.set_deferred("disabled", not active)

	# Recurse through children
	for child in node.get_children():
		set_node_active(child, active)

func refresh() -> void:
	set_node_active(minecraft_cube_hackathon, SaveLoad.SaveFileData.world_obj["Minecraft"])
	set_node_active(minecraft_cd, SaveLoad.SaveFileData.world_obj["Minecraft"])
	set_node_active(canapea_, SaveLoad.SaveFileData.world_obj["Sofa1"])
	set_node_active(canapea_2, SaveLoad.SaveFileData.world_obj["Sofa2"])
	set_node_active(futuristic_canapea, SaveLoad.SaveFileData.world_obj["Sofa3"])
	
	var tv_active = SaveLoad.SaveFileData.world_obj["tv"]
	set_node_active(mi_tv, tv_active)
	set_node_active(coffee_table, tv_active)

func _on_player_exit_pc() -> void:
	refresh()
