        

        NONE = 1
        SINGLE_PYRAMID = 2
        MULTI_PYRAMID = 3

        SOLID = 1
        ALTERNATE = 2
        SKIP = 3
        NONE = 4
        
        LevelMaker = Class{}

        

        function LevelMaker.createMap(level)
            local bricks = {}
            -- numero randomico de linhas e colunas
            local numRows = math.random(1,5)  --1,5
            local numCols = math.random(10,15)  --,10,15

            numCols = numCols % 2 == 0 and (numCols+1) or numCols

            -- so sera possivel spawnar 3 tier de uma cor no maximo
            -- o tier aumentara conforme o jogador for passando de level
            local highestTier = math.min(3, math.floor(level/5)) --3 
            -- math.floor pega a parte inteira de um numero decimal

            -- pega a maior cor baseado no nivel
            -- nv.1 - daria 4 cores até tier 1
            -- nv.2 - daria 5 cores até tier 1
            -- ...
            -- nv. 10 - daria 5 cores ate o tier 2 
            local highestColor = math.min(5, level % 5 + 0) --5
            

            

            for y = 1, numRows do  
                local skipPattern = math.random(1,2) == 1 and true or false
                -- para habilitar espaço vazio na linha 

                local alternatePattern = math.random(1,2) == 1 and true or false
                -- para habilidar troca de cores na linha

                    -- escolher 2 cores para alternar entre si
                    local alternateColor1 = math.random( 1, highestColor)
                    local alternateColor2 = math.random(1 , highestColor)
                    -- escolhe dois tier para alternar entre si
                    local alternateTier1 = math.random( 0, highestTier )
                    local alternateTier2 = math.random( 0, highestTier )

                local skipFlag = math.random(2) == 1 and true or false
                

                local alternarteFlag = math.random(2) == 1 and true or false
               
                local solidColor = math.random( 1, highestColor)
                local solidTier = math.random( 0, highestTier)

                for x = 1, numCols do

                    if skipPattern and skipFlag then 
                        skipFlag = not skipFlag

                        goto continue
                    else 
                        skipFlag = not skipFlag
                    end 

                    b = Brick( (x-1)*31 + 8 + (17 - numCols)*13, y*13)

                    if alternatePattern and alternarteFlag then
                        b.color = alternateColor1
                        b.tier = alternateTier1
                        alternarteFlag = not alternarteFlag
                    else 
                        b.color = alternateColor2
                        b.tier = alternateTier2
                        alternarteFlag = not alternarteFlag
                    end

                    if not alternatePattern then
                        b.color = solidColor
                        b.tier = solidTier
                    end

                    table.insert( bricks , b)
                    ::continue::
                end
            end

            if #bricks == 0 then
                return self.createMap(level)
            else
                return bricks
            end

        end
