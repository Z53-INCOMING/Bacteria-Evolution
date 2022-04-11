extends Node2D

onready var bacteriaScene = preload("res://Bacterium.tscn")
onready var foodScene = preload("res://food.tscn")

onready var Food = $Food
onready var Bacteria = $Bacteria
onready var label = $UI/bacteriaLabel
onready var speed = $UI/speed
onready var camera = $Camera2D
onready var lifeSpanLabel = $UI/lifeSpan
onready var childrenLabel = $UI/children
onready var timeLabel = $UI/timeLabel
onready var scaleLabel = $UI/scale
onready var fps = $UI/fps
onready var smartLabel = $UI/smart
onready var oviparousLabel = $UI/oviparous
onready var gestationLabel = $UI/gestation
onready var oviSmartLabel = $UI/oviSmart
onready var messages = $UI/message
onready var UI = $UI

var lifeSpans = []

var space = 2500

var sharpness = 7

var time = 0.0

var period = 160

var scaledPopulation = 300.0

var foodNoise = OpenSimplexNoise.new()

func _ready() -> void:
	randomize()
	period = Globals.period
	space = Globals.mapSize
	sharpness = Globals.sharpness
	foodNoise.seed = rand_range(0, 10000)
	foodNoise.period = period
	foodNoise.octaves = 1
	bacteria(clamp(space / 5, 50, 300))
	food(clamp(space * 2, 500, 5000))
	get_tree().paused = true



func food(amount):
	for _f in range(amount):
		var food = foodScene.instance()
		var randPositions = []
		for _i in range(0, sharpness):
			randPositions.append(Vector2(rand_range(-space, space), rand_range(-space, space)))
		var bestValue = 0
		var bestPosition = Vector2(rand_range(-space, space), rand_range(-space, space))
		for pos in randPositions:
			if (foodNoise.get_noise_2dv(pos + Vector2(space, space)) + 1) / 2 > bestValue:
				bestValue = (foodNoise.get_noise_2dv(pos) + 1) / 2
				bestPosition = pos
			
		food.global_position = bestPosition
		Food.add_child(food)
	

func bacteria(quantity):
	for _b in range(quantity):
		var bacteria = bacteriaScene.instance()
		var randPositions = []
		for _i in range(0, 14):
			randPositions.append(Vector2(rand_range(-space, space), rand_range(-space, space)))
		var bestPosition = Vector2(rand_range(-space, space), rand_range(-space, space))
		if space != 5000:
			var bestValue = 10.0
			for pos in randPositions:
				if (foodNoise.get_noise_2dv(pos + Vector2(space, space)) + 1) / 2 < bestValue:
					bestValue = (foodNoise.get_noise_2dv(pos) + 1) / 2
					bestPosition = pos
		else:
			var bestValue = 0.0
			for pos in randPositions:
				if (foodNoise.get_noise_2dv(pos + Vector2(space, space)) + 1) / 2 > bestValue:
					bestValue = (foodNoise.get_noise_2dv(pos) + 1) / 2
					bestPosition = pos
		bacteria.global_position = bestPosition
		bacteria.global_rotation_degrees = rand_range(-180, 180)
		bacteria.onRight = round(rand_range(-2, 2))
		bacteria.onLeft = round(rand_range(-2, 2))
		bacteria.onForward = round(rand_range(-2, 2))
		bacteria.onEggRight = round(rand_range(-2, 2))
		bacteria.onEggLeft = round(rand_range(-2, 2))
		bacteria.onEggForward = round(rand_range(-2, 2))
		bacteria.scale.x = rand_range(0.2, 2.0)
		if round(rand_range(0.0, 2.0)) == 0:
			bacteria.oviparous = true
		if round(rand_range(0.0, 9.0)) == 0.0:
			bacteria.toxic = true
		if round(rand_range(0.0, 14.0)) == 0.0:
			bacteria.resistant = true
		bacteria.gestationPeriod = rand_range(5.0, 30.0)
		Bacteria.add_child(bacteria)


