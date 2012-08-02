package com.jack.llk.view
{
	import com.jack.llk.control.Global;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class BaseImage extends Image
	{
		private var onClickFunc:Function;
		
		public function BaseImage(texture:Texture)
		{
			super(texture);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
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