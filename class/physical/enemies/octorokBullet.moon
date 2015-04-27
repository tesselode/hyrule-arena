export class OctorokBullet extends Projectile
  new: (state, x, y, dir) =>
    super state, x, y, 10, 10, 300, dir

    @isEnemy = true
