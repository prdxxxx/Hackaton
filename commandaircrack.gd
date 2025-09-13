extends Node

# --- State ---
var monitor_enabled: bool = false
var wifi_handshakes: Dictionary = {}       # SSID -> bool
var wifi_cracked: Dictionary = {}          # SSID -> String
var client_handshakes: Dictionary = {}     # Имя клиента -> bool
var client_cracked: Dictionary = {}        # Имя клиента -> String
var last_wifi_target: String = ""
var last_client_target: String = ""

# --- Клиенты банка ---
var clients: Array = [
	{"name":"Aether Dynamics", "balance":50.0,  "password":"aether_pw"},
	{"name":"James Carter",    "balance":30.0,  "password":"james_pw"},
	{"name":"Maria Smirnova",  "balance":70.0,  "password":"maria_pw"},
	{"name":"Ivan Petrov",     "balance":150.0, "password":"ivan_pw"},
]

# --- Сети для взлома админ-панели банка ---
var wifi_networks: Array = [
	{"ssid":"BankAdmin-1", "bssid":"AA:BB:CC:11:22:33", "password":"12345", "channel":6},
	{"ssid":"BankAdmin-2", "bssid":"DD:EE:FF:44:55:66", "password":"12345", "channel":11},
]

func _ready() -> void:
	for w in wifi_networks:
		wifi_handshakes[w.ssid] = false
		wifi_cracked[w.ssid] = ""
	for c in clients:
		client_handshakes[c.name] = false
		client_cracked[c.name] = ""

# -------------------------
# Главная точка ввода команд
# -------------------------
func process_command(input: String) -> String:
	var cmd = input.strip_edges()
	var lower_cmd = cmd.to_lower()

	match lower_cmd:
		"go":
			return go("")
		"help":
			return help()
		"scan":
			return scan_clients()
		"airmon-ng start wlan0":
			return airmon_ng_start_wlan0()
		"airodump-ng wlan0mon":
			return airodump_ng_wlan0mon()
		_:
			if lower_cmd.begins_with("airodump-ng -c "):
				return airodump_ng_capture(cmd)
			elif lower_cmd.begins_with("aireplay-ng --deauth"):
				return aireplay_ng_deauth(cmd)
			elif lower_cmd.begins_with("aircrack-ng -w "):
				return aircrack_ng_crack(cmd)
			elif lower_cmd.begins_with("attack "):
				var parts = lower_cmd.split(" ")
				if parts.size() >= 2:
					var idx = int(parts[1]) - 1
					return simulate_attack(idx)
				return "Usage: attack <target-number>"
			else:
				return "Unrecognised command - try 'help', 'scan' or 'airodump-ng wlan0mon'."

# -------------------------
func go(direction: String) -> String:
	if direction == "":
		return "Go where?"
	return "You go %s" % direction

# -------------------------
func help() -> String:
	return """SIMULATED Aircrack-ng Console
Common commands:
  help
  scan                        - List bank clients (name & balance)
  attack <n>                  - Attack client after Wi-Fi is cracked
  airmon-ng start wlan0       - Enable monitor mode (simulated)
  airodump-ng wlan0mon        - List Wi-Fi networks for admin panel
  airodump-ng -c <ch> --bssid <BSSID> -w capture wlan0mon
							   - Capture handshake from Wi-Fi
  aireplay-ng --deauth <n> -a <BSSID> wlan0mon
							   - Simulated deauth
  aircrack-ng -w <wordlist> <capture_file>
							   - Crack handshake (Wi-Fi or client)

Examples:
  scan
  attack 2
  airodump-ng wlan0mon
  airodump-ng -c 6 --bssid AA:BB:CC:11:22:33 -w capture wlan0mon
  aireplay-ng --deauth 10 -a AA:BB:CC:11:22:33 wlan0mon
  aircrack-ng -w rockyou.txt wificapture-BankAdmin-1.cap
  aircrack-ng -w rockyou.txt clientcapture-Aether_Dynamics.cap

Note: This is a simulated environment. No real network activity is performed.
"""

