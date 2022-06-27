
BirdSelectionState = Class{__includes = BaseState}

local x = 30
local y = 100
local selectCanary = love.graphics.newImage('src/assets/select.png')
local allBirds = love.graphics.newImage('src/assets/birds.png')


function BirdSelectionState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if x == 30 then
            bird = 'black'
        elseif x == 150 then
            bird = 'darkPurple'
        elseif x == 270 then 
            bird = 'pink'
        else
            bird = 'joker'
        end
        x = 30
        gStateMachine:change('contdown')
    end
    if love.keyboard.wasPressed('right') then
        if x < 370 then 
            x = x + 120 
            sounds['jump']:play()
        end
    elseif love.keyboard.wasPressed('left') then
        if x > 30 then
            x = x - 120
            sounds['jump']:play()
        end
    end
end

function BirdSelectionState:render()
    
    love.graphics.push()

    love.graphics.rectangle('line', x, y, 100, 80)

    love.graphics.draw(selectCanary, 20, 60)

    love.graphics.scale(0.65, 0.65) 
    love.graphics.draw(allBirds, 60, 170)
 
    love.graphics.pop()

end



