extends Node

func process_command(input: String):
	var words = input.split(" ", false)
	if words.size() == 0:
		return "Error" 
	var first_word = words[0].to_lower()
	var second_word = ""
	if words.size() > 1:
		second_word = words[1].to_lower()
	match first_word:
		"go":
			return go(second_word)
		"help":
			return help()
		"aircrack":
			return aircrack()
		_:
			return "Unrecognised command - please try again."
	
func go(second_word: String) -> String:
	if second_word == "":
		return "Go where?"
		
	return "You go %s" % second_word
	
func help() -> String:
	return "For information about a specific command, type HELP <command name>
			go [location]: 
			aircrack                                                    "


func aircrack() -> String:
	Events.emit_signal("aircrack_command")
	return "Aircrack console opened."
