extends Node

var terrain_tiles: Dictionary[String, TerrainTileDefinition]
var terrain_tile_lookup: Dictionary[Vector3i, String]


func add_terrain_tile(json_file: String, source_id: int, atlas_coords: Vector2i = Vector2i.ZERO):
	var data := Utils.get_json_data_from_file(json_file)
	var def := TerrainTileDefinition.new()
	def.deserialize(data)
	def.tile_source = source_id
	def.atlas_coords = atlas_coords
	
	assert(not terrain_tiles.has(def.name))
	terrain_tiles[def.name] = def
	terrain_tile_lookup[Vector3i(source_id, atlas_coords.x, atlas_coords.y)] = def.name
