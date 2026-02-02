class_name Map
extends Node2D

const CHUNK_SIZE = 32

@onready var terrain_tile_map: TileMapLayer = $Terrain
@onready var tile_maps: Dictionary[BaseTileDefinition.Layer, TileMapLayer] = {
	BaseTileDefinition.Layer.TERRAIN : terrain_tile_map
}

var chunk_data: Dictionary[Vector2i, MapChunkData]


func _ready() -> void:
	TileSetCreator.fill_tile_set(terrain_tile_map.tile_set, ["terrain_tiles"])


func set_tile(layer: BaseTileDefinition.Layer, tile_pos: Vector2i,
	source: int, atlas_coords: Vector2i = Vector2i.ZERO
):
	tile_maps[layer].set_cell(tile_pos, source, atlas_coords)

func erase_tile(layer: BaseTileDefinition.Layer, tile_pos: Vector2i):
	tile_maps[layer].erase_cell(tile_pos)


func register_tile_change(type: TileChanges.Type, layer: BaseTileDefinition.Layer, tile_pos: Vector2i, tile_def: BaseTileDefinition = null):
	var data := get_chunk_data_at_tile(tile_pos)
	data.changes.add_row(TileChanges.Row.new(type, layer, tile_pos, tile_def))


func get_tilemap_for_tile_def(tile_def: BaseTileDefinition)-> TileMapLayer:
	return tile_maps[tile_def.get_type()]


func get_chunk_data_at_tile(tile_pos: Vector2)-> MapChunkData:
	var chunk_coords: Vector2i = get_chunk_coords(tile_pos)
	
	if not chunk_data.has(chunk_coords):
		chunk_data[chunk_coords] = MapChunkData.new()
	return chunk_data[chunk_coords]


func get_mouse_tile()-> Vector2i:
	return terrain_tile_map.local_to_map(get_global_mouse_position())


static func get_chunk_coords(tile_pos: Vector2i)-> Vector2i:
	return Vector2(tile_pos / CHUNK_SIZE).floor()
