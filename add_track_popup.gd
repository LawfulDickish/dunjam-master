extends Control

var dragged = false
const SEPARATOR = "|"

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
	$PlayerWidget.load_track_by_file(path)
	$FilePath.text = path
	$NameInput.text = path.substr(path.rfind("/")+1,path.rfind(".")-path.rfind("/")-1) 
	#Auto-completes the name based on the filename by grabbing a substring between the last instance of the path "/" and the filename "."
	pass # Replace with function body.


func get_tag_name(tag: String) -> String: return tag.split(SEPARATOR)[1]
func get_tag_timecode(tag: String) -> float: return $PlayerWidget.text_timecode(tag.split(SEPARATOR)[0])

func get_tag_list() -> Array:
	var names = []
	for x in $Tags/List.item_count:
		names.append($Tags/List.get_item_text(x).split(SEPARATOR)[1])
	return names

func _on_add_pressed() -> void:
	if !($Tags/Input.text == ""):
		var name_code = $PlayerWidget.timecode_text($PlayerWidget/Progress.value) + SEPARATOR + $Tags/Input.text
		if ($Tags/Input.text in get_tag_list()):
			$Tags/List.set_item_text(get_tag_list().find($Tags/Input.text),name_code)
		else:
			$Tags/List.add_item(name_code)
		$Tags/Input.text = ""
	
	#Sets the timecode spinners to the current time even if nothing is added to tags
	set_time_spinners($PlayerWidget/Progress.value)
	pass 


func _on_remove_pressed() -> void:
	for select in $Tags/List.get_selected_items():
		$Tags/List.remove_item(select)
	pass 


func _on_list_item_activated(index: int) -> void:
	if $PlayerWidget/AudioStreamPlayer.playing:
		$PlayerWidget/AudioStreamPlayer.seek(get_tag_timecode($Tags/List.get_item_text(index)))
	else:
		$PlayerWidget/Progress.value = get_tag_timecode($Tags/List.get_item_text(index))
	pass 


func set_time_spinners(timestamp: float) -> void:
	$Tags/Minutes.value = floor(timestamp / 60)
	$Tags/Seconds.value = (timestamp as int) % 60
	$Tags/Milliseconds.value = (timestamp - floor(timestamp)) * 100
	pass 


func _on_add_at_time_pressed() -> void:
	if !($Tags/Input.text == ""):
		var test = "%d:%02d.%02d" % [$Tags/Minutes.value,$Tags/Seconds.value,$Tags/Milliseconds.value]
		var name_code = test + SEPARATOR + $Tags/Input.text
		if ($Tags/Input.text in get_tag_list()):
			$Tags/List.set_item_text(get_tag_list().find($Tags/Input.text),name_code)
		else:
			$Tags/List.add_item(name_code)
		$Tags/Input.text = ""
	pass 
