package com.jack.llk.control.events
{
	import starling.events.Event;

	public class ViewEvent extends Event
	{
		public static const GOTO_PREVIOUS_VIEW:String="goto_previous_view";

		public function ViewEvent(type:String, bubbles:Boolean=false, params:Object=null)
		{
			super(type, params);
		}
	}
}
