package com.jack.llk.vo.model
{
	import com.jack.llk.control.Common;
	import com.jack.llk.control.asset.Maps;

	public class ClassicModelVO extends BaseModelVO
	{
		private static var _instance:ClassicModelVO;	
		
		public function ClassicModelVO()
		{
			super();
		}
		
		public static function getInstance():ClassicModelVO
		{
			if(!_instance)
				_instance = new ClassicModelVO();
			
			return _instance;
		}
		
		override public function init():void
		{
			this.cacheName = Common.CACHE_CLASSIC_MODEL;
			this.MAX_LEVEL = Maps.totalClassicMaps;
			
			super.init();
		}
		
		
	}
}