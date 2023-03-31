

 function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

        for y = 0, sheetHeight -1 do
            for x = 0, sheetWidth -1 do 
                spritesheet[sheetCounter] = 
                love.graphics.newQuad(x*30, y*13 + 74, tilewidth, tileheight, atlas:getDimensions())
                sheetCounter = sheetCounter+1
            end
        end

        return spritesheet


end

function GenerateQuadsHeart(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

        for y = 0, sheetHeight -1 do
            for x = 0, sheetWidth -1 do 
                spritesheet[sheetCounter] = 
                love.graphics.newQuad(x*tilewidth, y*tileheight, tilewidth, tileheight, atlas:getDimensions())
                sheetCounter = sheetCounter+1
            end
        end

        return spritesheet


end




    function table.slice(table, first, last, step)
        local sliced = {}
        
        for i = first or 1, last or #table, step or 1 do 
            sliced[#sliced+1] = table[i]
        end

        return sliced
    end


    function GenerateQuadsPaddles(atlas)
        local x = 0
        local y = 0

        local counter = 1
        local quads = {}

        for i = 0, 2 do 
            --menor
            quads[counter] = love.graphics.newQuad(x,y,30,13,atlas:getDimensions())
            counter = counter+1
            --medium
            quads[counter] = love.graphics.newQuad(x+30,y,61,13,atlas:getDimensions())
            counter = counter+1
            --large
            quads[counter] = love.graphics.newQuad(x+91,y,89,13,atlas:getDimensions())
            counter = counter+1

            
            y = y + 13
        end
            return quads
    end

    function GenerateQuadsBalls(atlas)
        local x = 50
        local y = 40 

            local counter = 1 
            local quads = {}

            for i = 0, 3 do
                quads[counter] = love.graphics.newQuad(x,y,8,8,atlas:getDimensions())
                counter = counter+1

                x = x + 8
                
            end 
                return quads
    end

    function GenerateQuadsBrick(atlas)
        return table.slice(GenerateQuads(atlas,30,13),1,21)
    end
