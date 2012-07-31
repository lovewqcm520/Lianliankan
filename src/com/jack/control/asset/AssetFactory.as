package com.jack.control.asset
{
	import flash.display.Bitmap;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import starling.extensions.ATextureAtlas;
	import starling.textures.Texture;
	
	/**
	 * @example
	 *         var assetFactory : AssetFactory = new AssetFactory();
	 *         assetFactory.registerAssets("Assets");
	 *         assetFactory.addTextureAtlas("asset1",assetFactory.getMTexture("Asset1GFX"),assetFactory.getMXml("Asset1XML"),"Asset1GFX");
	 *         assetFactory.addTextureAtlas("asset2",assetFactory.getMTexture("Asset2GFX"),assetFactory.getMXml("Asset2XML"),"Asset2GFX");
	 *        //如果只想初始化话数据，不像初始化材质的话，直接把材质为null就好，用到时实时渲染材质
	 *         assetFactory.addTextureAtlas("asset2",null,assetFactory.getMXml("Asset2XML"),"Asset2GFX");
	 * @example
	 */
	public class AssetFactory implements IAssetFactory
	{        
		private var mTextureAtlasDic : Dictionary;
		private var mTextureDic : Dictionary;
		private var mTexturesDic : Dictionary;
		private var sTextures : Dictionary;
		private var mTextureXmlDic : Dictionary;
		private var mTextureNameDic : Dictionary;
		private var assetClassName : String;
		private var assetClassReference : Class;
		
		public function AssetFactory()
		{
			mTextureAtlasDic = new Dictionary();
			mTextureDic = new Dictionary();
			mTexturesDic = new Dictionary();
			sTextures = new Dictionary();
			mTextureNameDic = new Dictionary();
			mTextureXmlDic = new Dictionary();
		}
		
		/**
		 * you can override init() 
		 */
		public function init():void {
			
		}
		
		/**
		 * 
		 * @param    name
		 * @return
		 */
		public function getTextureAtls(name : String) : ATextureAtlas {
			if (mTextureAtlasDic[name]) {
				return mTextureAtlasDic[name];
			}
			return null;
		}
		
		/**
		 * 注册材质源
		 * @param    name
		 */
		public function registerAssets(classname : Class):void {
			assetClassReference = classname;
		}
		
		/**
		 * 根据名称获得相应的材质
		 * @param    name
		 * @return
		 */
		public function getMTexture(name:String) : Texture
		{
			if (mTextureXmlDic[name] == undefined)
			{
				var data:Object = new assetClassReference[name]();
				if (data is Bitmap)
					sTextures[name] = Texture.fromBitmapData((data as Bitmap).bitmapData,false);
				else if (data is ByteArray)
					sTextures[name] = Texture.fromAtfData(data as ByteArray);
			}
			return sTextures[name];
		}
		
		/**
		 * 根据名称获得xml
		 * @param    xname
		 * @return
		 */
		public function getMXml(xname : String):XML {
			if (mTextureXmlDic[xname] == undefined)
			{
				var data:Object = new assetClassReference[xname]();
				mTextureXmlDic[xname] = XML(data);
			}
			return mTextureXmlDic[xname];
		}
		
		
		/**
		 * 添加材质集数据
		 * @param    name 名称
		 * @param    texture 对应的材质
		 * @param    atlasXml xml文件
		 */
		public function addTextureAtlas(name:String, texture:Texture, atlasXml:XML,textureName:String):void
		{    
			mTextureAtlasDic[name] = new ATextureAtlas(texture, atlasXml);
			mTextureNameDic[name] = textureName;
		}
		
		/**
		 * 根据名称获得库中的材质
		 * @param    name
		 * @return
		 */
		public function getTexture(name:String):Texture
		{
			if (mTextureDic[name]) {
				
			}else {
				var taltsName : String = getTexturesAtlasName(name);
				if ((mTextureAtlasDic[taltsName] as ATextureAtlas).mAtlasTexture == null) {
					(mTextureAtlasDic[taltsName] as ATextureAtlas).mAtlasTexture = getMTexture(mTextureNameDic[taltsName]);
				}
				mTextureDic[name] = (mTextureAtlasDic[taltsName] as ATextureAtlas).getTexture(name);
			}
			return mTextureDic[name];
		}
		
		/**
		 * 根据名称获得材质序列
		 * @param    name
		 * @return
		 */
		public function getTextures(name:String):Vector.<Texture>
		{
			if (mTexturesDic[name]) {
				
			}else {
				mTexturesDic[name] = new Vector.<Texture>();
				var taltsNames : Vector.<String> = getTexturesName(name);
				trace("taltsNames : " + taltsNames);
				if (taltsNames) {
					for (var i : int = 0; i < taltsNames.length; i ++ ) {
						trace("i : " + taltsNames[i]);
						if ((mTextureAtlasDic[taltsNames[i]] as ATextureAtlas).mAtlasTexture == null) {
							(mTextureAtlasDic[taltsNames[i]] as ATextureAtlas).mAtlasTexture = getMTexture(mTextureNameDic[taltsNames[i]]);
						}
						mTexturesDic[name] = mTexturesDic[name].concat((mTextureAtlasDic[taltsNames[i]] as ATextureAtlas).getTextures(name));
					}
				}
			}
			return mTexturesDic[name];
		}
		
		/**
		 * 根据材质名称获得所属材质集的名称
		 * @param    name
		 * @return
		 */
		private function getTexturesAtlasName(name : String):String {
			var dic : Dictionary;
			for (var k : String in mTextureAtlasDic) {
				dic = (mTextureAtlasDic[k] as ATextureAtlas).mTextureNames;    
				if (dic[name]) {
					return k;
					break;
				}
			}
			return "undefined";
		}
		
		/**
		 * 根据材质序列名称获得所属材质集的名称
		 * @param    name
		 * @return
		 */
		private function getTexturesName(name : String) : Vector.<String> {
			var tlist : Vector.<String> = new Vector.<String>();
			var dic : Dictionary;
			var len : int = 0;
			var oldTime : uint = getTimer();
			len = name.length;
			for (var k : String in mTextureAtlasDic) {
				dic = (mTextureAtlasDic[k] as ATextureAtlas).mTextureNames;    
				for (var m : String in dic) {
					if (m.substr(0, len) == name) {
						tlist.push(k);
						break;
					}
				}
			}
			if (tlist.length > 0) {
				return tlist;
			}else{
				return null;
			}
		}
		
	}
}