package game.loader 
{
	import com.greensock.TweenMax;
	import game.assets.Assets;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.TextureSmoothing;
	/**
	 * ...
	 * @author eu mesmo
	 */
	public class Fly extends Sprite
	{
		private var fly_f1:Image;
		private var fly_f2:Image;
		private var tweenFly1:TweenMax;
		private var tweenFly2:TweenMax;
		
		public function Fly() 
		{
			fly_f1 = new Image(Assets.getAtlas('preloader', 1).getTexture('fly_1'));
			fly_f1.smoothing = TextureSmoothing.NONE;
			fly_f1.alpha = 1;
			fly_f1.x = -fly_f1.width / 2;
			fly_f1.y = -fly_f1.height / 2;
			fly_f1.scaleX = fly_f1.scaleY = 0.3;
			addChild(fly_f1);
			
			fly_f2 = new Image(Assets.getAtlas('preloader', 1).getTexture('fly_2'));
			fly_f2.smoothing = TextureSmoothing.NONE;
			fly_f2.alpha = 0;
			fly_f2.x = fly_f1.x;
			fly_f2.y = fly_f2.x;
			fly_f2.scaleX = fly_f2.scaleY = fly_f1.scaleX;
			addChild(fly_f2);
		}
		
		public function resume():void
		{
			tweenFly2 = TweenMax.to(fly_f2, 0.05, { alpha:1, repeat:-1, yoyo:true } );
			tweenFly1 = TweenMax.to(fly_f1, 0.05, { alpha:0, repeat:-1, yoyo:true } );
		}
		
		public function pause():void
		{
			if (tweenFly1)
				tweenFly1.kill();
			
			if (tweenFly2)
				tweenFly2.kill();
		}
	}
}