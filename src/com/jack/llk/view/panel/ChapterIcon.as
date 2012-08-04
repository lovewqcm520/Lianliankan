package com.jack.llk.view.panel
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.ChapterStars;
	import com.jack.llk.view.NumberSprite;
	import com.jack.llk.vo.ChapterVO;

	import starling.display.Image;

	/**
	 * Icon for choose chapter.
	 * @author Jack
	 */
	public class ChapterIcon extends BaseSprite
	{
		private var voChapter:ChapterVO;
		private var bg:Image;

		private var locked:Boolean;
		private var nStar:int;
		private var level:int;

		public function ChapterIcon()
		{
			super();

			// set the background
			bg=Assets.getImage("egg");
			addChild(bg);
		}

		public function init(voChapter:ChapterVO):void
		{
			this.voChapter=voChapter;

			// set the level number
			level=voChapter.level;
			var numSprite:NumberSprite=new NumberSprite(level);
			numSprite.scaleY=1.75;
			numSprite.x=bg.x + (bg.width - numSprite.width) / 2;
			numSprite.y=bg.y + (bg.height - numSprite.height) / 2;
			addChild(numSprite);

			// set the chapter star 
			nStar=voChapter.star;
			if (nStar > 0)
			{
				var starSprite:ChapterStars=new ChapterStars(nStar);
				starSprite.x=bg.x + (bg.width - starSprite.width) / 2;
				starSprite.y=bg.y + (bg.height - starSprite.height);
				addChild(starSprite);
			}

			// set the lock
			locked=voChapter.locked;
			if (locked)
			{
				var lock:Image=Assets.getImage("smalllock");
				lock.x=bg.x + (bg.width - lock.width) / 2;
				lock.y=bg.y + (bg.height - lock.height);
				addChild(lock);
			}
			else
			{
				this.onClick(startGameAtChapter);
			}
		}

		private function startGameAtChapter():void
		{
		}
	}
}
