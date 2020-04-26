
TitleScreenState = Class{__includes = BaseState} -- incluindo tudo que pertence ao estado base
-- pegar uma classe e copiar tudo que tem nela e colocar nessa

local logo = love.graphics.newImage('src/assets/logo.png')

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('contdown')
    end
end

function TitleScreenState:render()
    
    love.graphics.push()
    love.graphics.scale(0.3, 0.3) -- reduz tudo em 50% tanto em X como em Y
    love.graphics.draw(logo, 230, 120)
    love.graphics.pop()

    --love.graphics.setFont(smallFont)
    --love.graphics.printf('Pressione Enter', 130, 130, VIRTUAL_WIDTH, 'left')
end