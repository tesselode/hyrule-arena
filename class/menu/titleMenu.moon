export class TitleMenu extends Common
  new: (@state) =>
    super!

    @y = 85

  flyUp: =>
    @tween\to(self, 0.5, {y: -100})\ease('backin')

  flyDown: =>
    @tween\to(self, 0.5, {y: 85})\ease('backout')

  draw: (topLeftX, topLeftY) =>
    with love.graphics
      .setColor 255, 255, 255, 255
      .setFont fonts.title
      .print 'The best game ever', topLeftX + BASE_WIDTH / 2 - fonts.title\getWidth('The best game ever') / 2, topLeftY + @y
      .setFont fonts.menu
      .print 'Press enter to start', topLeftX + BASE_WIDTH / 2 - fonts.menu\getWidth('Press enter to start') / 2, topLeftY + @y + 35
