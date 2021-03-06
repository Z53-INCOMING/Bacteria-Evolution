extends Area2D
#Number of unique unnamed bacteria: 2375
#Number of unique names: 6873
#Number of all unique bacteria: 18,810,000
#Note: These are way off due to me updating the game. I'll try to keep them up to date but its just a number man, a number. Why should I care??

var wander = OpenSimplexNoise.new()

var color = Color.white

var speed = 30

var velocity = 0

var size = 0

var health = 3

var children = 0

export var food = 15.0

var timeAlive = 0

export var eggs = 0

onready var rightDtctor = $right

onready var leftDtctor = $left

onready var forwrdDtctor = $forward

onready var eggLeftDtctor = $leftEgg

onready var eggRightDtctor = $rightEgg

onready var eggForwardDtctor = $forwardEgg

onready var eggReady = $eggReady

onready var marker = $marker

var resistant = false

var bacteriaScene = load("res://Bacterium.tscn")

onready var eggScene = preload("res://Egg.tscn")

export var oviparous = false

export var gestationPeriod = 5.0

export var eggCooldown = 0.0

export var toxic = false

export var onLeft = 0

export var onRight = 0

export var onForward = 0

export var onEggLeft = 0

export var onEggRight = 0

export var onEggForward = 0

export var mutate = true

var left = false

var right = false

var marked = false

var forward = false

var leftEgg = false

var rightEgg = false

var forwardEgg = false

var moved = false

var parent = null

var parentName = ""

var smart = false

onready var visual = $visual

onready var basicBrain = $basicBrain
onready var brain = $brain
onready var eggSac = $eggSac
onready var resistance = $resistance
onready var toxicV = $toxic
onready var fangs = $fangs

var changeName = true

func _ready() -> void:
	randomize()
	if changeName:
		var possibleNames = File.new()
		possibleNames.open("res://possible names.tres", File.READ)
		var namesArray = possibleNames.get_as_text()
		namesArray = namesArray.split("\n")
		name = namesArray[rand_range(0, namesArray.size() - 1)]
		possibleNames.close()
	children = 0
	wander.seed = rand_range(0, 1000)
	
	if mutate:
		tryMutation()
	else:
		loadBacterium()
	
	if is_instance_valid(parent):
		parentName = parent.name

func loadBacterium():
	fangs.visible = false
	basicBrain.visible = false
	brain.visible = false
	eggSac.visible = false
	toxicV.visible = false
	resistance.visible = false
	scale.y = scale.x
	visualFrame(3)
	visualScale(2.48)
	if scale.x > 0.25:
		visualFrame(2)
		visualScale(1.72)
	if scale.x > 0.5:
		visualFrame(1)
		visualScale(1.0)
	if scale.x > 1.5:
		visualFrame(0)
		visualScale(0.54)
	if onForward == 2 and onRight == 1 and onLeft == -1:
		smart = true
		brain.visible = true
	else:
		smart = false
		brain.visible = false
	if onForward == -2 and onRight == -1 and onLeft == 1:
		basicBrain.visible = false
	else:
		basicBrain.visible = true
	if oviparous:
		if toxic:
			toxicV.visible = true
		else:
			eggSac.visible = true
	if resistant:
		resistance.visible = true
	if scale.x < 0.5:
		$left.global_scale = Vector2(0.5, 0.5)
		$forward.global_scale = Vector2(0.5, 0.5)
		$right.global_scale = Vector2(0.5, 0.5)
	
	scale.x = clamp(scale.x, 0.2, 2.0)
	gestationPeriod = clamp(gestationPeriod, 5.0, 30.0)
	gestationPeriod = round(gestationPeriod * 10) / 10
	scale.x = round(scale.x * 10) / 10
	
	onLeft = clamp(onLeft, -2, 2)
	onRight = clamp(onRight, -2, 2)
	onForward = clamp(onForward, -2, 2)
	
	onEggLeft = clamp(onEggLeft, -2, 2)
	onEggRight = clamp(onEggRight, -2, 2)
	onEggForward = clamp(onEggForward, -2, 2)
	
	onLeft = int(onLeft)
	onRight = int(onRight)
	onForward = int(onForward)
	
	onEggLeft = int(onEggLeft)
	onEggRight = int(onEggRight)
	onEggForward = int(onEggForward)
	
	visual.modulate = color
	basicBrain.modulate = color
	fangs.modulate = color
	

