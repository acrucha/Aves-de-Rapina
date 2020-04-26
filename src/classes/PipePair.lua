PipePair = Class{}


local pipeGap = 150

function PipePair:init(y, score)
    self.x = VIRTUAL_WIDTH + 32

    self.y = y

    if score % 4 == 0 and  pipeGap >= 95 then
        pipeGap =  pipeGap - 5
        PIPE_SPEED = PIPE_SPEED + 1
    end

    self.pipes = {
        ['upper'] = Pipe('top', self.y), --'top' significa que vai inicializar em cima ( de cabeça para baixo )
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + pipeGap)
    }
    -- criando 2 listas, 1 para os canos do chão e 1 para os canos do teto
    
    self.remove = false -- flag que diz se eu posso apagar os elementos ou não 
    self.score = false -- ver se o pipe foi ultrapassado completamente
end

function PipePair:update(dt)
    if self.x > -PIPE_WIDTH then -- se o cano ainda estiver em tela, atualize
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x -- estou atualizando a posição do par de canos
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end