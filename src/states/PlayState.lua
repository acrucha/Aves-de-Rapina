-- tudo que acontece durante o jogo
PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

local pipeSpawn = 4


function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 30 --serve para, de acordo com o cano de baixo, ele criar um novo em cima de tamanho variável 
end

function PlayState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('title')
    end

    self.timer = self.timer + dt

    if self.score == 15 and pipeSpawn > 3 then
        pipeSpawn = pipeSpawn - 1
    end

    if self.score == 30 and pipeSpawn > 2 then
        pipeSpawn = pipeSpawn - 1
    end

    if self.timer > pipeSpawn then -- a cada 'pipeSpawn' segundos vai aparecer um cano novo

        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-35, 35), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y
        -- math.min(...) => pega o menor entre um random de -20 a 20 + lastY e o tamanho da tela - 90 - tamanho do cano 
        -- o "-90" é dado para que seja possível ultrapassar o par de canos ( não correr risco de um cano bater no outro )

        table.insert(self.pipePairs, PipePair(y, self.score)) -- ele vai inserir um novo cano no local y
        --table.insert(pipes, Pipe()) -- basicamente a list_insert de algoritmos
        --estou inserindo um objeto do tipo Pipe() na tabela pipes que eu criei
        self.timer = 0 --resetando o timer
    end

    for k, pair in pairs(self.pipePairs) do
        
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then -- se o bird ultrapassar o pipe
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do 
        for l, pipe in pairs(pair.pipes) do -- para cada lista de canos que eu tenho, eu checo se houve colisão 
            if self.bird:collides(pipe) then -- retorna true ou false
                -- se tiver colisão, volte para a tela inicial
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        
        gStateMachine:change('score', {
            score = self.score
        })
    end

    --a função pairs retorna a tabela e a função next aplicada à esta tabela
    --resumindo, a pairs anda o cursor em uma lista/tabela
    --a função next => Permite a um programa pecorrer todos os campos de uma tabela. 
    --Seu primeiro argumento é uma tabela e seu segundo argumento é um índice nesta tabela. 
    --A função next retorna o próximo índice da tabela e seu valor associado.
    --[[
    for k, pipe in pairs(pipes) do
        pipe:update(dt)
        -- k é o indice (onde o cursor está)
        -- quando o cano desaparecer da tela POR INTEIRO (  por isso não é zero, e sim a largura do cano )
        if pipe.x < -pipe.width then 
            table.remove(pipes, k) -- list_delete de algoritmos
            -- deletando os canos que não vamos mais utilizar ( liberando memória )
        end
    end
    ]]    

end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    -- mostrar qual foi o seu score no final
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 10, 220, VIRTUAL_WIDTH, 'left')
    love.graphics.setFont(smallFont)
    love.graphics.printf('Pressione P para pausar e Enter para voltar ao menu inicial', 10, 250, VIRTUAL_WIDTH, 'left')


    self.bird:render()
end