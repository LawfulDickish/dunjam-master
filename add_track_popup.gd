extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_file_select_button_pressed() -> void:
	$TrackSelect.visible = true
	pass # Replace with function body.

func _on_track_select_file_selected(path: String) -> void:
	$FilePath.text = path
	$NameInput.text = path.substr(path.rfind("/")+1,path.rfind(".")-path.rfind("/")-1) 
	#Auto-completes the name based on the filename by grabbing a substring between the last instance of the path "/" and the filename "."
	pass # Replace with function body.
