package com.jack.llk.view
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	import com.jack.llk.util.GameUtil;
	
	import starling.core.Starling;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class ItemMovieClip extends BaseSprite
	{
		private var itemIndex:int;
		private var mapX:int;
		private var mapY:int;
		private var _activated:Boolean;
		
		private var smallItem:BaseMovieClip;
		private var bigItem:BaseMovieClip;
		private var onActivateFunc:Function;
		private var onActivateArgs:Array;
		private var onInactivateFunc:Function;
		private var onInactivateArgs:Array;

		public function ItemMovieClip(itemIndex:int, mapX:int, mapY:int, fps:Number=12)
		{
			activated = false;
			
			this.mapX = mapX;
			this.mapY = mapY;
			this.itemIndex = itemIndex;
			
			initialize();
		}
		
		private function initialize():void
		{
			smallItem = GameUtil.getSmallItemAt(itemIndex);
			smallItem.loop = true;
			smallItem.stop();
			addChild(smallItem);
			Starling.juggler.add(smallItem);
		}
		
		public function disappear():void
		{
			// show the explosion animation before dispose the item
			var t:Vector.<Texture> = Assets.getTextures("ITEM_OVER_SKIN");
			if(t && t.length > 0)
			{
				smallItem.visible = false;
				if(bigItem)
					bigItem.visible = false;
				
				// show the explosion
				var mcExplosion:OnceMovieClip = new OnceMovieClip(t, dispose, true, 20);
				mcExplosion.x = (smallItem.width-mcExplosion.width)/2;
				mcExplosion.y = (smallItem.height-mcExplosion.height)/2;
				addChild(mcExplosion);
				mcExplosion.play();
			}
		}
		
		override public function dispose():void
		{
			onActivateFunc = null;
			onActivateArgs = null;
			onInactivateFunc = null;
			onInactivateArgs = null;
			
			if(smallItem)
			{
				Starling.juggler.remove(smallItem);
				smallItem.removeFromParent(true);
				smallItem = null;
			}
			
			if(bigItem)
			{
				Starling.juggler.remove(bigItem);
				bigItem.removeFromParent(true);
				bigItem = null;
			}
			
			super.dispose();
		}
		
		public function playSmallAnimation():void
		{
			smallItem.play();
		}
		
		public function stopSmallAnimation():void
		{
			smallItem.stop();
		}
		
		public function shine():void
		{
			smallItem.play();
			Starling.juggler.add(smallItem);
		}
		
		public function onActivate(func:Function, ...args):void
		{
			onActivateFunc = func;
			onActivateArgs = args;
		}
	
		public function onInactivate(func:Function, ...args):void
		{
			onInactivateFunc = func;
			onInactivateArgs = args;
		}
	
		override protected function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					onClickItem();
					
					if(onClickFunc != null)
						onClickFunc.apply(null, onClickArgs);
				}
			}
		}
		
		private function onClickItem():void
		{
			// play sound when click the item
			SoundManager.play(SoundFactors.DIAN_JI_MUSIC);
			
			// show the big visual item
			activated = !activated;
		}

		public function set activated(value:Boolean):void
		{
			if(_activated != value)
			{
				_activated = value;
				
				if(value)
				{
					// show the big item
					if(!bigItem)
					{
						bigItem = GameUtil.getBigItemAt(itemIndex);
						bigItem.x = (smallItem.width-bigItem.width)/2;
						bigItem.y = (smallItem.height-bigItem.height)/2;
					}
					
					if(bigItem)
					{
						smallItem.removeFromParent();
						if(!contains(bigItem))
						{
							addChild(bigItem);
							Starling.juggler.add(bigItem);
						}
					}
					// call activate function 
					if(onActivateFunc != null)
						onActivateFunc.apply(null, onActivateArgs);
				}
				else
				{
					// go back to the small item					
					if(bigItem)
					{
						bigItem.removeFromParent();
						Starling.juggler.remove(bigItem);
					}
					
					if(!contains(smallItem))
					{
						addChild(smallItem);
					}
					// call inactivate function 
					if(onInactivateFunc != null)
						onInactivateFunc.apply(null, onInactivateArgs);
				}
			}
		}

		public function get activated():Boolean
		{
			return _activated;
		}
		
		
	}
}