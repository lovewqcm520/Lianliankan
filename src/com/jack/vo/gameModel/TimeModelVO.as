package com.jack.vo.gameModel
{	
	import com.jack.control.Constant;

	public class TimeModelVO extends BaseModelVO
	{
		public function TimeModelVO(nLevels:int)
		{
			super(Constant.CACHE_TIME_MODEL, nLevels);
		}
	}
}