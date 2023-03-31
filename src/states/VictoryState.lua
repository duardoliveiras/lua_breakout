

VictoryState = Class{__includes = BaseState}


function VictoryState:enter(params)
    self.level = params.level
    self.health = params.health
    self.paddle = params.paddle
    self.ball = params.ball
    self.score = params.score
end

function VictoryState:update(dt)
    self.paddle:update(dt)

    self.ball.x = self.paddle.x + (self.paddle.width/2) - 4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve',{
            level = self.level + 1,
            health = self.health,
            bricks = LevelMaker.createMap(self.level),
            paddle = self.paddle,
            ball = self.ball,
            score = self.score
        })
    end
end


function VictoryState:render()
    self.ball:render()
    self.paddle:render()

    renderHealth(self.health)  
    renderScore(self.score)

    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level) .. ' complete!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
    
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Press Enter to serve', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')

end
