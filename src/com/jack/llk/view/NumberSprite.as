package com.jack.llk.view
{
	import com.jack.llk.control.asset.Assets;
	
	import starling.display.Image;
	import starling.display.Sprite;

	public class NumberSprite extends Sprite
	{
		private var strNum:String;
		private var gap:Number=0;
		
		private static const BIG:String = "big";
		private static const SMALL:String = "small";
		private var numberType:String;

		public function NumberSprite(number:*, numberType:String="big")
		{
			super();

			this.numberType = numberType;
			strNum=String(number);
			initalize();

			this.touchable=false;
			this.flatten();
		}

		private function initalize():void
		{
			var str:String=strNum;
			var arr:Array=[];

			var len:int=str.length;
			for (var i:int=0; i < len; i++)
			{
				arr.push(str.charAt(i));
			}

			var img:Image;
			var w:Number=0;
			for (var j:int=0; j < len; j++)
			{
				img=getSingleNumberImage(arr[j]);
				img.x=w;
				img.y=0;
				w+=(img.width + gap);
				addChild(img);
			}
		}

		private function getSingleNumberImage(n:String):Image
		{
			var imgName:String;
			if(numberType == BIG)
				imgName = "b_num" + n;
			else if(numberType == SMALL)
				imgName = "s_num" + n
					
			return Assets.getImage(imgName);
		}

	}
}
