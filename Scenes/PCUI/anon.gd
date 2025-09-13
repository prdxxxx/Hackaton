extends Node

@export var delay: float = 5.0          # seconds between messages

var current_index: int = 2  # Start from the 3rd message (0-based)


func _show_next_message() -> void:
	if current_index >= get_child_count():
		return  # no more messages
	
	# Show current message
	var child = get_child(current_index)
	child.visible = true
	current_index += 1
	
	# Continue automatically after delay
	await get_tree().create_timer(delay).timeout
	_show_next_message()

func _on_discord_anon_on() -> void:
	_show_next_message()
