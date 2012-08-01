package com.jack.llk.vo.gameModel
{	
	import com.jack.llk.control.Constant;

	public class TimeModelVO extends BaseModelVO
	{
		public function TimeModelVO(nLevels:int)
		{
			super(Constant.CACHE_TIME_MODEL, nLevels);
		}
	}
}