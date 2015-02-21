package display {
	import com.gestureworks.cml.elements.Container;
	import com.gestureworks.events.GWTouchEvent;
	/**
	 * ...
	 * @author Ideum
	 */
	public class Sets extends Container {
		
		private var _selected:Set;
		private var _maxSize:int = 0; 
		public var callback:Function;		
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {
			
			//touch handler
			addEventListener(GWTouchEvent.TOUCH_BEGIN, selection);
			
			//compute max set size
			var sets:Array = getElementsByTagName(Set);
			for each(var s:Set in sets) {
				if (s.media.length > _maxSize) {
					_maxSize = s.media.length;
				}
			}
			
			super.init();
			
			x = stage.stageWidth/2  - getRect(this).width/2;
		}
		
		/**
		 * Set selected to touched object
		 * @param	e
		 */
		private function selection(e:GWTouchEvent):void {
			selected = e.target as Set; 
		}
		
		/**
		 * Update selection
		 */
		public function get selected():Set { return _selected; }
		public function set selected(value:Set):void {
			if (_selected == value) {
				return; 
			}
			
			//unselect previous
			if (_selected) {
				_selected.toggle();
			}
			
			//select new
			_selected = value; 
			if (_selected) {
				_selected.toggle();
			}
			
			if (callback != null) {
				callback.call(null, _selected);
			}
		}
		
		/**
		 * Size of largest set
		 */
		public function get maxSize():int { return _maxSize; }
	}

}