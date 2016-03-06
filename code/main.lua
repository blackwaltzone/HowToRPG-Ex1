----------------------
-- How to make an RPG Example 1
--
-- Dustin Heyden
-- Feb 2016
--
-- main.lua
--
-- Description:
--
----------------------

LoadLibrary('Asset')
Asset.Run('Dependencies.lua')

gRenderer = Renderer.Create()

local mapDef = CreateMap()
mapDef.on_wake = {}
mapDef.actions = {}
mapDef.trigger_types = {}
mapDef.triggers = {}

-- 11, 3, 1 == x, y, layer


--local CreateBlock = function(stack)
--	return
--	{
--		Enter = function() end,
--		Exit = function() end, 
--		HandleInput = function(self)
--			stack:Pop()
--		end,
--		Render = function() end,
--		Update = function(self)
--			return false
--		end
--	}
--end

local stack = StateStack:Create()
local explore = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
local menu = InGameMenuState:Create(stack)

gWorld = World:Create()
gIcons = Icons:Create(Texture.Find("inventory_icons.png"))
stack:Push(explore)
stack:Push(menu)


--stack:Push(FadeState:Create(stack))
--stack:Push(CreateBlock(stack))
--stack:PushFit(gRenderer, 0, 0, "Where am I?")
--stack:Push(CreateBlock(stack))
--stack:PushFit(gRenderer, -50, 50, "My head hurts!")
--stack:Push(CreateBlock(stack))
--stack:PushFit(gRenderer, -100, 100, "Uh...")


function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
    gWorld:Update(dt)
end