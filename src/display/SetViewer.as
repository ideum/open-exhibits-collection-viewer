package display  {
	import com.gestureworks.cml.components.CollectionViewer;
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.components.MediaViewer;
	import com.gestureworks.cml.elements.Collection;
	import com.gestureworks.cml.elements.Media;
	import com.gestureworks.cml.events.StateEvent;
	import com.gestureworks.cml.utils.DisplayUtils;
	import com.gestureworks.cml.utils.document;
	
	/**
	 * ...
	 * @author Ideum
	 */
	public class SetViewer extends CollectionViewer {
		
		private var _template:MediaViewer;
		private var sets:Sets;
		private var resources:Array = [];
		private var currentSet:Set; 
		private var media:Vector.<String>;	
		private var titles:Vector.<String>;
		private var descriptions:Vector.<String>;
		private var collection:Collection;
		private var displayCount:int; 
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {		
			
			//listen to set selection
			sets = document.getElementById("sets");
			sets.callback = selectSet;
			
			//generate viewers
			if (template) {
				for (var i:int = resources.length; i < sets.maxSize; i++) {
					resources.push(template.clone());
				}
			}
						
			super.init();				
			
			//persist display count
			collection = front; 					
			displayCount = collection.displayCount;	
			
			collection.addEventListener(StateEvent.CHANGE, queued);
		}	
		
		/**
		 * Set viewer template to clone
		 */
		public function get template():* { return _template };
		public function set template(value:*):void {
			if (value is XML || value is String) {
				value = document.getElementById(value);
			}
			if (value is Component) {
				_template = value; 
				resources.push(_template);				
			}
		}
		
		/**
		 * Set selection
		 * @param	value
		 */
		private function selectSet(value:Set):void {
			if (currentSet == value) {
				return; 
			}
			
			currentSet = value; 
			media = currentSet.media;
			titles = currentSet.titles;
			descriptions = currentSet.descriptions;
			loadSet();
		}
		
		/**
		 * Dynamically update collection objects
		 */
		private function loadSet():void {
			
			collection.clear();
			
			var viewer:MediaViewer;
			for (var i:int = 0; i < media.length; i++) {
				viewer = MediaViewer(resources[i]);
				viewer.resetTransform();
				
				Media(viewer.front).src = media[i]; 				
				if(titles.length > i){
					viewer.back.searchChildren("title").str = titles[i];
				}
				if (descriptions.length > i) {
					viewer.back.searchChildren("descr").str = descriptions[i];
				}

				collection.addChild(viewer);
			}
						
			collection.displayCount = displayCount;
			DisplayUtils.initAll(collection);			
		}
		
		/**
		 * Stop media playback
		 * @param	e
		 */
		private function queued(e:StateEvent):void {
			if (e.property == "queued") {
				Media(e.value.front).stop();
			}
		}
	}
}