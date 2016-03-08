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

--local mapDef = CreateMap()
--mapDef.on_wake = {}
--mapDef.actions = {}
--mapDef.trigger_types = {}
--mapDef.triggers = {}

-- 11, 3, 1 == x, y, layer

local stack = StateStack:Create()

-- ******** For the menu/explore state ********
--local explore = ExploreState:Create(stack, mapDef, Vector.Create(11, 3, 1))
--local menu = InGameMenuState:Create(stack)

-- ******** For the menu stuff ********
--gWorld = World:Create()
--gIcons = Icons:Create(Texture.Find("inventory_icons.png"))
--stack:Push(explore)
--stack:Push(menu)
local intro = 
{
	Scene
	{
		map = "player_house",
		focusX = 14,
		focusY = 20,
		hideHero = true,
	},
	BlackScreen(),
	Play("rain"),
	NoBlock(
		FadeSound("rain", 0, 1, 3)
	),	-- 0 -> 1 in 3 sec
	Caption("place", "title", "Village of Sontos"),
	Caption("time", "subtitle", "MIDNIGHT"),
	Wait(2),
	--NoBlock(FadeOutCaption("place", 3)),
	FadeOutCaption("place", 3),
	FadeOutCaption("time", 3),
	FadeSound("rain", 1, 0, 1),		-- 1 -> 0 in 1 sec
	KillState("place"),
	KillState("time"),
	FadeOutScreen(),
	Wait(2),
	Stop("rain"),
}
local storyboard = Storyboard:Create(stack, intro)
stack:Push(storyboard)


function update()
    local dt = GetDeltaTime()
    stack:Update(dt)
    stack:Render(gRenderer)
    --gWorld:Update(dt)
end