package com.jack.llk.view.module.classic
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Constant;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.panel.ChapterIcon;
	import com.jack.llk.view.panel.SettingPanel;
	import com.jack.llk.view.view.BaseView;
	import com.jack.llk.view.view.GameView;
	import com.jack.llk.vo.ChapterVO;
	import com.jack.llk.vo.model.ClassicModelVO;
	
	import org.josht.starling.foxhole.controls.ScrollContainer;
	import org.josht.starling.foxhole.layout.TiledRowsLayout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;

	public class ClassicModelChapterView extends BaseView
	{
		private var container:ScrollContainer;

		public function ClassicModelChapterView()
		{
			super();

			setBackground("asset_bg_model");
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			initialize();
		}

		private function initialize():void
		{
			// set chapter container
			setChapterContainer();

			// setting panel
			var setting:SettingPanel=new SettingPanel();
			addChildScaled(setting, 370, 690);
			setting.setClipRect(370, 690);

			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick=onBackClick;
		}
		
		private function setChapterContainer():void
		{
			var w:Number=this.width;
			var h:Number=this.height;
			
			// testonly			
			var conScaleX:Number=Global.contentScaleXFactor;
			var conScaleY:Number=Global.contentScaleYFactor;
			var layout:TiledRowsLayout=new TiledRowsLayout();
			layout.paging=TiledRowsLayout.PAGING_VERTICAL;
			layout.gap=25 * conScaleX;
			layout.paddingLeft=65 * conScaleX;
			layout.paddingTop=50 * conScaleY;
			layout.paddingRight=0 * conScaleX;
			layout.paddingBottom=0 * conScaleY;
			layout.horizontalAlign=TiledRowsLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign=TiledRowsLayout.VERTICAL_ALIGN_TOP;
			layout.tileHorizontalAlign=TiledRowsLayout.TILE_HORIZONTAL_ALIGN_LEFT;
			layout.tileVerticalAlign=TiledRowsLayout.TILE_VERTICAL_ALIGN_TOP;
			
			container=new ScrollContainer();
			container.layout=layout;
			//container.scrollerProperties.snapToPages = layout.paging != TiledRowsLayout.PAGING_NONE;
			container.x=0;
			container.y=0;
			addChildAt(container, 1);
			
			container.verticalScrollPolicy=ScrollContainer.SCROLL_POLICY_ON;
			container.horizontalScrollPolicy=ScrollContainer.SCROLL_POLICY_OFF;
			
			// get classic model level data from cache
			ClassicModelVO.getInstance().init();
			// get total chapters and chapter list
			var len:int=ClassicModelVO.getInstance().nChapters;
			var list:Vector.<ChapterVO>=ClassicModelVO.getInstance().chapterList;
			var voChapter:ChapterVO;
			var icon:ChapterIcon;
			for (var i:int=0; i < len; i++)
			{
				voChapter=list[i];
				icon=new ChapterIcon();
				icon.init(voChapter);
				if(!voChapter.locked)
				{
					icon.onClick(onStartGameAt, voChapter.level);
				}
				scaleObject(icon);
				container.addChild(icon);
			}
			
			// set the container size
			container.setSize(w, h);
		}
		
		/**
		 * Start classic game at specify level.
		 */
		private function onStartGameAt(level:int):void
		{
			var gameView:GameView=new GameView(Constant.GAME_MODEL_CLASSIC);
			gameView.x=Starling.current.nativeStage.fullScreenWidth;
			Game.getInstance().container.addChild(gameView);
			
			gameView.start(level);
			gameView.visible=true;
			
			var t1:Tween=new Tween(gameView, 0.3);
			t1.animate("x", 0);
			Starling.juggler.add(t1);			
			gameView.prepareShow();
			
			var t2:Tween=new Tween(this, 0.3);
			t2.animate("x", -Starling.current.nativeStage.fullScreenWidth);
			t2.onUpdate=onCurrentViewMoveUpdate;
			Starling.juggler.add(t2);			
			this.prepareHide();
			Game.getInstance().previousView=this;
		}
		
		private function onCurrentViewMoveUpdate():void
		{
			if(Starling.current.nativeStage.fullScreenWidth - Math.abs(this.x) <= 10)
			{
				if(contains(container))
				{
					container.removeFromParent(true);
					container = null;
				}
			}
		}
		
		public function recoverChapterContainer():void
		{
			if(container && contains(container))
				return;
			
			setChapterContainer();
		}
		
		/**
		 * Back to model screen.
		 */
		private function onBackClick():void
		{
			// dispose the classic model game view
			this.removeFromParent(true);
			
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
