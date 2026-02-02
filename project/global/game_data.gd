extends Node

var tiles: Dictionary # Dictionary[BaseTileDefinition.Layer, Dictionary[String, BaseTileDefinition]]

# Vector3i( source_id, atlas coords.x, atlas_coords.y ) -> tile name
var tile_lookup: Dictionary[Vector3i, BaseTileDefinition]


func add_tile(json_file: String, source_id: int, atlas_coords: Vector2i = Vector2i.ZERO):
	var data := Utils.get_json_data_from_file(json_file)
	var layer: BaseTileDefinition.Layer = data["layer"]
	var def: BaseTileDefinition= BaseTileDefinition.create_instance(layer)
	def.deserialize(data)
	def.tile_source = source_id
	def.atlas_coords = atlas_coords
	
	if not tiles.has(layer):
		tiles[int(layer)]= {}
	var tiles_dict: Dictionary = tiles[layer]
	
	assert(not tiles_dict.has(def.name))
	tiles_dict[def.name] = def
	tile_lookup[Vector3i(source_id, atlas_coords.x, atlas_coords.y)] = def


func get_tile(layer: BaseTileDefinition.Layer, tile_name: String)-> BaseTileDefinition:
	assert(tiles.has(int(layer)))
	var tiles_dict: Dictionary = tiles[int(layer)]
	assert(tiles_dict.has(tile_name))
	return tiles_dict[tile_name]
