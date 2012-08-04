package com.jack.llk.control.events
{
	import starling.events.Event;

	public class MyStarlingEvent extends Event
	{
		public var params:Object;
		
		public function MyStarlingEvent(type:String, bubbles:Boolean=false, params:Object=null)
		{
			this.params = params;
			super(type, bubbles);
		}
	}
}
