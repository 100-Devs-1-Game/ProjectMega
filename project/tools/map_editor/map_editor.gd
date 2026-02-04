class_name MapEditor
extends Node2D

const EXPORT_PATH = "export"

@export var debug_skip_uploading: bool = false
@export var upload_request_scene: PackedScene

@onready var map: Map = $Map
@onready var ui: MapEditorUI = $MapEditorUI



var new_tiles: Array[BaseTileDefinition]


func _ready() -> void:
	GlobalRefs.map_editor = self
	
	ui.save.connect(save)
	ui.upload_files.connect(upload_export_dir)


func place_tile(tile_pos: Vector2i, tile_def: BaseTileDefinition,
	layer: BaseTileDefinition.Layer = BaseTileDefinition.Layer.TERRAIN
):
	map.set_tile(layer, tile_pos, tile_def.tile_source, tile_def.atlas_coords)
	map.register_tile_change(TileChanges.Type.PLACE, layer, tile_pos, tile_def)


func remove_tile(tile_pos: Vector2i, layer: BaseTileDefinition.Layer = BaseTileDefinition.Layer.TERRAIN):
	map.erase_tile(layer, tile_pos)
	map.register_tile_change(TileChanges.Type.REMOVE, layer, tile_pos)


func register_tile(tile_name: String, type: BaseTileDefinition.Layer, texture_path: String):
	var tile_def: BaseTileDefinition
	match type:
		BaseTileDefinition.Layer.TERRAIN:
			tile_def = TerrainTileDefinition.new()
	
	tile_def.name = tile_name
	new_tiles.append(tile_def)
	
	var json_file: String = create_export_file(tile_def, texture_path)
	TileSetCreator.add_source_tile(map.get_tilemap_for_tile_def(tile_def).tile_set, json_file, texture_path)
	ui.enable_upload_button()


func save() -> void:
	export_tile_changes()


func create_export_file(tile_def: BaseTileDefinition, tile_texture_path: String)-> String:
	var data := tile_def.serialize()
	data["texture_path"] = tile_texture_path

	var path: String = tile_def.get_export_path()
	print(path)
	Utils.make_path(path)

	var file_name: String = tile_def.name + ".json"
	var file_path: String= path.path_join(file_name)
	Utils.create_json_file(file_path, data)
	return file_path


func export_tile_changes():
	var base_path = get_export_path().path_join("chunks").path_join("changes")
	Utils.make_path(base_path)
	for chunk_coords in map.chunk_data.keys():
		var file_name: String = "chunk_%d_%d.json" % [chunk_coords.x, chunk_coords.y]
		var file := FileAccess.open(base_path.path_join(file_name), FileAccess.WRITE)
		if FileAccess.get_open_error() != OK:
			push_error("Can't open file ", base_path.path_join(file_name))
			return
		var chunk: MapChunk = map.chunk_data[chunk_coords]
		chunk.dump_changes(file)
		file.close()


func upload_export_dir(path: String= OS.get_user_data_dir().path_join(EXPORT_PATH)):
	if debug_skip_uploading:
		return

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

	var upload_file_name := json_path.get_file().get_basename() + "." + file_path.get_extension()
	prints("Target path", target_path.path_join(upload_file_name))

	var headers := [
		"Content-Type: application/" + ( "json" if file_path.ends_with("json") else "octet-stream" ),
		"X-Filename: " + upload_file_name,
		"X-Target: " + target_path
	]

	var texture_path: String
	if file_path.ends_with("json"):
		var data = Utils.get_json_data_from_file(file_path)
		if data is Dictionary:
			if data.has("texture_path"):
				texture_path = data["texture_path"]
				# TODO
				Utils.remove_key_from_json_file(file_path, "texture_path")

	var bytes := FileAccess.get_file_as_bytes(file_path)

	var http: UploadHTTPRequest = upload_request_scene.instantiate()
	http.file_path = file_path
	add_child(http)
	
	# use IP to prevent CORS redirection issues in browser builds
	var error = http.request_raw("http://212.227.166.210:8000/upload", headers, HTTPClient.METHOD_POST, bytes)
	if error != OK:
		push_error("Http Request error ", error)
		return

	if texture_path:
		upload_export_file(texture_path, file_path)


func get_mouse_tile()-> Vector2i:
	return map.get_mouse_tile()


static func get_export_path()-> String:
	return OS.get_user_data_dir().path_join(MapEditor.EXPORT_PATH).path_join("map")
