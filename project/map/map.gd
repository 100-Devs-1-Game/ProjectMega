class_name Map
extends Node2D

const CHUNK_SIZE = 32
const CHUNK_CHANGES_PATH = "res://data/map/chunks/changes/"

@onready var terrain_tile_map: TileMapLayer = $Terrain
@onready var tile_maps: Dictionary[BaseTileDefinition.Layer, TileMapLayer] = {
	BaseTileDefinition.Layer.TERRAIN : terrain_tile_map
}
@onready var camera: Camera2D = $Camera2D


var chunks: Dictionary[Vector2i, MapChunk]


func _ready() -> void:
	TileSetCreator.fill_tile_set(terrain_tile_map.tile_set, ["terrain_tiles"])
	load_chunks()


func set_tile(layer: BaseTileDefinition.Layer, tile_pos: Vector2i,
	source: int, atlas_coords: Vector2i = Vector2i.ZERO
):
	tile_maps[layer].set_cell(tile_pos, source, atlas_coords)

func erase_tile(layer: BaseTileDefinition.Layer, tile_pos: Vector2i):
	tile_maps[layer].erase_cell(tile_pos)


func register_tile_change(type: TileChanges.Type, layer: BaseTileDefinition.Layer, tile_pos: Vector2i, tile_def: BaseTileDefinition = null):
	var data := get_chunk_at_tile(tile_pos)
	data.changes.add_row(TileChanges.Row.new(type, layer, tile_pos, tile_def))


func load_chunks():
	for res in ResourceLoader.list_directory(CHUNK_CHANGES_PATH):
		var file_path: String = CHUNK_CHANGES_PATH + res
		var file_name := res.get_basename()
		var data = JSON.parse_string(FileAccess.get_file_as_string(file_path))

		var split_name := file_name.split("_")
		var chunk_coords := Vector2i(int(split_name[1]), int(split_name[2]))
		var chunk := get_chunk(chunk_coords)
		chunk.deserialize_changes(data)
		render_tile_changes(chunk)


func render_tile_changes(chunk: MapChunk):
	var changes := chunk.changes
	for row in changes.rows:
		var tile_map := get_tilemap_for_layer(row.layer)
		var tile_pos := chunk.get_global_tile_pos(row.tile_pos)
		match row.type:
			TileChanges.Type.PLACE:
				tile_map.set_cell(tile_pos, row.tile_def.tile_source, row.tile_def.atlas_coords)
			TileChanges.Type.REMOVE:
				tile_map.erase_cell(tile_pos)


func get_tilemap_for_tile_def(tile_def: BaseTileDefinition)-> TileMapLayer:
	return get_tilemap_for_layer(tile_def.get_layer())


func get_tilemap_for_layer(layer: BaseTileDefinition.Layer)-> TileMapLayer:
	return tile_maps[layer]


func get_chunk_at_tile(tile_pos: Vector2i)-> MapChunk:
	var chunk_coords: Vector2i = get_chunk_coords(tile_pos)
	return get_chunk(chunk_coords)
	

func get_chunk(chunk_coords: Vector2i)-> MapChunk:
	if not chunks.has(chunk_coords):
		chunks[chunk_coords] = MapChunk.new(chunk_coords)
	return chunks[chunk_coords]


func get_mouse_tile()-> Vector2i:
	return terrain_tile_map.local_to_map(get_global_mouse_position())


static func get_chunk_coords(tile_pos: Vector2i)-> Vector2i:
	var tile_posv2 := Vector2(tile_pos)
	return Vector2(tile_posv2 / CHUNK_SIZE).floor()
