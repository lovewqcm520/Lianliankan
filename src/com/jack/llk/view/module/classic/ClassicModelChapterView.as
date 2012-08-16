package com.jack.llk.view.module.classic
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Common;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.panel.ChapterIcon;
	import com.jack.llk.view.panel.SettingPanel;
	import com.jack.llk.view.view.BaseView;
	import com.jack.llk.view.view.GameView;
	import com.jack.llk.vo.ChapterVO;
	import com.jack.llk.vo.model.ClassicModelVO;
	
	import org.josht.starling.display.Image;
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.PageIndicator;
	import org.josht.starling.foxhole.controls.Scroller;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.josht.starling.foxhole.layout.HorizontalLayout;
	import org.josht.starling.foxhole.layout.TiledRowsLayout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.ResizeEvent;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class ClassicModelChapterView extends BaseView
	{
		private var _list:List;
		private var _pageIndicator:PageIndicator;

		public function ClassicModelChapterView()
		{
			super();

			setBackground("asset_bg_model");
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			initialize();
			stage.addEventListener(ResizeEvent.RESIZE, onStageResize);
		}

		private function initialize():void
		{
			// set chapter container
			updateChapterList();

			// setting panel
			var setting:SettingPanel=new SettingPanel();
			addChildScaled(setting, 370, 690);
			setting.setClipRect(370, 690);

			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick=onBackClick;
		}
		
		/**
		 * Start classic game at specify level.
		 */
		private function onStartGameAt(level:int):void
		{
			var gameView:GameView=new GameView(Common.GAME_MODEL_CLASSIC);
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
			prepareHide();
			Game.getInstance().previousView=this;
		}
		
		private function onCurrentViewMoveUpdate():void
		{
			if(Starling.current.nativeStage.fullScreenWidth - Math.abs(x) <= 10)
			{
				if(contains(_list))
				{
					_list.removeFromParent(true);
					_list = null;
				}
				if(contains(_pageIndicator))
				{
					_pageIndicator.removeFromParent(true);
					_pageIndicator = null;
				}
			}
		}
		
		public function recoverChapterContainer():void
		{
			if(_list && contains(_list))
				return;
			
			updateChapterList();
		}
		
		/**
		 * Back to model screen.
		 */
		private function onBackClick():void
		{
			// dispose the classic model game view
			removeFromParent(true);
			
			// show model selecte screen
			Game.getInstance().modelView.visible=true;
			Game.getInstance().modelView.prepareShow();
		}

		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);

			onBackClick();
		}
		
		private function updateChapterList():void
		{
			// set the list data provider
			var data:Array = [];			
			// get classic model level data from cache
			ClassicModelVO.getInstance().init();
			// get total chapters and chapter list
			var len:int=ClassicModelVO.getInstance().nChapters;
			var list:Vector.<ChapterVO>=ClassicModelVO.getInstance().chapterList;
			var voChapter:ChapterVO;
			var item:ChapterIcon;
			for (var i:int=0; i < len; i++)
			{
				voChapter=list[i];
				item=new ChapterIcon();
				item.init(voChapter);
				scaleObject(item);
				item.scaleX *= 0.8;
				item.scaleY *= 0.8;
				data.push({icon:item});
			}
			var collection:ListCollection = new ListCollection(data);
			
			// set list layout
			var listLayout:TiledRowsLayout = new TiledRowsLayout();
			listLayout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			listLayout.useSquareTiles = false;
			listLayout.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			listLayout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			
			// init the list 
			_list = new List();
			_list.dataProvider = collection;
			_list.layout = listLayout;
			_list.scrollerProperties.snapToPages = true;
			_list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			_list.itemRendererProperties.iconField = "icon";
			_list.itemRendererProperties.iconPosition = Button.ICON_POSITION_TOP;
			_list.onScroll.add(onListScroll);
			_list.onItemTouch.add(onChapterTouch);
			addChildAt(_list, 1);
			
			var normalSymbolTexture:Texture = Assets.getTexture("normal-page-symbol");
			var selectedSymbolTexture:Texture = Assets.getTexture("selected-page-symbol");
			
			// set layout for page indicator
			var pageIndicatorLayout:HorizontalLayout = new HorizontalLayout();
			pageIndicatorLayout.gap = 3;
			pageIndicatorLayout.paddingTop = 5;
			pageIndicatorLayout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_MIDDLE;
			
			// set the page indicator
			_pageIndicator = new PageIndicator();
			_pageIndicator.normalSymbolFactory = function():Image
			{
				var img1:Image = new Image(normalSymbolTexture);
				img1.scaleX *= Global.contentScaleXFactor;
				img1.scaleY *= Global.contentScaleYFactor;
				return img1;
			}
			_pageIndicator.selectedSymbolFactory = function():Image
			{
				var img2:Image = new Image(selectedSymbolTexture);
				img2.scaleX *= Global.contentScaleXFactor;
				img2.scaleY *= Global.contentScaleYFactor;
				return img2;
			}
			_pageIndicator.layout = pageIndicatorLayout;
			_pageIndicator.maximum = 1;
			addChild(_pageIndicator);
			
			updateListLayout();
		}
		
		protected function updateListLayout():void
		{
			_pageIndicator.validate();
			_pageIndicator.y = stage.stageHeight - stage.stageHeight * 0.2;
			
			var shorterSide:Number = Math.min(stage.stageWidth, stage.stageHeight);
			var layout:TiledRowsLayout = TiledRowsLayout(_list.layout);
			layout.paddingTop = layout.paddingRight = layout.paddingBottom =
				layout.paddingLeft = shorterSide * 0.06;
			layout.paddingBottom = stage.stageHeight * 0.2;
			layout.gap = shorterSide * 0.1;
			
			_list.itemRendererProperties.gap = shorterSide * 0.01;
			
			_list.width = stage.stageWidth;
			_list.height = stage.stageHeight - _pageIndicator.height;
			_list.validate();
			
			_pageIndicator.maximum = Math.ceil(_list.maxHorizontalScrollPosition / _list.width) + 1;
			_pageIndicator.validate();
			_pageIndicator.x = (stage.stageWidth - _pageIndicator.width) / 2;
		}
		
		private function onListScroll(l:List):void
		{
			_pageIndicator.selectedIndex = l.horizontalPageIndex;
		}
		
		protected function onStageResize(event:ResizeEvent):void
		{
			updateListLayout();
		}
		
		/**
		 * Touch event handler for chapter icon in the list.
		 * @param l
		 * @param item
		 * @param index
		 * @param event
		 */
		private function onChapterTouch(l:List, item:Object, index:int, event:TouchEvent):void
		{
			var icon:ChapterIcon = item.icon;
			if(icon)
			{
				var touch:Touch=event.getTouch(icon);
				if (touch)
				{
					if (touch.phase == TouchPhase.ENDED)
					{
						if(!icon.locked)
						{
							onStartGameAt(icon.level);
						}
					}
				}
			}			
		}
		
		
	}
}
