
PlayState = Class{__includes = BaseState}

-- recebe os parametros das variaveis do jogo saindo do modo serving
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.ball = params.ball
    self.level = params.level

    self.ball.dx = math.random( -100 , 100 )
    self.ball.dy = math.random( 60, 100)

    
end

function PlayState:update(dt)
    
    if self.paused then 
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then 

        self.ball.y = self.paddle.y - 8
        -- reseta a posicao da bola evitando o bug da bola ficar grudada na remo
        self.ball.dy = -self.ball.dy

        if self.ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then 
            -- caso a bola toque na metade esquerda do remo e o remo esteja se deslocando para esquerda
            -- quanto mais ao centro a bola bater maior sera seu angulo
            self.ball.dx = -50 + - (8 * (self.paddle.x + self.paddle.width/2 - self.ball.x ))
        elseif self.ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            -- caso a bole toque na metade direita do remo e remo esteja se deslocando para direita
            self.ball.dx = 50 + (8 * math.abs( self.paddle.x + self.paddle.width/2 - self.ball.x ))
            -- math.abs retorna sempre um valor positivo 
        end 

        gSounds['paddle_hit']:play() 
    end


    for k, brick in pairs(self.bricks) do
    -- while para detectar colisao com os blocos

        if brick.inPlay == true and self.ball:collides(brick) then -- existe colisao apenas com blocos ativos
            brick:hit()

        self.score = (brick.tier*200 + brick.color*25) + self.score
        
            if self:checkVictory() == true then
                gSounds['victory']:play()

                gStateMachine:change('victory',{
                    level = self.level,
                    paddle = self.paddle,
                    health = self.health,
                    score = self.score,
                    ball = self.ball
                })
            end

            
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                -- verificando colisao com a borda esquerda, reseta a posicao e inverte a direcao y
                -- isso para nao colidir com mais de um bloco ao mesmo tempo
                self.ball.dx = -self.ball.dx 
                self.ball.x = brick.x - 8
                
            
            elseif self.ball.x + 6 > brick.x + brick.width and self.ball.dx < 0 then
                -- verificando colisao com a borda direita, reseta a posicao e inverte a direcao y
                -- isso para nao colidir com mais de um bloco ao mesmo tempo
                self.ball.dx = -self.ball.dx 
                self.ball.x = brick.x + 32 
            
            elseif self.ball.y < brick.y then   
                -- caso a bola toque no bloco pela parte de cima mude a direcao
                -- resete a posicao da bola
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            
            else 
                -- muda a direcao em relacao ao eixo y
                -- reseta a posicao
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end
            -- aumenta a velocidade em 2% para dificultar o game
            self.ball.dy = self.ball.dy * 1.02

            break -- bloqueia para colidir apenas com um bloco por vez 
        end
    end

        if self.ball.y >= VIRTUAL_HEIGHT then
            self.health = self.health - 1
            gSounds['hurt']:play()

            if self.health == 0 then
                gStateMachine:change('game_over',{
                    score = self.score
                })
            else 
                gStateMachine:change('serve',{
                    paddle = self.paddle,
                    level = self.level,
                    bricks = self.bricks,
                    health = self.health,
                    score = self.score
                })
            end
        end

        for k, brick in pairs(self.bricks) do
            brick:update(dt)
        end


    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

   
end

function PlayState:render()
   
    love.graphics.draw(gTextures['background'],0,0, -- coordenadas x e y
        0, -- sem rotacao
         VIRTUAL_WIDTH / (backgroundWidth - 1), -- escala em x, dividindo o tamanho virtual pelo tamanho de fato do background obtemos a escala
         VIRTUAL_HEIGHT / (backgroundHeight - 1) ) 

     for k, brick in pairs(self.bricks) do
        brick:render() 
     end

     for k, brick in pairs(self.bricks) do
        brick:renderParicles()
     end

    self.paddle:render()
    self.ball:render()
     renderScore(self.score)
     renderHealth(self.health)

    if self.paused == true then 
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSE",0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end  

-- verifica vitoria, caso ainda exista algum bloco, retorne falso
-- caso percorreu todo o for e nao tinha nenhum bloco ativo retorne verdadeiro, victoria
function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end
    end

    return true
end
