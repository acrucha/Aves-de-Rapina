
ScoreState = Class{__includes = BaseState}

local gold = love.graphics.newImage('src/assets/gold.png')
local silver = love.graphics.newImage('src/assets/silver.png')
local bronze = love.graphics.newImage('src/assets/bronze.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function ScoreState:medal()
    if self.score <= 15 then 
        love.graphics.draw(bronze, VIRTUAL_WIDTH / 2 - 28, 150)
    else 
        if self.score <= 40 then 
            love.graphics.draw(silver, VIRTUAL_WIDTH / 2 - 28, 150)

        else
            love.graphics.draw(gold, VIRTUAL_WIDTH / 2 - 28, 150)
        end
    end
end

function ScoreState:render()
    
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Você morreu!!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 120, VIRTUAL_WIDTH, 'center')

    self:medal()
    
    love.graphics.printf('Pressione Enter para jogar de novo', 0, 200, VIRTUAL_WIDTH, 'center')
end