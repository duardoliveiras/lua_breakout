

Paddle = Class{}


function Paddle:init()
    self.x = VIRTUAL_WIDTH/2 - 30 -- centro da tela
    self.y = VIRTUAL_HEIGHT - 26 -- inferior

    self.dx = 0

    self.width = 61
    self.height = 13

    self.skin = 1
    self.size = 2


end


function Paddle:update(dt)
    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
    else
        self.dx = 0 
    end 

    if self.dx < 0 then
        self.x = math.max(0, self.x + self.dx * dt) 
    else
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    end
end

function Paddle:render()
    love.graphics.draw(gTextures['spritesheet'], gFrames['paddles'][self.size + 4 * (self.skin -1)], self.x, self.y)

end