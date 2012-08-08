package com.jack.llk.view.component
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BaseSprite;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class RewardStarList extends BaseSprite
	{
		private var stars:int;
		
		public function RewardStarList(stars:int)
		{
			super();
			
			this.stars = stars;
			if(this.stars > 3)
				Log.error("Star can not more than 3!");
			
			initialize();
		}
		
		private function initialize():void
		{
			var bg:Image = Assets.getImage("starbg");
			addChild(bg);
			
			var starTexture:Texture = Assets.getTexture("starbig");
			var star:Image;
			
			var starY:Number = 10;
			for (var i:int = 0; i < stars; i++) 
			{
				star = new Image(starTexture);
				star.y = starY;
				if(i == 0)
					star.x = 10;
				else if(i == 1)
					star.x = 88;
				else if(i == 2)
					star.x = 165;
				addChild(star);
			}			
		}
	}
}