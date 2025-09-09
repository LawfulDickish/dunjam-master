extends Control
var natProg = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if $TagTrack.track != null:
		$AudioStreamPlayer.stream = $TagTrack.track
		$Progress.max_value = $AudioStreamPlayer.stream.get_length()
		$Progress.value = 0
		$Progress.step = .01
		$Progress.page = 5
		$Progress/PlayPause.button_pressed = false
		$Progress/Timecode.text = timecode_text($Progress.value) + " / " + timecode_text($Progress.max_value)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $AudioStreamPlayer.playing:
		natProg = true
		$Progress.value = $AudioStreamPlayer.get_playback_position()
		natProg = false
	pass


func load_track_by_file(path: String) -> void:
	$TagTrack.addtrack(path)
	_ready()
	pass

func load_track(track: AudioStream) -> void:
	$TagTrack.track = track
	_ready()
	pass

func timecode_text(length: float, precision: float = 2) -> String:
	var format = "%d:%0{0}.{1}f"
	var offset = 3 if precision > 0 else 2
	format = format.format([precision + offset, precision])
	var timecode = format % [ length / 60 , length - (floor(length / 60) * 60)]
	return timecode

func text_timecode(timecode: String) -> float:
	var length
	var minutes = timecode.split(":")[0] as int
	var seconds = timecode.split(":")[1] as float
	length = minutes * 60.0 + seconds
	return length

func get_timestamp() -> float:
	return $Progress.value

func _on_play_pause_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$AudioStreamPlayer.play($Progress.value)
	else:
		$AudioStreamPlayer.stop()
	pass
	
func _on_audio_stream_player_finished() -> void:
	$Progress/PlayPause.button_pressed = false
	pass

func _on_progress_value_changed(value: float) -> void:
	#Set timecode
	$Progress/Timecode.text = timecode_text($Progress.value) + " / " + timecode_text($Progress.max_value)
	if $AudioStreamPlayer.playing and !natProg:
		$AudioStreamPlayer.seek($Progress.value)
	pass


func _on_volume_value_changed(value: float) -> void:
	$AudioStreamPlayer.volume_db = value
	pass # Replace with function body.
