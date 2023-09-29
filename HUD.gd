extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_gameee

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Dodge the\nCreeps!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func update_score(score):
	$ScoreLabel.text = str(score)
	
func _on_start_button_pressed():
	print_debug("start button pressed")
	$StartButton.hide()
	start_gameee.emit()

func _on_message_timer_timeout():
	$Message.hide()
