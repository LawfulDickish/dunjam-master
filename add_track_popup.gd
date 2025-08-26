extends Control

var dragged = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $SongProgress/AudioStreamPlayer.playing:
		$SongProgress.value = $SongProgress/AudioStreamPlayer.get_playback_position()
	pass


func _on_file_select_button_pressed() -> void:
	$TrackSelect.visible = true
	pass # Replace with function body.

func _on_track_select_file_selected(path: String) -> void:
	$TagTrack.addtrack(path)
	$SongProgress/AudioStreamPlayer.stream = $TagTrack.track
	$SongProgress.value = 0
	$SongProgress.max_value = $SongProgress/AudioStreamPlayer.stream.get_length()
	
	$FilePath.text = path
	$NameInput.text = path.substr(path.rfind("/")+1,path.rfind(".")-path.rfind("/")-1) 
	#Auto-completes the name based on the filename by grabbing a substring between the last instance of the path "/" and the filename "."
	pass # Replace with function body.


func _on_play_pause_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$SongProgress/AudioStreamPlayer.play($SongProgress.value)
	else:
		$SongProgress/AudioStreamPlayer.stop()
	pass # Replace with function body.


func _on_song_progress_value_changed(value: float) -> void:
	$SongProgress/Label.text = "%d:%02d / %d:%02d" % [
		$SongProgress.value / 60 , ($SongProgress.value as int) % 60,
		$SongProgress.max_value / 60 , ($SongProgress.max_value as int) % 60]
	if $SongProgress/AudioStreamPlayer.playing and dragged:
		$SongProgress/AudioStreamPlayer.seek($SongProgress.value)
	pass # Replace with function body.


func _on_song_progress_drag_started() -> void:
	dragged = true
	pass # Replace with function body.


func _on_song_progress_drag_ended(value_changed: bool) -> void:
	dragged = false
	pass # Replace with function body.