func _process(delta: float) -> void:
	visual.frame = (size * 3) + (health - 1)
	var world = get_parent().get_parent()
	if !get_tree().paused:
		modulate -= Color(1, 1, 1) * delta * 3
		if modulate.r < 1.0:
			modulate = Color.white
		food -= delta * scale.x * (1.5 if resistant else 1.0)
		timeAlive += delta
		speed = 30
		moved = false
		if health <= 0:
			world.lifeSpans.append(timeAlive)
			queue_free()
		if food <= 0:
			food = 0.0

		var leftNum = leftDtctor.get_overlapping_areas().size()
		var rightNum = rightDtctor.get_overlapping_areas().size()
		forward = !forwrdDtctor.get_overlapping_areas().empty()

		right = false
		left = false

		if leftNum > 0 and leftNum > rightNum:
			left = true
		if rightNum > 0 and rightNum > leftNum:
			right = true
		
		leftEgg = !eggLeftDtctor.get_overlapping_areas().empty()
		rightEgg = !eggRightDtctor.get_overlapping_areas().empty()
		forwardEgg = !eggForwardDtctor.get_overlapping_areas().empty()
		
		if leftEgg:
			do(int(onEggLeft), delta)
			moved = true
		if rightEgg:
			do(int(onEggRight), delta)
			moved = true
		if forwardEgg:
			do(int(onEggForward), delta)
			moved = true
		
		if !moved:
			if left:
				do(int(onLeft), delta)
				moved = true
			if right:
				do(int(onRight), delta)
				moved = true
			if forward:
				do(int(onForward), delta)
				moved = true
		
		eggCooldown -= delta
		if eggCooldown < 0.0:
			eggCooldown = 0.0
		if !moved:
			rotation_degrees += wander.get_noise_1d(timeAlive * 50) * 5
		
		eggReady.global_scale = Vector2.ONE
		
		if eggReady.get_overlapping_areas().size() == 1:
			if eggs > 0 and eggCooldown == 0.0:
				modulate = Color.white * 2
				var first = bacteriaScene.instance()
				first.color = color
				first.onRight = onRight
				first.onLeft = onLeft
				first.onForward = onForward
				first.onEggRight = onEggRight
				first.onEggLeft = onEggLeft
				first.onEggForward = onEggForward
				first.scale.x = scale.x
				first.gestationPeriod = gestationPeriod
				first.oviparous = oviparous
				first.parent = self
				first.toxic = toxic
				first.resistant = resistant
				var second = bacteriaScene.instance()
				second.color = color
				second.onEggRight = onEggRight
				second.onEggLeft = onEggLeft
				second.onEggForward = onEggForward
				second.onRight = onRight
				second.onLeft = onLeft
				second.onForward = onForward
				second.scale.x = scale.x
				second.gestationPeriod = gestationPeriod
				second.oviparous = oviparous
				second.parent = self
				second.resistant = resistant
				second.toxic = toxic
				var main = get_parent().get_parent()
				var firstEgg = eggScene.instance()
				firstEgg.global_position = global_position + (Vector2(rand_range(-15, 15), rand_range(-15, 15)) * scale)
				firstEgg.frame = 3
				if scale.x > 0.25:
					firstEgg.frame = 2
				if scale.x > 0.5:
					firstEgg.frame = 1
				if scale.x > 1.5:
					firstEgg.frame = 0
				firstEgg.bacteria = first
				firstEgg.gestastionPeriod = gestationPeriod
				firstEgg.toxic = toxic
				firstEgg.color = color
				var secondEgg = eggScene.instance()
				secondEgg.global_position = global_position + (Vector2(rand_range(-15, 15), rand_range(-15, 15)) * scale)
				secondEgg.frame = 3
				if scale.x > 0.25:
					secondEgg.frame = 2
				if scale.x > 0.5:
					secondEgg.frame = 1
				if scale.x > 1.5:
					secondEgg.frame = 0
				secondEgg.bacteria = second
				secondEgg.gestastionPeriod = gestationPeriod
				secondEgg.toxic = toxic
				secondEgg.color = color
				main.add_child(firstEgg)
				main.add_child(secondEgg)
				eggs -= 2
				eggCooldown = 1.0
				if is_in_group("marked"):
					get_parent().get_parent().message(load("res://ReproduceSymbol.png"), name)
		
		velocity = lerp(velocity, speed, 0.12)
		position += Vector2(cos(rotation), sin(rotation)) * velocity * delta * max(scale.x, 1.0)
		
		if position.x > world.space:
			position.x -= world.space * 2
		if position.x < -world.space:
			position.x += world.space * 2
		
		if position.y > world.space:
			position.y -= world.space * 2
		if position.y < -world.space:
			position.y += world.space * 2
		
		if food >= 30.0 / (((scale.x - 1.0) / 2.0) + 1.0):
			if !oviparous:
				var bacteria = bacteriaScene.instance()
				bacteria.global_position = global_position
				bacteria.global_rotation = global_rotation
				bacteria.onRight = onRight
				bacteria.onLeft = onLeft
				bacteria.onForward = onForward
				bacteria.onEggRight = onEggRight
				bacteria.onEggLeft = onEggLeft
				bacteria.onEggForward = onEggForward
				bacteria.scale.x = scale.x
				bacteria.parent = self
				bacteria.resistant = resistant
				bacteria.color = color
				var main = get_parent()
				main.add_child(bacteria)
				food -= 12
				children += 1
				modulate = Color.white * 2
				if is_in_group("marked"):
					get_parent().get_parent().message(load("res://ReproduceSymbol.png"), name)
			else:
				eggs += 2
				children += 2
				food -= 12
				if toxic:
					food -= 8
				
	modulate.a = 1.0
	scale.y = scale.x
	marker.visible = marked
	if marked:
		marker.scale = world.camera.zoom / 2 / scale.x
		marker.global_rotation = 0
		marker.modulate = Globals.markerColor
		if !is_in_group("marked"):
			add_to_group("marked")
	else:
		if is_in_group("marked"):
			remove_from_group("marked")
		


