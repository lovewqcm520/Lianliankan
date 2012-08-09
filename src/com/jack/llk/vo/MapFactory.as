package com.jack.llk.vo
{
	import com.jack.llk.util.NumberUtil;
	import com.jack.llk.util.RandomUtil;

	public class MapFactory
	{
		public var level:int;
		// millisecond
		public var batterInterval:Number=3000;
		public var totalTime:Number;
		public var warningTime:Number;
		public var nItemTypes:int;
		public var nAvailableItems:int;
		public var nStones:int;
		public var nToolItems:int;
		public var nPaintedEggs:int;
		public var nRefreshTools:int;
		public var nBombTools:int;
		public var nFindTools:int;
		public var nFlicker:int=5;

		// map layout
		public var nTileWidth:Number=36;
		public var nTileHeight:Number=38;
		public var nGapHorizontal:Number=3;
		public var nGapVertical:Number=3;
		public var nPaddingTop:Number=0;
		public var nPaddingBottom:Number=0;
		public var nPaddingLeft:Number=0;
		public var nPaddingRight:Number=0;

		// map size
		public var col:int;
		public var row:int;
		public var actualCol:int;
		public var actualRow:int;
		
		public static const PROBABILITY_STONE:Number = 1.0;
		public static const PROBABILITY_TOOL_ITEM:Number = 1.0;

		// default min value
		public static const TOTAL_TIME_MIN:int=60;
		public static const WARNING_TIME_MIN:int=50;
//		public static const TOTAL_TIME_MIN:int=10;
//		public static const WARNING_TIME_MIN:int=8;
		public static const COL_MIN:int=8;
		public static const ROW_MIN:int=6;
		public static const ITEM_TYPE_MIN:int=24;
		public static const AVAILABLE_ITEM_MIN:int=30;
		public static const STONE_MIN:int=2;
		public static const TOOL_ITEM_MIN:int=30;
		public static const EGG_MIN:int=0;
		public static const TOOL_REFRESH_MIN:int=1;
		public static const TOOL_BOMB_MIN:int=1;
		public static const TOOL_FIND_MIN:int=1;
		public static const FLICKER_ITEM_MIN:int=3;
		public static const LEVEL_MIN:int=1;

		// default max value
		public static const TOTAL_TIME_MAX:int=100;
		public static const WARNING_TIME_MAX:int=85;
		public static const COL_MAX:int=10;
		public static const ROW_MAX:int=10;
		public static const ITEM_TYPE_MAX:int=24;
		public static const AVAILABLE_ITEM_MAX:int=100;
		public static const STONE_MAX:int=8;
		public static const TOOL_ITEM_MAX:int=50;
		public static const EGG_MAX:int=3;
		public static const TOOL_REFRESH_MAX:int=1;
		public static const TOOL_BOMB_MAX:int=1;
		public static const TOOL_FIND_MAX:int=1;
		public static const FLICKER_ITEM_MAX:int=8;
		public static const LEVEL_MAX:int=999;

		public static const factor:Number=3;

		private static var _instance:MapFactory;

		public function MapFactory()
		{

		}

		public static function getInstance():MapFactory
		{
			if (!_instance)
				_instance=new MapFactory();

			return _instance;
		}

		public function createGameRound(level:int):RoundVO
		{
			// testonly
			var realMaxLevel:int = 30;
			
			this.level=level > realMaxLevel ? realMaxLevel : level;
			
			var add:int=this.level - LEVEL_MIN;			
			var p:Number=add/(realMaxLevel - LEVEL_MIN);

			// get map col
			this.col=int(COL_MIN + p * (COL_MAX - COL_MIN) * factor);
			this.col=this.col > COL_MAX ? COL_MAX : this.col;

			// get map row
			this.row=int(ROW_MIN + p * (ROW_MAX - ROW_MIN) * factor);
			this.row=this.row > ROW_MAX ? ROW_MAX : this.row;

			// get total time that give to user first
			this.totalTime=int(TOTAL_TIME_MIN + p * (TOTAL_TIME_MAX - TOTAL_TIME_MIN));

			// get warning time that give to user first
			this.warningTime=int(WARNING_TIME_MIN + p * (WARNING_TIME_MAX - WARNING_TIME_MIN));

			// get item types
			//this.nItemTypes=int(ITEM_TYPE_MIN + p * (ITEM_TYPE_MAX - ITEM_TYPE_MIN));
			this.nItemTypes=ITEM_TYPE_MIN;

			// get available items
			this.nAvailableItems=int(AVAILABLE_ITEM_MIN + p * (AVAILABLE_ITEM_MAX - AVAILABLE_ITEM_MIN));
			// if nAvailableItems was odd make it a even
			if (!NumberUtil.isEven(this.nAvailableItems))
				this.nAvailableItems++;

			// get stone items
			if(RandomUtil.isEnabledOnProbability(PROBABILITY_STONE))
			{
				this.nStones=int(STONE_MIN + p * (STONE_MAX - STONE_MIN));
				// if nStones was odd make it a even
				if (!NumberUtil.isEven(this.nStones))
					this.nStones++;
			}
			else
			{
				this.nStones=0;
			}
			
			// get tool items
			if(RandomUtil.isEnabledOnProbability(PROBABILITY_TOOL_ITEM))
			{
				this.nToolItems=int(TOOL_ITEM_MIN + p * (TOOL_ITEM_MAX - TOOL_ITEM_MIN));
				// if nToolItems was odd make it a even
				if (!NumberUtil.isEven(this.nToolItems))
					this.nToolItems++;
			}
			else
			{
				this.nToolItems=TOOL_ITEM_MIN;
			}

			// get egg items
			this.nPaintedEggs=int(EGG_MIN + p * (EGG_MAX - EGG_MIN));

			// get refresh tool 
			this.nRefreshTools=int(TOOL_REFRESH_MIN + p * (TOOL_REFRESH_MAX - TOOL_REFRESH_MIN));

			// get bomb tool 
			this.nBombTools=int(TOOL_BOMB_MIN + p * (TOOL_BOMB_MAX - TOOL_BOMB_MIN));

			// get find tool 
			this.nFindTools=int(TOOL_FIND_MIN + p * (TOOL_FIND_MAX - TOOL_FIND_MIN));

			// get flicker numbers
			this.nFlicker=int(FLICKER_ITEM_MIN + p * (FLICKER_ITEM_MAX - FLICKER_ITEM_MIN));

			// adjust items quantity
			var nSize:int = col*row;
			if(nAvailableItems + nStones + nToolItems > nSize)
			{
				nAvailableItems = nSize - nStones - nToolItems;
			}

			// set the round vo
			var round:RoundVO=new RoundVO(this.level, col, row, nAvailableItems, nItemTypes);
			
			round.nFlicker=this.nFlicker;
			round.nStoneItems=this.nStones;
			round.nToolItems=this.nToolItems;
			round.nPaintedEggs=this.nPaintedEggs;
			round.totalTime=this.totalTime;
			round.warningTime=this.warningTime;
			round.batterInterval=this.batterInterval;

			round.nTileWidth=this.nTileWidth;
			round.nTileHeight=this.nTileHeight;
			round.nGapHorizontal=this.nGapHorizontal;
			round.nGapVertical=this.nGapVertical;
			round.nPaddingTop=this.nPaddingTop;
			round.nPaddingBottom=this.nPaddingBottom;
			round.nPaddingLeft=this.nPaddingLeft;
			round.nPaddingRight=this.nPaddingRight;

			// init the round
			round.init();
			
			// init the tools
			round.nRefreshTool=this.nRefreshTools;
			round.nBombTool=this.nBombTools;
			round.nFindTool=this.nFindTools;

			return round;
		}




	}
}
