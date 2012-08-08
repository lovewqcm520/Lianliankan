package com.jack.llk.view.view
{
	import com.jack.llk.Game;
	import com.jack.llk.control.Global;
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BaseImage;
	import com.jack.llk.view.button.CommonButton;
	import com.jack.llk.view.panel.SettingPanel;
	
	import org.josht.starling.foxhole.controls.ScrollContainer;
	import org.josht.starling.foxhole.layout.HorizontalLayout;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import com.jack.llk.view.module.endless.EndlessModelChapterView;
	import com.jack.llk.view.module.classic.ClassicModelChapterView;
	import com.jack.llk.view.module.time.TimeModelChapterView;

	public class ModelView extends BaseView
	{
		private var modelDesc:Image;
		private var container:ScrollContainer;

		private var mModelIconWidth:Number;

		private var classicImage:BaseImage;
		private var timeImage:BaseImage;
		private var endlessImage:BaseImage;

		private var minX:Number;
		private var maxX:Number;
		private var diff:Number=30;
		private var lastDescIndex:int=-1;

		private var timeModelView:TimeModelChapterView;
		private var endlessModelView:EndlessModelChapterView;

		private var tModelDesc:Vector.<Texture>;

		public function ModelView()
		{
			super();

			setBackground("asset_bg_model");
		}

		override protected function onAddedToStage(event:Event):void
		{
			super.onAddedToStage(event);

			initialize1();
		}

		private function initialize1():void
		{
			var w:Number=this.width;
			var h:Number=this.height;

			// classic model
			classicImage=Assets.getImage("classicmodelbg", true) as BaseImage;
			classicImage.onClick=onClassicModelSelected;
			scaleObject(classicImage);

			// time model
			timeImage=Assets.getImage("timemodelbg", true) as BaseImage;
			timeImage.onClick=onTimeModelSelected;
			scaleObject(timeImage);

			// endless model
			endlessImage=Assets.getImage("endlessmodelbg", true) as BaseImage;
			endlessImage.onClick=onEndlessModelSelected;
			scaleObject(endlessImage);

			mModelIconWidth=endlessImage.width;
			var desc:Number=(w - mModelIconWidth) / 2;
			minX=desc - diff;
			maxX=desc + diff;

			var conScaleX:Number=Global.contentScaleXFactor;
			var conScaleY:Number=Global.contentScaleYFactor;
			// try to use foxhole ui component			
			var layout:HorizontalLayout=new HorizontalLayout();
			layout.gap=80 * conScaleX;
			layout.paddingTop=35 * conScaleY;
			layout.paddingRight=80 * conScaleX;
			layout.paddingBottom=0 * conScaleY;
			layout.paddingLeft=115 * conScaleX;
			layout.horizontalAlign=HorizontalLayout.HORIZONTAL_ALIGN_LEFT;
			layout.verticalAlign=HorizontalLayout.VERTICAL_ALIGN_TOP;

			container=new ScrollContainer();
			container.layout=layout;

			container.verticalScrollPolicy=ScrollContainer.SCROLL_POLICY_OFF;
			container.horizontalScrollPolicy=ScrollContainer.SCROLL_POLICY_ON;
			container.setSize(w, h);
			container.onScroll.add(onScroll);

			container.addChild(classicImage);
			container.addChild(timeImage);
			container.addChild(endlessImage);

			addChild(container);

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
		
		private function onEndlessModelSelected():void
		{
			Log.log("onEndlessModelSelected");
			if (!endlessModelView)
			{
				endlessModelView=new EndlessModelChapterView();
				Game.getInstance().container.addChild(endlessModelView);
			}
			// show endless model screen
			endlessModelView.visible=true;
			endlessModelView.prepareShow();
			// hide model selecte screen
			this.visible=false;
			this.prepareHide();
		}

		private function onTimeModelSelected():void
		{
			Log.log("onTimeModelSelected");
			if (!timeModelView)
			{
				timeModelView=new TimeModelChapterView();
				Game.getInstance().container.addChild(timeModelView);
			}
			else
			{
				timeModelView.addChapterContainerToStage();
			}
			// show time model screen
			timeModelView.visible=true;
			timeModelView.prepareShow();
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
			if (container && !contains(container))
				addChildAt(container, 2);
		}

		private function onScroll(con:ScrollContainer):void
		{
			var horizontalScrollPosition:Number=con.horizontalScrollPosition;
			var index:int=Math.ceil(horizontalScrollPosition / mModelIconWidth) - 1;
			if (lastDescIndex != index && index >= 0 && index < 3)
			{
				lastDescIndex=index;

				var t:Texture=tModelDesc[index];
				modelDesc.texture=t;
				modelDesc.width=t.width;
				modelDesc.height=t.height;

				addChildScaled(modelDesc, 65, 440);
				setChildIndex(modelDesc, 1);
			}
		}

		/**
		 * Back to init screen.
		 */
		private function onBackClick():void
		{
			// stop horizontal layout container?
			container.removeFromParent();

			// start moving
			var t1:Tween=new Tween(this, 0.3);
			t1.animate("x", Starling.current.nativeStage.fullScreenWidth);
			Starling.juggler.add(t1);

			this.prepareHide();

			var t2:Tween=new Tween(Game.getInstance().initView, 0.3);
			t2.animate("x", 0);
			Starling.juggler.add(t2);

			Game.getInstance().initView.prepareShow();
		}

		override protected function onGotoPreviousView(event:ViewEvent):void
		{
			super.onGotoPreviousView(event);

			onBackClick();
		}

	}
}
