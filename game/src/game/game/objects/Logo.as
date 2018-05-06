package game.game.objects 
{
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import game.assets.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Logo extends Sprite
	{
		private var logoImages:Array = [
			{name:"logo_bg1", texture:"logo_bg", x:100, y:120, xini:100, yini:120, scale:2.3, scaleini:2.3, alpha:1, alphaini:0, time:1, delay:1, ease:Linear, pivot:0.5 },
			{texture:"logo_bg", x:100, y:120, xini:100, yini:120, scale: -1, scaleini: -1, alpha:1, alphaini:0, time:1, delay:1, ease:Linear, pivot:0.5 },
			{texture:"logo_back_p5", x:296, y:17, xini:396, yini:17, time:0.8, delay:1.1, alpha:1, alphaini:0 },
			{texture:"logo_back_p4", x:287, y:17, xini:387, yini:17, time:0.8, delay:1, alpha:1, alphaini:0 },
			{texture:"logo_back_p3", x:276, y:16, xini:376, yini:16, time:0.8, delay:0.9, alpha:1, alphaini:0 },
			{texture:"logo_back_p2", x:261, y:16, xini:361, yini:16, time:0.8, delay:0.8, alpha:1, alphaini:0 },
			{texture:"logo_back_p1", x:221, y:8, xini:321, yini:8, time:0.8, delay:0.7, alpha:1, alphaini:0 },
			{texture:"logo_back", x:38, y:2, xini:-120, yini:2, time:0.8, delay:0, alpha:1, alphaini:0 },
			{texture:"logo_to", x:45, y:72, xini:-100, yini:72, time:0.7, delay:0.8, alpha:1, alphaini:0 },
			{texture:"logo_the", x:48, y:101, xini:-110, yini:101, time:0.7, delay:1, alpha:1, alphaini:0 },
			{texture:"logo", x:0, y:83, xini:0, yini:83, time:0.8, scale:1, scaleini:0, delay:1, pivot:0.5, easeParams:[1.2, 0.4]},
			{texture:"logo_name", x:18, y:79, xini:18, yini:79, time:0.8, scale:1, scaleini:0, delay:1, pivot:0.5, easeParams:[1.2, 0.4] },
			{texture:"logo_arrow_p7", x:202, y:352, xini:160, yini:352, time:0.8, delay:1.6, alpha:1, alphaini:0, easeParams:[1.5, 0.3] },
			{texture:"logo_arrow_p6", x:161, y:369, xini:141, yini:369, time:0.8, delay:1.5, alpha:1, alphaini:0 },
			{texture:"logo_arrow_p5", x:140, y:371, xini:120, yini:371, time:0.8, delay:1.4, alpha:1, alphaini:0 },
			{texture:"logo_arrow_p4", x:121, y:373, xini:101, yini:373, time:0.8, delay:1.3, alpha:1, alphaini:0 },
			{texture:"logo_arrow_p3", x:110, y:374, xini:90, yini:374, time:0.8, delay:1.2, alpha:1, alphaini:0 },
			{texture:"logo_arrow_p2", x:93, y:374, xini:73, yini:374, time:0.8, delay:1.1, alpha:1, alphaini:0 },
			{texture:"logo_arrow_p1", x:32, y:293, xini:32, yini:293, time:0.8, delay:1, alpha:1, alphaini:0 }
		];
		
		public function Logo() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			var img:Image;
			var totalImages:int = logoImages.length
			for (var i:int = 0; i < logoImages.length; i++) 
			{
				img = new Image(Assets.getAtlas('interface', 1).getTexture(logoImages[i].texture));
				//img.smoothing = TextureSmoothing.NONE;
				
				if (logoImages[i].hasOwnProperty("pivot"))
				{
					img.pivotX = img.width * logoImages[i].pivot;
					img.pivotY = img.height * logoImages[i].pivot;
				}
				
				img.x = logoImages[i].xini + img.pivotX;
				img.y = logoImages[i].yini + img.pivotY;
				
				if (logoImages[i].hasOwnProperty("scaleini"))
					img.scaleX = img.scaleY = logoImages[i].scaleini;
				
				if (logoImages[i].hasOwnProperty("alphaini"))
					img.alpha = logoImages[i].alphaini;
				
				img.name = (logoImages[i].hasOwnProperty("name")) ? logoImages[i].name : logoImages[i].texture;
				
				addChild(img);
			}
			this.pivotX = (this.width / 2) - 140;
		}
		
		public function open(time:Number = 0):void
		{
			var img:Image;
			for (var i:int = 0; i < numChildren; i++) 
			{
				img = getChildAt(i) as Image;
				var scl:Number = (logoImages[i].hasOwnProperty("scale")) ? logoImages[i].scale : 1;
				
				var xx:Number = logoImages[i].x + img.pivotX;
				var yy:Number = logoImages[i].y + img.pivotY;
				
				var ease:* = (logoImages[i].hasOwnProperty("ease")) ? logoImages[i].ease : Elastic.easeOut;
				var params:Array = (logoImages[i].hasOwnProperty("easeParams")) ? logoImages[i].easeParams : [];
				
				var alpha:Number = (logoImages[i].hasOwnProperty("alpha")) ? logoImages[i].alpha : 1;
				
				TweenMax.to(img, logoImages[i].time, {x:xx, y:yy, alpha:alpha, scaleX:scl, scaleY:scl, delay:logoImages[i].delay, ease:ease, easeParams:params } );
			}
			
			img = getChildByName("logo_name") as Image;
			TweenMax.to(img, 1, { y:69 + img.pivotY, delay:2.1, ease:Elastic.easeOut, easeParams:[1.2, 0.3] } );
			
			img = getChildByName("logo_bg") as Image;
			TweenMax.to(img, 10, { scaleX:-2.8, scaleY:-2.8, delay:1.5, alpha:0, ease:Sine.easeInOut, repeat: -1 } );
			
			img = getChildByName("logo_bg1") as Image;
			TweenMax.to(img, 8, { scaleX:2, scaleY:2, delay:1, rotation:Math.PI / 25, ease:Sine.easeInOut, repeat: -1, yoyo:true } );
			
			img = getChildByName("logo_name") as Image;
			TweenMax.to(img, 0.8, { scaleX:0.985, scaleY:1.015, delay:2.1, ease:Sine.easeInOut, repeat: -1, yoyo:true } );
			
			img = getChildByName("logo") as Image;
			TweenMax.to(img, 0.8, { scaleX:0.99, scaleY:1.01, delay:2.1, ease:Sine.easeInOut, repeat: -1, yoyo:true } );
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}