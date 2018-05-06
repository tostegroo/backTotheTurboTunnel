package game.game 
{
	import com.greensock.TweenMax;
	import game.assets.Assets;
	import game.data.GameData;
	import game.game.sounds.SoundManager;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author ...
	 */
	public class Loader extends Sprite
	{
		public var loadedFunction:Function = null;
		
		private var bootStrings:Array = [
			{device:"RAM", 		status:"OK"},
			{device:"CPU1", 	status:"OK"},
			{device:"CPU2", 	status:"OK"},
			{device:"SOUND", 	status:"OK"},
			{device:"TOADS", 	status:"OK"}
		];
		public static var bootStatus:Vector.<TextField> = new Vector.<TextField>();
		private var textFont:BitmapFont;
		private var txt:TextField;
		private var bootScreen:Sprite;
		
		public function Loader() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			createBoot();
			
			if(loadedFunction!=null)
				loadedFunction(this);
			
			TweenMax.delayedCall(0.2, animateBoot);
		}
		
		private function createBoot():void
		{
			bootScreen = new Sprite();
			
			var ypos:Number = 0;
			for (var i:int = 0; i < bootStrings.length; i++) 
			{
				txt = new TextField(220, 50,  bootStrings[i].device, textFont.name, 40, 0xFFFFFF);
				txt.hAlign = HAlign.LEFT;
				txt.x = 0;
				txt.y = ypos;
				bootScreen.addChild(txt);
				
				txt = new TextField(60, 50,  bootStrings[i].status, textFont.name, 40, 0xFFFFFF);
				txt.hAlign = HAlign.LEFT;
				txt.visible = false;
				txt.x = 220;
				txt.y = ypos;
				bootStatus.push(txt);
				bootScreen.addChild(txt);
				
				ypos += 50;
			}
			bootScreen.x = (stage.stageWidth - bootScreen.width) / 2;
			bootScreen.y = ((stage.stageHeight - bootScreen.height) / 2) - 20;
			
			addChild(bootScreen);
		}
		
		private function animateBoot(idx:int = 0):void
		{
			if (idx == 0) 
			{
				statusOK(idx, 0.5);
			}else if (idx == 1) 
			{
				var introdummy:Intro = new Intro(function():void 
				{
					statusOK(idx, 0.4);
				});
			}else if (idx == 2)
			{
				var startdummy:StartScreen = new StartScreen(false, function():void 
				{
					statusOK(idx, 0.4);
				});
			}else if (idx == 3)
			{
				var gamedummy:Game = new Game(function():void 
				{
					statusOK(idx, 2);
				});
			}else if (idx == 4)
			{
				statusOK(4);
				TweenMax.to(bootScreen, 0.3, { alpha:0 , delay:1, onComplete:function():void 
				{
					GameData.main.changeScene("intro");
				}});
			}
			
		}
		
		private function statusOK(idx:int = 0, delay:Number = 0):void 
		{
			bootStatus[idx].visible = true;
			SoundManager.playSound("ok", "ok");
			
			if (idx < bootStatus.length - 1)
				TweenMax.delayedCall(delay, animateBoot, [idx + 1]); 
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			TweenMax.killAll();
		}
		
		public function stop():void
		{
			this.visible = false;
		}
		
		public function start():void
		{
			this.visible = true;
		}
	}

}