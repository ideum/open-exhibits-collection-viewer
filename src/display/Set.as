package display {
	import com.gestureworks.cml.base.media.MediaStatus;
	import com.gestureworks.cml.core.CMLParser;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Text;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.events.StateEvent;
	/**
	 * ...
	 * @author Ideum
	 */
	public class Set extends TouchContainer {
		
		//media collection
		private var _media:Vector.<String> = new Vector.<String>();		
		private var selected:Boolean;
		private var selectState:Image; 
		private var defaultState:Image; 
		private var label:Text;
		
		public var defaultTextColor:uint = 0xFFFFFF;
		public var selectedTextColor:uint = 0x000000;
				
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			super.init();
			
			var imgs:Array = getElementsByTagName(Image);
			selectState = imgs[0];
			defaultState = imgs[1];						
			
			label = getElementsByTagName(Text)[0];
			if (label) {
				label.color = defaultTextColor;
			}
			
			if (defaultState.isLoaded) {
				displayLoaded();
			}
			else{
				defaultState.addEventListener(StateEvent.CHANGE, displayLoaded);			
			}
		}	
		
		/**
		 * Update dimensions on image display
		 * @param	event
		 */
		private function displayLoaded(event:StateEvent=null):void {
			if (!event || (event.property == MediaStatus.LOADED && event.value)) {
				event.target.removeEventListener(StateEvent.CHANGE, displayLoaded); 
				dimensionsTo = event.target;
				if (label) {
					label.dimensionsTo = event.target;					
				}
				dispatchEvent(new StateEvent(StateEvent.CHANGE, this, MediaStatus.LOADED, true));
			}
		}
						
		/**
		 * Store media sources
		 * @param	cml
		 * @return
		 */
		override public function parseCML(cml:XMLList):XMLList {
			
			var children:XMLList = cml.*.copy();
			for (var i:int = children.length()-1; i >= 0 ; i--) {
				if (children[i].name() == "media") {
					_media.push(CMLParser.rootDirectory+children[i]);
					delete cml.*[i];
				}
			}
			
			return super.parseCML(cml);
		}
		
		/**
		 * Media sources
		 */
		public function get media():Vector.<String > { return _media; }
		
		/**
		 * Alternate between selected and unselected states
		 */
		public function toggle():void {
			selected = !selected;
			
			selectState.visible = selected;
			defaultState.visible = !selected;
			
			if (label) {
				label.color = selected ? selectedTextColor : defaultTextColor;
			}
		}
	}

}