func _process(delta: float) -> void:
	Physics2DServer.set_active(true)
	for marked in get_tree().get_nodes_in_group("marked"):
		if marked.health == 2:
			message(marked.name + " is about to die!")
		if marked.health < 1:
			message(marked.name + " is dead.")
		if marked.modulate.r > 1.9:
			message(marked.name + " just had children.")
	
	if !get_tree().paused:
		messages.modulate.a = lerp(messages.modulate.a, 0.0, 0.05)
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene("res://World.tscn")
	if Bacteria.get_child_count() == 1:
		label.text = "There is 1 bacterium."
	elif Bacteria.get_child_count() == 0:
		label.text = "The bacteria went extinct."
	else:
		label.text = "There are " + str(Bacteria.get_child_count()) + " bacteria."
		var smartBacteria = 0
		for b in Bacteria.get_children():
			if b.smart:
				smartBacteria += 1
		smartLabel.text = "Smart: " + str(smartBacteria)
		var oviBacteria = 0
		for b in Bacteria.get_children():
			if b.oviparous:
				oviBacteria += 1
		oviparousLabel.text = "Oviparous: " + str(oviBacteria)
	
	
	Engine.time_scale = speed.value
	camera.selfTime = speed.value
	fps.text = "FPS: " + str(round(Engine.get_frames_per_second()))
	
	if lifeSpans.size() != 0:
		var average = 0
		for i in lifeSpans:
			average += i
		average = average / lifeSpans.size()
		lifeSpanLabel.text = "Life Span: " + str(round(average * 10) / 10)
	
	if !get_tree().paused:
		time += delta
	timeLabel.text = "Sim Time: " + str(round(time * 10) / 10)
	
	if !get_tree().paused:
		if scaledPopulation < clamp(space / 5, 50, 300) and Bacteria.get_child_count() != 0 and Food.get_child_count() < 5500:
			food(round(space / 100.0) * round(speed.value))
		if scaledPopulation > clamp(space / 5, 50, 300) * 2.5 or Food.get_child_count() > 5500:
			if is_instance_valid(Food.get_child(0)):
				Food.get_child(0).queue_free()
		if Bacteria.get_child_count() > clamp(space / 5, 50, 300) * 4.0:
			if is_instance_valid(Bacteria.get_child(0)):
				Bacteria.get_child(0).queue_free()


func _on_Timer_timeout() -> void:
	if Bacteria.get_child_count() != 0:
		var average = 0.0
		for b in Bacteria.get_children():
			average += b.scale.x
		scaledPopulation = average
		average = average / Bacteria.get_child_count()
		scaleLabel.text = "Scale: " + str(round(average * 100) / 100)
		average = 0.0
		for b in Bacteria.get_children():
			average += b.children
		average = average / Bacteria.get_child_count()
		childrenLabel.text = "Children: " + str(round(average))
		average = 0.0
		var numOfEggLayers = 0
		for b in Bacteria.get_children():
			if b.oviparous:
				average += b.gestationPeriod
				numOfEggLayers += 1
		if numOfEggLayers != 0:
			average = average / numOfEggLayers
		else:
			average = 0
		gestationLabel.text = "Gestation Period: " + str(round(average * 10) / 10)
		var oviSmart = 0
		for b in Bacteria.get_children():
			if b.oviparous and b.smart:
				oviSmart += 1
		oviSmartLabel.text = "Oviparous And Smart: " + str(oviSmart)

func message(message: String):
	messages.modulate.a = 1.0
	messages.text += "\n" + message
	var msg = messages.text
	msg = msg.replace("@", "")
	msg = msg.replace("0", "")
	msg = msg.replace("1", "")
	msg = msg.replace("2", "")
	msg = msg.replace("3", "")
	msg = msg.replace("4", "")
	msg = msg.replace("5", "")
	msg = msg.replace("6", "")
	msg = msg.replace("7", "")
	msg = msg.replace("8", "")
	msg = msg.replace("9", "")
	messages.text = msg



func _on_chat_pressed() -> void:
	messages.visible = camera.chat.pressed
