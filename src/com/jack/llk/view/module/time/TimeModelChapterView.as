package com.jack.llk.view.module.time
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.panel.ChapterIcon;
	import com.jack.llk.view.panel.SettingPanel;
	import com.jack.llk.vo.ChapterVO;

	import org.josht.starling.foxhole.controls.ScrollContainer;
	import org.josht.starling.foxhole.layout.TiledRowsLayout;

	import starling.events.Event;
	import com.jack.llk.view.view.BaseView;

	public class TimeModelChapterView extends BaseView
	{
		private var container:ScrollContainer;

		public function TimeModelChapterView()
		{
			super();

			setBackground("asset_bg_model");
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			initialize1();
		}

		public function addChapterContainerToStage():void
		{
			if (container && !contains(container))
			{
				// recover it position
				container.verticalScrollPosition=0;
				addChildAt(container, 1);
			}
		}

		private function initialize1():void
		{
//			var w:Number=this.width;
//			var h:Number=this.height;
//
//			// testonly			
//			var conScaleX:Number=Global.contentScaleXFactor;
//			var conScaleY:Number=Global.contentScaleYFactor;
//			var layout:TiledRowsLayout=new TiledRowsLayout();
//			layout.paging=TiledRowsLayout.PAGING_VERTICAL;
//			layout.gap=25 * conScaleX;
//			layout.paddingLeft=50 * conScaleX;
//			layout.paddingTop=50 * conScaleY;
//			layout.paddingRight=0 * conScaleX;
//			layout.paddingBottom=0 * conScaleY;
//			layout.horizontalAlign=TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
//			layout.verticalAlign=TiledRowsLayout.VERTICAL_ALIGN_TOP;
//			layout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
//			layout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
//
//			container=new ScrollContainer();
//			container.layout=layout;
//			//container.scrollerProperties.snapToPages = layout.paging != TiledRowsLayout.PAGING_NONE;
//			container.x=0;
//			container.y=0;
//			addChild(container);
//
//			container.verticalScrollPolicy=ScrollContainer.SCROLL_POLICY_ON;
//			container.horizontalScrollPolicy=ScrollContainer.SCROLL_POLICY_OFF;
//
//			var voTimeModel:TimeModelVO=new TimeModelVO(100);
//			voTimeModel.init();
//
//			var len:int=voTimeModel.nLevel;
//			var list:Vector.<ChapterVO>=voTimeModel.chapterList;
//			var voChapter:ChapterVO;
//			var icon:ChapterIcon;
//			for (var i:int=0; i < len; i++)
//			{
//				voChapter=list[i];
//				icon=new ChapterIcon();
//				icon.init(voChapter);
//				scaleObject(icon);
//				container.addChild(icon);
//			}
//
//			// setting panel
//			var setting:SettingPanel=new SettingPanel();
//			addChildScaled(setting, 370, 690);
//			setting.setClipRect(370, 690);
//
//			// back button
//			var backBtn:CommonButton=new CommonButton("backbt");
//			addChildScaled(backBtn, 10, 690);
//			backBtn.onClick=onBackClick;
//
//			// set the container size
//			container.setSize(w, h);
		}

		/**
		 * Back to model screen.
		 */
		private function onBackClick():void
		{
			// stop horizontal layout container?
			container.removeFromParent();
			// hide classic model screen
			this.visible=false;
			this.prepareHide();
			// show model selecte screen
			Game.getInstance().modelView.visible=true;
			Game.getInstance().modelView.prepareShow();
		}

		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);

			onBackClick();
		}
	}
}
