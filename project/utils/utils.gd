class_name Utils

static func get_json_data_from_file(file_name: String)-> Variant:
	if not FileAccess.file_exists(file_name):
		push_error("File doesn't exist: ", file_name)
		return null

	var text = FileAccess.get_file_as_string(file_name)
	assert(not text.is_empty())
	return JSON.parse_string(text)
