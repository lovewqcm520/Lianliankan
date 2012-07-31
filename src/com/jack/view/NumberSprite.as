package com.jack.view
{
	import com.jack.control.asset.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	public class NumberSprite extends Sprite
	{
		private var num:int;
		private var gap:Number = 0;
		
		public function NumberSprite(n:int)
		{
			super();
			
			num = n;
			initalize();
			
			this.touchable = false;
			this.flatten();
		}
		
		private function initalize():void
		{
			var str:String = num.toString();
			var arr:Array = [];
			
			var len:int = str.length;
			for (var i:int = 0; i < len; i++) 
			{
				arr.push(str.charAt(i));
			}	
			
			var img:Image;
			var w:Number = 0;
			for (var j:int = 0; j < len; j++) 
			{
				img = getSingleNumberImage(arr[j]);
				img.x = w;
				img.y = 0;
				w += (img.width + gap);
				addChild(img);
			}			
		}		
		
		private function getSingleNumberImage(n:String):Image
		{
			var imgName:String = "num" + n;
			return Assets.getImage(imgName);
		}
		
	}
}