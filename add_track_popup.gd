extends Control

var dragged = false
const SEPARATOR = "|"

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
	$Tags/List.clear()
	$SongProgress/AudioStreamPlayer.stream = $TagTrack.track
	$SongProgress.max_value = $SongProgress/AudioStreamPlayer.stream.get_length()
	$SongProgress.value = 0
	$SongProgress/Timecode.text = timecode_text($SongProgress.value) + " / " + timecode_text($SongProgress.max_value)
	$SongProgress/PlayPause.button_pressed = false
	
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
	$SongProgress/Timecode.text = timecode_text($SongProgress.value) + " / " + timecode_text($SongProgress.max_value)
	if $SongProgress/AudioStreamPlayer.playing and dragged:
		$SongProgress/AudioStreamPlayer.seek($SongProgress.value)
	pass # Replace with function body.

func timecode_text(length: float, precision: float = 2) -> String:
	var format = "%d:%0{0}.{1}f"
	var offset = 3 if precision > 0 else 2
	format = format.format([precision + offset, precision])
	var timecode = format % [ length / 60 , length - (floor(length / 60) * 60)]
	return timecode

func text_timecode(timecode: String):
	var length
	var minutes = timecode.split(":")[0] as int
	var seconds = timecode.split(":")[1] as float
	length = minutes * 60.0 + seconds
	return length

func get_tag_name(tag: String) -> String: return tag.split(SEPARATOR)[1]
func get_tag_timecode(tag: String) -> float: return text_timecode(tag.split(SEPARATOR)[0])

func get_tag_list() -> Array:
	var names = []
	for x in $Tags/List.item_count:
		names.append($Tags/List.get_item_text(x).split(SEPARATOR)[1])
	return names


func _on_song_progress_drag_started() -> void:
	dragged = true
	pass # Replace with function body.


func _on_song_progress_drag_ended(value_changed: bool) -> void:
	dragged = false
	pass # Replace with function body.


func _on_audio_stream_player_finished() -> void:
	$SongProgress/PlayPause.button_pressed = false
	pass # Replace with function body.


func _on_add_pressed() -> void:
	if !($Tags/Input.text == ""):
		var name_code = timecode_text($SongProgress.value) + SEPARATOR + $Tags/Input.text
		if ($Tags/Input.text in get_tag_list()):
			$Tags/List.set_item_text(get_tag_list().find($Tags/Input.text),name_code)
		else:
			$Tags/List.add_item(name_code)
		$Tags/Input.text = ""
	pass # Replace with function body.


func _on_remove_pressed() -> void:
	for select in $Tags/List.get_selected_items():
		$Tags/List.remove_item(select)
	pass # Replace with function body.


func _on_list_item_activated(index: int) -> void:
	if $SongProgress/AudioStreamPlayer.playing:
		$SongProgress/AudioStreamPlayer.seek(get_tag_timecode($Tags/List.get_item_text(index)))
	else:
		$SongProgress.value = get_tag_timecode($Tags/List.get_item_text(index))
	pass # Replace with function body.
