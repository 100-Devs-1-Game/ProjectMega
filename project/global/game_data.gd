extends Node

var terrain_tiles: Dictionary[String, TerrainTileDefinition]


func add_terrain_tile(json_file: String, source_id: int, atlas_coords: Vector2i = Vector2i.ZERO):
	var data: Variant = Utils.get_json_data_from_file(json_file)
	var def := TerrainTileDefinition.new()
	def.name = data.name
	def.tile_source = source_id
	def.atlas_coords = atlas_coords
	
	assert(not terrain_tiles.has(def.name))
	terrain_tiles[def.name] = def
