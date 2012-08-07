package com.jack.llk.view.component.chain
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.view.OnceMovieClip;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	public class ThunderChain extends Sprite
	{
		private var textures:Vector.<Texture>;
		private var itemExactWidth:Number;
		private var itemExactHeight:Number;
		private var itemGapX:Number;
		private var itemGapY:Number;

		private var tw:Number=66;
		private var th:Number=59;

		private var lightFrame:Sprite;

		public function ThunderChain()
		{
			super();
		}

		public function initialize(routeList:Array, itemExactWidth:Number, itemExactHeight:Number, itemGapX:Number, itemGapY:Number):void
		{
			this.itemExactWidth=itemExactWidth;
			this.itemExactHeight=itemExactHeight;
			this.itemGapX=itemGapX;
			this.itemGapY=itemGapY;

			textures=Assets.getTextures("chain_thunder_blue");

			lightFrame=new Sprite();
			linkRoad(routeList);

			// play the sound
			SoundManager.play(SoundFactors.THUNDER);
		}

		private function linkRoad(route:Array):void
		{
			var obj1:Object;
			var obj2:Object;
			var minCol:int;
			var maxCol:int;
			var col:int;
			var light:OnceMovieClip;
			var minRow:int;
			var maxRow:int;
			var row:int;
			addChild(lightFrame);
			lightFrame.alpha=1;
			var i:uint;
			while (i < (route.length - 1))
			{

				obj1=route[i];
				obj2=route[(i + 1)];
				if (obj1.y == obj2.y)
				{
					minCol=Math.min(obj1.x, obj2.x);
					maxCol=Math.max(obj1.x, obj2.x);
					col=minCol;
					while (col < maxCol)
					{
						light=new OnceMovieClip(textures, null, true, 32);
						if (col == maxCol - 1)
							light.width=itemExactWidth + 10;
						light.x=(col - 1) * (itemExactWidth + itemGapX) + itemExactWidth / 2;
						light.y=(obj1.y - 1) * (itemExactHeight + itemGapY);
						lightFrame.addChild(light);

						Starling.juggler.add(light);
						light.play();

						col=(col + 1);
					}
				}
				else if (obj1.x == obj2.x)
				{
					minRow=Math.min(obj1.y, obj2.y);
					maxRow=Math.max(obj1.y, obj2.y);
					row=minRow;
					while (row < maxRow)
					{
						light=new OnceMovieClip(textures, null, true, 32);
						light.rotation=deg2rad(90);
						light.y=(row - 1) * (itemExactHeight + itemGapY) + 15;
						light.x=(obj1.x - 1) * (itemExactWidth + itemGapX) + itemExactWidth + 9;
						lightFrame.addChild(light);

						Starling.juggler.add(light);
						light.play();

						row=(row + 1);
					}
				}
				i=(i + 1);
			}

			// animation
//			TweenLite.to(lightFrame, 0.2, {delay:0.2, alpha:0, onComplete:function ():void
//			{
//				var _loc_1:* = lightFrame.numChildren - 1;
//				while (_loc_1 >= 0)
//				{
//					
//					lightFrame.removeChildAt(_loc_1);
//					_loc_1 = _loc_1 - 1;
//				}
//				removeChild(lightFrame);
//			}
//			});
		}

		override public function dispose():void
		{
			textures=null;

			super.dispose();
		}
	}
}
