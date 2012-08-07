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
			var prefix:String;
			
			// stone
			if(index == MapVO.STONE_ITEM)
			{
				t.push(Assets.getTexture("stone"));
			}
			// tool items
			else if(MapVO.isToolItem(index))
			{
				// SMALL_ITEM_EGG
				switch(index)
				{
					case MapVO.EGG_ITEM:
					{
						prefix="SMALL_ITEM_EGG";
						break;
					}
						
					case MapVO.BOMB_ITEM:
					{
						prefix="SMALL_ITEM_BOMB";
						break;
					}
						
					case MapVO.FIND_ITEM:
					{
						prefix="SMALL_ITEM_FIND";
						break;
					}
						
					case MapVO.REFRESH_ITEM:
					{
						prefix="SMALL_ITEM_REFRESH";
						break;
					}
						
					case MapVO.TIME_ITEM:
					{
						prefix="SMALL_ITEM_TIME";
						break;
					}
				}
				t=Assets.getTextures(prefix);
			}
			else
			{
				// SMALL_ITEM_11_
				prefix="SMALL_ITEM_" + index.toString() + "_";
				t=Assets.getTextures(prefix);
			}
			
			if (t && t.length > 0)
				return new BaseMovieClip(t, fps);

			return null;
		}

		// get big item by index
		public static function getBigItemAt(index:int, fps:Number=12):BaseMovieClip
		{
			var prefix:String;
			var t:Vector.<Texture>;
			
			// tool items
			if(MapVO.isToolItem(index))
			{
				// BIG_ITEM_EGG
				switch(index)
				{
					case MapVO.EGG_ITEM:
					{
						prefix="BIG_ITEM_EGG";
						break;
					}
						
					case MapVO.BOMB_ITEM:
					{
						prefix="BIG_ITEM_BOMB";
						break;
					}
						
					case MapVO.FIND_ITEM:
					{
						prefix="BIG_ITEM_FIND";
						break;
					}
						
					case MapVO.REFRESH_ITEM:
					{
						prefix="BIG_ITEM_REFRESH";
						break;
					}
						
					case MapVO.TIME_ITEM:
					{
						prefix="BIG_ITEM_TIME";
						break;
					}
				}
			}
			else
			{
				prefix = "BIG_ITEM_" + index.toString() + "_"
			}
			
			t=Assets.getTextures(prefix);
			if (t && t.length > 0)
				return new BaseMovieClip(t, fps);

			return null;
		}



	}
}
