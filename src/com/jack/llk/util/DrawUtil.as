package com.jack.llk.util
{
	import com.jack.llk.control.asset.Assets;
	
	import starling.display.Image;

	public class DrawUtil
	{
		public function DrawUtil()
		{
		}

		public static function drawTransparentImage(width:Number, height:Number):Image
		{
			var img:Image = Assets.getImage("transparent_image0000");
			img.width = width;
			img.height = height;
			
			return img;
		}
	}
}
