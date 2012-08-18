package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BaseImage;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.module.classic.ClassicModelChapterView;
	import com.jack.llk.view.module.endless.EndlessModelChapterView;
	import com.jack.llk.view.module.time.TimeModelChapterView;
	import com.jack.llk.view.panel.SettingPanel;
	
	import org.josht.starling.foxhole.controls.Button;
	import org.josht.starling.foxhole.controls.List;
	import org.josht.starling.foxhole.controls.PageIndicator;
	import org.josht.starling.foxhole.controls.Scroller;
	import org.josht.starling.foxhole.data.ListCollection;
	import org.josht.starling.foxhole.layout.HorizontalLayout;
	import org.josht.starling.foxhole.layout.TiledRowsLayout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class ModelView extends BaseView
	{
		private var modelDesc:Image;

		private var mModelIconWidth:Number;

		private var classicImage:BaseImage;
		private var timeImage:BaseImage;
		private var endlessImage:BaseImage;

		private var minX:Number;
		private var maxX:Number;
		private var diff:Number=30;
		private var lastDescIndex:int=-1;

		private var tModelDesc:Vector.<Texture>;
		private var _list:List;
		private var _pageIndicator:PageIndicator;

		public function ModelView()
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
			var w:Number=this.width;
			var h:Number=this.height;

			// classic model
			classicImage=Assets.getImage("classicmodelbg", true) as BaseImage;
			scaleObject(classicImage);

			// time model
			timeImage=Assets.getImage("timemodelbg", true) as BaseImage;
			scaleObject(timeImage);

			// endless model
			endlessImage=Assets.getImage("endlessmodelbg", true) as BaseImage;
			scaleObject(endlessImage);

			mModelIconWidth=endlessImage.width;
			var desc:Number=(w - mModelIconWidth) / 2;
			minX=desc - diff;
			maxX=desc + diff;

			var conScaleX:Number=Global.contentScaleXFactor;
			var conScaleY:Number=Global.contentScaleYFactor;
			
			// set list layout		
			var layout:TiledRowsLayout = new TiledRowsLayout();
			layout.paging = TiledRowsLayout.PAGING_HORIZONTAL;
			layout.useSquareTiles = false;
			layout.tileHorizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.horizontalAlign = TiledRowsLayout.HORIZONTAL_ALIGN_CENTER;
			layout.paddingTop=35 * conScaleY;
			layout.paddingRight=80 * conScaleX;
			layout.paddingBottom=200 * conScaleY;
			layout.paddingLeft=100 * conScaleX;

			// set the list data provider
			var data:Array = [{icon:classicImage}, {icon:timeImage}, {icon:endlessImage}];			
			var collection:ListCollection = new ListCollection(data);
			
			// init the list 
			_list = new List();
			_list.dataProvider = collection;
			_list.layout = layout;
			_list.scrollerProperties.snapToPages = true;
			_list.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_NONE;
			_list.itemRendererProperties.iconField = "icon";
			_list.itemRendererProperties.iconPosition = Button.ICON_POSITION_TOP;
			_list.onScroll.add(onScroll);
			_list.onItemTouch.add(onChapterTouch);
			//_list.itemRendererProperties.gap = 10 * conScaleX;			
			_list.width = w;
			_list.height = h;
			_list.validate();
			
			addChild(_list);
			
			// init the model desc movie clip
			tModelDesc=new Vector.<Texture>();
			tModelDesc[0]=Assets.getTexture("classicmodelcontent");
			tModelDesc[1]=Assets.getTexture("timemodelcontent");
			tModelDesc[2]=Assets.getTexture("endlessmodelcontent");
			modelDesc=new Image(tModelDesc[0]);
			lastDescIndex=0;
			addChildScaled(modelDesc, 65, 440);
			setChildIndex(modelDesc, 1);

			// setting panel
			var setting:SettingPanel=new SettingPanel();
			addChildScaled(setting, 370, 690);
			setting.setClipRect(370, 690);

			// back button
			var backBtn:CommonButton=new CommonButton("backbt");
			addChildScaled(backBtn, 10, 690);
			backBtn.onClick=onBackClick;
			
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
			_pageIndicator.maximum = 3;
			addChild(_pageIndicator);
			
			updateListLayout();
		}
		
		private function onChapterTouch(list:List, item:Object, index:int, event:TouchEvent):void
		{
			var touch:Touch=event.getTouch(item.icon as DisplayObject);
			if (touch)
			{
				if (touch.phase == TouchPhase.ENDED)
				{
					if(list.horizontalPageIndex == 0)
						onClassicModelSelected();
					else if(list.horizontalPageIndex == 1)
						onTimeModelSelected();
					else if(list.horizontalPageIndex == 2)
						onEndlessModelSelected();
				}
			}			
		}
		
		private function onClassicModelSelected():void
		{
			Log.log("onClassicModelSelected");
			var classicModelView:ClassicModelChapterView=new ClassicModelChapterView();
			Game.getInstance().container.addChild(classicModelView);
			// show classic model screen
			classicModelView.visible=true;
			classicModelView.prepareShow();
			// hide model selecte screen
			this.visible=false;
			this.prepareHide();
		}
		
		private function onTimeModelSelected():void
		{
			Log.log("onTimeModelSelected");
			var timeModelView:TimeModelChapterView=new TimeModelChapterView();
			Game.getInstance().container.addChild(timeModelView);
			// show time model screen
			timeModelView.visible=true;
			timeModelView.prepareShow();
			// hide model selecte screen
			this.visible=false;
			this.prepareHide();
		}
		
		private function onEndlessModelSelected():void
		{
			Log.log("onEndlessModelSelected");
			var endlessModelView:EndlessModelChapterView=new EndlessModelChapterView();
			Game.getInstance().container.addChild(endlessModelView);
			// show endless model screen
			endlessModelView.visible=true;
			endlessModelView.prepareShow();
			// hide model selecte screen
			this.visible=false;
			this.prepareHide();
		}

		override public function dispose():void
		{

			super.dispose();
		}

		public function addModelContainerToStage():void
		{
			if (_list && !contains(_list))
				addChildAt(_list, 2);
		}

		private function onScroll(l:List):void
		{
			var index:int=l.horizontalPageIndex;
			
			var t:Texture=tModelDesc[index];
			modelDesc.texture=t;
			modelDesc.width=t.width;
			modelDesc.height=t.height;
			
			addChildScaled(modelDesc, 65, 440);
			setChildIndex(modelDesc, 1);
			
			_pageIndicator.selectedIndex = index;
		}

		/**
		 * Back to init screen.
		 */
		private function onBackClick():void
		{
			// start moving
			var t1:Tween=new Tween(this, 0.3);
			t1.animate("x", Starling.current.nativeStage.fullScreenWidth);
			t1.onUpdate=onCurrentViewMoveUpdate;
			Starling.juggler.add(t1);
			this.prepareHide();

			var t2:Tween=new Tween(Game.getInstance().initView, 0.3);
			t2.animate("x", 0);
			Starling.juggler.add(t2);
			Game.getInstance().initView.prepareShow();
		}
		
		private function onCurrentViewMoveUpdate():void
		{
			if(contains(_list))
			{
				_list.removeFromParent();
			}
		}

		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);

			onBackClick();
		}
		
		protected function updateListLayout():void
		{
			_pageIndicator.validate();
			_pageIndicator.y = stage.stageHeight - stage.stageHeight * 0.1;
			
			_pageIndicator.maximum = 3;
			_pageIndicator.validate();
			_pageIndicator.x = (stage.stageWidth - _pageIndicator.width) / 2;
		}

	}
}
