extends Node
class_name Tello, "res://addons/TelloDroneNode/drone_icon.png"


signal command_send(cmd)
signal recived_control_code(val)
signal recived_control_code_ok()
signal recived_control_code_error()
signal recived_telemery(key, val)
signal recived_telemery_pitch(val)
signal recived_telemery_roll(val)
signal recived_telemery_yaw(val)
signal recived_telemery_vgx(val)
signal recived_telemery_vgy(val)
signal recived_telemery_vgz(val)
signal recived_telemery_templ(val)
signal recived_telemery_temph(val)
signal recived_telemery_tof(val)
signal recived_telemery_h(val)
signal recived_telemery_bat(val)
signal recived_telemery_baro(val)
signal recived_telemery_time(val)
signal recived_telemery_agx(val)
signal recived_telemery_agy(val)
signal recived_telemery_agz(val)


export(bool) var activate_telemetry := true
export(float, -1, 10) var telemetry_update_time := 0.2
export(float, 0, 8) var keep_active_time := 0
export(int) var local_ctrl_port := 8889
export(int) var local_telemetry_port := 8890
export(String) var drone_ip := "192.168.10.1"
export(int) var drone_ctrl_port := 8889


var last_command : String
var last_ctrl_msg : String
var is_active := false setget _set_is_active,_get_is_active


var _ctrl_socket : PacketPeerUDP
var _tele_socket : PacketPeerUDP
var _keep_active_timer : Timer
var _telemetry_update_timer : Timer
var _telemetry_raw : String


func _ready() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 49, OS.get_ticks_usec(), '')
	set_process(false)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 50, OS.get_ticks_usec(), '	set_process(false)')


func _process(delta: float) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 53, OS.get_ticks_usec(), '')
	_process_ctrl()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 54, OS.get_ticks_usec(), '	_process_ctrl()')
	_process_telemetry()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 55, OS.get_ticks_usec(), '	_process_telemetry()')
	if telemetry_update_time == 0:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 56, OS.get_ticks_usec(), '	if telemetry_update_time == 0:')
		update_telemetry()
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 57, OS.get_ticks_usec(), '		update_telemetry()')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 57, OS.get_ticks_usec(), '')


func start() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 60, OS.get_ticks_usec(), '')
	if is_processing():
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 61, OS.get_ticks_usec(), '	if is_processing():')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 62, OS.get_ticks_usec(), '')
	_init_ctrl_socket()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 63, OS.get_ticks_usec(), '	_init_ctrl_socket()')
	_init_tele_socket()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 64, OS.get_ticks_usec(), '	_init_tele_socket()')
	if keep_active_time > 0:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 65, OS.get_ticks_usec(), '	if keep_active_time > 0:')
		_keep_active_timer = Timer.new()
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 66, OS.get_ticks_usec(), '		_keep_active_timer = Timer.new()')
		_keep_active_timer.wait_time = 5
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 67, OS.get_ticks_usec(), '		_keep_active_timer.wait_time = 5')
		_keep_active_timer.one_shot = false
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 68, OS.get_ticks_usec(), '		_keep_active_timer.one_shot = false')
		_keep_active_timer.connect("timeout", self, "_on_keep_active_timer_timeout")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 69, OS.get_ticks_usec(), '		_keep_active_timer.connect("timeout", self, "_on_keep_active_timer_timeout")')
		add_child(_keep_active_timer)
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 70, OS.get_ticks_usec(), '		add_child(_keep_active_timer)')
		_keep_active_timer.start(keep_active_time)
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 71, OS.get_ticks_usec(), '		_keep_active_timer.start(keep_active_time)')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 71, OS.get_ticks_usec(), '')
	if activate_telemetry:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 72, OS.get_ticks_usec(), '	if activate_telemetry:')
		if telemetry_update_time > 0:
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 73, OS.get_ticks_usec(), '		if telemetry_update_time > 0:')
			_telemetry_update_timer = Timer.new()
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 74, OS.get_ticks_usec(), '			_telemetry_update_timer = Timer.new()')
			_telemetry_update_timer.wait_time = telemetry_update_time
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 75, OS.get_ticks_usec(), '			_telemetry_update_timer.wait_time = telemetry_update_time')
			_telemetry_update_timer.one_shot = false
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 76, OS.get_ticks_usec(), '			_telemetry_update_timer.one_shot = false')
			_telemetry_update_timer.connect("timeout", self, "_on_telemetry_update_timer_timeout")
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 77, OS.get_ticks_usec(), '			_telemetry_update_timer.connect("timeout", self, "_on_telemetry_update_timer_timeout")')
			add_child(_telemetry_update_timer)
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 78, OS.get_ticks_usec(), '			add_child(_telemetry_update_timer)')
			_telemetry_update_timer.start()
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 79, OS.get_ticks_usec(), '			_telemetry_update_timer.start()')
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 79, OS.get_ticks_usec(), '')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 79, OS.get_ticks_usec(), '')
	command()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 80, OS.get_ticks_usec(), '	command()')
	last_ctrl_msg = "none"
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 81, OS.get_ticks_usec(), '	last_ctrl_msg = "none"')


