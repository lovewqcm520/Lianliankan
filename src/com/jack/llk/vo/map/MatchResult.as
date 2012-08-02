package com.jack.llk.vo.map
{
	public class MatchResult
	{
		private var _list:Array;
		
		public function MatchResult()
		{
		}
		
		public function get list():Array
		{
			return _list;
		}
		
		public function fill(...args):void
		{
			_list = args;
		}
		
		public function clear():void
		{
			if(_list)
				_list.length = 0;
		}
		
		public function clone():MatchResult
		{
			if(_list)
			{
				var mr:MatchResult = new MatchResult();
				mr.fill(_list.concat());
				return mr;
			}

			return null;
		}
	}
}