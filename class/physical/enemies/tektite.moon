export class Tektite extends Enemy
  new: (state, x, y) =>
    super state, x, y, 12, 8

    @image = images.tektite

    --jumping pattern
    @timer\recur ->
        @inAir = true
        player = @state.player
        @velocity = vector player\getCenter!.x - @getCenter!.x, player\getCenter!.y - @getCenter!.y
        @velocity = @velocity\normalized! * 50
        flux.to(self, .3, {z: 25})\oncomplete(->
          flux.to(self, .3, {z: 0})\ease('quadin')\oncomplete(->
            @inAir = false
            @velocity = vector 0, 0)),
      2

  update: (dt) =>
    super dt

    --makes things look a little better
    @depth = 100 + @z
