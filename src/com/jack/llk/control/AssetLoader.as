package com.jack.llk.control
{
	import br.com.stimuli.loading.BulkLoader;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class AssetLoader
	{
		private var oldTime:int;
		
		public function AssetLoader()
		{
		}
		
		public function load():void
		{
			oldTime = getTimer();
			
			var loader:BulkLoader = new BulkLoader("llk");
			
			loader.add("assets/textures/bg_init.png");
			loader.add("assets/textures/bg_about.png");
			loader.add("assets/textures/bg_model.png");
			loader.add("assets/textures/bg_game.png");
			loader.add("assets/textures/effect.png");
			loader.add("assets/textures/asset2.png");
			loader.add("assets/textures/asset3.png");
			loader.add("assets/textures/items.png");
			
			loader.add("assets/textures/effect.xml");
			loader.add("assets/textures/asset2.xml");
			loader.add("assets/textures/asset3.xml");
			loader.add("assets/textures/items.xml");
			
			loader.add("assets/sounds/THUNDER.mp3");
			loader.add("assets/sounds/XIAO_CHU_MUSIC.mp3");
			loader.add("assets/sounds/SHUA_XIN_MUSIC.mp3");
			loader.add("assets/sounds/DAO_JU_MUSIC.mp3");
			loader.add("assets/sounds/DAO_JI_SHI_MUSIC.mp3");
			loader.add("assets/sounds/DATING_BACK_MUSIC.mp3");
			loader.add("assets/sounds/JI_SHOU_MUSIC.mp3");
			loader.add("assets/sounds/AN_NIU_MUSIC.mp3");
			loader.add("assets/sounds/DIAN_JI_MUSIC.mp3");
			loader.add("assets/sounds/GAME_BACK_MUSIC.mp3");
			loader.add("assets/sounds/ZHA_DAN_MUSIC.mp3");
			loader.add("assets/sounds/WIN_BACK_MUSIC.mp3");
			loader.add("assets/sounds/READY_GO_MUSIC.mp3");
			loader.add("assets/sounds/LOST_BACK_MUSIC.mp3");
			
			loader.addEventListener(BulkLoader.COMPLETE, onComplete);
			loader.start();
		}
		
		protected function onComplete(event:Event):void
		{
			trace("onComplete", getTimer()-oldTime);
		}
	}
}