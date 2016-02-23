Entity = {}
Entity.__index = Entity


function Entity:Create(def)
	local this = 
	{
		mSprite = Sprite.Creat()
		mTexture = Texture.Find(def.Texture)
	}