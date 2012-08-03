package com.jack.llk.view.panel
{
	import com.jack.llk.control.asset.Assets;
	import com.jack.llk.view.BaseSprite;
	import com.jack.llk.view.button.BaseButton;
	import com.jack.llk.view.button.CommonButton;
	
	import starling.display.Image;
	import starling.textures.Texture;
	
	public class PausePanel extends BaseSprite
	{
		private var disableXIcon:Image;
		
		public function PausePanel()
		{
			super();
			
			initialize();
		}
		
		private function initialize():void
		{
			// set background dialog
			var bg:Image = Assets.getImage("dialogbg");
			bg.scaleX = bg.scaleY = 0.82;
			bg.x = 0;
			bg.y = 0;
			addChild(bg);
			
			// set play button
			var upState:Texture = Assets.getTexture("startgamebt");
			var text:String="";
			var downState:Texture = Assets.getTexture("startgamebted");	
			var playBtn:BaseButton = new BaseButton(upState, text, downState);
			playBtn.x = bg.x + (bg.width-playBtn.width)/2;
			playBtn.y = -playBtn.height/2;
			addChild(playBtn);
			playBtn.onClick = onResume;
			
			// set back, restart, about, music, sound , 5 buttons
			var btnY:Number = 107;
			var gap:Number = -10;
			var btnW:Number = 98;
			var fx:Number = bg.x + (bg.width - 5*(btnW+gap))/2;
			
			// back button
			var backBtn:CommonButton = new CommonButton("backbt");
			backBtn.x = fx;
			backBtn.y = btnY;
			backBtn.onClick = onBack;
			
			// restart button
			var restartBtn:CommonButton = new CommonButton("restartbtn");
			restartBtn.x = fx + 1*(btnW+gap);
			restartBtn.y = btnY;
			restartBtn.onClick = onRestart;
			
			var aboutBtn:CommonButton = new CommonButton("aboutbt");
			aboutBtn.x = fx + 2*(btnW+gap);
			aboutBtn.y = btnY;
			aboutBtn.onClick = onAbout;
			
			var musicBtn:CommonButton = new CommonButton("music_white");
			musicBtn.x = fx + 3*(btnW+gap);
			musicBtn.y = btnY;
			musicBtn.onClick = onMusic;
			
			var soundBtn:CommonButton = new CommonButton("sound_white");
			soundBtn.x = fx + 4*(btnW+gap);
			soundBtn.y = btnY;
			soundBtn.onClick = onSound;
			
			addChild(backBtn);
			addChild(restartBtn);
			addChild(aboutBtn);
			addChild(musicBtn);
			addChild(soundBtn);
		}
		
		/**
		 * Enable or disable the sound.
		 */
		private function onSound():void
		{
			
		}
		
		/**
		 * Enable or disable the music.
		 */
		private function onMusic():void
		{
			
		}
		
		/**
		 * Show the about view.
		 */
		private function onAbout():void
		{
			
		}
		
		/**
		 * Restart current mode and level game.
		 */
		private function onRestart():void
		{
			
		}
		
		/**
		 * Back to last view.
		 */
		private function onBack():void
		{
			
		}
		
		/**
		 * Resume the paused game.
		 */
		private function onResume():void
		{
			
		}
	}
}