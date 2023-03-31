Brick = Class{}

    paletteColors = {
        -- blue
        [1] = { 
            ['r'] = 75,
            ['g'] = 128,
            ['b'] = 202
        },
        -- green        
        [2] = { 
            ['r'] = 86,
            ['g'] = 123,
            ['b'] = 121
        },
        --red
        [3] = { 
            ['r'] = 180,
            ['g'] = 82,
            ['b'] = 82
        },
        --gold
        [4] = { 
            ['r'] = 255,
            ['g'] = 182,
            ['b'] = 30
        },
        --pink
        [5] = { 
            ['r'] = 174,
            ['g'] = 59,
            ['b'] = 66
        }


    }


    function Brick:init(x,y)
        self.tier = math.random(4) -- para colorir e calcular o score
        self.color = 1
        self.x = x
        self.y = y
        self.width = 30
        self.height = 13

        self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
        -- a funcao newParticle recebe a texture e a quantidade de particulas que ira ser gerado

        self.psystem:setParticleLifetime(0.5, 1)
        -- define o tempo de vida da particula varia entre 0.5 e 1 sec

        self.psystem:setLinearAcceleration(-15, 0, 15 ,80)
        -- aceleracao minima ao longo do eixo x
        -- aceleracao minima ao longo do eixo y
        -- aceleracao maxima ao longo do eixo x
        -- aceleracao maxima ao longo do eixo y

        self.psystem:setEmissionArea('normal', 10, 10)
        -- define a area de geracao da particula eixo x e y

        self.inPlay = true -- para controlar quando o bloco deve ser renderizado
    end

    function Brick:hit()
        -- sistema que usa duas cores baseado no tier do bloco
        self.psystem:setColors(

        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        55 * (self.tier + 1) / 255,
        paletteColors[self.color].r / 255,
        paletteColors[self.color].g / 255,
        paletteColors[self.color].b / 255,
        0
    )
        self.psystem:emit(64)

        gSounds['hit3']:play()
        gSounds['hit3']:play()


        if self.tier > 0 then
            if self.color == 1 then 
            self.color = self.color -1
            self.color = 5
            else 
            self.tier = self.tier -1 
            end
        else 
            if self.color == 1 then 
                self.inPlay = false
            else 
                self.color = self.color -1 
            end
        end

        if self.inPlay == false then 
            gSounds['hit1']:play()
            gSounds['hit1']:play()
        end


    end

    function Brick:update(dt)
        self.psystem:update(dt)
    end


    function Brick:render()
        if self.inPlay then
            love.graphics.draw(gTextures['spritesheet'], gFrames['bricks'][1 + ((self.color-1) * 4) +  self.tier],
            self.x, self.y)
            -- multiplica por quatro pois na spritesheet cada cor esta 4 quads adiante
            -- entao e uma cor, e 3 variacoes dessa cor (tier), depois outra cor e assim por diante
        end
    end 

    function Brick:renderParicles()
        love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
    end
