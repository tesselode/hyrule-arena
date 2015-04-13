export class Tektite extends Enemy
  new: (world, x, y) =>
    super world, x, y

    --jumping pattern
    @timer\recur ->
        @inAir = true
        player = currentState.player
        @velocity = vector player\getCenter!.x - @getCenter!.x, player\getCenter!.y - @getCenter!.y
        @velocity = @velocity\normalized! * 200
        flux.to(self, .3, {z: 50})\oncomplete(->
          flux.to(self, .3, {z: 0})\ease('quadin')\oncomplete(->
            @inAir = false
            @velocity = vector 0, 0)),
      2

  update: (dt) =>
    super dt

    --makes things look a little better
    @depth = 100 + @z
