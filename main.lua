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

LoadLibrary("Renderer")
LoadLibrary("Sprite")
LoadLibrary("System")
LoadLibrary("Texture")
LoadLibrary("Vector")
LoadLibrary("Asset")
LoadLibrary("Keyboard")


Asset.Run("Animation.lua")
Asset.Run("Map.lua")
Asset.Run("Util.lua")
Asset.Run("Entity.lua")
Asset.Run("StateMachine.lua")
Asset.Run("MoveState.lua")
Asset.Run("WaitState.lua")
Asset.Run("NPCStandState.lua")
Asset.Run("PlanStrollState.lua")
Asset.Run("Tween.lua")
Asset.Run("Actions.lua")
Asset.Run("Trigger.lua")
Asset.Run("EntityDefs.lua")
Asset.Run("Character.lua")
Asset.Run("small_room.lua")


local mapDef = CreateMap()
mapDef.on_wake =
{
	{
		id = "AddNPC",
		params = {{ def = "strolling_npc", x = 11, y = 5 }},
	},
	{
		id = "AddNPC",
		params = {{ def = "standing_npc", x = 4, y = 5 }},
	},
}
local gMap = Map:Create(mapDef)

gRenderer = Renderer:Create()

gMap:GoToTile(5, 5)

gHero = Character:Create(gCharacters.hero, gMap)
--gNPC = Character:Create(gCharacters.strolling_npc, gMap)

--Actions.Teleport(gMap, 11, 5)(nil, gNPC.mEntity)

gUpDoorTeleport = Actions.Teleport(gMap, 11, 3)
gDownDoorTeleport = Actions.Teleport(gMap, 10, 11)
gHero.mEntity:SetTilePos(11, 3, 1, gMap)

gTriggerTop = Trigger:Create
{
    OnEnter = gDownDoorTeleport
}

gTriggerBot = Trigger:Create
{
    OnEnter = gUpDoorTeleport,
}

gTriggerStart = Trigger:Create
{
    OnExit = function() gMessage = "OnExit: Left the start position" end
}

gTriggerPot = Trigger:Create
{
    OnUse = function() gMessage = "OnUse: The pot is full of snakes!" end,
}

gMap.mTriggers =
{
    -- Layer 1
    {
        [gMap:CoordToIndex(10, 12)] = gTriggerBot,
        [gMap:CoordToIndex(11, 2)] = gTriggerTop,
        [gMap:CoordToIndex(11, 3)] = gTriggerStart,
        [gMap:CoordToIndex(10, 3)] = gTriggerPot,
    }
}

function GetFacedTileCoords(character)

    -- Change the facing information into a tile offset
    local xInc = 0
    local yInc = 0

    if character.mFacing == "left" then
        xInc = 1
    elseif character.mFacing == "right" then
        xInc = -1
    elseif character.mFacing == "up" then
        yInc = -1
    elseif character.mFacing == "down" then
        yInc = 1
    end

    local x = character.mEntity.mTileX + xInc
    local y = character.mEntity.mTileY + yInc

    return x, y
end


gMessage = "Hello There"

function update()

    local dt = GetDeltaTime()

    local playerPos = gHero.mEntity.mSprite:GetPosition()
    gMap.mCamX = math.floor(playerPos:X())
    gMap.mCamY = math.floor(playerPos:Y())

    gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)

    local layerCount = gMap:LayerCount()

    for i = 1, layerCount do

    	local heroEntity = nil
    	if i == gHero.mEntity.mLayer then
    		heroEntity = gHero.mEntity
    	end

    	gMap:RenderLayer(gRenderer, i, heroEntity)
    end

    gHero.mController:Update(dt)
    --gNPC.mController:Update(dt)
    for k, v in ipairs(gMap.mNPCs) do
    	v.mController:Update(dt)
    end

    if Keyboard.JustPressed(KEY_SPACE) then
        -- which way is the player facing?
        local x, y = GetFacedTileCoords(gHero)
        local trigger = gMap:GetTrigger(gHero.mEntity.mLayer, x, y)
        if trigger then
            trigger:OnUse(gHero)
        end
    end

    gRenderer:DrawRect2d(
        gMap.mCamX-System.ScreenWidth()/2,
        gMap.mCamY+System.ScreenHeight()/2,
        gMap.mCamX+ System.ScreenWidth()/2,
        gMap.mCamY+System.ScreenHeight()/2 - 60,
        Vector.Create(0, 0, 0, 1)
    )

    local y =  gMap.mCamY+System.ScreenHeight()/2 - 30
    gRenderer:AlignText("center", "center")
    gRenderer:DrawText2d(gMap.mCamX, y, gMessage, Vector.Create(1,1,1,1))

    gRenderer:AlignTextX("left")
    gRenderer:DrawText2d(-30, 150, "Try using the pot (USE = space key)", Vector.Create(1,1,1,1), 175)

end