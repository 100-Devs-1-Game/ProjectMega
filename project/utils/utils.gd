class_name Utils


static func create_json_file(file_name: String, data):
	var file := FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


static func get_json_data_from_file(file_name: String)-> Dictionary:
	if not FileAccess.file_exists(file_name):
		push_error("File doesn't exist: ", file_name)
		return {}

	var text = FileAccess.get_file_as_string(file_name)
	assert(not text.is_empty())
	return JSON.parse_string(text)


static func remove_key_from_json_file(file_name: String, key: String):
	var data := get_json_data_from_file(file_name)
	if not data.has(key):
		push_error("Key %s doesn't exist in %s" % [ file_name, key ])
		return

	data.erase(key)
	create_json_file(file_name, data)


static func make_path(full_path: String):
	var rest_path := full_path.split("/")
	var path := rest_path[0]
	rest_path.remove_at(0)
	while not rest_path.is_empty():
		path += "/" + rest_path[0]
		rest_path.remove_at(0)
		
		if not DirAccess.dir_exists_absolute(path):
			var error := DirAccess.make_dir_absolute(path)
			if error != OK:
				push_error("Can't create path %s, error %d" % [path, error])
				return