func _on_telemetry_update_timer_timeout() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 84, OS.get_ticks_usec(), '')
	update_telemetry()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 85, OS.get_ticks_usec(), '	update_telemetry()')


func _on_keep_active_timer_timeout() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 88, OS.get_ticks_usec(), '')
	command()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 89, OS.get_ticks_usec(), '	command()')


func _init_tele_socket() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 92, OS.get_ticks_usec(), '')
	if !activate_telemetry:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 93, OS.get_ticks_usec(), '	if !activate_telemetry:')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 94, OS.get_ticks_usec(), '')
	_tele_socket = PacketPeerUDP.new()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 95, OS.get_ticks_usec(), '	_tele_socket = PacketPeerUDP.new()')
	# warning-ignore:return_value_discarded
	_tele_socket.listen(local_telemetry_port)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 97, OS.get_ticks_usec(), '	_tele_socket.listen(local_telemetry_port)')


func _init_ctrl_socket() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 100, OS.get_ticks_usec(), '')
	# warning-ignore:return_value_discarded
	_ctrl_socket = PacketPeerUDP.new()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 102, OS.get_ticks_usec(), '	_ctrl_socket = PacketPeerUDP.new()')
	_ctrl_socket.listen(local_ctrl_port)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 103, OS.get_ticks_usec(), '	_ctrl_socket.listen(local_ctrl_port)')


func _process_telemetry() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 106, OS.get_ticks_usec(), '')
	if !_tele_socket:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 107, OS.get_ticks_usec(), '	if !_tele_socket:')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 108, OS.get_ticks_usec(), '')
	var count := _tele_socket.get_available_packet_count()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 109, OS.get_ticks_usec(), '	var count := _tele_socket.get_available_packet_count()')
	if count < 1:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 110, OS.get_ticks_usec(), '	if count < 1:')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 111, OS.get_ticks_usec(), '')
	var bytes : PoolByteArray
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 112, OS.get_ticks_usec(), '	var bytes : PoolByteArray')
	for _i in range(count):
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 113, OS.get_ticks_usec(), '	for _i in range(count):')
		bytes = _tele_socket.get_packet()
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 114, OS.get_ticks_usec(), '		bytes = _tele_socket.get_packet()')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 114, OS.get_ticks_usec(), '')
	_telemetry_raw = bytes.get_string_from_ascii()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 115, OS.get_ticks_usec(), '	_telemetry_raw = bytes.get_string_from_ascii()')


