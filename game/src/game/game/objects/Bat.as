package game.game.objects 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	
	import game.assets.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Bat extends Sprite
	{
		public var frameContainer:Sprite;
		public var frame0:Image;
		public var frame1:Image;
		public var frame2:Image;
		public var frame3:Image;
		public var tweenFly:TweenMax;
		public var tweenSwing:TweenMax;
		private var frames:Object = { totalFrames:3, frame:0.01 };
		
		public var batframes:Vector.<Image> = new Vector.<Image>();
		
		public function Bat() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			var scaleMod:Number = Math.random() * 0.5;
			frameContainer = new Sprite();
			frameContainer.scaleX = frameContainer.scaleY = 1 + scaleMod;
			addChild(frameContainer);
			
			frame0 = new Image(Assets.getAtlas('level', 1).getTexture('bat_f0'));
			frameContainer.addChild(frame0);
			batframes.push(frame0);
			
			frame1 = new Image(Assets.getAtlas('level', 1).getTexture('bat_f1'));
			frame1.x = 15;
			frame1.visible = false;
			frameContainer.addChild(frame1);
			batframes.push(frame1);
			
			frame2 = new Image(Assets.getAtlas('level', 1).getTexture('bat_f2'));
			frame2.x = frame1.x;
			frame2.visible = false;
			frameContainer.addChild(frame2);
			batframes.push(frame2);
			
			frame3 = new Image(Assets.getAtlas('level', 1).getTexture('bat_f3'));
			frame3.x = frame2.x - 3;
			frame3.visible = false;
			frameContainer.addChild(frame3);
			batframes.push(frame3);
		}
		
		public function fly():void
		{
			frames.frame = 0.01;
			tweenFly = TweenMax.to(frames, 0.1, { frame:frames.totalFrames, ease:Linear.easeNone, repeat: -1, onUpdate:function():void
			{
				var frm:int = Math.ceil(frames.frame);
				for (var i:int = 0; i < frames.totalFrames + 1; i++) 
				{
					batframes[i].visible = false;
				}
				batframes[frm].visible = true;
			}} );
			tweenSwing = TweenMax.to(frameContainer, 1, { y:50, repeat: -1, yoyo:true, ease:Sine.easeInOut } );
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			if(tweenFly)
				tweenFly.kill();
			
			if(tweenSwing)
				tweenSwing.kill();
		}
	}
}