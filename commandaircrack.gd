extends Node

var monitor_enabled = false
var captured_handshake = false
var cracked_password = ""

func process_command(input: String) -> String:
	var cmd = input.strip_edges()
	var lower_cmd = cmd.to_lower()

	if lower_cmd == "go":
		return go("")
	elif lower_cmd == "help":
		return help()
	elif lower_cmd == "airmon-ng start wlan0":
		return airmon_ng_start_wlan0()
	elif lower_cmd == "airodump-ng wlan0mon":
		return airodump_ng_wlan0mon()
	elif lower_cmd.begins_with("airodump-ng -c "):
		return airodump_ng_capture(cmd)
	elif lower_cmd.begins_with("aireplay-ng --deauth"):
		return aireplay_ng_deauth(cmd)
	elif lower_cmd.begins_with("aircrack-ng -w "):
		return aircrack_ng_crack(cmd)
	elif lower_cmd.begins_with("go "):
		return go(cmd.substr(3, cmd.length() - 3))
	else:
		return "Unrecognised command - please try again."


func go(direction: String) -> String:
	if direction == "":
		return "Go where?"
	return "You go %s" % direction


func help() -> String:
	return """Aircrack-ng 1.52 rc52 - (C) 2006 - 2025
Common commands:
  go <direction>               - Move somewhere (example: go north)
  help                         - Show this help menu

  airmon-ng start wlan0        - Enable monitor mode on wlan0
  airodump-ng wlan0mon         - Scan for Wi-Fi networks
  airodump-ng -c <channel> --bssid <BSSID> -w capture wlan0mon
							   - Capture handshake from target network
  aireplay-ng --deauth <n> -a <BSSID> wlan0mon
							   - Send deauth packets to clients
  aircrack-ng -w <wordlist> <capture_file>
							   - Crack captured handshake with wordlist

Examples:
  airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon
  aireplay-ng --deauth 10 -a AA:BB:CC:DD:EE:FF wlan0mon
  aircrack-ng -w /usr/share/wordlists/rockyou.txt capture-01.cap
"""


func airmon_ng_start_wlan0() -> String:
	if monitor_enabled:
		return "[!] wlan0 is already in monitor mode (wlan0mon)"
	monitor_enabled = true
	return "[+] Monitor mode enabled on wlan0 -> wlan0mon"


func airodump_ng_wlan0mon() -> String:
	if not monitor_enabled:
		return "[!] Error: wlan0 is not in monitor mode"
	var networks = [
		"AA:BB:CC:DD:EE:FF  MyWiFi     WPA2  Ch 6",
		"11:22:33:44:55:66  CafeNet    WPA3  Ch 11",
		"77:88:99:AA:BB:CC  OpenFree   OPN   Ch 1"
	]
	var output = "[*] Scanning for Wi-Fi networks...\n"
	for net in networks:
		output += net + "\n"
	return output.strip_edges()


func airodump_ng_capture(cmd: String) -> String:
	if not monitor_enabled:
		return "[!] Error: wlan0 is not in monitor mode"
	var parts = cmd.split(" ")
	if parts.size() >= 6:
		var channel = parts[2]
		var bssid = parts[4]
		captured_handshake = true
		return "[*] Listening on channel %s for BSSID %s...\n[+] Handshake captured! Saved to capture-01.cap" % [channel, bssid]
	return "Usage: airodump-ng -c <channel> --bssid <BSSID> -w capture wlan0mon"


func aireplay_ng_deauth(cmd: String) -> String:
	if not monitor_enabled:
		return "[!] Error: wlan0 is not in monitor mode"
	var parts = cmd.split(" ")
	if parts.size() >= 6:
		var count = parts[2]
		var bssid = parts[4]
		return "[!] Sending %s deauth packets to %s via wlan0mon\n[+] Clients disconnected." % [count, bssid]
	return "Usage: aireplay-ng --deauth <n> -a <BSSID> wlan0mon"


func aircrack_ng_crack(cmd: String) -> String:
	if not captured_handshake:
		return "[!] Error: No handshake file found (run airodump-ng first)"
	var parts = cmd.split(" ")
	if parts.size() >= 4:
		var wordlist = parts[2]
		var capfile = parts[3]
		# имитация подбора пароля
		var tries = ["12345678", "password", "qwerty123", "letmein", "superwifi123"]
		var output = "[*] Cracking %s with wordlist %s...\n" % [capfile, wordlist]
		for i in range(tries.size()):
			output += "  Testing: %s\n" % tries[i]
		cracked_password = "superwifi123"
		output += "[+] KEY FOUND: %s" % cracked_password
		return output
	return "Usage: aircrack-ng -w <wordlist> <capture_file>"
