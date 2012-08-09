package com.jack.llk.control.events
{
	import starling.events.Event;

	public class MyStarlingEvent extends Event
	{
		public var params:Object;
		
		public function MyStarlingEvent(type:String, params:Object=null, bubbles:Boolean=false)
		{
			this.params = params;
			super(type, bubbles);
		}
	}
}
