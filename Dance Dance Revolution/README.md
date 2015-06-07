#Dance Dance Revolution

Final project for Digital circuits course by William Thing

demo video can be found: [NEED TO UPLOAD VIDEO AND INSERT LINK]

Description: DDR implementation programmed on hardware (FPGA DE1-SOC) allows the player to hit correct keys (matching the column of lights with corresponding key) when the light on the LED matrix hits the 2nd top row (which will turn red) which will recieve 2 points, 1st row (orange light) will recieve 1 point, and any other spot when player presses any key will result in -2 point. Score is displayed on HEX display. Hit reset for game to reset/start a new game. Enjoy!!


Controls:

* SW[9]: reset, will reset/pause the game of current DDR as well resetting the score.

* KEY[3]: controls left most column of LED matrix; used to hit lights in correct spot for 2 points (when light turns red on the matrix)., 1 point (when light turns orange on the matrix), and -2 point if player presses button too early or late.

* KEY[2]: controls 2nd from left most column of LED matrix; used to hit lights in correct spot for 2 points (when light turns red on the matrix)., 1 point (when light turns orange on the matrix), and -2 point if player presses button too early or late.

* KEY[1]: controls 2nd right most column of LED matrix; used to hit lights in correct spot for 2 points (when light turns red on the matrix)., 1 point (when light turns orange on the matrix), and -2 point if player presses button too early or late.

* KEY[0]: controls right most column of LED matrix; used to hit lights in correct spot for 2 points (when light turns red on the matrix)., 1 point (when light turns orange on the matrix), and -2 point if player presses button too early or late.
