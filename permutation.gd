extends Node2D

var permutation
var rng = RandomNumberGenerator.new()
var SIZE = 320
var seed_val = 323429

func _ready():
	# print out the permutation array to add as a constant to our perlin_noise_generator script
	permutation = MakePermutation(SIZE, seed_val)
	print(permutation)

func MakePermutation(size, seed_val):
	rng.seed = seed_val
	SIZE = size
	var _permutation = []
	for x in (SIZE):
		_permutation.push_back(x)
	_permutation = Shuffle(_permutation)
	for x in (SIZE):
		_permutation.push_back(_permutation[x])
	return _permutation

func Shuffle(arrayToShuffle):
	for e in range(0, SIZE - 1):
		var index = round(rng.randf() * e - 1)
		var temp = arrayToShuffle[e]
		
		arrayToShuffle[e] = arrayToShuffle[index]
		arrayToShuffle[index] = temp
	return arrayToShuffle
