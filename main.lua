require 'src/Dependencies'
-- arquivo dependencies possui todas constantes, variaveis e objetos do jogo


function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    -- esse funcao define o filtro 'nearest-neighboor' que serve para deixar o jogo 2D sem desfoque
    -- de maneira que fique mais nitido

    math.randomseed(os.time())
    -- toda vez que chamado sera dado um valor aleatorio baseado na hora do sistema

    love.window.setTitle('Space Block')
    -- define o titulo da janela do jogo

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),   
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    -- vetor que possui 3 posicoes que armazena os tipos de fontes que serao usadas

    love.graphics.setFont(gFonts['small']) -- defino a fonte pequena como principal

    gTextures = {
        ['spritesheet'] = love.graphics.newImage('graphics/spritesheet.png'),
        ['background'] = love.graphics.newImage('graphics/background.jpeg'),
        ['background_start'] = love.graphics.newImage('graphics/background_start.jpeg'),
        ['heart'] = love.graphics.newImage('/graphics/heart.png'),
        ['particle'] = love.graphics.newImage('/graphics/particle.png')
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['spritesheet']),
        ['balls'] = GenerateQuadsBalls(gTextures['spritesheet']),
        ['bricks'] = GenerateQuadsBrick(gTextures['spritesheet']),
        ['heart'] = GenerateQuadsHeart(gTextures['heart'], 10, 9)
    }
    -- vetor que possui 2 posicoes que armazena as imagens do projeto

    gSounds = {
        ['confirm'] = love.audio.newSource('sounds/confirm.wav','static'),
        ['high_score'] = love.audio.newSource('sounds/high_score.wav','static'), 
        ['hit1'] = love.audio.newSource('sounds/hit1.wav','static'),
        ['hit2'] = love.audio.newSource('sounds/hit2.wav','static'),
        ['hit3'] = love.audio.newSource('sounds/hit3.wav','static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav','static'),
        ['music'] = love.audio.newSource('sounds/music.wav','static'),
        ['no_select'] = love.audio.newSource('sounds/no_select.wav','static'),
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav','static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav','static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav','static'),
        ['score'] = love.audio.newSource('sounds/score.wav','static'),
        ['select'] = love.audio.newSource('sounds/select.wav','static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav','static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav','static')
    } 
    -- vetor que possui 14 posicoes que armazena os sons do jogo

    gSounds['music']:play()
    

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, { vsync = true, fullscreen = false, resizable = true})
    -- inicializa a resolucao virtual, que sera renderizada no jogo, idependente do tamanho da janela

    gStateMachine = StateMachine {  -- objeto do tipo StateMachine
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['game_over'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['high_score'] = function() return HighScoreState() end
    }
    gStateMachine:change('start',
    {highScore = loadHighScore()}
    ) -- funcao para mudar o estado para o Start


    -- aqui armazenamos os estado do jogo que sera usado para as transicoes
    -- o jogo possui 6 estados, que sao:
    -- 1 'start' inicio do jogo, pede para pressionar tecla enter
    -- 2 'paddle-select' onde o jogador seleciona a raquete que ele ira usar
    -- 3 'servir' espera o pressinamento de uma tecla para inicar a movimentacao
    -- 4 'play' a bola entra movimento quicando entre as raquetes
    -- 5 'vitoria' o jogador destruiu todos os blocos do nivel atual
    -- 6 'game-over' o jogador perdeu, exibe a pontuacao e permite reiniciar

    love.keyboard.keysPressed = {}
    -- e uma tabela para acompanharmos as teclas que foram pressionadas em um frame

end

function love.resize(w,h)
    push:resize(w,h)
end 
-- funcao que chamada quando alterada a dimensao da janela manualmente, essa funcao ajusta as sprite
-- de acordo com o tamanho novo dado por w e h

function love.update(dt)
    gStateMachine:update(dt)    
    love.keyboard.keysPressed = {} -- reset das teclas pressionadas
end

-- essa funcao update e chamada a cada quadro, com o parametro 'dt' deltaTime, medido em segundos, e multiplicado isso por quaisquer
-- mudancas que desejamos fazer no jogo, sendo assim essa funcao fara que seja possivel ser executado de forma consistente em todo hardware

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end
-- essa funcao verifica se alguma tecla foi pressionada e salva na tabela, entretanto a tabela e resetada a cada update
-- sendo assim, sera usada apenas para comandos que sao pressionados uma vez como por exemplo o 'escape' para sair do jogo

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] == true then 
        return true
    else 
        return false
    end
end

-- funcao que serve para testarmos pressionamentos de teclas individuais

function love.draw()
    push:apply('start') 
    -- comeca a desenhar utilizando o push, com a resolucao virtual

    backgroundWidth = gTextures['background_start']:getWidth()
    backgroundHeight = gTextures['background_start']:getHeight()

    love.graphics.draw(gTextures['background_start'],0,0, -- coordenadas x e y
    0, -- sem rotacao
     VIRTUAL_WIDTH / (backgroundWidth - 1), -- escala em x, dividindo o tamanho virtual pelo tamanho de fato do background obtemos a escala
     VIRTUAL_HEIGHT / (backgroundHeight - 1) ) -- escala em y

     gStateMachine:render()
     displayFPS()

     push:apply('end')
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH-100

    for i=1, health do -- vida cheia
        love.graphics.draw(gTextures['heart'], gFrames['heart'][1], healthX, 4)
        healthX = healthX+11
    end

    for i=1, 3 -health do -- vida vazia
        love.graphics.draw(gTextures['heart'], gFrames['heart'][2], healthX, 4)
        healthX = healthX+11
    end
end

function renderScore(score)
    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: ', VIRTUAL_WIDTH - 60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5, 40, 'right')
    
end


function displayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1,1,1,1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS(), 5, 5))
end


-- funcao para carregar o arquivo .lst que fica no diretorio
-- home/.local/share/love 

function loadHighScore()
    love.filesystem.setIdentity('breakout')

    -- if the file doesn't exist, initialize it with some default scores
    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end

        love.filesystem.write('breakout.lst', scores)
    end

    -- flag for whether we're reading a name or not
    local name = true
    local currentName = nil
    local counter = 1

    -- initialize scores table with at least 10 blank entries
    local scores = {}

    for i = 1, 10 do
        -- blank table; each will hold a name and a score
        scores[i] = {
            name = nil,
            score = nil
        }
    end

    -- iterate over each line in the file, filling in names and scores
    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end

        -- flip the name flag
        name = not name
    end

    return scores
end

