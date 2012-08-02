package com.jack.llk.view.panel
{
	import com.jack.llk.control.Global;
	import com.jack.llk.view.button.SettingButton;
	
	import flash.geom.Rectangle;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.extensions.ClippedSprite;
	
	public class SettingPanel extends ClippedSprite
	{
		public var settingBtn:SettingButton;
		private var panel:SettingBackground;
		private var isSettingPanelOpened:Boolean;
		
		public function SettingPanel()
		{
			super();
			
			initialize();
		}
		
		public function setClipRect(cx:Number, cy:Number):void
		{
			var cw:Number = settingBtn.width;
			var ch:Number = (150 + settingBtn.height - 12);
			
			cx *= Global.contentScaleXFactor;
			cy = (cy-150)*Global.contentScaleYFactor;
			cw *= Global.contentScaleXFactor;
			ch *= Global.contentScaleYFactor;
			
			this.clipRect = new Rectangle(cx, cy, cw, ch);
		}
		
		private function initialize():void
		{
			settingBtn = new SettingButton();
			settingBtn.x = 0;
			settingBtn.y = 0;
			addChild(settingBtn);
			settingBtn.onClick = onSettingBtnClick;
			
			panel = new SettingBackground();
			panel.x = settingBtn.x;
			//settingPanel.y = settingBtn.y - 185;
			panel.y = settingBtn.y;
			panel.visible = false;
			addChildAt(panel, 0);
			
			isSettingPanelOpened = false;			
		}
		
		private function onSettingBtnClick():void
		{
			panel.visible=true;
			
			var tween:Tween;
			if(isSettingPanelOpened)
			{
				tween = new Tween(panel, 0.3);
				tween.onComplete = onSettingPanelHideComplete;
				tween.animate("y", settingBtn.y);
			}
			else
			{
				tween = new Tween(panel, 0.3);
				tween.onComplete = onSettingPaneShowComplete;
				tween.animate("y", settingBtn.y - 185);
			}
			
			Starling.juggler.add(tween);
			
			isSettingPanelOpened = !isSettingPanelOpened;
		}
		
		private function onSettingPaneShowComplete():void
		{
			panel.visible = true;
		}
		
		private function onSettingPanelHideComplete():void
		{
			panel.visible = false;
		}
	}
}