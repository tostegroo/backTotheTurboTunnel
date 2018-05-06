package game.game.hud 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import game.assets.Assets;
	import game.game.Game;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	import starling.utils.rad2deg;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class TouchController extends Sprite
	{
		public var padXDump:Number = 20;
		public var padYDump:Number = 20;
		
		public var movXMax:Number = 40;
		public var movYMax:Number = 30;
		
		private var tapArea:Quad;
		public var tapPress:Function = null;
		public var tapRelease:Function = null;
		
		private var pt:Point = new Point(0, 0);
		private var mv:Point = new Point(0, 0);
		
		private var padArea:Quad;
		public var onMoveX:Function = null;
		public var stopMoveX:Function = null;
		public var onMoveY:Function = null;
		public var stopMoveY:Function = null;
		
		private var touchedPad:Object;
		private var touchesPad:Touch;
		
		private var touchedTap:Object;
		private var touchesTap:Touch;
		
		private var i:int = 0;
		
		public function TouchController(game:Game = null) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			touchedTap = { pressed:false, timePressed:0 };
			touchedPad = { pressed:false, timePressed:0 };
			
			tapArea = new Quad(stage.stageWidth / 2, stage.stageHeight, 0x0000ff);
			tapArea.x = stage.stageWidth / 2;
			tapArea.alpha = 0;
			addChild(tapArea);
			
			padArea = new Quad(stage.stageWidth / 2, stage.stageHeight, 0xff0000);
			padArea.alpha = 0;
			addChild(padArea);
			
			tapArea.addEventListener(TouchEvent.TOUCH, onTouchTap);
			padArea.addEventListener(TouchEvent.TOUCH, onTouchPad);
		}
		
		private function onTouchPad(e:TouchEvent):void
		{
			touchesPad = e.getTouch(this.padArea);
			if (touchesPad != null)
			{
				pt.setTo(0, 0);
				mv.setTo(0, 0);
				
				if (touchesPad.phase == TouchPhase.BEGAN)
				{
					touchedPad.pressed = true;
					touchedPad.timePressed = touchedPad.timestamp;
					
				}else if (touchesPad.phase == TouchPhase.MOVED)
				{
					pt.setTo(touchesPad.getLocation(this).x, touchesPad.getLocation(this).y);
					mv.setTo(touchesPad.getMovement(this).x, touchesPad.getMovement(this).y);
					
					if (touchedPad.pressed == true)
					{
						mv.x = (Math.abs(mv.x) < 1) ? 0 : mv.x;
						mv.x = Math.round(mv.x);
						mv.x = (mv.x > movXMax) ? movXMax : mv.x;
						mv.x = (mv.x < -movXMax) ? -movXMax : mv.x;
						
						mv.y = (Math.abs(mv.y) < 1) ? 0 : mv.y;
						mv.y = Math.round(mv.y);
						mv.y = (mv.y > movYMax) ? movYMax : mv.y;
						mv.y = (mv.y < -movYMax) ? -movYMax : mv.y;
						
						if (onMoveX != null)
							onMoveX(mv.x / padXDump);
						
						if (onMoveY != null)
							onMoveY(mv.y / padYDump);
					}
					
				}else if (touchesPad.phase == TouchPhase.ENDED)
				{
					touchedPad.pressed = false;
					touchedPad.timePressed = touchedPad.timestamp - touchedPad.timePressed;
					touchedPad.timePressed = 0;
					
					pt.setTo(0, 0);
					mv.setTo(0, 0);
					
					if (stopMoveX != null)
						stopMoveX();
					
					if (stopMoveY != null)
						stopMoveY();
				}
			}
		}
		
		private function onTouchTap(e:TouchEvent):void
		{
			touchesTap = e.getTouch(this.tapArea);
			
			if (touchesTap != null)
			{
				if (touchesTap.phase == TouchPhase.BEGAN)
				{
					touchedTap.pressed = true;
					touchedTap.timePressed = touchesTap.timestamp;
					
					if (tapPress != null)
						tapPress();
					
				}else if (touchesTap.phase == TouchPhase.ENDED)
				{
					touchedTap.pressed = false;
					touchedTap.timePressed = touchedTap.timestamp - touchedTap.timePressed;
					touchedTap.timePressed = 0;
					
					if (tapRelease != null)
						tapRelease();
				}
			}
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			if (tapArea)
				tapArea.removeEventListener(TouchEvent.TOUCH, onTouchTap);
			
			if(padArea)
				padArea.removeEventListener(TouchEvent.TOUCH, onTouchPad);
		}
	}
}