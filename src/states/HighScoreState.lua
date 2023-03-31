



    HighScoreState = Class{__includes = BaseState}

    function HighScoreState:enter(params)
        self.highScore = params.highScore
    end

    function HighScoreState:update(dt)
        if love.keyboard.wasPressed('escape') then
            gSounds['wall_hit']:play()

            gStateMachine:change('start',{
                highScore = self.highScore
            })
        end
    end


    function HighScoreState:render()
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('High Scores',0,50, VIRTUAL_WIDTH ,'center')

        love.graphics.setFont(gFonts['medium'])

        -- busca os 10 maiores scores da tabela
        for i=1, 10 do
            local name = self.highScore[i].name or '---'
            local score = self.highScore[i].score or '---'

            love.graphics.printf(tostring(i) .. '-',VIRTUAL_WIDTH/4 , 80+(i*14), 50, 'left')
            love.graphics.printf(name, VIRTUAL_WIDTH/4 + 38, 80+(i*14), 50, 'left')
            love.graphics.printf(score, VIRTUAL_WIDTH/2, 80+(i*14), 100, 'right' )

        end

        love.graphics.setFont(gFonts['small'])
        love.graphics.printf('Press Escape to return to the main menu', 0, VIRTUAL_HEIGHT-10, VIRTUAL_WIDTH, 'center')



    end
