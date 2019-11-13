--เข้ม
--792,564
love.graphics.setDefaultFilter('nearest', 'nearest')
player = {}
enemy = {}
enemies_controller = {}
enemies_controller.enemies = {}
enemies_controller.image = love.graphics.newImage("invader.png")
tile = love.graphics.newImage("Space.png")
score = 0
Game_over = false
Game = true
ex = 0
ey = 0

function checkCollisions(enemies, bullet)
    for i, e in ipairs(enemies) do
        for _, b in pairs(bullet) do
            if b.y <= e.y + e.height and b.x > e.x and b.x < e.x + e.width then
                table.remove(enemies, i)
                table.remove(bullet)
                score = score + 1
                love.graphics.print(score, 0, 0)
                --enemies_controller:spawnEnemy()
                --enemies_controller:spawnEnemy()
            end
        end
    end
end

function checkCollisions_2(player, enemies)
    for i, p in ipairs(player) do
        for _, e in pairs(enemies) do
            if e.y <= p.y + p.height and e.x > p.x and e.x < p.x + p.width then
                love.graphics.setColor(0, 0, 0)
                love.graphics.rectangle("fill", 0, 0, 800, 600)
            end
        end
    end
end

function love.load()
    player = {}
    player.image = love.graphics.newImage("Player2.png")
    player.x = 380
    player.y = 564
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
    --enemies_controller:spawnEnemy()
    --enemies_controller:spawnEnemy()
    --enemies_controller:spawnEnemy()
end

function enemies_controller:spawnEnemy(x, ey)
    enemy = {}
    enemy.x = ex--love.math.random(0, 700)
    enemy.y = ey
    enemy.width = 40
    enemy.height = 24
    enemy.cooldown = 20
    table.insert(self.enemies, enemy)
end

function love.update(dt)
    if Game then
        player.cooldown = player.cooldown - 1

        if love.keyboard.isDown("right") then 
            player.x = player.x+ 5
        elseif love.keyboard.isDown("left") then 
            player.x = player.x- 5
        else player.image = love.graphics.newImage("Player2.png") end
    
        if love.keyboard.isDown("space") then player.fire() end
    end

    if love.keyboard.isDown("escape") then love.window.close() end

    if #enemies_controller == 0 then 
        --enemies_controller:spawnEnemy()
        --enemies_controller:spawnEnemy()
    end

    for i,b in ipairs(player.bullet) do b.y = b.y - 10 end

    for _,b in ipairs(player.bullet) do
        if b.y < 0 then table.remove(bullet) end
    end

    for i,e in ipairs(enemies_controller.enemies) do
        if e.y > 564 then Game_over = true end
    end

    for _,e in pairs(enemies_controller.enemies) do e.y = e.y + 0.3 end

    checkCollisions_2(player, enemies_controller.enemies)
    checkCollisions(enemies_controller.enemies, player.bullet)

    enemies_controller:spawnEnemy()
    for i = 0, 15 do
        enemies_controller:spawnEnemy()
        
        for u = 0, 3 do
            enemies_controller:spawnEnemy()
        end
    end
end

function love.draw()
    love.graphics.scale()
    love.graphics.draw(tile, 0, 0)

    love.graphics.draw(player.image, player.x, player.y, 0)

    love.graphics.setColor(0, 255, 0)
    love.graphics.print(score, 0, 0)
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 0, 10)

    love.graphics.setColor(255, 255, 255)
    for _,b in ipairs(player.bullet) do love.graphics.draw(bullet.image, b.x, b.y, 0) end

    for _,e in pairs(enemies_controller.enemies) do love.graphics.draw(enemies_controller.image, e.x, e.y, 0) end

    if Game_over then 
        Game = false
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print("Game Over!!!", 0, 282, 0, 10)
        love.graphics.print("Your score is: "..tostring(score), 282, 396, 0, 5) 
    end
end