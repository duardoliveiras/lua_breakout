


ServeState = Class{__includes = BaseState}


    function ServeState:enter(params)
        self.paddle = params.paddle
        self.bricks = params.bricks
        self.health = params.health
        self.score = params.score
        self.level = params.level
        self.ball = Ball()
        self.ball.skin = math.random(4)
    end

    
    function ServeState:update(dt)
        self.paddle:update(dt)
        self.ball.x = self.paddle.x + (self.paddle.width/2) -4
        self.ball.y = self.paddle.y - 8

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gStateMachine:change('play', {
                    paddle = self.paddle,
                    bricks = self.bricks,
                    health = self.health,
                    level = self.level,
                    ball = self.ball,
                    score = self.score
            })
        end

        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end

    end

    function ServeState:render()

        love.graphics.draw(gTextures['background'],0,0, -- coordenadas x e y
        0, -- sem rotacao
         VIRTUAL_WIDTH / (backgroundWidth - 1), -- escala em x, dividindo o tamanho virtual pelo tamanho de fato do background obtemos a escala
         VIRTUAL_HEIGHT / (backgroundHeight - 1) ) 
    

        self.paddle:render()
        self.ball:render()

        for k, brick in pairs(self.bricks) do
            brick:render()
        end
    
        renderScore(self.score)
        renderHealth(self.health)

        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('Press Enter to Serve!', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')

    end

