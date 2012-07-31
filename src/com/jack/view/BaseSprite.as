package com.jack.view
{
	import com.jack.control.Global;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class BaseSprite extends Sprite
	{
		private var onClickFunc:Function;
		
		public function BaseSprite()
		{
			super();
			
			addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		public function addChildScaled(child:DisplayObject, childX:Number=-9999, childY:Number=-9999):void
		{
			if(child)
			{
				child.scaleX *= Global.contentScaleXFactor;
				child.scaleY *= Global.contentScaleYFactor;
				
				addChild(child);
				
				if(childX != -9999 && childY != -9999)
				{
					child.x = (childX * Global.contentScaleXFactor);
					child.y= (childY * Global.contentScaleYFactor);
				}
			}
		}
		
		public function scaleObject(child:DisplayObject):void
		{
			if(child && child.scaleX == 1 && child.scaleY == 1)
			{
				child.scaleX *= Global.contentScaleXFactor;
				child.scaleY *= Global.contentScaleYFactor;
			}
		}
		
		public function set onClick(func:Function):void
		{
			onClickFunc = func;
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(this);
			
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					if(onClickFunc != null)
						onClickFunc.apply();
				}
			}
		}
		
		override public function dispose():void
		{
			onClickFunc = null;
			removeEventListener(TouchEvent.TOUCH, onTouch);
			
			super.dispose();
		}
	}
}