package game.game.objects 
{
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	/**
	 * ...
	 * @author ...
	 */
	public class TitleObject extends Sprite
	{
		public var image:Image;
		public var mask:PixelMaskDisplayObject;
		public var shiny:Quad;
		public var shiny_all:Quad;
		public var tweenShiny:TweenMax;
		public var canAnimate:Boolean = false;
		
		public function TitleObject(texture:Texture) 
		{
			image = new Image(texture);
			addChild(image);
			
			pivotX = image.width / 2;
			pivotY = image.height / 2;
			
			shiny = new Quad(30, image.height, 0xffffff);
			shiny.alpha = 0.7;
			shiny.y = 3;
			shiny.rotation = deg2rad(15);
			shiny.x = -shiny.width;
			
			shiny_all = new Quad(image.width + 50, image.height + 50, 0xffffff);
			shiny_all.x = -25;
			shiny_all.y = -25;
			shiny_all.alpha = 0;
			
			mask = new PixelMaskDisplayObject(1, false);
			mask.mask = image;
			mask.addChild(shiny);
			mask.addChild(shiny_all);
			
			addChild(mask);
		}
		
		public function animateShiny():void
		{
			if (canAnimate == true)
			{
				TweenMax.killTweensOf(shiny)
				TweenMax.killTweensOf(shiny_all)
				TweenMax.killDelayedCallsTo(animateShiny);
				
				shiny.x = - shiny.width;
				shiny.alpha = 0.7;
				shiny_all.alpha = 0;
				mask.isAnimated = true;
				
				TweenMax.to(shiny_all, 0.1, {alpha:0.4, yoyo:true, repeat:1});
				tweenShiny = TweenMax.to(shiny, 0.6, { x:image.width + shiny.width, alpha:0.1, ease:Sine.easeOut, onComplete:function():void 
				{
					mask.isAnimated = false;
					shiny.x = - shiny.width;
					var delay:Number = 3 + (Math.random() * 5);
					TweenMax.delayedCall(delay, animateShiny);
				} } );
			}
		}
		
		public function open():void
		{
			shiny.x = - shiny.width;
			shiny.alpha = 0.7;
			shiny_all.alpha = 0;
			canAnimate = true;
			animateShiny();
		}
		
		public function close():void
		{
			canAnimate = false;
			
			shiny.x = - shiny.width;
			shiny.alpha = 0.7;
			shiny_all.alpha = 0;
			TweenMax.killDelayedCallsTo(animateShiny);
			if (tweenShiny)
				tweenShiny.kill();
			
			mask.isAnimated = false;
		}
	}
}