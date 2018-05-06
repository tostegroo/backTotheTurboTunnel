package game.game.objects 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
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
	public class Stars extends Sprite
	{
		private var planet:Planet;
		private var starContainer:Sprite;
		
		private var totalStars:int = 200;
		public var starfieldBG:Image;
		public var tweenAlpha:TweenMax;
		
		public var speed:Number = 1;
		
		private var img:Image;
		private var time:Number = 0;
		private var deltaTime:Number;
		
		private var canUpdate:Boolean = true;
		private var callback:Function = null;
		
		public function Stars() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			starContainer = new Sprite();
			addChild(starContainer);
			for (var i:int = 0; i < totalStars; i++) 
			{
				var sizeVariation:Number = Math.random() * 7;
				var kick:int = Math.ceil(Math.random() * 10);
				sizeVariation += (kick == 2) ? Math.random() * 7 : 0;

				img = new Image(Assets.getAtlas('interface_intro', 1).getTexture('star'));
				img.width = 5 + sizeVariation;
				img.height = 5 + sizeVariation;
				img.alpha = 0.2 + (Math.random() * 0.8);
				img.absoluteHeight = img.height;
				
				img.y = Math.random() * stage.stageHeight;
				img.x = Math.random() * stage.stageWidth;
				
				tweenAlpha = TweenMax.to(img, 2, { alpha:0.2 , ease:Sine.easeInOut, repeat:-1, yoyo:true, delay:Math.random() * 20} );
				starContainer.addChild(img);
			}
			
			planet = new Planet();
			planet.x = stage.stageWidth / 2;
			planet.y = stage.stageHeight + (2000 * Device.scale);
			addChild(planet );
			
			speed = 1;
			start();
		}
		
		public function transitionToStop(time:Number = 1, callback:Function = null):void
		{
			this.callback = callback;
			
			TweenMax.to(this, 1 * time, { speed:50, ease:Sine.easeIn } );
			TweenMax.to(this, 3.4 * time, { speed:0, ease:Sine.easeOut, delay:1 * time, onComplete:function():void 
			{
				canUpdate = false;
				stop();
			}} );
			TweenMax.to( planet, 4 * time, { y:stage.stageHeight, ease:Sine.easeOut, onComplete:function():void 
			{
				if (callback != null)
				{
					callback();
					callback = null;
				}
			}} );
		}
		
		public function close():void
		{
			canUpdate = true;
			start();
			TweenMax.to(this, 0.6, { speed: 30, ease:Sine.easeIn } );
			TweenMax.to(planet, 0.6, { y: stage.stageHeight + (300 * Device.scale), ease:Sine.easeIn } );
		}
		
		public function stop():void
		{
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		public function start():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:EnterFrameEvent):void 
		{
			if (GameData.gamePaused == false && canUpdate==true)
			{
				var times:int = Math.ceil(e.passedTime * 60);
				times = (times > 30) ? 30 : times;
				deltaTime = e.passedTime / times;
				
				for (var i:int = 0; i < times; i++) 
				{
					for (var j:int = 0; j < starContainer.numChildren; j++) 
					{
						img = starContainer.getChildAt(j) as Image;
						img.y -= 100 * deltaTime * speed * img.scaleX;
						
						var scl:Number = (5 * (speed - 1));
						scl = (scl < 0) ? 0 : scl;
						img.height = img.absoluteHeight + scl;
						
						if (img.y < -(img.height + 10))
						{
							img.y = stage.stageHeight + img.height + 10;
						}
					}
				}
			}
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			tweenAlpha.kill();
		}
	}

}