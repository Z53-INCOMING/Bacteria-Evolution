extends Camera2D

var speed = 100

var mouseStart = Vector2.ZERO

var selfTime = 1.0

var start = Vector2.ZERO

onready var mouse = $mouse

onready var customBacteriaBuilderScene = preload("res://CustomBacteria.tscn")
onready var fScene = preload("res://food.tscn")
onready var bScene = preload("res://Bacterium.tscn")
onready var aScene = preload("res://Archea.tscn")
onready var mScene = preload("res://Mech.tscn")
onready var spScene = preload("res://SpikePit.tscn")
onready var tScene = preload("res://Turret.tscn")
onready var ccScene = preload("res://ConstructionClaw.tscn")
onready var wScene = preload("res://Worm.tscn")
onready var iScene = preload("res://RadiationBlaster.tscn")

var disabled = false

onready var menu = $UI/menu
onready var originalTextures = $UI/menu/originalTextures
onready var chat = $UI/menu/chat
onready var wrap = $UI/menu/wrap

onready var childrenLabel = $UI/visible/childCount
onready var ageLabel = $UI/visible/age
onready var foodLabel = $UI/visible/food
onready var nameLabel = $UI/visible/name
onready var parentLabel = $UI/visible/parent
onready var scaleLabel = $UI/visible/scale

onready var marked = $UI/visible/marked

onready var left = $UI/visible/left
onready var right = $UI/visible/right
onready var front = $UI/visible/front

onready var left2 = $UI/visible/left2
onready var right2 = $UI/visible/right2
onready var front2 = $UI/visible/front2

onready var Lcone = $UI/visible/leftCone
onready var Rcone = $UI/visible/rightCone
onready var Fcone = $UI/visible/frontCone

var nothingCol = Color(1, 0.141176, 0, 0.435294)
var fullCol = Color(0, 0.623529, 1, 0.435294)
var eggCol = Color(1, 0.937255, 0, 0.435294)

onready var visibleNode = $UI/visible

onready var gestation = $UI/visible/gestation

onready var undo = $UI/visible/back

var canWASD = true

var following = null

var prevFollowing = null

func colorCone(cone, food, egg):
	if food and !egg:
		cone.color = fullCol
	elif egg and !food:
		cone.color = eggCol
	elif egg and food:
		cone.color = lerp(eggCol, fullCol, 0.5)
	else:
		cone.color = nothingCol



