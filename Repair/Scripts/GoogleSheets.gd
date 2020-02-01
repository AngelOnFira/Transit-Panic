extends Node

var http_request = HTTPRequest.new()
signal sheets_reciever

func _ready():
	add_child(http_request)

func get_sheet(caller, sheet_key, sheet_name):
	add_child(http_request)
	var url = "https://docs.google.com/spreadsheets/d/{key}/gviz/tq?tqx=out:csv&sheet={sheet_name}"
	var url_filled = url.format({
		"key": sheet_key,
		"sheet_name": sheet_name
	})
	print(url_filled)
	http_request.connect("request_completed", self, "_on_request_completed")
	http_request.connect("sheets_request_finished", caller, "sheets_request_finished")
	http_request.request(url_filled)

func _on_request_completed(_result, response_code, _headers, body):
	get_tree().paused = true
	if response_code != 200:
		print("Not able to load CSV")
		
	print(body.get_string_from_utf8())
	
	#emit_signal(sheets_reciever)