func update_telemetry() -> Dictionary:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 118, OS.get_ticks_usec(), '')
	var raw := _telemetry_raw
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 119, OS.get_ticks_usec(), '	var raw := _telemetry_raw')
	var split1 := raw.split(";", false, 15)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 120, OS.get_ticks_usec(), '	var split1 := raw.split(";", false, 15)')
	var d := {}
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 121, OS.get_ticks_usec(), '	var d := {}')
	for item1 in split1:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 122, OS.get_ticks_usec(), '	for item1 in split1:')
		var split2 := String(item1).split(":", false, 2)
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 123, OS.get_ticks_usec(), '		var split2 := String(item1).split(":", false, 2)')
		var k := split2[0]
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 124, OS.get_ticks_usec(), '		var k := split2[0]')
		var v := split2[1]
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 125, OS.get_ticks_usec(), '		var v := split2[1]')
		d[k] = v
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 126, OS.get_ticks_usec(), '		d[k] = v')
		emit_signal("recived_telemery", k, v)
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 127, OS.get_ticks_usec(), '		emit_signal("recived_telemery", k, v)')
		match k:
			"pitch":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 129, OS.get_ticks_usec(), '			"pitch":')
				emit_signal("recived_telemery_pitch", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 130, OS.get_ticks_usec(), '				emit_signal("recived_telemery_pitch", int(v))')
			"roll":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 131, OS.get_ticks_usec(), '			"roll":')
				emit_signal("recived_telemery_roll", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 132, OS.get_ticks_usec(), '				emit_signal("recived_telemery_roll", int(v))')
			"yaw":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 133, OS.get_ticks_usec(), '			"yaw":')
				emit_signal("recived_telemery_yaw", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 134, OS.get_ticks_usec(), '				emit_signal("recived_telemery_yaw", int(v))')
			"vgx":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 135, OS.get_ticks_usec(), '			"vgx":')
				emit_signal("recived_telemery_vgx", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 136, OS.get_ticks_usec(), '				emit_signal("recived_telemery_vgx", int(v))')
			"vgy":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 137, OS.get_ticks_usec(), '			"vgy":')
				emit_signal("recived_telemery_vgy", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 138, OS.get_ticks_usec(), '				emit_signal("recived_telemery_vgy", int(v))')
			"vgz":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 139, OS.get_ticks_usec(), '			"vgz":')
				emit_signal("recived_telemery_vgz", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 140, OS.get_ticks_usec(), '				emit_signal("recived_telemery_vgz", int(v))')
			"templ":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 141, OS.get_ticks_usec(), '			"templ":')
				emit_signal("recived_telemery_templ", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 142, OS.get_ticks_usec(), '				emit_signal("recived_telemery_templ", int(v))')
			"temph":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 143, OS.get_ticks_usec(), '			"temph":')
				emit_signal("recived_telemery_temph", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 144, OS.get_ticks_usec(), '				emit_signal("recived_telemery_temph", int(v))')
			"tof":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 145, OS.get_ticks_usec(), '			"tof":')
				emit_signal("recived_telemery_tof", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 146, OS.get_ticks_usec(), '				emit_signal("recived_telemery_tof", int(v))')
			"h":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 147, OS.get_ticks_usec(), '			"h":')
				emit_signal("recived_telemery_h", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 148, OS.get_ticks_usec(), '				emit_signal("recived_telemery_h", int(v))')
			"bat":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 149, OS.get_ticks_usec(), '			"bat":')
				emit_signal("recived_telemery_bat", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 150, OS.get_ticks_usec(), '				emit_signal("recived_telemery_bat", int(v))')
			"baro":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 151, OS.get_ticks_usec(), '			"baro":')
				emit_signal("recived_telemery_baro", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 152, OS.get_ticks_usec(), '				emit_signal("recived_telemery_baro", int(v))')
			"time":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 143, OS.get_ticks_usec(), '			"time":')
				emit_signal("recived_telemery_time", int(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 154, OS.get_ticks_usec(), '				emit_signal("recived_telemery_time", int(v))')
			"agx":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 155, OS.get_ticks_usec(), '			"agx":')
				emit_signal("recived_telemery_agx", float(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 156, OS.get_ticks_usec(), '				emit_signal("recived_telemery_agx", float(v))')
			"agy":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 157, OS.get_ticks_usec(), '			"agy":')
				emit_signal("recived_telemery_agy", float(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 158, OS.get_ticks_usec(), '				emit_signal("recived_telemery_agy", float(v))')
			"agz":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 159, OS.get_ticks_usec(), '			"agz":')
				emit_signal("recived_telemery_agz", float(v))
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 160, OS.get_ticks_usec(), '				emit_signal("recived_telemery_agz", float(v))')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 160, OS.get_ticks_usec(), '')
	return d


