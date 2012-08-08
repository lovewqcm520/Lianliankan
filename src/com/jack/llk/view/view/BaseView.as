package com.jack.llk.view.view
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.control.events.EventController;
	import com.jack.llk.control.events.ViewEvent;
	import com.jack.llk.log.Log;
	import com.jack.llk.view.BaseSprite;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;

	public class BaseView extends BaseSprite
	{
		protected var backgroundTexture:Texture;
		protected var backgroundImage:Image;

		private var hasPreviousViewEvent:Boolean=false;

		public function BaseView()
		{
			super();

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			prepareShow();
		}

		/**
		 * Set background image for this screen.
		 * @param backgroundAsset
		 */
		public function setBackground(backgroundAsset:*, touchable:Boolean=false):void
		{
			if (backgroundAsset is String)
				backgroundTexture=Assets.getTexture(String(backgroundAsset));
			else if (backgroundAsset is Texture)
				backgroundTexture=Texture(backgroundAsset);

			if (!backgroundTexture)
				return;

			if (backgroundImage)
			{
				backgroundImage.removeFromParent(true);
				backgroundImage=null;
			}
			backgroundImage=new Image(backgroundTexture);
			backgroundImage.x=0;
			backgroundImage.y=0;
			backgroundImage.width=Starling.current.nativeStage.fullScreenWidth;
			backgroundImage.height=Starling.current.nativeStage.fullScreenHeight;
			backgroundImage.touchable=touchable;
			addChild(backgroundImage);
		}

		public function prepareShow():void
		{
//			if (isFlattened)
//				this.unflatten();

			if (!hasPreviousViewEvent)
			{
				EventController.e.addEventListener(ViewEvent.GOTO_PREVIOUS_VIEW, onGotoPreviousView);
				hasPreviousViewEvent=true;
				Log.log("show", this);
			}
		}

		protected function onGotoPreviousView(event:ViewEvent):void
		{
			Log.log("onGotoPreviousView", this);
		}

		public function prepareHide():void
		{
//			if (!isFlattened)
//				this.flatten();

			if (hasPreviousViewEvent)
			{
				EventController.e.removeEventListener(ViewEvent.GOTO_PREVIOUS_VIEW, onGotoPreviousView);
				hasPreviousViewEvent=false;
				Log.log("hide", this);
			}
		}

		override public function dispose():void
		{
			if (hasPreviousViewEvent)
			{
				EventController.e.removeEventListener(ViewEvent.GOTO_PREVIOUS_VIEW, onGotoPreviousView);
				//Log.log("dispose", this);
			}
			
			super.dispose();
		}


	}
}
