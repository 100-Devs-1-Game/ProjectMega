class_name Utils


static func get_json_data_from_file(file_name: String)-> Dictionary:
	if not FileAccess.file_exists(file_name):
		push_error("File doesn't exist: ", file_name)
		return {}

	var text = FileAccess.get_file_as_string(file_name)
	assert(not text.is_empty())
	return JSON.parse_string(text)


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
