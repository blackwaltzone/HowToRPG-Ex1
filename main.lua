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
LoadLibrary("Asset")
LoadLibrary("Mouse")
LoadLibrary("Vector")
LoadLibrary("Keyboard")

Asset.Run("Util.lua")
Asset.Run("Map.lua")
Asset.Run("Entity.lua")
Asset.Run("small_room.lua")


local gMap = Map:Create(CreateMap())
gRenderer = Renderer:Create()


local heroDef =
{
	texture  	= "walk_cycle.png",
	width       = 16,
	height      = 24,
	startFrame  = 9,
	tileX       = 10,
	tileY       = 2
}

gHero = Entity:Create(heroDef)


gMap:GoToTile(5, 5)


function Teleport(entity, map)
	local x, y = map:GetTileFoot(entity.mTileX, entity.mTileY)
	entity.mSprite:SetPosition(x, y + heroHeight / 2)
end
Teleport(gHero, gMap)

gHeroTexture = Texture.Find("walk_cycle.png")
local heroWidth = 16	-- pixels
local heroHeight= 24
gHeroUVs = GenerateUVs(heroWidth, heroHeight, gHeroTexture)
gHeroSprite = Sprite:Create()
gHeroSprite:SetTexture(gHeroTexture)
-- 9 is the hero facing forward
gHeroSprite:SetUVs(unpack(gHeroUVs[9]))
-- 10, 2 is the tile in front of the door
gHeroX = 10
gHeroY = 2
Teleport(gHeroX, gHeroY, gMap)


function update()
	gRenderer:Translate(-gMap.mCamX, -gMap.mCamY)
	gMap:Render(gRenderer)
	gRenderer:DrawSprite(gHero.mSprite)

	if Keyboard.JustPressed(KEY_LEFT) then
		gHero.mTileX = gHero.mTileX - 1
		Teleport(gHero, gMap)
	elseif Keyboard.JustPressed(KEY_RIGHT) then
		gHero.mTileX = gHero.mTileX + 1
		Teleport(gHero, gMap)
	end

	if Keyboard.JustPressed(KEY_UP) then
		gHero.mTileY = gHero.mTileY - 1
		Teleport(gHero, gMap)
	elseif Keyboard.JustPressed(KEY_DOWN) then
		gHero.mTileY = gHero.mTileY + 1
		Teleport(gHero, gMap)
	end
end