extends Node

@onready var discord: Control = $"."


@export var child_nodes: Array  =[
	"$PanelContainer/WindowBase/Chat/ScrollContainer/VBoxContainer/Message",
	"$PanelContainer/WindowBase/Chat/ScrollContainer/VBoxContainer/Message2",
	"$PanelContainer/WindowBase/Chat/ScrollContainer/VBoxContainer/Message3",
	"$PanelContainer/WindowBase/Chat/ScrollContainer/VBoxContainer/Message4",
	"$PanelContainer/WindowBase/Chat/ScrollContainer/VBoxContainer/Message5",
	"$PanelContainer/WindowBase/Chat/ScrollContainer/VBoxContainer/Message6"
]
@export var duration := 5.0

func _ready():
	# Start the gradual enabling process
	call_deferred("start_turning_on")

func start_turning_on():
	var nodes = []
	for path in child_nodes:
		var node = get_node(path)  # now valid, path is a NodePath
		if node:
			node.visible = false
			nodes.append(node)
	_turn_on_nodes_over_time(nodes, duration)



func _turn_on_nodes_over_time(nodes: Array, total_time: float) -> void:
	var timer := 0.0
	var count = nodes.size()
	while timer < total_time:
		timer += get_process_delta_time()
		var fraction = timer / total_time
		var active_count = int(fraction * count)
		for i in range(active_count):
			if not nodes[i].visible:
				nodes[i].visible = true
		await get_tree().process_frame
	# Make sure all are on at the end
	for node in nodes:
		node.visible = true




func _on_exit_pressed() -> void:
	discord.hide()
