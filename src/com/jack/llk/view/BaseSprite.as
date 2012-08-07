package com.jack.llk.view
{
	import com.jack.llk.control.Global;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class BaseSprite extends Sprite
	{
		protected var onClickFunc:Function;
		protected var onClickArgs:Array;

		public function BaseSprite()
		{
			super();

			addEventListener(TouchEvent.TOUCH, onTouch);
		}

		public function addChildScaled(child:DisplayObject, childX:Number=-9999, childY:Number=-9999, index:int=-1):void
		{
			if (child)
			{
				child.scaleX*=Global.contentScaleXFactor;
				child.scaleY*=Global.contentScaleYFactor;

				addChild(child);

				if (childX != -9999 && childY != -9999)
				{
					child.x=(childX * Global.contentScaleXFactor);
					child.y=(childY * Global.contentScaleYFactor);
				}
				
				if(index != -1 && index < numChildren)
				{
					setChildIndex(child, index);
				}
			}
		}

		public function scaleObject(child:DisplayObject):void
		{
			if (child && child.scaleX == 1 && child.scaleY == 1)
			{
				child.scaleX*=Global.contentScaleXFactor;
				child.scaleY*=Global.contentScaleYFactor;
			}
		}

		public function onClick(func:Function, ... args):void
		{
			onClickFunc=func;
			onClickArgs=args;
		}

		protected function onTouch(event:TouchEvent):void
		{
			var touch:Touch=event.getTouch(this);

			if (touch)
			{
				if (touch.phase == TouchPhase.ENDED)
				{
					if (onClickFunc != null)
						onClickFunc.apply(null, onClickArgs);
				}
			}
		}

		override public function dispose():void
		{
			onClickFunc=null;
			onClickArgs=null;
			removeEventListener(TouchEvent.TOUCH, onTouch);

			super.dispose();
		}
	}
}