func _process_ctrl() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 164, OS.get_ticks_usec(), '')
	var count := _ctrl_socket.get_available_packet_count()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 165, OS.get_ticks_usec(), '	var count := _ctrl_socket.get_available_packet_count()')
	if count < 1:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 166, OS.get_ticks_usec(), '	if count < 1:')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 167, OS.get_ticks_usec(), '')
	for _i in range(count):
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 168, OS.get_ticks_usec(), '	for _i in range(count):')
		var bytes := _ctrl_socket.get_packet()
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 169, OS.get_ticks_usec(), '		var bytes := _ctrl_socket.get_packet()')
		var msg := bytes.get_string_from_ascii().rstrip("\n")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 170, OS.get_ticks_usec(), '		var msg := bytes.get_string_from_ascii().rstrip("\n")')
		last_ctrl_msg = msg
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 171, OS.get_ticks_usec(), '		last_ctrl_msg = msg')
		emit_signal("recived_control_code", msg)
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 172, OS.get_ticks_usec(), '		emit_signal("recived_control_code", msg)')
		match msg:
			"ok":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 174, OS.get_ticks_usec(), '			"ok":')
				emit_signal("recived_control_code_ok")
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 175, OS.get_ticks_usec(), '				emit_signal("recived_control_code_ok")')
			"error":
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 176, OS.get_ticks_usec(), '			"error":')
				emit_signal("recived_control_code_error")
				NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 177, OS.get_ticks_usec(), '				emit_signal("recived_control_code_error")')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 177, OS.get_ticks_usec(), '')
	_keep_active_timer.paused = false
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 178, OS.get_ticks_usec(), '	_keep_active_timer.paused = false')


func send_cmd(cmd: String) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 181, OS.get_ticks_usec(), '')
	if !is_processing() and !cmd.begins_with("command"):
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 182, OS.get_ticks_usec(), '	if !is_processing() and !cmd.begins_with("command"):')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 193, OS.get_ticks_usec(), '')
	if keep_active_time > 0:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 184, OS.get_ticks_usec(), '	if keep_active_time > 0:')
		_keep_active_timer.start(keep_active_time)
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 185, OS.get_ticks_usec(), '		_keep_active_timer.start(keep_active_time)')
		_keep_active_timer.paused = true
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 186, OS.get_ticks_usec(), '		_keep_active_timer.paused = true')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 186, OS.get_ticks_usec(), '')
	last_ctrl_msg = ""
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 187, OS.get_ticks_usec(), '	last_ctrl_msg = ""')
	last_command = cmd
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 188, OS.get_ticks_usec(), '	last_command = cmd')
	emit_signal("command_send", cmd)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 189, OS.get_ticks_usec(), '	emit_signal("command_send", cmd)')
	var packet := cmd.to_ascii()
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 190, OS.get_ticks_usec(), '	var packet := cmd.to_ascii()')
	# warning-ignore:return_value_discarded
	_ctrl_socket.set_dest_address(drone_ip, drone_ctrl_port)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 192, OS.get_ticks_usec(), '	_ctrl_socket.set_dest_address(drone_ip, drone_ctrl_port)')
	# warning-ignore:return_value_discarded
	_ctrl_socket.put_packet(packet)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 194, OS.get_ticks_usec(), '	_ctrl_socket.put_packet(packet)')
	set_process(true)
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 195, OS.get_ticks_usec(), '	set_process(true)')


func _get_is_active() -> bool:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 199, OS.get_ticks_usec(), '')
	return is_processing()


func _set_is_active(val: bool) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 202, OS.get_ticks_usec(), '')
	# read only - ignore silently
	pass
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 204, OS.get_ticks_usec(), '	pass')


func command() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 207, OS.get_ticks_usec(), '')
	send_cmd("command")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 208, OS.get_ticks_usec(), '	send_cmd("command")')


func takeoff() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 211, OS.get_ticks_usec(), '')
	send_cmd("takeoff")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 212, OS.get_ticks_usec(), '	send_cmd("takeoff")')


func land() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 215, OS.get_ticks_usec(), '')
	send_cmd("land")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 216, OS.get_ticks_usec(), '	send_cmd("land")')


func emergency() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 219, OS.get_ticks_usec(), '')
	send_cmd("emergency")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 220, OS.get_ticks_usec(), '	send_cmd("emergency")')


