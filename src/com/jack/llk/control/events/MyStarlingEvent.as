package com.jack.llk.control.events
{
	import starling.events.Event;
	
	public class MyStarlingEvent extends Event
	{
		public function MyStarlingEvent(type:String, bubbles:Boolean=false, data:Object=null)
		{
			super(type, bubbles);
		}
	}
}