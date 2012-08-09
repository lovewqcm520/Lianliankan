package com.jack.llk.control.events
{
	import starling.events.Event;

	public class ViewEvent extends MyStarlingEvent
	{
		public static const GOTO_PREVIOUS_VIEW:String="goto_previous_view";

		public function ViewEvent(type:String, params:Object=null, bubbles:Boolean=false)
		{
			super(type, params, bubbles);
		}
	}
}
