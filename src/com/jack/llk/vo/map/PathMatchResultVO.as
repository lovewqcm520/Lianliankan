package com.jack.llk.vo.map
{
	public class PathMatchResultVO
	{
		private var _list:Array;

		public function PathMatchResultVO()
		{
		}

		public function get list():Array
		{
			return _list;
		}

		public function fill(... args):void
		{
			_list=args;
		}

		public function clear():void
		{
			if (_list)
				_list.length=0;
		}

		public function clone():PathMatchResultVO
		{
			if (_list)
			{
				var mr:PathMatchResultVO=new PathMatchResultVO();
				mr.fill(_list.concat());
				return mr;
			}

			return null;
		}
	}
}
