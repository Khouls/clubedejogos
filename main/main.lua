function love.load()
		love.window.setTitle("PONG")
		love.window.setPosition(400, 200)
		love.window.setMode(960,540)

		pontuacao1 = 0
    pontuacao2 = 0

    H = love.graphics.getHeight()
    W = love.graphics.getWidth()

    mundo = love.physics.newWorld(0,0,true)
			mundo:setCallbacks(endContact)

    bola = {}
    	bola.b = love.physics.newBody(mundo, W/2, H/2, "dynamic")
    	bola.b:setMass(1/10000)
    	bola.s = love.physics.newCircleShape(10)
    	bola.f = love.physics.newFixture(bola.b, bola.s)
   		bola.f:setRestitution(1.7)
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
        bastao2.f:setUserData("Bastao2")

      --bola.b:setAngle(math.rad(math.random(0,359)))

      bola.b:setLinearVelocity(200,130)


      bg = love.graphics.newImage("background.jpg")
      fonte8bit = love.graphics.newFont("8-BIT WONDER.ttf", 40)
      love.graphics.setFont(fonte8bit)


end

function love.update(dt)
    bolaXSpeed, bolaYSpeed = bola.b:getLinearVelocity()

		yB1 = bastao1.b:getY()
		yB2 = bastao2.b:getY()

		bolaX = bola.b:getX()
		bolaR = bola.s:getRadius()


		--muda a velocidade horizontal da bola se ela for muito baixa

    if (bolaXSpeed < 190) and (bolaXSpeed >= 0)  then
        bola.b:setLinearVelocity(200, bolaYSpeed * 0.75)
    end

    if (bolaXSpeed > -190) and (bolaXSpeed <= 0)  then
        bola.b:setLinearVelocity(-200, bolaYSpeed * 0.75)

    end

	  mundo:update(dt)




    -- Testa pra ver se saiu da tela (horizontal)
    if (bolaX + bolaR) >= W then -- Saiu pela direita
        pontuacao1 = pontuacao1 + 1
        bola.b:setX(W/2)
        bola.b:setY(H/2)

        bola.b:setLinearVelocity(-200, 0)--math.random(-150,150))

    elseif (bolaX - bolaR) <= 0 then -- Saiu pela esquerda
        pontuacao2 = pontuacao2 + 1
        bola.b:setX(W/2)
        bola.b:setY(H/2)

        bola.b:setLinearVelocity(200, 0)--math.random(-150,150))

    end

		--fecha o jogo se chegar em 5

    if pontuacao1 == 5 or pontuacao2 == 5 then
        love.event.quit()
    end


    speedB = 350

		--faz os bastões se moverem

    if love.keyboard.isDown("q") and yB1 > 50 then
        bastao1.b:setY(yB1 - speedB * dt)

    elseif love.keyboard.isDown("a") and yB1 < (H - 50) then
        bastao1.b:setY(yB1 + speedB * dt)
    end

    if love.keyboard.isDown("p") and yB2 > 50 then
        bastao2.b:setY(yB2 - speedB * dt)

    elseif love.keyboard.isDown("l") and yB2 < (H - 50) then
        bastao2.b:setY(yB2 + speedB * dt)
    end


    bola.prevPos[10] = {bola.b:getX(), bola.b:getY()}
    for i = 1,9 do
        bola.prevPos[i] = bola.prevPos[i+1]
    end



end

function love.draw()

		--desenha o fundo
    love.graphics.setColor(232/255, 12/255, 116/255,1)
    love.graphics.draw(bg, 0, 0, 0, W/bg:getWidth(), H/bg:getHeight())

		--imprime a pontuação
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(pontuacao1, (W/2) - 80, 100)
    love.graphics.print(pontuacao2, (W/2) + 40, 100)


		--desenha a bola
    love.graphics.setColor(12/255, 232/255, 16/255, 1)
    love.graphics.ellipse("fill", bola.b:getX(), bola.b:getY(), bola.s:getRadius(), bola.s:getRadius())


		--faz uma trilha bonita para a bola
    for i, pos in ipairs(bola.prevPos) do
        love.graphics.setColor(112/255, 232/255, 16/255, 1/(10- i))
        love.graphics.ellipse("fill", pos[1], pos[2], bola.s:getRadius(), bola.s:getRadius())
    end

		--desenha os bastões
    love.graphics.polygon("fill", bastao1.b:getWorldPoints(bastao1.s:getPoints()))
    love.graphics.polygon("fill", bastao2.b:getWorldPoints(bastao2.s:getPoints()))


end

function endContact(a, b, coll)

		aNome = a:getUserData()
		bNome = b:getUserData()

		impulso = 100

		if aNome == "Bastao1" and bNome == "Bola"then
				if love.keyboard.isDown("q") then
					bola.b:applyLinearImpulse(0,-impulso)

				elseif love.keyboard.isDown("a") then
						bola.b:applyLinearImpulse(0,impulso)
				end
		end

		if aNome == "Bastao2" and bNome == "Bola" then
				if love.keyboard.isDown("p") then
					bola.b:applyLinearImpulse(0,-impulso)

				elseif love.keyboard.isDown("l") then
						bola.b:applyLinearImpulse(0,impulso)
				end
		end


end
