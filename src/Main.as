package {
	
	import com.gestureworks.cml.core.CMLCore;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.core.GestureWorks;
	import com.gestureworks.utils.Stats;
	import display.Set;
	import display.Sets;
	import display.SetViewer;
	import display.CVMenu;
	import display.CVViewer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ideum
	 */
	
	[SWF(width = "1920", height = "1080", backgroundColor = "0xCCCCCC", frameRate = "30")]
	
	public class Main extends GestureWorks {
		
		public function Main():void {
			super();
			
			CMLParser.addEventListener(CMLParser.COMPLETE, cmlInit);
			
			// load custom cml package and classes
			CMLCore.packages = CMLCore.packages.concat(["display"]);
			CMLCore.classes = CMLCore.classes.concat([CVMenu, CVViewer, Set, Sets, SetViewer]);				
			
			fullscreen = true;
			gml = "library/gml/gestures.gml";
			cml = "library/cml/main.cml";
		}
		
		/**
		 * CML parsing complete event handler
		 * @param	e
		 */
		private function cmlInit(e:Event):void {			
			CMLParser.removeEventListener(CMLParser.COMPLETE, cmlInit);
			
			//add stats display for performance evalutation
			//if (CONFIG::debug == true) {
				//addChild(new Stats());
			//}
		}
		
		/**
		 * GML parsing complete call
		 */
		override protected function gestureworksInit():void {
			super.gestureworksInit();
		}
	}
	
}