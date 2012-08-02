package com.jack.llk.control.asset
{
	import flash.utils.Dictionary;
	
	import starling.extensions.ATextureAtlas;
	import starling.textures.Texture;

	/**
	 * @example
	 * AssetManager.getInstance().reregisterAssetFactory("ipad",ipadAssetFactory);
	 * AssetManager.getInstance().reregisterAssetFactory("iphone",iphoneAssetFactory);
	 * AssetManager.getInstance().setDefaultAssetFactory("ipad");
	 * AssetManager.getInstance().init();
	 * @example
	 */
	public class AssetManager
	{
		private static var instance:AssetManager;
		private var curAssetFactory:IAssetFactory;
		private var assetFactoryDic:Dictionary = new Dictionary();
		
		public function AssetManager()
		{
		}
		
		public static function getInstance():AssetManager
		{
			if(instance == null)
			{
				instance = new AssetManager();
			}
			
			return instance;
		}
		
		public function registerAssetFactory(name:String, factory:IAssetFactory):void
		{
			assetFactoryDic[name] = factory;
		}
		
		public function setDefaultAssetFactory(name:String):void
		{
			if(assetFactoryDic[name])
				curAssetFactory = assetFactoryDic[name] as IAssetFactory;
		}
		
		public function init():void
		{
			if(curAssetFactory)
				curAssetFactory.init();
		}
		
		public function getTextureAtlas(name:String):ATextureAtlas
		{
			if(curAssetFactory)
				return curAssetFactory.getTextureAtlas(name);
			
			return null;
		}
		
		public function getTexture(name):Texture
		{
			if(curAssetFactory)
				return curAssetFactory.getTexture(name);
			
			return null;
		}
		
		public function getTextures(name):Texture
		{
			if(curAssetFactory)
				return curAssetFactory.getTextures(name);
			
			return null;
		}
	}
}