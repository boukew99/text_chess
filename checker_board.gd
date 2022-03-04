extends PanelContainer

onready var grid = $VBoxContainer/PanelContainer/GridContainer
onready var copy = $VBoxContainer/HBoxContainer/Copy
onready var save = $VBoxContainer/HBoxContainer/Save

func _ready():
	OS.min_window_size = OS.window_size
	
func _on_Save_pressed():
	var data = []
	
	var skip = 0
	for cell in grid.get_children():
		if cell.text:
			if skip:
				data.append(skip)
				skip = 0
				
			data.append(cell.text)
		else:
			skip += 1
	
	save.hint_tooltip = str(data)
	
	var file = File.new()
	file.open("user://chess.dat", File.WRITE)
	file.store_string(var2str(data))
	file.close()
	
func _on_Load_pressed():
	var file = File.new()
	file.open("user://chess.dat", File.READ)
	var data = str2var(file.get_as_text())
	file.close()
	
	var skip = 0
	for cell in grid.get_children():
		if skip:
			cell.text = ""
			skip -= 1
		else:
			var val = data.pop_front()
			
			if val is int:
				skip = val -1
				
			elif val is String:
				cell.text = val
			
# https://www.chess.com/terms/fen-chess
func _on_Copy_pressed():
	var fen = ""
	var count = 0
	
	for cell in grid.get_children():
		if cell.get_index() and cell.get_index() % 8 == 0: # 8 = columns
			if count:
				fen += str(count)
				count = 0
			fen+="/"
		
		if cell.text: 
			if count:
				fen += str(count)
				count = 0
				
			fen += cell.text
			
		else:
			count += 1
			
			if count == 8:
				fen += str(count)
				count = 0
		
	copy.hint_tooltip = fen
	OS.clipboard = fen

func _on_Paste_pressed():
	# clear
	for cell in grid.get_children():
		cell.text = ""
		
	var fen = OS.clipboard
	var cell = 0
	
	for character in fen:
		if character == "/":
			pass
		elif character.is_valid_integer():
			character = int(character)
			if character > 8: return # validity check
			cell += character
		else:
			grid.get_child(cell).text = character
			cell += 1
		
		if cell > 8 * 8 - 1: return # validity check 
