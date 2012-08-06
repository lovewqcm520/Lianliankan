package com.jack.llk.util
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.view.BaseMovieClip;
	import com.jack.llk.vo.map.MapVO;
	
	import starling.textures.Texture;

	public class GameUtil
	{
		public function GameUtil()
		{
		}

		// get small item by index
		public static function getSmallItemAt(index:int, fps:Number=12):BaseMovieClip
		{
			var t:Vector.<Texture> = new Vector.<Texture>();
			
			// stone
			if(index == MapVO.STONE)
			{
				t.push(Assets.getTexture("stone"));
			}
			else
			{
				// SMALL_ITEM_11_
				var prefix:String="SMALL_ITEM_" + index.toString() + "_";
				t=Assets.getTextures(prefix);
			}
			
			if (t && t.length > 0)
				return new BaseMovieClip(t, fps);

			return null;
		}

		// get big item by index
		public static function getBigItemAt(index:int, fps:Number=12):BaseMovieClip
		{
			var prefix:String="BIG_ITEM_" + index.toString() + "_";

			var t:Vector.<Texture>=Assets.getTextures(prefix);
			if (t && t.length > 0)
				return new BaseMovieClip(t, fps);

			return null;
		}



	}
}
