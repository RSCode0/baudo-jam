extends Node2D

var location = "user://Save.tres"
var SaveFile: ResourceSaveData = ResourceSaveData.new()

func _ready() -> void:
	_load()

func get_data():
	return SaveFile

func _load():
	if FileAccess.file_exists(location):
		SaveFile = ResourceLoader.load(location)

func save():
	ResourceSaver.save(SaveFile, location)
