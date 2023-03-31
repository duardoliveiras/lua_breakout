

StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:enter(params)
    self.highScore = params.highScore
end

    function StartState:update(dt)
        if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
            highlighted = highlighted == 1 and 2 or 1
            gSounds['paddle_hit']:play()
        end

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then 
            gSounds['confirm']:play()

                if highlighted == 1 then
                    gStateMachine:change('serve',
                        { paddle = Paddle(1),
                        bricks = LevelMaker.createMap(2),
                        health = 3,
                        score = 0,
                        level = 1
                        })
                elseif highlighted == 2 then
                    gStateMachine:change('high_score',{
                        highScore = self.highScore
                    })
                end
            end

        if love.keyboard.wasPressed('escape') then
            love.event.quit()
        end
    end


    function StartState:render()


        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("Space Block",0,VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(gFonts['medium'])

        if highlighted == 1 then
                love.graphics.setColor(255, 190, 0, 255)
        end

        love.graphics.printf("START",0,VIRTUAL_HEIGHT/2 + 70, VIRTUAL_WIDTH, 'center')

        love.graphics.setColor(1,1,1,1)

        if highlighted == 2 then
            love.graphics.setColor(255, 190, 0, 255)
        end 
            love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT/2 + 90, VIRTUAL_WIDTH, 'center')
            love.graphics.setColor(1,1,1,1)
    end