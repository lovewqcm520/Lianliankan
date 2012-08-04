package com.jack.llk.vo.gameModel
{
	import com.jack.llk.control.Constant;

	public class ClassicModelVO extends BaseModelVO
	{
		public function ClassicModelVO(nLevels:int)
		{
			super(Constant.CACHE_CLASSIC_MODEL, nLevels);
		}
	}
}
