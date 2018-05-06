package game.core 
{
	import com.greensock.TweenMax;
	import flash.data.SQLResult;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import game.assets.Device;
	import game.game.Loader;
	import game.utils.math.MathHelper;
	
	import game.assets.Assets;
	import game.data.GameData;
	import game.game.Game;
	import game.game.Intro;
	import game.game.sounds.SoundManager;
	import game.inputs.InputManager;
	import game.loader.PreLoader;
	import game.game.StartScreen;
	import starling.core.Starling;
	import starling.display.Shape;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class Main extends Sprite 
	{	
		public var loader:Loader;
		public var intro:Intro;
		public var game:Game;
		public var startScreen:StartScreen;
		public var preLoader:PreLoader;
		public var gameContainer:Sprite;
		
		public var scanlines:flash.display.Sprite;
		
		public function Main() 
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			GameData.main = this;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			InputManager.init(Starling.current.nativeStage);
			if (InputManager.gamepads && InputManager.gamepads.gamepad && InputManager.gamepads.gamepad.length > 0)
			{
				InputManager.gamepads.gamepad[0].useStickAsPOV = true;
				InputManager.gamepads.gamepad[0].stickPOVTolerance = 0.8;
			}
			
			var texture:Bitmap = new Assets.scanlinesTexture();
			texture.smoothing = false;
			
			/*if (Device.deviceHeight >= 480)
			{
				var ww:Number = Device.maxWidth;
				var hh:Number = Device.maxHeight;
				
				scanlines = new flash.display.Sprite();
				scanlines.graphics.beginBitmapFill(texture.bitmapData);
				scanlines.graphics.moveTo(0, 0);
				scanlines.graphics.lineTo(ww, 0);
				scanlines.graphics.lineTo(ww, hh);
				scanlines.graphics.lineTo(0, hh);
				scanlines.graphics.endFill();
				scanlines.mouseEnabled = false;
				scanlines.alpha = 0.3;
				Starling.current.nativeStage.addChild(scanlines);
			}*/
			
			gameContainer = new Sprite();
			addChild(gameContainer);
			
			preLoader = new PreLoader();
			preLoader.x = 0;
			preLoader.y = 0;
            addChild(preLoader);
			
			GameData.createDBConnection(function():void 
			{
				GameData.getHiscore(function(hiscore:int = 0):void
				{
					GameData.hiscore = hiscore;
				});
				GameData.getName(function(name:String = ""):void
				{ 
					GameData.userName = name;
				});
				GameData.getNick(function(name:String = "AAA"):void
				{
					GameData.nick = name;
				});
				GameData.getNID(function(id:String = ""):void
				{
					GameData.uid = id;
				});
				
				GameData.getVolume(function(sfx:Number = 0.7, music:Number = 0.7):void 
				{
					SoundManager.music_volume = music;
					SoundManager.sfx_volume = sfx;
					
					changeScene("loader");
				} );
			});
		}
		
		public function changeScene(scene:String = "intro", stopAllSounds:Boolean = true):void
		{
			if (stopAllSounds == true)
			{
				SoundManager.stopSound("all");
				SoundManager.stopSound("ambience");
			}
			
			if (scene == "start" || scene=="startSkip" || scene == "intro" || scene == "loader")
			{
				changeScreen(scene);
			}else
			{
				if(preLoader)
					preLoader.open();
				
				TweenMax.killDelayedCallsTo(changeScreen);
				TweenMax.delayedCall(1, changeScreen, [scene]);
			}
		}
		
		private function changeScreen(scene:String = "intro"):void
		{
			GameData.gamePaused = false;
			if (loader)
			{
				gameContainer.removeChild(loader);
				loader.dispose();
				loader = null;
			}
			
			if (game)
			{
				gameContainer.removeChild(game);
				game.dispose();
				game = null;
				//Assets.disposeTextureAtlas('level');
			}
			
			if (intro)
			{
				gameContainer.removeChild(intro);
				intro.dispose();
				intro = null;
				//Assets.disposeTextureAtlas('hud');
			}
			
			if (startScreen)
			{
				gameContainer.removeChild(startScreen);
				startScreen.dispose();
				startScreen = null;
			}
			
			switch (scene)
			{
				case "game":
					game = new Game();
					game.loadedFunction = disposeLoader;
					preLoader.onComplete = game.afterLoad;
					gameContainer.addChild(game);
					game.start();
					break;
				case "intro":
					intro = new Intro();
					intro.loadedFunction = disposeLoader;
					gameContainer.addChild(intro);
					intro.start();
					break;
				case "start":
					startScreen = new StartScreen(false);
					startScreen.loadedFunction = disposeLoader;
					gameContainer.addChild(startScreen);
					startScreen.start();
					break;
				case "startSkip":
					startScreen = new StartScreen(true);
					startScreen.loadedFunction = disposeLoader;
					gameContainer.addChild(startScreen);
					startScreen.start();
					break;
				case "loader":
					loader = new Loader();
					loader.loadedFunction = disposeLoader;
					gameContainer.addChild(loader);
					loader.start();
					break;
			}
		}
		
		private function disposeLoader(e:*):void 
		{
			if(preLoader)
				preLoader.close();
			
			e.loadedFunction = null;
		}
		
		public function onResize():void
		{
			if(startScreen!=null)
				startScreen.onResize();
		}
	}
}