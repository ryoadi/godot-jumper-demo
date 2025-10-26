extends Object

## Jump height
var jump_height: float = 300

## Jump time.
var jump_time: float = 1

# Calculated jump power.
var _jump_power: float = _calculate_jump_power(jump_height, jump_time)

# Calculate jump power
func _calculate_jump_power(height: float, time_to_peak: float) -> float:
	return (2.0 * height) / pow(time_to_peak, 2.0)
