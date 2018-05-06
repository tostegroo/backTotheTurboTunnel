package game.game.objects 
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	
	import game.assets.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Planet extends Sprite
	{
		public var smokeTween:TweenMax;
		public var smokeSprite:Vector.<Sprite> = new Vector.<Sprite>();
		public var tween:TweenMax;
		
		public var planet:Image;
		
		public var smokes:Vector.<Object> = new <Object>[
			{texture:"smoke_big", rotation:-20, xoffset: -200, y:10, delay:0, time:20 },
			{texture:"smoke_big", rotation: -20, xoffset: -200, y:10, delay:6.5, time:20 },
			{texture:"smoke_big", rotation:-20, xoffset:-200, y:10, delay:9.5, time:20 },
			{texture:"smoke_big", rotation:20, xoffset:200, y:10, delay:0, time:20 },
			{texture:"smoke_big", rotation:20, xoffset:200, y:10, delay:6.5, time:20 },
			{texture:"smoke_big", rotation:20, xoffset:200, y:10, delay:9.5, time:20 },
			{texture:"smoke_small", rotation:0, xoffset:0, delay:0.5, y:80, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:-20, xoffset:-300, delay:1, y:40, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:20, xoffset:300, delay:1, y:40, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:-20, xoffset:-450, delay:1, y:30, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:20, xoffset:450, delay:1.5, y:30, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:0, xoffset:0, delay:2, y:80, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:-20, xoffset:-200, delay:3, y:50, scale:1.2, time:15 },
			{texture:"smoke_small", rotation:20, xoffset:200, delay:2, y:50, scale:1.2, time:15 }
		];
		
		public function Planet() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			planet = new Image(Assets.getAtlas('interface_intro', 1).getTexture("planet"));
			planet.scaleX = planet.scaleY = 1.2;
			planet.x = -planet.width/2;
			planet.y = -planet.height;
			
			var img:Image;
			var spt:Sprite;
			for (var i:int = 0; i < smokes.length; i++) 
			{
				var yy:Number = (smokes[i].hasOwnProperty("y")) ? smokes[i].y : 0;
				
				spt = new Sprite();
				smokeSprite.push(spt);
				img = new Image(Assets.getAtlas('interface_intro', 1).getTexture(smokes[i].texture));
				img.alpha = 0.4;
				img.scaleX = img.scaleY = (smokes[i].hasOwnProperty("scale")) ? smokes[i].scale : 1;
				img.y = -(img.height * 1.15) - yy;
				img.x = -img.width * 0.5;
				spt.x = smokes[i].xoffset;
				spt.alpha = 0;
				
				spt.addChild(img);
				addChild(spt);
				
				animate(i, spt, smokes[i].delay);
			}
			addChild(planet);
		}
		
		public function animate(index:int = 0, spt:Sprite = null, delay:Number = 0):void
		{
			spt.scaleX = spt.scaleY = 0.9;
			spt.y = planet.height + 40;
			spt.rotation = deg2rad(0);
			tween = TweenMax.to(spt, 3, { rotation:deg2rad(smokes[index].rotation/5), scaleX:0.91, scaleY:0.91, alpha:1, ease:Sine.easeIn, delay:delay, onComplete:function(spt:Sprite, index:int):void 
			{
				var time:Number = smokes[index].time;
				tween = TweenMax.to(spt, time, { rotation:deg2rad(smokes[index].rotation), scaleX:1.1, scaleY:1.1, alpha:0, y:planet.height-20, ease:Sine.easeOut, onComplete:function(spt:Sprite, index:int):void 
				{
					var rnd:Number = Math.random() * 0.7;
					animate(index, spt, rnd);
				}, onCompleteParams:[spt, index] } );
			}, onCompleteParams:[spt, index]});
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			tween.kill();
		}
	}
}