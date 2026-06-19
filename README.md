# Pongo Casino
A "Juice" Jam product made in godot inspired by the 1972 game, Pong! 

## Game Jam
A Pong Roguelike game jam hosted by [Blastworks Inc.](https://www.blastworksinc.com/) and completed over 72 hours.
Made in partnership with Claire Jané ([LinkedIn](https://www.linkedin.com/in/claireejane/), [GitHub](https://github.com/claireejane))


# =======From The Jam=======

# Pong
This is a pong template for the 2026 Blastworks Juice Jam.

## Scenes
The project features 3 scenes:
* components/ball
	* 25px by 25px white square
	* "Ball" collision layer
	* Masks for "Default" or "Paddle" collision layers
	* AudioStreamPlayer2D for hit SFX
* components/paddle
	* 50px by 200px white rectangle
	* "Paddle" collision layer
	* Masks for "Default" or "Ball" collision layers
* game
	* Background CanvasLayer for BG color, divider, and score labels
	* Marker2D for ball spawn position
	* Left and right paddles
	* Top and bottom wall boundaries
		* These use a WorldBoundaryShape2D shape (infinite line with a direction)
	* Left and right goal
		* Their `body_entered` signal is hooked up to the game
	* AudioStreamPlayer for score SFX

## Scripts
The project features 3 scripts that correspond to the 3 scenes:
* Ball
	* Moves in its current direction and bounces (using Vector2.bounce) using the collision normal
	* Plays an SFX (hit.wav) when it bounces
	* Its current direction can be set (e.g. on start)
* Paddle
	* Either follows its current target (e.g. the ball) or follows manual input
* Game
	* Starts by spawning a Ball
	* If a goal is entered by a Ball then a new Ball is spawned and the opposite side scores a point
	* Spawning creates a new Ball instance with a random direction and updates the AI paddle's target
	* Plays an SFX (score.wav) on scoring
	* Updates the left paddle with user input every frame

## Project Settings
The following project settings were set:
* Project name is "Pong"
* Default scene is the Game scene
* Has `move_up` and `move_down` input actions
* Viewport is 1920x1080
* Window size is 1280x720
* Window stretch mode set to "canvas_items"
	* Scales with black bars for maintaining 16x9 aspect ratio
* Physics layers
	* 1 - Default
	* 2 - Paddle
	* 3 - Ball
