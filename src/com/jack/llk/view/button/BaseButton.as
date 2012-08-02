package com.jack.llk.view.button
{
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.MyStarlingEvent;
	import com.jack.llk.control.factors.SoundFactors;
	import com.jack.llk.control.sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class BaseButton extends Button
	{		
		private var eventType:String;
		private var eventData:Object;
		private var onClickFunc:Function;
				
		public function BaseButton(upState:Texture, text:String="", downState:Texture=null, eventType:String=null, eventData:Object=null)
		{
			super(upState, text, downState);
			
			this.eventType = eventType;
			this.eventData = eventData;
			
			addEventListener(Event.TRIGGERED, onBtnTriggered);
		}
		
		protected function get mBg():Sprite
		{
			return this.getChildAt(0) as Sprite;
		}
		
		public function set onClick(func:Function):void
		{
			onClickFunc = func;
		}
		
		protected function onBtnTriggered(event:Event):void
		{		
			// play the sound when trigger button
			SoundManager.play(SoundFactors.AN_NIU_MUSIC);
			// dispatch the event
			if(eventType)
			{
				var e:MyStarlingEvent = new MyStarlingEvent(eventType, false, eventData);
				EventController.e.dispatchEvent(e);
			}
			// call the onClickFunc
			if(onClickFunc != null)
				onClickFunc.apply();
		}				
		
		override public function dispose():void
		{
			eventData = null;
			onClickFunc = null;
			if(hasEventListener(Event.TRIGGERED))
				removeEventListener(Event.TRIGGERED, onBtnTriggered);
			
			super.dispose();
		}
		
		
	}
}