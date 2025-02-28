extends Node2D

const SIZE = 320
var FREQUENCY = 0.05
var alphaModifier = 1
@export var seed_val = 323429

var _sprite
var _image : Image
var _texture : Texture2D
var _packed_byte_array : PackedByteArray # will store the image data
var rng = RandomNumberGenerator.new()
var permutation

func _ready():
	rng.seed = seed_val
	permutation = MakePermutation()
	_sprite = $Sprite2D
	_image = Image.new()
	for x in range (0, SIZE * SIZE):
		_packed_byte_array.append(255)
		_packed_byte_array.append(255)
		_packed_byte_array.append(255)
		var noise = Noise2D((x % SIZE) * FREQUENCY, -(x / SIZE) * FREQUENCY)
		noise = abs((noise + 1) / 2)
		noise *= alphaModifier
		_packed_byte_array.append(round(noise * 255))
	_image.set_data(SIZE, SIZE, false, Image.FORMAT_RGBA8, _packed_byte_array)
	_image.resize(320, 320, 1)
	_texture = ImageTexture.create_from_image(_image)
	_sprite.texture = _texture
	_image.save_png("res://perlin_noise2.png")
	
	
func Noise2D(x, y):
	var X = int(floor(x)) & 255
	var Y = int(floor(y)) & 255
	x -= floor(x)
	y -= floor(y)
	var topRight = Vector2(x-1.0, y-1.0);
	var topLeft = Vector2(x, y-1.0);
	var bottomRight = Vector2(x-1.0, y);
	var bottomLeft = Vector2(x, y);
	
	# Select a value from the permutation array for each of the 4 corners
	var valueTopRight = permutation[permutation[X+1]+Y+1];
	var valueTopLeft = permutation[permutation[X]+Y+1];
	var valueBottomRight = permutation[permutation[X+1]+Y];
	var valueBottomLeft = permutation[permutation[X]+Y];
	
	var dotTopRight = dot(topRight, GetConstantVector(valueTopRight));
	var dotTopLeft = dot(topLeft, GetConstantVector(valueTopLeft));
	var dotBottomRight = dot(bottomRight, GetConstantVector(valueBottomRight));
	var dotBottomLeft = dot(bottomLeft, GetConstantVector(valueBottomLeft));
	
	var u = Fade(x)
	var v = Fade(y)
	
	return Lerp(u, Lerp(v, dotBottomLeft, dotTopLeft), Lerp(v, dotBottomRight, dotTopRight))
	
func Fade(t):
	return ((6*t - 15)*t + 10)*t*t*t;
func Lerp(t, a, b):
	return a + t * (b - a)
	
func MakePermutation():
	var _permutation = []
	for x in (SIZE):
		_permutation.push_back(x)
	_permutation = Shuffle(_permutation)
	for x in (SIZE):
		_permutation.push_back(_permutation[x])
	return _permutation

func GetConstantVector(v):
	var h = v & 3
	if(h == 0):
		return Vector2(1.0, 1.0)
	elif(h == 1):
		return Vector2(-1.0, 1.0)
	elif(h == 2):
		return Vector2(1.0, -1.0)
	else:
		return Vector2(-1.0, -1.0)

func Shuffle(arrayToShuffle):
	for e in range(0, SIZE - 1):
		var index = round(rng.randf() * e - 1)
		var temp = arrayToShuffle[e]
		
		arrayToShuffle[e] = arrayToShuffle[index]
		arrayToShuffle[index] = temp
	return arrayToShuffle

func dot(vector1 : Vector2, vector2 : Vector2):
	return vector1.x * vector2.x + vector1.y * vector2.y
