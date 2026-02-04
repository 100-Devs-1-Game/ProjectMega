class_name TileSetCreator


static func fill_tile_set(tile_set: TileSet, paths: Array[String]):
	assert(tile_set.tile_size.x == tile_set.tile_size.y)
	var tile_size: int = tile_set.tile_size.x

	var collision_polygon := [ Vector2(0, 0), Vector2(tile_size, 0), Vector2(tile_size, tile_size),  Vector2(0, tile_size) ]

	for i in collision_polygon.size():
		collision_polygon[i] = collision_polygon[i] - Vector2.ONE * tile_size / 2

	for path in paths:
		for res in ResourceLoader.list_directory(GameData.ASSET_PATH + path):
			var texture_path: String = GameData.ASSET_PATH + path + "/" + res
			var tile_name := res.get_basename()
			var json_file: String = GameData.DATA_PATH + path + "/" + tile_name + ".json"
			add_source_tile(tile_set, json_file, texture_path)


static func add_source_tile(tile_set: TileSet, json_file: String, texture_path: String):
	assert(tile_set.tile_size.x == tile_set.tile_size.y)
	var tile_size: int = tile_set.tile_size.x

	var texture
	if texture_path.begins_with("res:"):
		texture = load(texture_path)
	else:
		texture = Utils.load_image_from_absolute_path(texture_path)
	
	var source := TileSetAtlasSource.new()
	source.texture_region_size = Vector2i.ONE * tile_size
	source.texture = texture
	source.create_tile(Vector2i.ZERO)
		
	tile_set.add_source(source)
	
	#if has_collision:
		#var tile_data: TileData = source.get_tile_data(Vector2i.ZERO, 0)
		#tile_data.add_collision_polygon(0)
		#var polygon: PackedVector2Array = tile_def.custom_collision_polygon if tile_def.custom_collision_polygon else collision_polygon
		#tile_data.set_collision_polygon_points(0, 0, polygon)
	
	GameData.add_tile(json_file, tile_set.get_source_count() - 1)
