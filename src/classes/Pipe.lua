
Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('src/assets/pipe1.png')

PIPE_SPEED = 60

PIPE_HEIGHT = 288
PIPE_WIDTH = 70


function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation -- pode ser 'top' ou 'bottom'

end

function Pipe:update(dt)
    --self.x = self.x + PIPE_SPEED * dt
end

function Pipe:render()

    love.graphics.draw(PIPE_IMAGE, self.x,           -- (já que se eu translado o cano pra cima, o início do sprite agora é a cabeça)
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y), -- se for 'top', o y some PIPE_HEIGHT .
    0, -- rotação                                                          se não, não mude
    1, -- escala do X (espelhar pro lado)
    self.orientation == 'top' and -1 or 1) -- escala do Y (espelhar pra cima)
    -- se for 'top' (pipe de cima), gire ( -1 ). se não, não mude ( 1 ).
end

