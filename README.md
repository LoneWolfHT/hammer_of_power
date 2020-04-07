# Hammer of Power

Adds a powerful hammer to the game.

### Supports Minetest Game and [Nodecore](https://content.minetest.net/packages/Warr1024/nodecore/)

#

## Usage

Rightclick to spawn a fling entity in your pointed direction
Punch the fling entity to fling yourself in that direction
You will take fall damage if your hammer can spawn a fling entity again (It can do so 5 seconds after punching a fling entity, your wielditem will indicate when the time is up because it will stop moving upwards)
To prevent yourself from taking fall damage you need to rightclick the ground you are falling on before you land on it. This can be achieved by holding down rightmouse and aiming at the ground.
If you do land with the rightmouse method all entities including players within a 3 node radius will be blasted away from you, the greater the falling velocity the farther they will fly. So flinging yourself downwards in midair results in a bigger blast.

## Minetest Game Crafting

See code (hammer_of_power/compat/mtg.lua)

## Nodecore Crafting

Annealed mallet head on an annealed lode rod for steel hammer.
Infuse steel hammer with lux for hammer of power, may take a while
