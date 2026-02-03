class_name TileChanges

enum Type { PLACE, REMOVE }

class Row:
	var type: Type
	var tile_def: BaseTileDefinition
	var tile_pos: Vector2i
	var layer: BaseTileDefinition.Layer
	
	func _init(p_type: Type, p_layer: BaseTileDefinition.Layer, pos: Vector2i, def: BaseTileDefinition = null):
		type = p_type
		layer = p_layer
		tile_pos = Vector2i(wrapi(pos.x, 0, Map.CHUNK_SIZE), wrapi(pos.y, 0, Map.CHUNK_SIZE))
		tile_def = def

	func serialize()-> Dictionary:
		var data := {}
		data["type"] = int(type)
		data["layer"] = int(layer)
		data["tile_pos"] = [tile_pos.x, tile_pos.y]
		if tile_def:
			data["tile_def"] = tile_def.name
		return data
	
	static func deserialize(data: Dictionary)-> Row:
		var tile_layer: BaseTileDefinition.Layer = data["layer"]
		var tile_pos_arr: Array = data["tile_pos"]
		return Row.new(
			data["type"],
			tile_layer,
			Vector2i(tile_pos_arr[0], tile_pos_arr[1]),
			GameData.get_tile_definition(tile_layer, data["tile_def"]) if data.has("tile_def") else null
		)
	
	func same_tile_as(other_row: Row)-> bool:
		return tile_pos == other_row.tile_pos and layer == other_row.layer


var rows: Array[Row]
var dirty_idx: int = -1



func add_row(new_row: Row, dirty: bool = true):
	if dirty and dirty_idx == -1:
		dirty_idx = rows.size()

	# TODO make sure the following code is correct before uncommenting again
	#
	#for row in rows.duplicate():
		#if row.same_tile_as(new_row):
			#if rows.find(row) < dirty_idx:
				#dirty_idx -= 1
			#rows.erase(row)

	rows.append(new_row)


func get_dirty_rows()-> Array[Row]:
	var result: Array[Row]
	
	for i in range(max(dirty_idx, 0), rows.size()):
		result.append(rows[i])
	return result


func mark_all_clean():
	dirty_idx = -1
