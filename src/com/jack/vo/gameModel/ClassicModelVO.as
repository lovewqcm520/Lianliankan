package com.jack.vo.gameModel
{	
	import com.jack.control.Constant;

	public class ClassicModelVO extends BaseModelVO
	{
		public function ClassicModelVO(nLevels:int)
		{
			super(Constant.CACHE_CLASSIC_MODEL, nLevels);
		}
	}
}