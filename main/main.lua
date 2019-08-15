-- Load some default values for our rectangle.
function love.load()
    pontuacao1 = 0
    pontuacao2 = 0

    H = love.graphics.getHeight()
    W = love.graphics.getWidth()

    mundo = love.physics.newWorld(0,0,true)

    bola = {}
    	bola.b = love.physics.newBody(mundo, W/2, H/2, "dynamic")
    	bola.b:setMass(1/10000)
    	bola.s = love.physics.newCircleShape(10)
    	bola.f = love.physics.newFixture(bola.b, bola.s)
   		bola.f:setRestitution(1.2)
    	bola.f:setUserData("Bola")
      bola.prevPos = {{W/2,H/2}, {W/2,H/2}, {W/2,H/2}}

    chao = {}
    	chao.b = love.physics.newBody(mundo, W/2, H, "static")
    	chao.s = love.physics.newRectangleShape(W,1)
    	chao.f = love.physics.newFixture(chao.b, chao.s)
    	chao.f:setUserData("Chao")

    teto = {}
    	teto.b = love.physics.newBody(mundo, W/2, 0, "static")
    	teto.s = love.physics.newRectangleShape(W,1)
    	teto.f = love.physics.newFixture(teto.b, teto.s)
    	teto.f:setUserData("Chao")


      bastao1 = {}
        bastao1.b = love.physics.newBody(mundo, 30, H/2, "static")
        bastao1.s = love.physics.newPolygonShape(-10, -40, 5, -40, 15, 0, 5, 40, -10, 40)
        bastao1.f = love.physics.newFixture(bastao1.b, bastao1.s)
        bastao1.f:setUserData("Bastao1")

      bastao2 = {}
        bastao2.b = love.physics.newBody(mundo, W - 30, H/2, "static")
        bastao2.s = love.physics.newPolygonShape(10, -40, -5, -40, -15, 0, -5, 40, 10, 40)
        bastao2.f = love.physics.newFixture(bastao2.b, bastao2.s)
        bastao2.f:setUserData("Bastao1")

      --bola.b:setAngle(math.rad(math.random(0,359)))

      bola.b:setLinearVelocity(200,130)


end

function love.update(dt)
    bolaXSpeed, bolaYSpeed = bola.b:getLinearVelocity()

    if bolaXSpeed < 40 and bolaXSpeed >= 0  then
        bola.b:setLinearVelocity(50,bolaYSpeed)
    end

    if bolaXSpeed > -40 and bolaXSpeed <= 0  then
        bola.b:setLinearVelocity(-50,bolaYSpeed)
    end

	  mundo:update(dt)

    yB1 = bastao1.b:getY()
    yB2 = bastao2.b:getY()

    bolaX = bola.b:getX()
    bolaR = bola.s:getRadius()


    -- Testa pra ver se saiu da tela (horizontal)
    if (bolaX + bolaR) >= W then -- Saiu pela direita
        pontuacao1 = pontuacao1 + 1
        bola.b:setX(W/2)
        bola.b:setY(H/2)

        bola.b:setLinearVelocity(-200, math.random(-150,150))

    elseif (bolaX - bolaR) <= 0 then -- Saiu pela esquerda
        pontuacao2 = pontuacao2 + 1
        bola.b:setX(W/2)
        bola.b:setY(H/2)

        bola.b:setLinearVelocity(200, math.random(-150,150))

    end

    if pontuacao1 == 5 or pontuacao2 == 5 then
        love.event.quit()
    end


    speedB = 350

    if love.keyboard.isDown("q") and yB1 > 50 then
        bastao1.b:setY(yB1 - speedB * dt)
    end

    if love.keyboard.isDown("a") and yB1 < (H - 50) then
        bastao1.b:setY(yB1 + speedB * dt)
    end

    if love.keyboard.isDown("p") and yB2 > 50 then
        bastao2.b:setY(yB2 - speedB * dt)
    end

    if love.keyboard.isDown("l") and yB2 < (H - 50) then
        bastao2.b:setY(yB2 + speedB * dt)
    end


    bola.prevPos[10] = {bola.b:getX(), bola.b:getY()}
    for i = 1,9 do
        bola.prevPos[i] = bola.prevPos[i+1]
    end



end

-- Draw a coloured rectangle.
function love.draw()
    --love.graphics.setColor(0, 0.6, 0.4)
    --love.graphics.polygon("fill", teto.b:getWorldPoints(teto.s:getPoints()))
    --love.graphics.polygon("fill", chao.b:getWorldPoints(chao.s:getPoints()))
    love.graphics.setColor(1, 112/255, 13/255, 1)
    love.graphics.ellipse("fill", bola.b:getX(), bola.b:getY(), bola.s:getRadius(), bola.s:getRadius())

    love.graphics.setColor(13/255, 109/255, 1, 1)
    love.graphics.polygon("fill", bastao1.b:getWorldPoints(bastao1.s:getPoints()))
    love.graphics.polygon("fill", bastao2.b:getWorldPoints(bastao2.s:getPoints()))
    love.graphics.setColor(1,1,1)
    love.graphics.print(pontuacao1, (W/2) - 60, 100, 0, 4, 4)
    love.graphics.print(pontuacao2, (W/2) + 30, 100, 0, 4, 4)
    love.graphics.line(W/2, 0, W/2, H)

    for i, pos in ipairs(bola.prevPos) do
        love.graphics.setColor(1, 112/255, 13/255, 1/i)
        love.graphics.ellipse("fill", pos[1], pos[2], bola.s:getRadius(), bola.s:getRadius())
    end

end
