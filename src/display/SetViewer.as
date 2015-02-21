package display  {
	import com.gestureworks.cml.components.CollectionViewer;
	import com.gestureworks.cml.layouts.PileLayout;
	import com.gestureworks.cml.layouts.PointLayout;
	import com.gestureworks.cml.utils.document;
	import com.gestureworks.cml.utils.NumberUtils;
	import com.gestureworks.events.GWGestureEvent;
	import display.CVViewer;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Ideum
	 */
	public class SetViewer extends CollectionViewer {
		
		private var _template:CVViewer;
		private var sets:Sets;
		private var resources:Array = [];
		private var presistAmnt:int; 
		
		private var showSet:PileLayout;
		private var removeSet:PointLayout;
		private var currentSet:Set; 
		private var media:Vector.<String>;
		private var outPoints:Array = [new Point( -1000, 540), new Point(2920, 540), new Point(460, -1000), new Point(2920, 540)];
		private var pnts:String;		
		
		/**
		 * Constructor
		 */
		public function SetViewer() {
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function init():void {		
			
			//listen to set selection
			sets = document.getElementById("sets");
			sets.callback = selectSet;
			
			
			pnts = outPoints[0].x + ","+outPoints[0].y + ","
			
			//generate viewers
			if (template) {
				for (var i:int = 1; i < sets.maxSize; i++) {
					resources.push(template.clone());
					pnts += outPoints[i % outPoints.length].x + "," + outPoints[i % outPoints.length].y+",";
				}
			}
			
			//presist amnt to show
			presistAmnt = amountToShow;
			
			
			//set add layout
			showSet = new PileLayout();
			showSet.continuousTransform = false;
			showSet.tween = true;
			showSet.angle = 2;
			showSet.originX = 1300;
			showSet.originY = 700;			
			showSet.children = resources;
			showSet.onComplete = update;	
			
			//set remove layout
			removeSet = new PointLayout();
			removeSet.continuousTransform = false;
			removeSet.cacheTransforms = false; 
			removeSet.points = pnts;
			removeSet.children = resources;
			removeSet.tween = true;	
			removeSet.onComplete = loadViewers;
			
			super.init();				
		}
		
		/**
		 * Turn animation back on after load tween completes
		 */
		private function update():void {
			animateIn = true;
		}		
		
		/**
		 * Set viewer template to clone
		 */
		public function get template():* { return _template };
		public function set template(value:*):void {
			
			if (value is XML) {
				value = document.getElementById(value);
			}
			
			if(value is CVViewer){
				_template = value; 
				resources.push(_template);
				template.parent.removeChild(template);
			}
		}
		
		/**
		 * Set selection
		 * @param	value
		 */
		private function selectSet(value:Set):void {
			currentSet = value; 
			media = currentSet.media;
			removeSet.tween = true; 					
			applyLayout(removeSet);
		}
		
		/**
		 * Load new viewers
		 */
		private function loadViewers():void {
			
			//clear display
			clear();
			
			//dynamically update and add viewers
			for (var i:int = 0; i < media.length; i++) {
				resources[i].src = media[i];
				addChildAt(resources[i], numChildren);
			}
			
			amountToShow = presistAmnt; 
			animateIn = false; //prevent standard tween from interfereing with layouts			
			super.init();
			
			//initialize new viewers offscreen
			removeSet.tween = false; 
			removeSet.onComplete = initOut;
			applyLayout(removeSet);
		}
		
		/**
		 * Restore remove layout settings and apply add-set animation
		 */
		private function initOut():void {
			removeSet.tween = true; 
			removeSet.onComplete = loadViewers;
			showSet.tweenDelay = NumberUtils.map(media.length, 2, 25, 0, 1);
			applyLayout(showSet);
		}
		
		/**
		 * Restore initial state on remove
		 * @param	c
		 */
		override protected function removeComponent(c:DisplayObject):void {
			CVViewer(c).reset();
			super.removeComponent(c);
		}
		
		/**
		 * Removes viewers form display list
		 */
		private function clear():void {
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			for (var i:int = numChildren - 1; i >= 0; i--) {
				getChildAt(i).removeEventListener(GWGestureEvent.COMPLETE, onGestureComplete);
				removeChildAt(i);
			}
		}		
		
		/**
		 * Custom position check to remedy standard collision test failures
		 * @param	event
		 */
		override protected function onGestureComplete(event:GWGestureEvent = null):void {
			var v:CVViewer = event.target as CVViewer;
			var hCheck:Boolean = (v.x > 60 - v.width*v.scale) && (v.x < stage.stageWidth - 60);
			var vCheck:Boolean = (v.y > 60 - v.height*v.scale) && (v.y < stage.stageHeight - 60);
			if (!(hCheck && vCheck))
				removeComponent(DisplayObject(event.target));
		}
		
	}

}