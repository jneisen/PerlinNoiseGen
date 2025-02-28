extends Node2D

const SIZE = 320
const FREQUENCY = 0.05
const alphaModifier = 1

@onready var _sprite = $Sprite2D
var _image = Image.new()
var _texture : Texture2D
var _packed_byte_array : PackedByteArray # will store the image data

const permutation = [196, 62, 39, 261, 285, 272, 89, 205, 6, 253, 195, 19, 247, 140, 130, 191, 92, 12, 142, 213, 86, 49, 26, 135, 138, 292, 241, 265, 42, 197, 296, 223, 184, 58, 276, 72, 239, 186, 242, 317, 87, 155, 235, 287, 216, 267, 298, 38, 152, 194, 207, 172, 71, 225, 220, 9, 266, 46, 284, 77, 202, 132, 113, 14, 37, 295, 104, 54, 203, 283, 11, 45, 236, 91, 177, 246, 240, 118, 215, 20, 101, 231, 294, 219, 297, 187, 139, 169, 127, 230, 233, 60, 59, 238, 105, 198, 13, 165, 99, 305, 16, 153, 115, 183, 1, 149, 95, 273, 116, 97, 268, 252, 303, 24, 208, 119, 0, 44, 106, 8, 98, 226, 311, 218, 21, 210, 15, 82, 96, 161, 158, 128, 209, 279, 221, 264, 288, 179, 263, 200, 270, 107, 67, 41, 277, 17, 55, 63, 175, 35, 259, 134, 162, 25, 124, 61, 257, 73, 68, 174, 201, 31, 160, 48, 34, 66, 204, 109, 143, 168, 291, 56, 112, 228, 256, 309, 290, 4, 280, 76, 100, 40, 47, 307, 103, 250, 304, 65, 18, 148, 308, 69, 129, 190, 237, 293, 111, 224, 188, 173, 166, 301, 147, 180, 52, 157, 122, 51, 90, 206, 319, 229, 144, 102, 2, 33, 286, 36, 133, 234, 262, 315, 306, 181, 80, 78, 245, 299, 88, 281, 176, 53, 94, 110, 214, 117, 151, 131, 310, 171, 278, 136, 211, 182, 125, 93, 57, 159, 269, 178, 193, 249, 5, 137, 271, 114, 227, 10, 282, 232, 30, 121, 29, 302, 141, 199, 3, 75, 150, 64, 300, 251, 189, 123, 27, 185, 126, 43, 212, 248, 79, 163, 28, 255, 260, 50, 83, 217, 312, 154, 84, 313, 170, 243, 32, 244, 145, 108, 156, 222, 120, 22, 81, 275, 167, 146, 318, 316, 70, 314, 274, 164, 192, 74, 289, 85, 23, 254, 258, 7, 196, 62, 39, 261, 285, 272, 89, 205, 6, 253, 195, 19, 247, 140, 130, 191, 92, 12, 142, 213, 86, 49, 26, 135, 138, 292, 241, 265, 42, 197, 296, 223, 184, 58, 276, 72, 239, 186, 242, 317, 87, 155, 235, 287, 216, 267, 298, 38, 152, 194, 207, 172, 71, 225, 220, 9, 266, 46, 284, 77, 202, 132, 113, 14, 37, 295, 104, 54, 203, 283, 11, 45, 236, 91, 177, 246, 240, 118, 215, 20, 101, 231, 294, 219, 297, 187, 139, 169, 127, 230, 233, 60, 59, 238, 105, 198, 13, 165, 99, 305, 16, 153, 115, 183, 1, 149, 95, 273, 116, 97, 268, 252, 303, 24, 208, 119, 0, 44, 106, 8, 98, 226, 311, 218, 21, 210, 15, 82, 96, 161, 158, 128, 209, 279, 221, 264, 288, 179, 263, 200, 270, 107, 67, 41, 277, 17, 55, 63, 175, 35, 259, 134, 162, 25, 124, 61, 257, 73, 68, 174, 201, 31, 160, 48, 34, 66, 204, 109, 143, 168, 291, 56, 112, 228, 256, 309, 290, 4, 280, 76, 100, 40, 47, 307, 103, 250, 304, 65, 18, 148, 308, 69, 129, 190, 237, 293, 111, 224, 188, 173, 166, 301, 147, 180, 52, 157, 122, 51, 90, 206, 319, 229, 144, 102, 2, 33, 286, 36, 133, 234, 262, 315, 306, 181, 80, 78, 245, 299, 88, 281, 176, 53, 94, 110, 214, 117, 151, 131, 310, 171, 278, 136, 211, 182, 125, 93, 57, 159, 269, 178, 193, 249, 5, 137, 271, 114, 227, 10, 282, 232, 30, 121, 29, 302, 141, 199, 3, 75, 150, 64, 300, 251, 189, 123, 27, 185, 126, 43, 212, 248, 79, 163, 28, 255, 260, 50, 83, 217, 312, 154, 84, 313, 170, 243, 32, 244, 145, 108, 156, 222, 120, 22, 81, 275, 167, 146, 318, 316, 70, 314, 274, 164, 192, 74, 289, 85, 23, 254, 258, 7]


func _ready():
	generatePerlin()
	_image.set_data(SIZE, SIZE, false, Image.FORMAT_RGBA8, _packed_byte_array)
	_texture = ImageTexture.create_from_image(_image)
	_sprite.texture = _texture

func generatePerlin():
	for x in range (0, SIZE * SIZE):
		_packed_byte_array.append(255)
		_packed_byte_array.append(255)
		_packed_byte_array.append(255)
		var noise = Noise2D((x % SIZE + position.x / _sprite.scale.x) * FREQUENCY, -(x / SIZE + position.y / _sprite.scale.y) * FREQUENCY)
		noise = abs((noise + 1) / 2)
		noise *= alphaModifier
		_packed_byte_array.append(round(noise * 255))
	
	
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

func dot(vector1 : Vector2, vector2 : Vector2):
	return vector1.x * vector2.x + vector1.y * vector2.y
