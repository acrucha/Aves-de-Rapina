--[[
    StateMachine exige que cada Estado tenha um conjunto de quatro métodos de "interface" que possam 
    ser chamados com segurança => portanto, ao herdarmos desse estado base, nossas classes de Estado 
    terão todas pelo menos versões vazias desses métodos, mesmo que não as definamos em as classes reais.
]]

BaseState = Class{} -- base para todos os estados que criaremos

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end