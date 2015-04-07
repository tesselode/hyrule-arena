export class Tektite extends Enemy
  new: (world, x, y) =>
    super world, x, y

    --jumping pattern
    @timer\recur ->
        @inAir = true
        flux.to(self, .5, {z: 100})\oncomplete(->
          flux.to(self, .5, {z: 0})\ease('quadin')\oncomplete(->
            @inAir = false)),
      2