func _process(delta: float) -> void:
	undo.disabled = !is_instance_valid(prevFollowing)
	current = !disabled
	weapon("irradiate", iScene)
	weapon("archea", aScene)
	weapon("mech", mScene)
	weapon("construction claw", ccScene)
	weapon("worm", wScene)
	mouse.visible = false
	if !disabled:
		weapon("customBacteria", customBacteriaBuilderScene)
		mouse.visible = true
		if Input.is_action_just_pressed("menu"):
			menu.visible = !menu.visible
			if menu.visible:
				get_tree().paused = true
		if Input.is_action_just_pressed("spike pit"):
			var sp = spScene.instance()
			sp.global_position = get_global_mouse_position()
			get_parent().add_child(sp)
		if Input.is_action_just_pressed("turret"):
			var t = tScene.instance()
			t.global_position = get_global_mouse_position()
			get_parent().add_child(t)
		
		visibleNode.visible = false
		if is_instance_valid(following):
			following.marked = marked.pressed
			global_position = following.global_position
			
			visibleNode.visible = true
			
			gestation.visible = following.oviparous
			
			gestation.text = "Gestation: " + str(following.gestationPeriod)
			
			colorCone(Lcone, following.left, following.leftEgg)
			colorCone(Rcone, following.right, following.rightEgg)
			colorCone(Fcone, following.forward, following.forwardEgg)
			
			left2.frame = 0
			match following.onEggLeft:
				0:
					left2.frame = 1
				-1:
					left2.rotation_degrees = -180
				1:
					left2.rotation_degrees = 0
				2:
					left2.rotation_degrees = -90
				-2:
					left2.rotation_degrees = 90
			right2.frame = 0
			match following.onEggRight:
				0:
					right2.frame = 1
				-1:
					right2.rotation_degrees = -180
				1:
					right2.rotation_degrees = 0
				2:
					right2.rotation_degrees = -90
				-2:
					right2.rotation_degrees = 90
			front2.frame = 0
			match following.onEggForward:
				0:
					front2.frame = 1
				-1:
					front2.rotation_degrees = -180
				1:
					front2.rotation_degrees = 0
				2:
					front2.rotation_degrees = -90
				-2:
					front2.rotation_degrees = 90
			
			left.frame = 0
			match following.onLeft:
				0:
					left.frame = 1
				-1:
					left.rotation_degrees = -180
				1:
					left.rotation_degrees = 0
				2:
					left.rotation_degrees = -90
				-2:
					left.rotation_degrees = 90
			right.frame = 0
			match following.onRight:
				0:
					right.frame = 1
				-1:
					right.rotation_degrees = -180
				1:
					right.rotation_degrees = 0
				2:
					right.rotation_degrees = -90
				-2:
					right.rotation_degrees = 90
			front.frame = 0
			match following.onForward:
				0:
					front.frame = 1
				-1:
					front.rotation_degrees = -180
				1:
					front.rotation_degrees = 0
				2:
					front.rotation_degrees = -90
				-2:
					front.rotation_degrees = 90
			
			foodLabel.text = "Food: " + str(round(following.food))
			ageLabel.text = "Age: " + str(round(following.timeAlive))
			scaleLabel.text = "Scale: " + str(following.scale.x)
			childrenLabel.text = "Children: " + str(round(following.children))
			parentLabel.text = "None"
			if round(following.timeAlive) != round(get_parent().time):
				var parentName = following.parentName
				parentName = parentName.replace("@", "")
				parentName = parentName.replace("0", "")
				parentName = parentName.replace("1", "")
				parentName = parentName.replace("2", "")
				parentName = parentName.replace("3", "")
				parentName = parentName.replace("4", "")
				parentName = parentName.replace("5", "")
				parentName = parentName.replace("6", "")
				parentName = parentName.replace("7", "")
				parentName = parentName.replace("8", "")
				parentName = parentName.replace("9", "")
				parentLabel.text = parentName + " (Dead)"
			parentLabel.disabled = true
			if is_instance_valid(following.parent):
				parentLabel.disabled = false
				var parentName = following.parent.name
				parentName = parentName.replace("@", "")
				parentName = parentName.replace("0", "")
				parentName = parentName.replace("1", "")
				parentName = parentName.replace("2", "")
				parentName = parentName.replace("3", "")
				parentName = parentName.replace("4", "")
				parentName = parentName.replace("5", "")
				parentName = parentName.replace("6", "")
				parentName = parentName.replace("7", "")
				parentName = parentName.replace("8", "")
				parentName = parentName.replace("9", "")
				parentLabel.text = parentName
			var nameText = following.name
			nameText = nameText.replace("@", "")
			nameText = nameText.replace("0", "")
			nameText = nameText.replace("1", "")
			nameText = nameText.replace("2", "")
			nameText = nameText.replace("3", "")
			nameText = nameText.replace("4", "")
			nameText = nameText.replace("5", "")
			nameText = nameText.replace("6", "")
			nameText = nameText.replace("7", "")
			nameText = nameText.replace("8", "")
			nameText = nameText.replace("9", "")
			nameLabel.text = nameText
		
		if canWASD:
			if Input.is_action_pressed("left"):
				position.x -= speed * zoom.x * delta / selfTime * Input.get_action_strength("left")
				following = null
			if Input.is_action_pressed("right"):
				position.x += speed * zoom.x * delta / selfTime * Input.get_action_strength("right")
				following = null
			if Input.is_action_pressed("up"):
				position.y -= speed * zoom.x * delta / selfTime * Input.get_action_strength("up")
				following = null
			if Input.is_action_pressed("down"):
				position.y += speed * zoom.x * delta / selfTime * Input.get_action_strength("down")
				following = null
		
		if Input.is_action_pressed("zoom in"):
			zoom.x -= zoom.x * 0.5 * delta / selfTime * Input.get_action_strength("zoom in")
		if Input.is_action_pressed("zoom out"):
			zoom.x += zoom.x * 0.5 * delta / selfTime * Input.get_action_strength("zoom out")
		
		if Input.is_action_just_released("alt zoom in"):
			zoom.x -= zoom.x * 3 * delta / selfTime
		if Input.is_action_just_released("alt zoom out"):
			zoom.x += zoom.x * 3 * delta / selfTime
		
		if Input.is_action_just_pressed("pan"):
			mouseStart = get_viewport().get_mouse_position()
			start = global_position
			following = null
		if Input.is_action_pressed("pan"):
			global_position = start + ((mouseStart - get_viewport().get_mouse_position()) * zoom)
			
		if Input.is_action_just_pressed("follow"):
			if !mouse.get_overlapping_areas().empty() and "food" in mouse.get_overlapping_areas()[0]:
				var falseAlarm = false
				for child in get_children():
					if child.name == "CustomBacteria":
						falseAlarm = true
				if !falseAlarm:
					prevFollowing = following
					following = mouse.get_overlapping_areas()[0]
					marked.pressed = following.marked
		if Input.is_action_pressed("kill"):
			if !mouse.get_overlapping_areas().empty():
				for victim in mouse.get_overlapping_areas():
					victim.queue_free()
		
		if Input.is_action_just_pressed("pause"):
			get_tree().paused = !get_tree().paused
		
		if Input.is_action_pressed("spawn food"):
			var f = fScene.instance()
			f.global_position = get_global_mouse_position()
			get_parent().Food.add_child(f)
		if Input.is_action_just_pressed("spawn bacteria"):
			var b = bScene.instance()
			b.global_position = get_global_mouse_position()
			match int(round(rand_range(1.0, 3.0))):
				1:
					b.onLeft = -1
					b.onRight = 1
					b.onForward = 2
					b.onEggForward = 2
					b.onEggLeft = -1
					b.onEggRight = 1
					b.resistant = true
					b.mutate = false
					b.oviparous = false
					b.scale.x = 0.2
				2:
					b.onLeft = -1
					b.onRight = 1
					b.onForward = 2
					b.onEggForward = -2
					b.onEggLeft = 1
					b.onEggRight = -1
					b.oviparous = true
					b.mutate = false
					b.resistant = false
					b.toxic = true
					b.gestationPeriod = rand_range(10.0, 30.0)
					b.scale.x = 2.0
				3:
					b.onLeft = -1
					b.onRight = 1
					b.onForward = 2
					b.onEggForward = -2
					b.onEggLeft = 1
					b.onEggRight = -1
					b.oviparous = false
					b.mutate = false
					b.resistant = false
					b.scale.x = 1.0
			get_parent().Bacteria.add_child(b)
		zoom.y = zoom.x
		mouse.scale = zoom
		
		if wrap.pressed:
			var space = get_parent().space
			if position.x > space:
				position.x -= space * 2
			if position.x < -space:
				position.x += space * 2
			
			if position.y > space:
				position.y -= space * 2
			if position.y < -space:
				position.y += space * 2
		
		mouse.global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("blue"):
			get_parent().get_child(8).global_position = get_global_mouse_position()
		if Input.is_action_just_pressed("orange"):
			get_parent().get_child(9).global_position = get_global_mouse_position()
		if Input.is_action_pressed("blue"):
			get_parent().get_child(8).global_rotation = get_global_mouse_position().angle_to_point(get_parent().get_child(8).global_position)
		if Input.is_action_pressed("orange"):
			get_parent().get_child(9).global_rotation = get_global_mouse_position().angle_to_point(get_parent().get_child(9).global_position)

