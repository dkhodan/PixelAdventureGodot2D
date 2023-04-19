extends Label

func _on_player_change_state(state, state_id):
	self.text = str(state)