func up(distance: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 223, OS.get_ticks_usec(), '')
	if distance < 0:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 224, OS.get_ticks_usec(), '	if distance < 0:')
		down(abs(distance))
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 225, OS.get_ticks_usec(), '		down(abs(distance))')
	if distance < 20:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 226, OS.get_ticks_usec(), '	if distance < 20:')
		push_error("up distance must be greater than or equeals 20")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 227, OS.get_ticks_usec(), '		push_error("up distance must be greater than or equeals 20")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 228, OS.get_ticks_usec(), '')
	if distance > 500:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 229, OS.get_ticks_usec(), '	if distance > 500:')
		push_error("up distance must be smaller than or equeals 500")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 230, OS.get_ticks_usec(), '		push_error("up distance must be smaller than or equeals 500")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 231, OS.get_ticks_usec(), '')
	send_cmd("up " + String(distance))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 232, OS.get_ticks_usec(), '	send_cmd("up " + String(distance))')


func down(distance: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 235, OS.get_ticks_usec(), '')
	if distance < 20:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 236, OS.get_ticks_usec(), '	if distance < 20:')
		push_error("down distance must be greater than or equeals 20")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 237, OS.get_ticks_usec(), '		push_error("down distance must be greater than or equeals 20")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 238, OS.get_ticks_usec(), '')
	if distance > 500:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 239, OS.get_ticks_usec(), '	if distance > 500:')
		push_error("down distance must be smaller than or equeals 500")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 240, OS.get_ticks_usec(), '		push_error("down distance must be smaller than or equeals 500")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 241, OS.get_ticks_usec(), '')
	send_cmd("down " + String(distance))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 242, OS.get_ticks_usec(), '	send_cmd("down " + String(distance))')


func left(distance: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 245, OS.get_ticks_usec(), '')
	if distance < 20:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 246, OS.get_ticks_usec(), '	if distance < 20:')
		push_error("left distance must be greater than or equeals 20")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 247, OS.get_ticks_usec(), '		push_error("left distance must be greater than or equeals 20")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 248, OS.get_ticks_usec(), '')
	if distance > 500:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 249, OS.get_ticks_usec(), '	if distance > 500:')
		push_error("left distance must be smaller than or equeals 500")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 250, OS.get_ticks_usec(), '		push_error("left distance must be smaller than or equeals 500")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 251, OS.get_ticks_usec(), '')
	send_cmd("left " + String(distance))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 252, OS.get_ticks_usec(), '	send_cmd("left " + String(distance))')


func right(distance: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 255, OS.get_ticks_usec(), '')
	if distance < 20:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 256, OS.get_ticks_usec(), '	if distance < 20:')
		push_error("right distance must be greater than or equeals 20")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 257, OS.get_ticks_usec(), '		push_error("right distance must be greater than or equeals 20")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 258, OS.get_ticks_usec(), '')
	if distance > 500:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 259, OS.get_ticks_usec(), '	if distance > 500:')
		push_error("right distance must be smaller than or equeals 500")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 260, OS.get_ticks_usec(), '		push_error("right distance must be smaller than or equeals 500")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 261, OS.get_ticks_usec(), '')
	send_cmd("right " + String(distance))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 262, OS.get_ticks_usec(), '	send_cmd("right " + String(distance))')


func forward(distance: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 265, OS.get_ticks_usec(), '')
	if distance < 20:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 266, OS.get_ticks_usec(), '	if distance < 20:')
		push_error("forward distance must be greater than or equeals 20")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 267, OS.get_ticks_usec(), '		push_error("forward distance must be greater than or equeals 20")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 268, OS.get_ticks_usec(), '')
	if distance > 500:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 269, OS.get_ticks_usec(), '	if distance > 500:')
		push_error("forward distance must be smaller than or equeals 500")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 270, OS.get_ticks_usec(), '		push_error("forward distance must be smaller than or equeals 500")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 271, OS.get_ticks_usec(), '')
	send_cmd("forward " + String(distance))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 272, OS.get_ticks_usec(), '	send_cmd("forward " + String(distance))')


func back(distance: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 275, OS.get_ticks_usec(), '')
	if distance < 20:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 276, OS.get_ticks_usec(), '	if distance < 20:')
		push_error("backward distance must be greater than or equeals 20")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 277, OS.get_ticks_usec(), '		push_error("backward distance must be greater than or equeals 20")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 278, OS.get_ticks_usec(), '')
	if distance > 500:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 279, OS.get_ticks_usec(), '	if distance > 500:')
		push_error("backward distance must be smaller than or equeals 500")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 280, OS.get_ticks_usec(), '		push_error("backward distance must be smaller than or equeals 500")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 281, OS.get_ticks_usec(), '')
	send_cmd("back " + String(distance))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 282, OS.get_ticks_usec(), '	send_cmd("back " + String(distance))')


