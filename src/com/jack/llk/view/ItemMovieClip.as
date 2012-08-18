package com.jack.llk.view
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.util.Delay;
	import com.jack.llk.util.GameUtil;
	import com.jack.llk.vo.map.MapVO;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class ItemMovieClip extends BaseSprite
	{
		public var itemIndex:int;
		public var mapX:int;
		public var mapY:int;
		private var _activated:Boolean;

		private var smallItem:BaseMovieClip;
		private var bigItem:BaseMovieClip;
		private var onActivateFunc:Function;
		private var onActivateArgs:Array;
		private var onInactivateFunc:Function;
		private var onInactivateArgs:Array;

		public function ItemMovieClip(itemIndex:int, mapX:int, mapY:int, fps:Number=12)
		{
			activated=false;

			this.mapX=mapX;
			this.mapY=mapY;
			this.itemIndex=itemIndex;

			initialize();
			
			// 
			if(itemIndex == MapVO.STONE_ITEM)
			{
				this.touchable = false;
				this.width = Common.ITEM_SMALL_WIDTH;
				this.height = Common.ITEM_SMALL_HEIGHT;
			}
		}

		private function initialize():void
		{
			smallItem=GameUtil.getSmallItemAt(itemIndex, 3);
			smallItem.loop=true;
			smallItem.stop();
			smallItem.width=Common.ITEM_SMALL_WIDTH;
			smallItem.height=Common.ITEM_SMALL_HEIGHT;
			addChild(smallItem);
			Starling.juggler.add(smallItem);
		}

		public function disappear():void
		{
			// show the explosion animation before dispose the item
			var t:Vector.<Texture>=Assets.getTextures("ITEM_OVER_SKIN");
			if (t && t.length > 0)
			{
				if (smallItem)
					smallItem.visible=false;
				if (bigItem)
					bigItem.visible=false;

				// show the explosion
				var mcExplosion:OnceMovieClip=new OnceMovieClip(t, dispose, true, 20);
				mcExplosion.scaleX=mcExplosion.scaleY=0.8;
				mcExplosion.x=(smallItem.width - mcExplosion.width) / 2;
				mcExplosion.y=(smallItem.height - mcExplosion.height) / 2;
				addChild(mcExplosion);
				mcExplosion.play();
			}
		}

		override public function dispose():void
		{
			onActivateFunc=null;
			onActivateArgs=null;
			onInactivateFunc=null;
			onInactivateArgs=null;

			if (smallItem)
			{
				Starling.juggler.remove(smallItem);
			}

			if (bigItem)
			{
				Starling.juggler.remove(bigItem);
			}

			super.dispose();
		}
		
		public function updateMapPosition(x:int, y:int):void
		{
			this.mapX = x;	
			this.mapY = y;	
		}

		public function playSmallAnimation():void
		{
			smallItem.play();
		}

		public function stopSmallAnimation():void
		{
			smallItem.stop();
		}

		public function showFindAnimation():void
		{
			// show the big item
			gotoBig();

			// go back to normal small status after some times
			Delay.doIt(1000, gotoSmall);
		}

		public function onActivate(func:Function, ... args):void
		{
			onActivateFunc=func;
			onActivateArgs=args;
		}

		public function onInactivate(func:Function, ... args):void
		{
			onInactivateFunc=func;
			onInactivateArgs=args;
		}

		override protected function onTouch(event:TouchEvent):void
		{
			var touch:Touch=event.getTouch(this);

			if (touch)
			{
				if (touch.phase == TouchPhase.ENDED)
				{
					onClickItem();

					if (onClickFunc != null)
						onClickFunc.apply(null, onClickArgs);
				}
			}
		}

		private function onClickItem():void
		{
			// play sound when click the item
			SoundManager.play(SoundFactors.DIAN_JI_MUSIC);

			// show the big visual item
			activated=!activated;
		}

		public function set activated(value:Boolean):void
		{
			if (_activated != value)
			{
				_activated=value;

				if (value)
				{
					gotoBig();

					// call activate function 
					if (onActivateFunc != null)
						onActivateFunc.apply(null, onActivateArgs);
				}
				else
				{
					gotoSmall();

					// call inactivate function 
					if (onInactivateFunc != null)
						onInactivateFunc.apply(null, onInactivateArgs);
				}
			}
		}

		private function gotoSmall():void
		{
			// go back to the small item					
			if (bigItem)
			{
				bigItem.removeFromParent();
				Starling.juggler.remove(bigItem);
			}

			if (smallItem && !contains(smallItem))
			{
				addChild(smallItem);
			}
		}

		private function gotoBig():void
		{
			// show the big item
			if (!bigItem)
			{
				bigItem=GameUtil.getBigItemAt(itemIndex);
				bigItem.width=Common.ITEM_BIG_WIDTH;
				bigItem.height=Common.ITEM_BIG_HEIGHT;
				bigItem.x=(smallItem.width - bigItem.width) / 2;
				bigItem.y=(smallItem.height - bigItem.height) / 2;
			}

			if (bigItem)
			{
				smallItem.removeFromParent();
				if (!contains(bigItem))
				{
					addChild(bigItem);
					Starling.juggler.add(bigItem);
				}
			}
		}

		public function get activated():Boolean
		{
			return _activated;
		}


	}
}
