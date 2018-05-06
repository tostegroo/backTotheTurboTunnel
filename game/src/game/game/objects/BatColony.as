package game.game.objects 
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class BatColony extends Sprite
	{
		public var bats:Vector.<Bat> = new Vector.<Bat>();
		public var totalBats:int = 1;
		
		/*{position:new Point(903, 152), scale:1.1},
		{position:new Point(852, 122), scale:0.8},
		{position:new Point(720, 162), scale:1.1},
		{position:new Point(684, 100), scale:0.8},
		{position:new Point(642, 152), scale:1.2},
		{position:new Point(606, 106), scale:0.9},
		{position:new Point(578, 120), scale:0.7},
		{position:new Point(524, 130), scale:1},
		{position:new Point(452, 156), scale:1.1},
		{position:new Point(376, 154), scale:1.2},
		{position:new Point(340, 110), scale:0.8},
		{position:new Point(310, 123), scale:0.8},
		{position:new Point(256, 131), scale:0.98},
		{position:new Point(210, 119), scale:0.9},
		{position:new Point(184, 157), scale:0.95},
		{position:new Point(106, 151), scale:0.8},
		{position:new Point(148, 99), scale:0.9}*/
		
		public var batPositions:Vector.<Object> = new <Object>[
			{position:new Point(903, 64), scale:1.1},
			{position:new Point(852, 50), scale:0.8},
			{position:new Point(720, 65), scale:1.1},
			{position:new Point(684, 43), scale:0.8},
			{position:new Point(642, 60), scale:1.2},
			{position:new Point(606, 55), scale:0.9},
			{position:new Point(578, 54), scale:0.7},
			{position:new Point(524, 56), scale:1},
			{position:new Point(452, 61), scale:1.1},
			{position:new Point(376, 64), scale:1.2},
			{position:new Point(340, 68), scale:0.8},
			{position:new Point(310, 43), scale:0.8},
			{position:new Point(256, 43), scale:0.98},
			{position:new Point(210, 45), scale:0.9},
			{position:new Point(184, 51), scale:0.95},
			{position:new Point(106, 52), scale:0.8},
			{position:new Point(148, 43), scale:0.9}
		];
		
		public function BatColony() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			totalBats = batPositions.length;
			var bt:Bat;
			for (var i:int = 0; i < totalBats; i++) 
			{
				bt = new Bat();
				bt.scaleX = bt.scaleY = batPositions[i].scale;
				bt.x = batPositions[i].position.x - (38 * batPositions[i].scale);
				bt.y = batPositions[i].position.y - (10 * batPositions[i].scale);
				addChild(bt);
				
				bats.push(bt);
			}
		}
		
		public function flybats():void
		{
			var ypos:Number = 0;
			for (var i:int = 0; i < totalBats; i++) 
			{
				bats[i].fly();
				
				var time:Number = (Math.abs(-100 - bats[i].x) / 1000);
				ypos = -80 + (Math.random() * 350);
				TweenMax.to(bats[i], 1.5 * time, { x: -100, y:ypos, ease:Sine.easeInOut, onComplete:function(bat:Bat):void 
				{
					removeChild(bat);
				}, onCompleteParams:[bats[i]]});
			}
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}	
	}
}