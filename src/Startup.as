package 
{
	import com.jack.llk.Game;
	import com.jack.llk.control.asset.Assets;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Startup extends Sprite
	{
		public function Startup()
		{
			super();
			
			// asset
			Assets.init();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			initialize();
		}
		
		private function initialize():void
		{
			// initialize the game.
			Game.getInstance().initialize();
		}				
		
	}
}