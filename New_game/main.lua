player = {}
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage("invader.png")
tile = love.graphics.newImage("Space.png")
Game = true
Game_over = false
score = 0

function checkCollisions(enemies, bullet)
    for i, e in ipairs(enemies) do
        for _, b in pairs(bullet) do
            if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
                table.remove(enemies, i)
                table.remove(bullet)
                score = score + 1
                love.graphics.print(score, 0, 0)
                enemies_controller:spawnEnemy()
                enemies_controller:spawnEnemy()
            end
        end
    end
end

function love.load()
    player = {}
    player.image = love.graphics.newImage("Player.png")
    player.x = 380
    player.y = 564
    player.speed = 5
    player.height = 32
    player.width = 32
    player.cooldown = 20
    player.bullet = {}
    enemy = {}
    player.fire = function()
        if player.cooldown <= 0 then
            player.cooldown = 10
            bullet = {}
            bullet.image = love.graphics.newImage("bullet.png")
            bullet.x = player.x + 13
            bullet.y = player.y
            table.insert(player.bullet, bullet)
        end
    end
    enemies_controller:spawnEnemy()
    enemies_controller:spawnEnemy()
    enemies_controller:spawnEnemy()

end

function enemies_controller:spawnEnemy(x, y)
    enemy = {}
    enemies_controller.image = love.graphics.newImage("invader.png")
    enemy.x = love.math.random(0, 700)
    enemy.y = 0
    enemy.width = 40
    enemy.height = 24
    enemy.cooldown = 20
    table.insert(self.enemies, enemy)
end


function love.update(dt)
    if Game then
        player.cooldown = player.cooldown - 1

        if love.keyboard.isDown("right") then 
            player.x = player.x+ player.speed
        elseif love.keyboard.isDown("left") then 
            player.x = player.x- player.speed
        else player.image = love.graphics.newImage("Player.png") end
    
        if love.keyboard.isDown("space") then player.fire() end

        if love.keyboard.isDown("z") then player.speed = 10 else player.speed = 5 end

    end

    if love.keyboard.isDown("escape") then love.window.close() end

    for i,b in ipairs(player.bullet) do b.y = b.y - 10 end

    for _,b in ipairs(player.bullet) do
        if b.y < 0 then table.remove(bullet) end
    end

    for i,e in ipairs(enemies_controller.enemies) do
        if e.y > 564 then Game_over = true end
    end

    for _,e in pairs(enemies_controller.enemies) do e.y = e.y + 0.3 end

    checkCollisions(enemies_controller.enemies, player.bullet)

end

function love.draw()
    love.graphics.scale()
    love.graphics.draw(tile, 0, 0)

    love.graphics.draw(player.image, player.x, player.y, 0)
    love.graphics.print(score, 0, 0)
    love.graphics.setColor(0, 255, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 0, 10)       

    love.graphics.setColor(255, 255, 255)
    for _,b in ipairs(player.bullet) do love.graphics.draw(bullet.image, b.x, b.y, 0) end

    for _,e in pairs(enemies_controller.enemies) do
        love.graphics.draw(enemies_controller.image, e.x, e.y, 0)
    end

    if Game_over then 
        Game = false
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Game Over!!!", 0, 282, 0, 10)
        love.graphics.print("Your score is: "..tostring(score), 242, 396, 0, 5) 
    end

end