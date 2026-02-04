extends GutTest

func test_url_exists():
	var url_exists = await Utils.does_url_exist("https://www.google.com", self)
	assert_true(url_exists)
	
	url_exists = await Utils.does_url_exist("https://www.fake-url-that-doesnt-exist-kjhhbzjuhg.com", self)
	assert_false(url_exists)
	
func test_repo_file_exists():
	var file_exists = await Utils.does_repository_file_exist("project.godot", self)
	assert_true(file_exists)
	
	file_exists = await Utils.does_repository_file_exist("project_not.godot", self)
	assert_false(file_exists)
