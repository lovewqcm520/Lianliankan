package com.jack.llk.vo.model
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.asset.Maps;

	public class TimeModelVO extends BaseModelVO
	{
		private static var _instance:TimeModelVO;	
		
		public function TimeModelVO()
		{
			super();
		}
		
		public static function getInstance():TimeModelVO
		{
			if(!_instance)
				_instance = new TimeModelVO();
			
			return _instance;
		}
		
		override public function init():void
		{
			this.cacheName = Common.CACHE_TIME_MODEL;
			this.MAX_LEVEL = Maps.totalTimeMaps;
			
			super.init();
		}
		
		
	}
}