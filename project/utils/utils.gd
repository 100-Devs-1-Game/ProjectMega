class_name Utils

const REPOSITORY_URL = "100-Devs-1-Game/ProjectMega"

static func create_json_file(file_name: String, data):
	var file := FileAccess.open(file_name, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()


static func get_json_data_from_file(file_name: String)-> Variant:
	if not FileAccess.file_exists(file_name):
		push_error("File doesn't exist: ", file_name)
		return {}

	var text = FileAccess.get_file_as_string(file_name)
	assert(not text.is_empty())
	return JSON.parse_string(text)


static func remove_key_from_json_file(file_name: String, key: String):
	var data: Dictionary= get_json_data_from_file(file_name)
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

static func load_image_from_absolute_path(path: String)-> ImageTexture:
	var file := FileAccess.open(path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Can't open file ", file)
		return null
	var img_buffer = file.get_buffer(file.get_length())
	var img = Image.new()
	img.load_png_from_buffer(img_buffer)
	return ImageTexture.create_from_image(img)


static func does_repository_file_exist(file_path: String, node: Node, path_prefix: String = "project")-> bool:
	file_path = path_prefix.path_join(file_path)
	var repo_url := "https://raw.githubusercontent.com/" + REPOSITORY_URL
	var url: String = repo_url.path_join("refs/heads/main").path_join(file_path)
	var url_exists: bool = await does_url_exist(url, node)
	return url_exists


static func does_url_exist(url: String, node: Node)-> bool:
	var http_request = HTTPRequest.new()
	node.add_child(http_request)

	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		return false

	var result: Array = await http_request.request_completed
	http_request.queue_free()
	
	assert(result.size() == 4)
	prints("Does urls exist", url, result[1])
	return int(result[0]) == OK and int(result[1]) != 404
	
