extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_add_track_pressed() -> void:
	$PopupWindow.visible = true
	pass # Replace with function body.

func _on_play_track_pressed() -> void:
	$"PanelHolder/TrackDependencies/InfoSection/Player Section/CurrentTrack".play()
	pass # Replace with function body.


func _on_stop_track_pressed() -> void:
	$"PanelHolder/TrackDependencies/InfoSection/Player Section/CurrentTrack".stop()
	pass # Replace with function body.
