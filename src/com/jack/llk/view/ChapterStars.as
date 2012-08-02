package com.jack.llk.view
{
	import com.jack.llk.control.asset.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class ChapterStars extends Sprite
	{
		private var nStars:int;
		
		public function ChapterStars(nStars:int)
		{
			super();
			
			this.nStars = nStars;
			initalize();
			this.touchable = false;
		}
		
		private function initalize():void
		{
			if(nStars > 0)
			{
				var tStar:Texture = Assets.getTexture("smallstar");
				var star:Image;
				var pad:Number = -20;
				var w:Number = 0;
				for (var i:int = 0; i < nStars; i++) 
				{
					star = new Image(tStar);
					star.x = w;
					addChild(star);
					w += (star.width + pad);
				}
			}			
		}
	}
}