class_name MapChunk

var coords: Vector2i
var changes: TileChanges = TileChanges.new()



func _init(p_coords: Vector2i):
	coords = p_coords


func deserialize_changes(arr: Array):
	for item in arr:
		changes.add_row(TileChanges.Row.deserialize(item), false)
	
	
func dump_changes(file: FileAccess):
	var data_arr := []
	for row in changes.get_dirty_rows():
		data_arr.append(row.serialize())
	file.store_string(JSON.stringify(data_arr))
	changes.mark_all_clean()


func get_global_tile_pos(local_tile_pos: Vector2i)-> Vector2i:
	return local_tile_pos + coords * Map.CHUNK_SIZE