func cw(angle: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 285, OS.get_ticks_usec(), '')
	if angle < 1:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 286, OS.get_ticks_usec(), '	if angle < 1:')
		push_error("clockwise angle must be greater than or equeals 1")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 287, OS.get_ticks_usec(), '		push_error("clockwise angle must be greater than or equeals 1")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 288, OS.get_ticks_usec(), '')
	if angle > 3600:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 289, OS.get_ticks_usec(), '	if angle > 3600:')
		push_error("clockwise angle must be smaller than or equeals 3600")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 290, OS.get_ticks_usec(), '		push_error("clockwise angle must be smaller than or equeals 3600")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 291, OS.get_ticks_usec(), '')
	send_cmd("cw " + String(angle))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 292, OS.get_ticks_usec(), '	send_cmd("cw " + String(angle))')


func ccw(angle: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 295, OS.get_ticks_usec(), '')
	if angle < 1:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 296, OS.get_ticks_usec(), '	if angle < 1:')
		push_error("counter clockwise angle must be greater than or equeals 1")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 297, OS.get_ticks_usec(), '		push_error("counter clockwise angle must be greater than or equeals 1")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 298, OS.get_ticks_usec(), '')
	if angle > 3600:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 299, OS.get_ticks_usec(), '	if angle > 3600:')
		push_error("counter clockwise angle must be smaller than or equeals 3600")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 300, OS.get_ticks_usec(), '		push_error("counter clockwise angle must be smaller than or equeals 3600")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 301, OS.get_ticks_usec(), '')
	send_cmd("ccw " + String(angle))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 302, OS.get_ticks_usec(), '	send_cmd("ccw " + String(angle))')


func flip(direction: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 306, OS.get_ticks_usec(), '')
	match direction:
		1:
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 307, OS.get_ticks_usec(), '		1:')
			send_cmd("flip f")
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 308, OS.get_ticks_usec(), '			send_cmd("flip f")')
		2:
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 309, OS.get_ticks_usec(), '		2:')
			send_cmd("flip r")
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 310, OS.get_ticks_usec(), '			send_cmd("flip r")')
		3:
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 311, OS.get_ticks_usec(), '		3:')
			send_cmd("flip b")
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 312, OS.get_ticks_usec(), '			send_cmd("flip b")')
		4:
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 313, OS.get_ticks_usec(), '		4:')
			send_cmd("flip l")
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 314, OS.get_ticks_usec(), '			send_cmd("flip l")')
		_:
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 315, OS.get_ticks_usec(), '		_:')
			push_error("flip direction unknown")
			NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 316, OS.get_ticks_usec(), '			push_error("flip direction unknown")')
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 316, OS.get_ticks_usec(), '')


func go(x: int, y: int, z: int, s: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 319, OS.get_ticks_usec(), '')
	# TODO boundy checks
	send_cmd("go {x} {y} {z} {s}".format({"x": x, "y": y, "z": z, "s": s}))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 321, OS.get_ticks_usec(), '	send_cmd("go {x} {y} {z} {s}".format({"x": x, "y": y, "z": z, "s": s}))')


func curve(x1: int, y1: int, z1: int, x2: int, y2: int, z2: int, s: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 324, OS.get_ticks_usec(), '')
	# TODO boundy checks
	# TODO check x/y/z can’t be between -20 – 20 at the same time
	# TODO check if the arc radius is not within the range of 0.5-10 meters, it responses false
	send_cmd("curve {x1} {y1} {z1} {x2} {y2} {z3} {s}".format({"x1": x1, "y1": y1, "z1": z1, "x2": x2, "y2": y2, "z2": z2, "s": s}))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 328, OS.get_ticks_usec(), '	send_cmd("curve {x1} {y1} {z1} {x2} {y2} {z3} {s}".format({"x1": x1, "y1": y1, "z1": z1, "x2": x2, "y2": y2, "z2": z2, "s": s}))')


