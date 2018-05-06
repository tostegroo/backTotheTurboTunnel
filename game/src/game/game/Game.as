package game.game 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import game.assets.Device;
	import game.data.AnalyticsData;
	import game.data.GameData;
	import game.game.hud.GameOverScreen;
	import game.game.hud.GetReadyScreen;
	import game.game.hud.PauseScreen;
	import game.game.sounds.GameMusic;
	import game.inputs.gamepads.GenericGamepad;
	import game.inputs.gamepads.Xbox360Gamepad;
	
	import game.assets.Assets;
	import game.data.NetworkData;
	import game.game.levels.Level;
	import game.game.chars.Player;
	import game.game.hud.TouchController;
	import game.game.hud.GameHUD;
	import game.game.sounds.SoundManager;
	import game.inputs.InputManager;
	
	import starling.display.Shape;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.animation.Juggler;
	import starling.events.EnterFrameEvent;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Linear;
	
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class Game extends Sprite 
	{
		public var loadedFunction:Function = null;
		private var keys:Array = [];
		
		private var time:Number = 0;
		private var deltaTime:Number;
		
		private var player:Player = null;
		
		public var level:Level;
		public var controller:TouchController;
		public var gameHUD:GameHUD;
		public var getReadyScreen:GetReadyScreen;
		public var gameOverScreen:GameOverScreen;
		public var pauseScreen:PauseScreen;
		public var loaded:Boolean = false;
		public var gameMusic:GameMusic;
		
		public var gameoverOpen:Boolean = false;
		public var getreadyOpen:Boolean = true;
		private var maxPos:Point = new Point(1000, 390);
		private var minPos:Point = new Point(170, 315);
		
		public function Game(callback:Function = null) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			player = new Player("");
			controller = new TouchController(this);
			gameHUD = new GameHUD(this);
			getReadyScreen = new GetReadyScreen();
			gameOverScreen = new GameOverScreen();
			pauseScreen = new PauseScreen();
			gameMusic = new GameMusic();
			
			if (callback != null)
				callback();
		}
		
		private function init(e:Event):void 
		{	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			minPos.x += Device.stageOffset;
			maxPos.x += Device.stageOffset;
			
			addChild(controller);
			
			addChild(gameHUD);
			
			getReadyScreen.clickFunction = gameStart;
			addChild(getReadyScreen);
			
			if (player)
				gameOverScreen.clickFunction = player.resetGame;
			
			addChild(gameOverScreen);
			
			pauseScreen.clickFunction = resume;
			addChild(pauseScreen);
			
			if(loadedFunction!=null)
				loadedFunction(this);
			
			reset(true);
		}
		
		public function afterLoad():void
		{
			loaded = true;
			
			if (getReadyScreen != null)
				getReadyScreen.open();
			
			if (GameData.is_mobile == false)
			{
				InputManager.removeAllInputs();
				InputManager.addInput("gr_continue", { keyboard:"all", gamepad:"all" }, 0, getReadyScreen.close, null, null, true);
			}
			
			InputManager.keyboard.backFunction = pause;
			
			AnalyticsData.trackPage("/game_start");
			
			SoundManager.playSound("ambience", "ambience", -1, 0.4, "sfx");
		}
		
		private function remove(e:Event):void 
		{
			removeChild(gameHUD);
			removeChild(controller);
			removeChild(gameOverScreen);
			removeChild(getReadyScreen);
			
			SoundManager.stopSound("ambience");
			gameMusic.stop();
			
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
			TweenMax.killAll();
			InputManager.keyboard.backFunction = null;
			InputManager.removeAllInputs();
			GameData.gamePaused = false;
			GameData.pauseScreen = false;
		}
		
		public function gameOver():void
		{
			gameoverOpen = true;
			AnalyticsData.trackPage("/game_over");
			InputManager.removeAllInputs();
			gameOverScreen.selectControl(0, false, false);
			
			gameOverScreen.open(function():void 
			{
				setGameOverInputs();
			});
		}
		
		public function setGameOverInputs():void
		{
			if (GameData.is_mobile == false)
			{
				var bt_s_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.START : GenericGamepad.BUTTON9;
				var bt_a_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.A : GenericGamepad.BUTTON0;
				InputManager.addInput("go_continue", { keyboard:[Keyboard.SPACE], gamepad:[bt_s_pad] }, 0, gameOverScreen.close, null, null, true);
				InputManager.addInput("left", { keyboard:[Keyboard.LEFT, Keyboard.A], gamepad:[GenericGamepad.AXIS0_NEGATIVE, GenericGamepad.POV_LEFT ] }, 0, gameOverScreen.onLeft, null, null, true);
				InputManager.addInput("right", { keyboard:[Keyboard.RIGHT, Keyboard.D], gamepad:[GenericGamepad.AXIS0_POSITIVE, GenericGamepad.POV_RIGHT ] }, 0, gameOverScreen.onRight, null, null, true);
				InputManager.addInput("up", { keyboard:[Keyboard.UP, Keyboard.W], gamepad:[GenericGamepad.AXIS1_NEGATIVE, GenericGamepad.POV_FORWARD ] }, 0, gameOverScreen.onUp, null, null, true);
				InputManager.addInput("down", { keyboard:[Keyboard.DOWN, Keyboard.S], gamepad:[GenericGamepad.AXIS1_POSITIVE, GenericGamepad.POV_BACKWARD ] }, 0, gameOverScreen.onDown, null, null, true);
				InputManager.addInput("action", { keyboard:[Keyboard.ENTER], gamepad:[bt_a_pad] }, 0, gameOverScreen.onAction, null, null, true);	
			}
		}
		
		public function replay():void
		{
			reset(false);
			gameStart();
		}
		
		public function reset(usebats:Boolean = false):void
		{
			player.maxPos = new Point(maxPos.x, stage.stageHeight - maxPos.y);
			player.minPos = new Point(minPos.x, stage.stageHeight - minPos.y);
			player.x = minPos.x;
			player.y = stage.stageHeight - (minPos.y + ((maxPos.y - minPos.y) / 2));
			player.realY = player.y;
			
			if (level)
			{
				TweenMax.killAll();
				level.reset();
				removeChild(level);
				level.dispose();
				level = null;
			}
			level = new Level(player, usebats);
			addChildAt(level, 0);
			
			gameHUD.reset();
			player.reset();
		}
		
		public function setPlayerInputs():void
		{
			InputManager.removeAllInputs();
			if (player)
			{
				controller.tapPress = player.jump;
				controller.tapRelease = player.stopJump;
				//controller.onMoveX = player.moveX;
				controller.onMoveY = player.moveY;
				//controller.stopMoveX = player.stopMoveX;
				controller.stopMoveY = player.stopMoveY;
				
				if (GameData.is_mobile == false)
				{
					var bt_a_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.A : GenericGamepad.BUTTON0;
					InputManager.addInput("jump", { keyboard:Keyboard.SPACE, gamepad:[bt_a_pad] }, 0, player.jump, player.stopJump, null, true);
					InputManager.addInput("left", { keyboard:[Keyboard.LEFT, Keyboard.A], gamepad:[GenericGamepad.AXIS0_NEGATIVE, GenericGamepad.POV_LEFT ] }, 0, player.moveLeft, player.stopMoveX, null, false);
					InputManager.addInput("right", { keyboard:[Keyboard.RIGHT, Keyboard.D], gamepad:[GenericGamepad.AXIS0_POSITIVE, GenericGamepad.POV_RIGHT ] }, 0, player.moveRight, player.stopMoveX, null, false);
					InputManager.addInput("up", { keyboard:[Keyboard.UP, Keyboard.W], gamepad:[GenericGamepad.AXIS1_NEGATIVE, GenericGamepad.POV_FORWARD ] }, 0, player.moveUp, player.stopMoveY, null, false);
					InputManager.addInput("down", { keyboard:[Keyboard.DOWN, Keyboard.S], gamepad:[GenericGamepad.AXIS1_POSITIVE, GenericGamepad.POV_BACKWARD ] }, 0, player.moveDown, player.stopMoveY, null, false);
					
					var bt_b_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.BACK : GenericGamepad.BUTTON8;
					InputManager.addInput("d_up", { keyboard:[Keyboard.Z], gamepad:[bt_b_pad] }, 0, level.actionLayer.toggleUpdate, null, null, true);
					//InputManager.addInput("moveX", { gamepad:GenericGamepad.AXIS0 }, 0, null, null, player.moveX, false);
					//InputManager.addInput("moveY", { gamepad:GenericGamepad.AXIS1 }, 0, null, null, player.moveY, false);
				}
			}
			
			if (GameData.is_mobile == false)
			{
				var bt_s_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.START : GenericGamepad.BUTTON9;
				InputManager.addInput("pause", { keyboard:Keyboard.P, gamepad:bt_s_pad }, 0, pause, null, null, true);
			}
		}
		
		public function gameStart():void
		{
			if (getReadyScreen)
			{
				removeChild(getReadyScreen);
				getReadyScreen = null;
				
				if (level.batColony)
				{
					TweenMax.delayedCall(0.1, function():void 
					{
						SoundManager.playSound("bats");
						level.batColony.flybats();
					});
				}
				gameHUD.counter(0);
			}
			setPlayerInputs();
			
			player.run();
			
			getreadyOpen = false;
			gameoverOpen = false;
			
			gameMusic.play();
			
			AnalyticsData.trackPage("/playing");
		}
		
		public function stop():void
		{
			this.visible = false;
			if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, update);
		}
		
		public function start():void
		{
			this.visible = true;
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		public function pause(callback:Function = null):void
		{
			if (GameData.gamePaused==false && pauseScreen && gameoverOpen == false && getreadyOpen == false)
			{
				gameHUD.stopCounter();
				GameData.gamePaused = true;
				GameData.pauseScreen = true;
				
				SoundManager.pauseSound("ambience");
				gameMusic.pause();
				
				if (player)
					player.pause();
				
				SoundManager.playSound("musicPause", "musicPause", -1, 0.4, "music");
				AnalyticsData.trackPage("/pause_screen");
				if (this.hasEventListener(Event.ENTER_FRAME)) this.removeEventListener(Event.ENTER_FRAME, update);
				InputManager.removeAllInputs();
				pauseScreen.open(function():void 
				{
					InputManager.keyboard.backFunction = resume;
					if (GameData.is_mobile == false)
					{
						var bt_a_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.A : GenericGamepad.BUTTON0;
						InputManager.addInput("p_left", { keyboard:[Keyboard.LEFT, Keyboard.A], gamepad:[GenericGamepad.AXIS0_NEGATIVE, GenericGamepad.POV_LEFT ] }, 0, pauseScreen.onLeft, null, null, true);
						InputManager.addInput("p_right", { keyboard:[Keyboard.RIGHT, Keyboard.D], gamepad:[GenericGamepad.AXIS0_POSITIVE, GenericGamepad.POV_RIGHT ] }, 0, pauseScreen.onRight, null, null, true);
						InputManager.addInput("p_up", { keyboard:[Keyboard.UP, Keyboard.W], gamepad:[GenericGamepad.AXIS1_NEGATIVE, GenericGamepad.POV_FORWARD ] }, 0, pauseScreen.onUp, null, null, true);
						InputManager.addInput("p_down", { keyboard:[Keyboard.DOWN, Keyboard.S], gamepad:[GenericGamepad.AXIS1_POSITIVE, GenericGamepad.POV_BACKWARD ] }, 0, pauseScreen.onDown, null, null, true);
						InputManager.addInput("p_action", { keyboard:[Keyboard.ENTER, Keyboard.SPACE], gamepad:[bt_a_pad] }, 0,	pauseScreen.action, null, null, true);
						var bt_s_pad:int = (GameData.inputType == "gamepadXbox") ? Xbox360Gamepad.START : GenericGamepad.BUTTON9;
						InputManager.addInput("pause", { keyboard:Keyboard.P, gamepad:bt_s_pad }, 0, pauseScreen.close, null, null, true);
					}
					
					if (callback != null)
						callback();
				});
			}else
			{
				if (callback != null)
						callback();
			}
		}
		
		public function resume():void
		{
			if (GameData.gamePaused==true && pauseScreen)
			{
				SoundManager.resumeSound("ambience");
				SoundManager.stopSound("musicPause");
				
				gameHUD.counter(3, function():void 
				{
					gameMusic.resume();
					
					if (player)
						player.resume();
					
					AnalyticsData.trackPage("/playing");
					setPlayerInputs();
					addEnterFrame();
				});
				
				GameData.gamePaused = false;
				GameData.pauseScreen = false;
			}
		}
		
		private function addEnterFrame():void
		{
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(e:EnterFrameEvent):void 
		{
			if (GameData.gamePaused == false)
			{
				var times:int = Math.ceil(e.passedTime * 60);
				times = (times > 30) ? 30 : times;
				deltaTime = e.passedTime / times;
				
				for (var i:int = 0; i < times; i++) 
				{
					if(player)
						player.update(deltaTime);
					
					if(level)
						level.update(deltaTime);
						
					if(player)
						player.validateUpdate(deltaTime);
					
					
					var minp:Number = stage.stageHeight - minPos.y;
					var maxp:Number = stage.stageHeight - maxPos.y;
					
					if (gameMusic)
						gameMusic.setVolume(-((minp - player.y) / (maxp - minp)));
				}
			}
		}
	}
}