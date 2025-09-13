extends Node

# Пример сетей, которые станут доступны после скана
var sample_networks := []

func process_command(input: String):
	var words = input.split(" ", false)
	if words.size() == 0:
		return "[!] Empty command"

	var cmd = words[0].to_lower()

	match cmd:
		"scan":
			# Выполняем сканирование
			Events.scan_done = true
			sample_networks = [
				{"bssid":"AA:BB:CC:DD:EE:FF", "essid":"MyWiFi", "enc":"WPA2", "ch":"6"},
				{"bssid":"11:22:33:44:55:66", "essid":"CafeNet", "enc":"WPA3", "ch":"11"},
				{"bssid":"77:88:99:AA:BB:CC", "essid":"OpenFree", "enc":"OPN", "ch":"1"}
			]
			return "[*] Scan complete. Networks found. Use 1, 2, 3 to attack."
		
		"1","2","3":
			if not Events.scan_done:
				return "[!] You must perform Scan first!"
			var index = int(cmd) - 1
			if index >= sample_networks.size():
				return "[!] Invalid target."
			var target = sample_networks[index]
			return _attack_target(target)
		
		_:
			return "[!] Unknown command."

func _attack_target(target: Dictionary) -> String:
	var output = "[*] Starting MITM attack on %s (%s)...\n" % [target.essid, target.bssid]
	output += "[*] Capturing traffic...\n"
	output += "[*] MITM attack complete."
	return output
