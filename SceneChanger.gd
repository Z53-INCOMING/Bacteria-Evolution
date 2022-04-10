extends Node


func go_to_scene(path, current_scene):
	var loader = ResourceLoader.load_interactive(path)
	
	var loading_bar = load("res://Loading.tscn").instance()
	
	get_tree().get_root().call_deferred("add_child", loading_bar)
	
	while true:
		var err = loader.poll()
		if err == ERR_FILE_EOF:
			var resource = loader.get_resource()
			get_tree().get_root().call_deferred("add_child", resource.instance())
			loading_bar.queue_free()
			current_scene.queue_free()
			break
		if err == OK:
			var progress = float(loader.get_stage()) / loader.get_stage_count()
			loading_bar.value = progress
		yield(get_tree(), "idle_frame")
