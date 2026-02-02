class_name MapEditorUI
extends CanvasLayer

signal save
signal upload_files

@export var create_tile_form: PackedScene

@onready var upload_files_button: Button = %UploadFiles


func enable_upload_button():
	upload_files_button.disabled = false


func _on_create_tile_pressed() -> void:
	UIManager.open_form(create_tile_form)


func _on_upload_files_pressed() -> void:
	upload_files_button.disabled = true
	upload_files.emit()


func _on_save_pressed() -> void:
	save.emit()
