
push = require 'src/classes/push'

Class = require 'src/classes/class'

require 'src/classes/Bird'

require 'src/classes/Pipe'

require 'src/classes/PipePair'

-- estados de jogo:
require 'src/classes/StateMachine'
require 'src/states/BaseState'
require 'src/states/PlayState'
require 'src/states/ScoreState'
require 'src/states/CountdownState'
require 'src/states/TitleScreenState'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('src/assets/background.png')

local backgroundScroll = 0

local ground = love.graphics.newImage('src/assets/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
--o chão tem que se mover 2 vezes mais rápido que o plano de fundo
--para dar a sensação de profundidade

local BACKGROUND_LOOPING_POINT = 353 
--  indica quando o background vai rodar de novo
--  já que em 413 pixels e o início formam um padrão 
local GROUND_LOOPING_POINT = 512
--local pipes = {} -- criando uma lista
-- fazemos isso para ter um jeito de alocarmos memória para os canos
-- e depois apagar os que não estivermos usando
-- é como um array dinâmico ( table/lista(em algoritmos) )

local scrolling = true

function love.load()

    --love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Birds of prey')

    smallFont = love.graphics.newFont('src/assets/fonts/font.ttf', 14) -- "press enter to..."
    mediumFont = love.graphics.newFont('src/assets/fonts/font.ttf', 25) 
    flappyFont = love.graphics.newFont('src/assets/fonts/font.ttf', 55) -- title
    scoreFont = love.graphics.newFont('src/assets/fonts/font.ttf', 30) -- score
    hugeFont = love.graphics.newFont('src/assets/fonts/font.ttf', 60) -- contagem
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('src/music/jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('src/music/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('src/music/hurt.wav', 'static'),
        ['score'] = love.audio.newSource('src/music/score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('src/music/marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true) -- musica vai ficar tocando infinitamente
    sounds['music']:play()

    math.randomseed(os.time())

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true, 
        fullscreen = false,
        resizable = true
    })
    --serve para mudar de estado quando for necessário ou  realizar alguma função no estado que o meu jogo ta
    gStateMachine = StateMachine { -- o "g" na frente é pra indicar que é uma variável global
        ['title'] = function() return TitleScreenState() end, -- retorna a tela title 
        ['play'] = function() return PlayState() end, -- retorna a tela play
        ['score'] = function() return ScoreState() end,
        ['contdown'] = function() return CountdownState() end
    }
    gStateMachine:change('title') -- mudo para a tela que eu quiser

    love.keyboard.keysPressed = {} --criando uma lista

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
    -- existe para fazer a checagem caso alguma tecla for apertada
    if key == 'escape' then
        love.event.quit()
    else 
        if key == 'enter' then
            pause:loop()
        end
    end

end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
    --essa função existe pra que eu possa saber se a tecla espace foi pressionada ou não lá no Bird.lua
end

function love.update(dt)

    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        gStateMachine:update(dt)
    end
    --  tiro o módulo para ele reiniciar toda vez
    if love.keyboard.wasPressed('p') then
        if scrolling then
            scrolling = false
        else    
            scrolling = true
        end
    end

    love.keyboard.keysPressed = {}
    -- reiniciando o keypressed para testar novamente se alguma tecla foi pressionada
end

function love.draw()
    push:start()
    
    love.graphics.draw(background, -backgroundScroll, 0)
    --parâmetros: (imagem, x, y)
    
    gStateMachine:render()

    if not scrolling then
        love.graphics.setFont(hugeFont)
        love.graphics.printf('PAUSE', 0, 100, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    -- o "-" significa que ele vai rodar no sentido contrário à trajetória do personagem

    push:finish()
end  

