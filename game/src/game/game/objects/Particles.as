package game.game.objects 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Device;
	import game.data.GameData;
	import starling.events.EnterFrameEvent;
	
	import game.assets.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Particles extends Sprite
	{
		private var totalParticles:int = 100;
		public var speed:Number = 1;
		private var img:Image;
		private var time:Number = 0;
		private var deltaTime:Number;
		private var mov:Vector.<Point> = new Vector.<Point>();
		
		private var canUpdate:Boolean = true;
		
		public function Particles() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			for (var i:int = 0; i < totalParticles; i++) 
			{
				var sizeVariation:Number = Math.random() * 7;
				var kick:int = Math.ceil(Math.random() * 10);
				sizeVariation += (kick == 2) ? Math.random() * 30 : 0;

				img = new Image(Assets.getAtlas('level', 1).getTexture('particle'));
				img.width = 2 + sizeVariation;
				img.height = 2 + sizeVariation;
				img.alpha = 0.9;
				img.absoluteHeight = img.height;
				mov.push(new Point((-5 + (Math.random() * 10)),(-50 + (Math.random() * 100))));
				
				img.y = 250 + (Math.random() * (stage.stageHeight-250));
				img.x = Math.random() * stage.stageWidth;
				
				addChild(img);
			}
			speed = 1;
		}
		
		public function update(val:Number = 1, deltaTime:Number = 1/60):void 
		{
			if (GameData.gamePaused == false && canUpdate==true)
			{
					for (var j:int = 0; j < numChildren; j++) 
					{
						img = getChildAt(j) as Image;
						img.x += (mov[j].x + (-val)) * img.scaleX;
						img.y += mov[j].y * deltaTime * speed * img.scaleX;
						var rot:Number = 0.15 * img.scaleX;
						rot = (rot > 0.5) ? 0.5 : rot;
						img.rotation += rot; 
						
						if (img.x < -(img.width + 10) || img.y < -(img.height + 10) || img.y > (stage.stageHeight + img.height + 10) || img.x > (stage.stageWidth + img.width + 10))
						{
							img.y = Math.random() * stage.stageHeight;
							img.x = Math.random() * stage.stageWidth;
						}
					}
			}
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}

}