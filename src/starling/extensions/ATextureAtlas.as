package starling.extensions
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	public class ATextureAtlas
	{
		public var mTextureNames:Dictionary=new Dictionary();
		public var mAtlasTexture:Texture;
		public var mTextureRegions:Dictionary;
		private var mTextureFrames:Dictionary;

		public function ATextureAtlas(texture:Texture, atlasXml:XML=null)
		{
			mTextureRegions=new Dictionary();
			mTextureFrames=new Dictionary();
			mAtlasTexture=texture;

			if (atlasXml)
				parseAtlasXml(atlasXml);
		}

		public function dispose():void
		{
			mAtlasTexture.dispose();
		}

		private function parseAtlasXml(atlasXml:XML):void
		{
			var scale:Number;
			if (mAtlasTexture)
				scale=mAtlasTexture.scale;
			else
				scale=1;

			for each (var i:XML in atlasXml.SubTexture)
			{
				var name:String=i.attribute("name");
				var x:Number=parseFloat(i.attribute("x")) / scale;
				var y:Number=parseFloat(i.attribute("y")) / scale;
				var width:Number=parseFloat(i.attribute("width")) / scale;
				var height:Number=parseFloat(i.attribute("height")) / scale;
				var frameX:Number=parseFloat(i.attribute("frameX")) / scale;
				var frameY:Number=parseFloat(i.attribute("frameY")) / scale;
				var frameWidth:Number=parseFloat(i.attribute("frameWidth")) / scale;
				var frameHeight:Number=parseFloat(i.attribute("frameHeight")) / scale;

				var region:Rectangle=new Rectangle(x, y, width, height);
				var frame:Rectangle=frameWidth > 0 && frameHeight > 0 ? new Rectangle(frameX, frameY, frameWidth, frameHeight) : null;

				addRegion(name, region, frame);
			}
		}

		public function getTexture(name:String):Texture
		{
			var region:Rectangle=mTextureRegions[name];

			if (region == null)
				return null
			else
				return Texture.fromTexture(mAtlasTexture, region, mTextureFrames[name]);
		}

		public function getTextures(prefix:String=""):Vector.<Texture>
		{
			var textures:Vector.<Texture>=new Vector.<Texture>();
			var names:Vector.<String>=new Vector.<String>();

			var name:String;

			for (name in mTextureRegions)
			{
				if (name.indexOf(prefix) == 0)
					names.push(name);
			}

			names.sort(Array.CASEINSENSITIVE);

			for each (name in names)
			{
				textures.push(getTexture(name));
			}

			return textures;
		}

		public function addRegion(name:String, region:Rectangle, frame:Rectangle=null):void
		{
			mTextureNames[name]=name;
			mTextureRegions[name]=region;
			if (frame)
				mTextureFrames[name]=frame;
		}

		public function removeRegion(name:String):void
		{
			delete mTextureRegions[name]
		}

	}
}
