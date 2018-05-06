package game.game.hud 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import game.assets.Device;
	import game.game.objects.MenuButton;
	import starling.display.Quad;

	import game.assets.Assets;
	import game.data.GameData;
	import game.game.Game;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class GameHUD extends Sprite
	{
		private var game:Game = null; 
		public var points:int = 0;
		private var bt_pause:MenuButton;
		public var totalFont:BitmapFont;
		public var textFont:BitmapFont;
		public var total:TextField;
		public var count:TextField;
		public var countTimer:TweenMax;
		public var timeToCount:Number = 0;
		
		private static var instance:GameHUD = null;
		public static function getInstance():GameHUD
		{
			if (GameHUD.instance == null) GameHUD.instance = new GameHUD();
				return GameHUD.instance;
		}
		
		public function GameHUD(game:Game = null) 
		{
			this.game = game;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			totalFont = Assets.getFont("textHUD");
			totalFont.smoothing = TextureSmoothing.TRILINEAR;
			
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			GameData.points = points;
			total = new TextField(300, 110, "0", totalFont.name, 100, 0xffffff);
			total.pivotY = 50;
			total.pivotX = 150;
			total.hAlign = HAlign.CENTER;
			total.vAlign = VAlign.CENTER;
			total.x = stage.stageWidth/2;
			total.y = Math.floor(90 * Device.scale);
			this.addChild(total);
			
			bt_pause = new MenuButton(Assets.getAtlas('interface_hud').getTexture('bt_pause'), Assets.getAtlas('interface_hud').getTexture('bt_pause_over'), new Point(4, 108));
			bt_pause.scaleX = bt_pause.scaleY = 0.8;
			bt_pause.x = Math.floor(stage.stageWidth - (bt_pause.button.width) - 38);
			bt_pause.y = Math.floor((38 * Device.scale));
			bt_pause.clickFunction = GameData.main.game.pause;
			addChild(bt_pause);
			bt_pause.overOut(false);
			
			count = new TextField(300, 200, "0", textFont.name, 180, 0xffffff);
			count.pivotY = 90;
			count.pivotX = 150;
			count.hAlign = HAlign.CENTER;
			count.vAlign = VAlign.CENTER;
			count.x = stage.stageWidth/2;
			count.y = stage.stageHeight / 2;
			count.alpha = 0;
			count.visible = false;
			this.addChild(count);
		}
		
		public function counter(countTimes:Number = 3, callback:Function = null):void
		{
			if(countTimer!=null)
				countTimer.kill();
			
			timeToCount = countTimes;
			var txta:String = (countTimes == 0) ? "go!" : countTimes.toString();
			count.text = txta;
			
			TweenMax.to(count, 0, {autoAlpha:1, scaleX:2, scaleY:2});
			countTimer = TweenMax.to(count, 0.5, { autoAlpha:0, scaleX:1, scaleY:1, repeat:countTimes, ease:Sine.easeOut, onRepeat:function():void 
			{
				var txt:String = String(Number(count.text) - 1);
				txt = (txt == "0") ? "go!" : txt;
				count.text = txt;
			}, onComplete:function():void 
			{
				if (callback != null)
					callback();
			}});
		}
		
		public function stopCounter():void
		{
			if(countTimer!=null)
				countTimer.kill();
			
			TweenMax.to(count, 0, { autoAlpha:0 } );
		}
		
		public function updatePoint(value:int = 0):void
		{
			points += value;
			TweenMax.killTweensOf(total);
			TweenMax.to(total, 0.1, { scaleX:1.2, scaleY:1.2, yoyo:true, repeat:1, ease:Sine.easeInOut } );
			total.text = points.toString();
			GameData.points = points;
			GameData.position += 1;
		}
		
		public function reset():void
		{
			points = 0;
			total.text = points.toString();
			GameData.points = points;
			GameData.position = 1;
		}
		
		private function remove(e:Event):void 
		{
			game = null;
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}