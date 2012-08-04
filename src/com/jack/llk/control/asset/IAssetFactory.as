package com.jack.llk.control.asset
{
	import starling.extensions.ATextureAtlas;
	import starling.textures.Texture;

	public interface IAssetFactory
	{
		function init():void;
		function addTextureAtlas(name:String, texture:Texture, atlasXml:XML, textureName:String):void;
		function getTexture(name:String):Texture;
		function getTextures(name:String):Vector.<Texture>;
		function getTextureAtlas(name:String):ATextureAtlas;

	}
}
