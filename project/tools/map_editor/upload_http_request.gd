class_name UploadHTTPRequest
extends HTTPRequest

var file_path: String

func _on_http_request_request_completed(result: int, _response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("HTTP request failed ", result)
	assert(not file_path.is_empty())
	DirAccess.remove_absolute(file_path)
	queue_free()
