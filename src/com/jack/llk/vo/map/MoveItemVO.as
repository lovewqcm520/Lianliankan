package com.jack.llk.vo.map
{
	import flash.geom.Point;

	public class MoveItemVO
	{
		public var start:Point;
		public var end:Point;
		
		public function MoveItemVO(start:Point, end:Point)
		{
			this.start = start;
			this.end = end;
		}
		
		public function toString():String
		{
			return start.toString() + "	" + end.toString();
		}
	}
}