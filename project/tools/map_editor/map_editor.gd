class_name MapEditor
extends Node2D

const EXPORT_PATH = "export"
const TERRAIN_TILES_PATH = "terrain_tiles"

@onready var http: HTTPRequest = $HTTPRequest

var new_tiles: Array[BaseTileDefinition]


func _ready() -> void:
	GlobalRefs.map_editor = self


func register_tile(tile_name: String, tile_texture_path: String):
	var tile_def := TerrainTileDefinition.new()
	tile_def.name = tile_name
	new_tiles.append(tile_def)
	
	create_export_file(tile_def, tile_texture_path)


func create_export_file(tile_def: BaseTileDefinition, tile_texture_path: String):
	var data := tile_def.serialize()
	data["texture_path"] = tile_texture_path

	var path: String = OS.get_user_data_dir().path_join(EXPORT_PATH).path_join(TERRAIN_TILES_PATH)
	print(path)
	Utils.make_path(path)

	var file_name: String = tile_def.name + ".json"
	var file := FileAccess.open(path.path_join(file_name), FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


func upload_export_dir(path: String= OS.get_user_data_dir().path_join(EXPORT_PATH)):
	for file in DirAccess.get_files_at(path):
		upload_export_file(path.path_join(file))

	for dir in DirAccess.get_directories_at(path):
		upload_export_dir(path.path_join(dir))


func upload_export_file(file_path: String, json_path: String = ""):
	if json_path.is_empty():
		json_path = file_path
	prints("Uploading file", file_path)

	var target_path : String = json_path.split(EXPORT_PATH + "/")[1]
	target_path = target_path.rsplit("/", false, 1)[0]
	prints("Target path", target_path)
	
	var headers := [
		"Content-Type: application/" + "json" if file_path.ends_with("json") else "octet-stream",
		"X-Filename: " + file_path.get_file(),
		"X-Target: " + target_path
	]

	var texture_path: String
	if file_path.ends_with("json"):
		var data := Utils.get_json_data_from_file(file_path)
		if data.has("texture_path"):
			texture_path = data["texture_path"]
			# TODO
			#Utils.remove_key_from_json_file(file_path, "texture_path")

	var bytes := FileAccess.get_file_as_bytes(file_path)

	var error = http.request_raw("http://onehundred.dev:8000/upload", headers, HTTPClient.METHOD_POST, bytes)
	if error != OK:
		push_error("Http Request error ", error)
		return

	if texture_path:
		upload_export_file(texture_path, file_path)


func _on_http_request_request_completed(result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("HTTP request failed ", result)
