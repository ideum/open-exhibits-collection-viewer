package display {
	import com.gestureworks.cml.components.Component;
	import com.gestureworks.cml.elements.Frame;
	import com.gestureworks.cml.elements.Image;
	import com.gestureworks.cml.elements.Menu;
	import com.gestureworks.cml.elements.TouchContainer;
	import com.gestureworks.cml.utils.CloneUtils;
	import com.gestureworks.events.GWGestureEvent;
	/**
	 * ...
	 * @author Ideum
	 */
	public class CVViewer extends Component {
		
		private var image:Image;		
		private var _current:TouchContainer;		
		private var _src:String; 
		
		/**
		 * Constructor
		 */
		public function CVViewer() {
			super();
			mouseChildren = true;
			nativeTransform = false;
			affineTransform = true;				
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {

			menu = searchChildren(Menu);
			frame = searchChildren(Frame);			
			
			//image element
			image = searchChildren(Image);
			image.close();
			image.visible = false; 
			
			//gesture handlers
			addEventListener(GWGestureEvent.DRAG, dragHandler);
			addEventListener(GWGestureEvent.SCALE, scaleHandler);
			addEventListener(GWGestureEvent.ROTATE, rotateHandler);
			
			super.init();
		}
			
		/**
		 * Media source path
		 */
		public function get src():String { return _src; }
		public function set src(value:String):void {
			_src = value; 	
			current = image;	
			CVMenu(menu).videoMenu = false;
			updateLayout();
		}
		
		/**
		 * Current media element
		 */
		private function get current():TouchContainer { return _current; }
		private function set current(value:TouchContainer):void {
			if (_current) {
				image.close();
				_current.visible = false; 
			}
			
			_current = value;
			_current["src"] = src;
			_current.visible = true; 
			
			image.open();
		}		
		
		/**
		 * @inheritDoc
		 */
		override protected function updateLayout(event:* = null):void {
			if (current) {
				width = current.width;
				height = current.height;	
			}				
			super.updateLayout(event);
		}
		
		/**
		 * Drag gesture handler
		 * @param	e
		 */
		private function dragHandler(e:GWGestureEvent):void {
			e.target.x += e.value.drag_dx; 
			e.target.y += e.value.drag_dy; 
		}
		
		/**
		 * Scale gesture handler
		 * @param	e
		 */		
		private function scaleHandler(e:GWGestureEvent):void {
			e.target.scale += e.value.scale_dsx; 
		}
		
		/**
		 * Rotation gesture handler
		 * @param	e
		 */		
		private function rotateHandler(e:GWGestureEvent):void {
			e.target.rotation += e.value.rotate_dtheta;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function onDown(event:* = null):void {
			//move to top
			parent.addChildAt(this, parent.numChildren -1);
			super.onDown(event);
		}
		
		/**
		 * Restore initial transform
		 */
		override public function reset():void {
			loadState();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():* 
		{	
			cloneExclusions.push("backs", "textFields", "src");
			var clone:CVViewer = CloneUtils.clone(this, this.parent, cloneExclusions);	
			clone.init();				
			
			return clone;
		}		
	}

}