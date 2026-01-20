class_name MapEditor
extends Node2D

const EXPORT_PATH = "export"
const TERRAIN_TILES_PATH = "terrain_tiles"

@export var upload_request_scene: PackedScene

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
	Utils.create_json_file(path.path_join(file_name), data)


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
	target_path = "map".path_join(target_path)
	
	var upload_file_name := json_path.get_file().get_basename() + "." + file_path.get_extension()
	prints("Target path", target_path.path_join(upload_file_name))
	
	var headers := [
		"Content-Type: application/" + ( "json" if file_path.ends_with("json") else "octet-stream" ),
		"X-Filename: " + upload_file_name,
		"X-Target: " + target_path
	]

	var texture_path: String
	if file_path.ends_with("json"):
		var data := Utils.get_json_data_from_file(file_path)
		if data.has("texture_path"):
			texture_path = data["texture_path"]
			# TODO
			Utils.remove_key_from_json_file(file_path, "texture_path")

	var bytes := FileAccess.get_file_as_bytes(file_path)

	var http: UploadHTTPRequest = upload_request_scene.instantiate()
	add_child(http)
	
	# use IP to prevent CORS redirection issues in browser builds
	var error = http.request_raw("http://212.227.166.210:8000/upload/", headers, HTTPClient.METHOD_POST, bytes)
	if error != OK:
		push_error("Http Request error ", error)
		return

	if texture_path:
		upload_export_file(texture_path, file_path)
