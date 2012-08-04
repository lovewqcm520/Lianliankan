package com.jack.llk.view
{
	import com.jack.llk.control.asset.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class BatterTip extends Sprite
	{
		private var curBatter:int;
		private var maxBatter:int;
		
		public function BatterTip(curBatter:int, maxBatter:int)
		{
			super();
			
			this.curBatter = curBatter;
			this.maxBatter = maxBatter;
			initialize();
			
			// testonly
			// make the tip bigger, because original image was too small
			this.scaleX = this.scaleY = 2;
		}
		
		private function initialize():void
		{
			// set text title
			var batterTitle:Image = Assets.getImage("batter");
			
			// set batter number
			var curBatterSp:NumberSprite = new NumberSprite(curBatter, "small");
			var maxBatterSp:NumberSprite = new NumberSprite(maxBatter, "small");
			var slash:Image = Assets.getImage("s_slash");
			
			addChild(batterTitle);
			var sy:Number = 2;
			
			curBatterSp.x = batterTitle.x + batterTitle.width;
			curBatterSp.y = sy;
			addChild(curBatterSp);
			
			slash.x = curBatterSp.x + curBatterSp.width;
			slash.y = sy;
			addChild(slash);
			
			maxBatterSp.x = slash.x + slash.width;
			maxBatterSp.y = sy;
			addChild(maxBatterSp);
		}
	}
}