func do(id, delta):
	if id == 1:
		rotation_degrees += 180 * delta
	if id == -1:
		rotation_degrees -= 180 * delta
	if id == 2:
		speed = 60
	if id == -2:
		speed = -20
		


func _on_Bacteria_area_entered(area: Area2D) -> void:
	if area.energy == 10.0:
		if area.bacteria.parent != self:
			if area.toxic and !resistant:
				area.development -= 4.0
				food = 0.0
				health = 0
			else:
				food += area.energy
				area.queue_free()
	elif area.energy == -30.0:
		food = 0.0
		health = 0
	else:
		food += area.energy
		area.queue_free()

func visualFrame(value):
	size = value
	basicBrain.frame = value
	brain.frame = value
	eggSac.frame = value
	resistance.frame = value
	toxicV.frame = value
	fangs.frame = value

func visualScale(value):
	visual.scale = Vector2(value, value)
	basicBrain.scale = Vector2(value, value)
	brain.scale = Vector2(value, value)
	eggSac.scale = Vector2(value, value)
	resistance.scale = Vector2(value, value)
	toxicV.scale = Vector2(value, value)
	fangs.scale = Vector2(value, value)


func _on_FoodCheck_timeout() -> void:
	if !get_tree().paused:
		if food <= 0.0:
			health -= 1
			if food < 1.0 and is_in_group("marked"):
				get_parent().get_parent().message(load("res://cautionSymbol.png"), name)
			if health == 0 and is_in_group("marked"):
				get_parent().get_parent().message(load("res://DeathSymbol.png"), name)
		elif health != 3:
			health += 1
		

func tryMutation():
	if round(rand_range(0.0, 3.0)) == 0.0:
		onRight = round(rand_range(-2, 2))
	if round(rand_range(0.0, 3.0)) == 0.0:
		onLeft = round(rand_range(-2, 2))
	if round(rand_range(0.0, 3.0)) == 0.0:
		onForward = round(rand_range(-2, 2))
	
	if round(rand_range(0.0, 3.0)) == 0.0:
		onEggRight = round(rand_range(-2, 2))
	if round(rand_range(0.0, 3.0)) == 0.0:
		onEggLeft = round(rand_range(-2, 2))
	if round(rand_range(0.0, 3.0)) == 0.0:
		onEggForward = round(rand_range(-2, 2))
	
	if round(rand_range(0.0, 2.0)) == 0.0:
		scale.x += rand_range(-0.2, 0.2)
	if round(rand_range(0.0, 4.0)) != 0.0:
		gestationPeriod += rand_range(-1.5, 1.5)
	if round(rand_range(0.0, 4.0)) == 0.0:
		oviparous = !oviparous
	if round(rand_range(0.0, 5.0)) == 0.0:
		toxic = !toxic
	if round(rand_range(0.0, 5.0)) == 0.0:
		resistant = true
	if round(rand_range(0.0, 14.0)) == 0.0:
		resistant = false
	if round(rand_range(0.0, 1.0)) == 0.0:
		color.r += rand_range(-0.05, 0.05)
	if round(rand_range(0.0, 1.0)) == 0.0:
		color.g += rand_range(-0.05, 0.05)
	if round(rand_range(0.0, 1.0)) == 0.0:
		color.b += rand_range(-0.05, 0.05)
	color.r = clamp(color.r, 0.0, 1.0)
	color.g = clamp(color.g, 0.0, 1.0)
	color.b = clamp(color.b, 0.0, 1.0)
	color.a = 1.0
	
	loadBacterium()
