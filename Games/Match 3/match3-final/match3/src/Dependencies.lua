--import library
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

--import utils
require 'src/StateMachine'
require 'src/Util'
require 'src/Constants'

--import game states
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/BeginGameState'
require 'src/states/PlayState'
require 'src/states/GameOverState'

--import game objects
require 'src/Board'
require 'src/Tile'