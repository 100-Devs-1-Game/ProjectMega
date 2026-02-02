class_name MapChunkData

var changes: TileChanges = TileChanges.new()



func dump_changes(file: FileAccess):
	var data_arr := []
	for row in changes.get_dirty_rows():
		data_arr.append(row.serialize())
	file.store_string(JSON.stringify(data_arr))
	changes.mark_all_clean()
