extends Node

var track
var tags = {}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound
func load_wav(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamWAV.new()
	sound.data = file.get_buffer(file.get_length())
	return sound
func load_ogg(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamOggVorbis.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func addtrack(path: String) -> void:
	if path.ends_with(".mp3"):
		$".".track = load_mp3(path)
	elif path.ends_with(".wav"):
		$".".track = load_wav(path)
	elif path.ends_with(".ogg"):
		$".".track = load_ogg(path)
	pass
