Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('src/assets/bird2.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.dy = 0
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

end

function Bird:collides(pipe)
    -- AABB collision 
    --[[
        caso o bird ( posição x + largura ) estiver entre a posição x do pipe e a largura E 
        caso o bird ( posição y + altura ) estiver entre a posição y e a altura, houve colisão.
        o "+ 2" e "- 4" são para a colisão ficar mais visível (pixel perfect colliding) => uma margem => bounding box
        bounding boxes => são caixas delimitadoras que estão ao redor de objetos que estão sendo verificados em uma colisão
    ]] 
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