func speed(s: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 331, OS.get_ticks_usec(), '')
	if s < 10 or s > 100:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 332, OS.get_ticks_usec(), '	if s < 10 or s > 100:')
		push_error("speed under 10 or over 100")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 333, OS.get_ticks_usec(), '		push_error("speed under 10 or over 100")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 334, OS.get_ticks_usec(), '')
	send_cmd("speed " + String(s))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 335, OS.get_ticks_usec(), '	send_cmd("speed " + String(s))')


func rc(left_right: int, forward_backward: int, up_down: int, yaw: int) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 338, OS.get_ticks_usec(), '')
	if left_right < -100 or forward_backward < -100 or up_down < -100 or yaw < -100:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 339, OS.get_ticks_usec(), '	if left_right < -100 or forward_backward < -100 or up_down < -100 or yaw < -100:')
		push_error("rc all values must be over -100")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 340, OS.get_ticks_usec(), '		push_error("rc all values must be over -100")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 341, OS.get_ticks_usec(), '')
	if left_right > 100 or forward_backward > 100 or up_down > 100 or yaw > 100:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 342, OS.get_ticks_usec(), '	if left_right > 100 or forward_backward > 100 or up_down > 100 or yaw > 100:')
		push_error("rc all values must be under 100")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 343, OS.get_ticks_usec(), '		push_error("rc all values must be under 100")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 344, OS.get_ticks_usec(), '')
	send_cmd("rc {lr} {fb} {ud} {y}".format({"lr": left_right, "fb": forward_backward, "ud": up_down, "y": yaw}))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 345, OS.get_ticks_usec(), '	send_cmd("rc {lr} {fb} {ud} {y}".format({"lr": left_right, "fb": forward_backward, "ud": up_down, "y": yaw}))')


func wifi(ssid: String, password: String) -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 348, OS.get_ticks_usec(), '')
	if ssid.length() == 0:
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 349, OS.get_ticks_usec(), '	if ssid.length() == 0:')
		push_error("wifi ssid can not be an empty string")
		NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 350, OS.get_ticks_usec(), '		push_error("wifi ssid can not be an empty string")')
		return
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 351, OS.get_ticks_usec(), '')
	send_cmd("wifi {ssid} {pass}".format({"ssid": ssid, "pass": password}))
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 352, OS.get_ticks_usec(), '	send_cmd("wifi {ssid} {pass}".format({"ssid": ssid, "pass": password}))')


func speedQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 355, OS.get_ticks_usec(), '')
	send_cmd("speed?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 356, OS.get_ticks_usec(), '	send_cmd("speed?")')


func batteryQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 359, OS.get_ticks_usec(), '')
	send_cmd("battery?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 360, OS.get_ticks_usec(), '	send_cmd("battery?")')


func timeQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 363, OS.get_ticks_usec(), '')
	send_cmd("time?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 364, OS.get_ticks_usec(), '	send_cmd("time?")')


func heightQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 367, OS.get_ticks_usec(), '')
	send_cmd("height?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 368, OS.get_ticks_usec(), '	send_cmd("height?")')


func tempQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 371, OS.get_ticks_usec(), '')
	send_cmd("temp?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 372, OS.get_ticks_usec(), '	send_cmd("temp?")')


func attitudeQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 375, OS.get_ticks_usec(), '')
	send_cmd("attitude?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 376, OS.get_ticks_usec(), '	send_cmd("attitude?")')


func baroQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 379, OS.get_ticks_usec(), '')
	send_cmd("baro?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 380, OS.get_ticks_usec(), '	send_cmd("baro?")')


func accelerationQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 383, OS.get_ticks_usec(), '')
	send_cmd("acceleration?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 384, OS.get_ticks_usec(), '	send_cmd("acceleration?")')


func tofQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 387, OS.get_ticks_usec(), '')
	send_cmd("tof?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 388, OS.get_ticks_usec(), '	send_cmd("tof?")')


func wifiQ() -> void:
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 391, OS.get_ticks_usec(), '')
	send_cmd("wifi?")
	NaiveGDScriptProfiler.note('addons/TelloDroneNode/TelloDroneNode.gd', 392, OS.get_ticks_usec(), '	send_cmd("wifi?")')