func _on_parent_button_down() -> void:
	if is_instance_valid(following) and is_instance_valid(following.parent):
		prevFollowing = following
		following = following.parent
		marked.pressed = following.marked


func _on_menu_button_down() -> void:
	SceneChanger.go_to_scene("res://Menu.tscn", get_parent())
	




func _on_back_button_down() -> void:
	following = prevFollowing
	prevFollowing = null


func weapon(input: String, scene: PackedScene):
	var weaponNames = ["Archea", "Mech", "ConstructionClaw", "Worm", "Camera", "CustomBacteria"]
	var detectedChild = ""
	if Input.is_action_just_pressed(input):
		if disabled:
			for child in get_parent().get_children():
				if weaponNames.has(child.name):
					global_position = child.global_position
					child.queue_free()
					disabled = false
					match child.name:
						"Archea":
							detectedChild = "archea"
						"Mech":
							detectedChild = "mech"
						"ConstructionClaw":
							detectedChild = "construction claw"
						"Worm":
							detectedChild = "worm"
						"Camera":
							detectedChild = "irradiate"
						"CustomBacteria":
							detectedChild = "customBacteria"
					break
		if detectedChild != input:
			var weapon = scene.instance()
			if "global_position" in weapon:
				weapon.global_position = get_global_mouse_position()
			get_parent().add_child(weapon)
			disabled = true
