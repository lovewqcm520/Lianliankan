package com.jack.llk.control.events
{
	import starling.events.Event;
	
	public class ViewEvent extends Event
	{
		public static const GOTO_PREVIOUS_VIEW:String = "goto_previous_view";
		
		public static const GAME_RESUME:String = "game_resume";
		
		public static const GAME_PAUSE:String = "game_pause";
		
		public static const GAME_RESTART:String = "game_restart";
		
		public static const GAME_NEXT:String = "game_next";
		
		public function ViewEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles);
		}
	}
}