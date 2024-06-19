extends Control

var rank = "P"
var hype = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match(rank):
		"C":
			pass
		"B":
			hype -= (100/6)*delta
		"A":
			hype -= (100/5)*delta
		"S":
			hype -= (100/4)*delta
		"P":
			hype -= (100/2)*delta
		_:
			pass
	if hype <= 0:
		hype = 100
		match(rank):
			"C":
				hype = 0
			"B":
				hype = 100
				rank = "C"
			"A":
				hype = 100
				rank = "B"
			"S":
				hype = 100
				rank = "A"
			"P":
				hype = 100
				rank = "S"
			_:
				rank = "C"
	$RankLabel.text = rank
	$HypeProg.value = hype

func increase_hype(amount):
	hype += amount
	if hype >= 100:
		hype = 0
		match(rank):
			"C":
				rank = "B"
			"B":
				rank = "A"
			"A":
				rank = "S"
			"S":
				rank = "P"
			"P":
				hype = 100
			_:
				rank = "C"
				hype = 0
