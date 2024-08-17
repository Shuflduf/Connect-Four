class_name Encrypter
extends Node


static func encrypt(input: String) -> String:
	randomize()
	var code = ""
	var random_offset = randi_range(0, 100)
	for i in input.get_slice(":", 0).split("."):
		code += char(int(i) + random_offset)
		
	code += char(":".unicode_at(0) + random_offset)
	
	for i in input.get_slice(":", 1):
		code += char(int(i) + random_offset)
	return code

static func decrypt(input: String) -> String:
	var decoded = ""
	var random_offset = input.right(1).unicode_at(0)
	var on_port = false
	for i: String in input:
		if i.unicode_at(0) == ":".unicode_at(0) + random_offset:
			decoded = decoded.trim_suffix(".")
			decoded += ":"
			on_port = true
			continue
		decoded += str(i.unicode_at(0) - random_offset)
		if !on_port:
			decoded += "."
		
	
	decoded = decoded.trim_suffix(".")

	return decoded
