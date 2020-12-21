<ins>Complexity<ins>

This game meets the complexity requirements, because the game logic and design include several topics that were discussed in the weekly lectures. See below for explanations of the list of topics included

Collision Detection: 
AABB is a box collision that was used in the lectures. However, the projectiles were rounds in my game and thus I used circle-box collision technique.

StateMachine:
A stateMachine was included to changes game states to the following states: GameOverState, PlayState, StartState, SelectCharState

Procedural Generation:
My game in includes 4 types of projectiles. When the projectiles are generated, the algorithm dictates how it behaves, in other words, how it moves. The projectiles can behave like a laser or one of the three other types depending on the algorithm

SpriteSheet:
There are several sprite sheets that were used in my game and thus sprite sheet parsing was also used.

2D Animations:
My game includes walk, idle, and death animations for all the three selectable characters

Data-Driven Design:
The player's 'properties' are all stored in a file called entity_defs. It includes player properties like walk speed and animation information

Timer/Tween:
The projectiles are generated on a timer and some of the projectile movements done by tweens.

<ins>distinctiveness<ins>

This game meets the distinctiveness requirements, because includes some new topics. See below for explanations of the list of topics included

Circle-Box Collision detection:
This games check collisions between a circle and a box using a collision technique other than AABB

Procedural Generation Mathematically:
The algorithm to generate the projectile uses more mathematically logic than if statements. Much of the projectile generations using the equations y = rsin(theta), x = r cos(theta) to obtain the coordinates of a circle.

Colliders:
Using the same approach in UNITY, I created a collider class that gives objects collide-able properties instead of giving object collision detection functions.

In addition, the game also meets the distinctiveness requirements from a game play point of view. The idea is to dodge the projectiles which you could argue is similar to dodging the pipes in Flappy Bird. However, there is only one way to dodge the pipes, but there are several to dodge the projectiles.

Moreover, the dodging games implemented in the lectures like Helicopter Game 3D and Flappy Bird involved a moving background. The idea of movement in these games is locking the player movement in one direction (in the case of the games mentioned, it is the y direction) and move everything else to the player. On the other hand, my game design for movement is different as both the player and projectiles are free to move in all directions