# -------------------------
func airmon_ng_start_wlan0() -> String:
	if monitor_enabled:
		return "[!] wlan0 is already in monitor mode (wlan0mon)"
	monitor_enabled = true
	return "[+] Monitor mode enabled on wlan0 -> wlan0mon"

# -------------------------
# Сканирование клиентов
func scan_clients() -> String:
	var output = "[*] Bank clients:\n"
	for i in range(clients.size()):
		var c = clients[i]
		output += "%d) %s    Balance: $%0.2f\n" % [i+1, c.name, c.balance]
	return output.strip_edges()

# -------------------------
# Сети Wi-Fi для взлома
func airodump_ng_wlan0mon() -> String:
	if not monitor_enabled:
		return "[!] Error: wlan0 is not in monitor mode"
	var output = "[*] Scanning for Wi-Fi networks (admin panel)...\n"
	for i in range(wifi_networks.size()):
		var w = wifi_networks[i]
		output += "%d) SSID: %s  BSSID: %s  Channel: %d\n" % [i+1, w.ssid, w.bssid, w.channel]
	return output.strip_edges()

func airodump_ng_capture(cmd: String) -> String:
	if not monitor_enabled:
		return "[!] Error: wlan0 is not in monitor mode"
	# Определяем SSID из команды
	var parts = cmd.split(" ")
	if parts.size() < 6:
		return "Usage: airodump-ng -c <ch> --bssid <BSSID> -w capture wlan0mon"
	var bssid = parts[4]
	for w in wifi_networks:
		if w.bssid == bssid:
			wifi_handshakes[w.ssid] = true
			last_wifi_target = w.ssid
			return "[*] Listening on channel %d...\n[+] Handshake captured for %s (wificapture-%s.cap)" % [w.channel, w.ssid, w.ssid]
	return "[!] BSSID not found."

func aireplay_ng_deauth(cmd: String) -> String:
	if not monitor_enabled:
		return "[!] Error: wlan0 is not in monitor mode"
	return "[!] Sending simulated deauth packets...\n[+] Clients temporarily disconnected (simulated)."

# -------------------------
# Взлом клиента по индексу
func simulate_attack(index: int) -> String:
	if last_wifi_target == "":
		return "[!] Crack a Wi-Fi network first!"
	if index < 0 or index >= clients.size():
		return "[!] Invalid target index."
	var c = clients[index]
	client_handshakes[c.name] = true
	last_client_target = c.name
	return "[*] Target: %s (index %d)\n[*] Sending simulated deauth... \n[+] Handshake captured for %s (clientcapture-%s.cap)" % [c.name, index+1, c.name, c.name.replace(" ", "_")]

# -------------------------
# Взлом пароля (Wi-Fi или клиент)
func aircrack_ng_crack(cmd: String) -> String:
	var parts = cmd.split(" ")
	if parts.size() < 4:
		return "Usage: aircrack-ng -w <wordlist> <capture_file>"

	var cap_file = parts[3]
	var output = "[*] Cracking handshake (simulated)...\n"

	# Wi-Fi
	for w in wifi_networks:
		if cap_file.to_lower().find(w.ssid.to_lower()) != -1:
			if not wifi_handshakes[w.ssid]:
				return "[!] No handshake captured for Wi-Fi %s. Run airodump-ng -c first." % w.ssid
			var tries = ["12345678","password","qwerty123","letmein","12345"]
			for t in tries:
				output += "  Testing: %s\n" % t
			wifi_cracked[w.ssid] = w.password
			output += "[+] KEY FOUND for Wi-Fi %s: %s\n" % [w.ssid, w.password]
			return output

	# Клиент
	for c in clients:
		if cap_file.to_lower().find(c.name.to_lower().replace(" ", "_")) != -1:
			if not client_handshakes[c.name]:
				return "[!] No handshake captured for client %s. Run attack <n> first." % c.name
			var tries = ["12345678","password","qwerty123","letmein",c.password]
			for t in tries:
				output += "  Testing: %s\n" % t
			client_cracked[c.name] = c.password
			output += "[+] KEY FOUND for client %s: %s\n" % [c.name, c.password]
			return output

	return "[!] Capture file not recognized."
