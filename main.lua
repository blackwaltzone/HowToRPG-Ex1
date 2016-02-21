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

Asset.Run("Util.lua")
Asset.Run("Map.lua")
Asset.Run("larger_map.lua")


local gMap = Map:Create(CreateMap())
gRenderer = Renderer:Create()


function update()
	gMap:Render(gRenderer)
end