extends Control

var rank = "P"
var hype = 100
var delay_seconds = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Reduces Hype each frame by an amount depending on the current rank
# unless the delay is active in which case it counts that down instead.
func _process(delta):
	if delay_seconds <= 0:
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
	else:
		delay_seconds -= delta
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


# Increases the current hype by the amount given. Overflows to the next rank
# if given enough to rank up. Also temprarily pauses hype loss.
func increase_hype(amount):
	delay_seconds = 0.5 # feel free to tweak this number, but don't make it zero.
	hype += amount
	while hype >= 100:
		hype -= 100
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
				break
			_:
				rank = "C"
				hype = 0
	

# Note: This is just a placeholder for now. Once hype increasing has properly been implemented, this can be removed
func _on_increase_hype_placeholder_pressed():
	increase_hype(20)
