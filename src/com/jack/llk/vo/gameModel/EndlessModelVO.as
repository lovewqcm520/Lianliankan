package com.jack.llk.vo.gameModel
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.LocalCache;
	import com.jack.llk.vo.EndlessModelRecordVO;

	public class EndlessModelVO
	{
		private var voRecord:EndlessModelRecordVO;
		
		public function EndlessModelVO()
		{
			
		}
		
		/**
		 * Run this init function when user choose some model type game.
		 */
		public function init():void
		{
			// first read from cache, if cache has nothing, init manually
			if(initFromCache() == false)
			{
				initChapterList();
			}
		}
		
		/**
		 * Flush the data to local shared object
		 */
		public function flushToCache():void
		{
			// flush the data to local shared object
			LocalCache.getInstance().addValue(Constant.CACHE_ENDLESS_MODEL, voRecord);
		}
		
		public function get maxLevel():int
		{
			return voRecord.maxLevel;
		}
		
		public function get maxScore():int
		{
			return voRecord.maxScore;
		}
		
		private function initChapterList():void
		{
			voRecord = new EndlessModelRecordVO();
			
			flushToCache();
		}
		
		private function initFromCache():Boolean
		{
			var v:EndlessModelRecordVO = LocalCache.getInstance().getValue(Constant.CACHE_ENDLESS_MODEL) as EndlessModelRecordVO;
			
			if(v)
			{
				voRecord = v;
				return true;
			}
			
			return false;
		}
	}
}