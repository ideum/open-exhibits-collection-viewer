package display {
	import com.gestureworks.cml.elements.Button;
	import com.gestureworks.cml.elements.Menu;
	/**
	 * ...
	 * @author Ideum
	 */
	public class CVMenu extends Menu {
		
		private var play:Button;
		private var pause:Button;
		private var _videoMenu:Boolean;
			
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			super.init();
			
			play = getElementById("play");
			pause = getElementById("pause");
			videoMenu = videoMenu;
		}
		
		/**
		 * Controls display of video-specific controls
		 */
		public function get videoMenu():Boolean { return _videoMenu; }
		public function set videoMenu(value:Boolean):void {
			_videoMenu = value; 
			
			if(play && pause){
				play.visible = value;
				pause.visible = value;
			}
		}
	}

}