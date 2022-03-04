extends Button

func _ready():
	hint_tooltip = str(get_index())
	
func get_drag_data(_position):
	return self

func can_drop_data(_position, data):
	return "text" in data and not data.name == self.name
	
func drop_data(_position, data):
	text = data.text
	data.text = ""
