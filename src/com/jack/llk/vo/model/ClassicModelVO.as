package com.jack.llk.vo.model
{
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.LocalCache;
	import com.jack.llk.control.asset.Maps;
	import com.jack.llk.vo.ChapterVO;

	public class ClassicModelVO
	{
		private var MAX_LEVEL:int;
		private var _chapterList:Vector.<ChapterVO>;
		
		private static var _instance:ClassicModelVO;	

		public function ClassicModelVO()
		{
		}
		
		public static function getInstance():ClassicModelVO
		{
			if(!_instance)
				_instance = new ClassicModelVO();
			
			return _instance;
		}

		/**
		 * Run this init function when user choose classic model.
		 */
		public function init():void
		{
			MAX_LEVEL = Maps.totalClassicMaps;
			if(!_chapterList)
			{
				// first read from cache, if cache has nothing, init manually
				if (initChapterListFromCache() == false)
				{
					initChapterList();
				}
			}
		}

		/**
		 * Flush the data to local shared object
		 */
		public function flushToCache():void
		{
			// flush the data to local shared object
			if (chapterList && chapterList.length > 0)
				LocalCache.getInstance().addValue(Constant.CACHE_CLASSIC_MODEL, chapterList);
		}


		/**
		 * Call this function when user finish some chaptor under this model to record.
		 * @param level
		 * @param stars
		 * @param autoUpdateNextLevel True auto update the next level, unlock it.
		 */
		public function flushAt(level:int, stars:int, locked:Boolean=false, autoUpdateNextLevel:Boolean=true):void
		{
			var readyToFlush:Boolean = false;
			if (chapterList[level - 1] == undefined)
			{
				var c:ChapterVO = new ChapterVO();
				c.level = level;
				c.locked = locked;
				c.star = stars;
				chapterList[level - 1]=c;
				readyToFlush = true;
			}
			else
			{
				if(ChapterVO(chapterList[level - 1]).star != stars ||
				   ChapterVO(chapterList[level - 1]).locked != locked)
				{
					ChapterVO(chapterList[level - 1]).star = stars;
					ChapterVO(chapterList[level - 1]).locked = locked;
					readyToFlush=true;
				}
			}
			
			if(readyToFlush && autoUpdateNextLevel)
			{
				// auto unlock next level with default 0 star
				flushAt(level+1, 0, false, false);
				
				// update the sharedobject
				flushToCache();
			}			
		}

		private function initChapterList():void
		{
			_chapterList=new Vector.<ChapterVO>();

			var c:ChapterVO;
			for (var i:int=0; i < MAX_LEVEL; i++)
			{
				c=new ChapterVO();
				c.level=i + 1;
				c.star = 0;
				// init only first chapter was unlocked
				c.locked = (i == 0 ? false : true);

				_chapterList.push(c);
			}
		}

		private function initChapterListFromCache():Boolean
		{
			var arr:Vector.<Object>=LocalCache.getInstance().getValue(Constant.CACHE_CLASSIC_MODEL);
			if (arr && arr.length > 0)
			{
				var obj:Object;
				var cha:ChapterVO;
				var len:int = arr.length;
				
				if(!_chapterList)
					_chapterList = new Vector.<ChapterVO>(MAX_LEVEL);
					
				for (var i:int = 0; i < len; i++) 
				{
					obj = arr[i];
					if(_chapterList[i] == undefined)
					{
						cha = new ChapterVO();
						cha.level = obj.level;
						cha.locked = obj.locked;
						cha.star = obj.star;
						_chapterList[i] = cha;
					}
					else
					{
						ChapterVO(_chapterList[i]).level = obj.level;
						ChapterVO(_chapterList[i]).locked = obj.locked;
						ChapterVO(_chapterList[i]).star = obj.star;
					}
				}
				
				return true;
			}

			return false;
		}

		public function get chapterList():Vector.<ChapterVO>
		{
			return _chapterList;
		}

		public function get nChapters():int
		{
			return _chapterList.length;
		}
	}
}
