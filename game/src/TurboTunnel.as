package 
{
	import com.greensock.TweenMax;
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.display.StageAspectRatio;
	import flash.display.StageDisplayState;
	import flash.display.StageOrientation;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.StageOrientationEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.TouchscreenType;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import game.data.AnalyticsData;
	import game.data.GameData;
	
	import game.assets.Device;
	import game.data.NetworkData;
	import game.inputs.InputManager;
	import starling.core.Starling;
	import flash.events.Event;
	import game.core.Main;
	import starling.core.Starling;
	
	import game.assets.Assets;
	import game.game.sounds.SoundManager;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	[SWF(width = "1024", height = "768", frameRate = "60", backgroundColor = "#000000")]
	public class TurboTunnel extends Sprite 
	{
		private var starling:Starling;
		private var starlingCarregado:Boolean = false;
		private var orientation:Number = 0;
		
		public function TurboTunnel():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			Starling.multitouchEnabled = true;
            Starling.handleLostContext = true;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			Device.maxWidth = stage.fullScreenWidth;
			Device.maxHeight = stage.fullScreenHeight;
			Device.deviveWidth = stage.fullScreenWidth;
			Device.deviceHeight = stage.fullScreenHeight;
			Device.aspectRatio = Device.deviveWidth / Device.deviceHeight;
			Device.width = Math.ceil(768 * Device.aspectRatio);
			Device.height = 768;
			Device.relativeScale = Device.deviceHeight / Device.height;
			
			var offset:Number = (Device.width - 1024) / 2;
			offset = (offset < 0) ? 0 : offset;
			Device.stageOffset = offset;
			
			var viewPort:Rectangle = new Rectangle(0, 0, Device.deviveWidth, Device.deviceHeight);
			starling = new Starling(Main, stage, viewPort, null, "auto", "baseline");
			starling.antiAliasing = 0;
			starling.simulateMultitouch = true;
			starling.showStats = false;
			
			starling.stage.stageWidth = Device.width;
			starling.stage.stageHeight = Device.height;
			
			var os:String = Capabilities.os;
			
			AnalyticsData.initTracker(this);
			AnalyticsData.trackEvent("OS", "init", os);
			AnalyticsData.trackPage("/load");
			
			GameData.is_touch = true;//(Capabilities.touchscreenType == TouchscreenType.FINGER) ? true : false;
			GameData.is_mobile = true;
			GameData.can_exit = !GameData.is_mobile;
			
			if (GameData.is_mobile == false)
			{
				GameData.inputType = "keyboard";
				stage.addEventListener(Event.RESIZE, onResize);
				onResize();
			}else
			{
				GameData.inputType = "touch";
			}
			
			starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, function(e:Event):void 
            {
				starlingCarregado = true;
                starling.start();
				
				if (GameData.is_mobile == false)
					stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            });
			
			NativeApplication.nativeApplication.addEventListener(Event.DEACTIVATE, deactivate);
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, activate);
			
			var startOrientation:String = stage.orientation;
			if (startOrientation == StageOrientation.DEFAULT || startOrientation == StageOrientation.UPSIDE_DOWN){
				stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			}
			else{
				stage.setOrientation(startOrientation);
			}
			
			if(Stage.supportsOrientationChange) {
				stage.setAspectRatio(StageAspectRatio.LANDSCAPE);
			}
		 
			stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGING, orientationChangeListener, false, 0, true);
		}
		
		private function onResize(e:Event = null):void
		{
			var ow:Number = stage.stageWidth;
			var oh:Number = stage.stageHeight;
			var wprop:Number = ow / oh;
			
			Device.deviveWidth = (wprop >= Device.aspectRatio) ? oh * Device.aspectRatio : ow;
			Device.deviceHeight = (wprop >= Device.aspectRatio) ? oh : ow / Device.aspectRatio;
			
			var viewPortRectangle:Rectangle = new Rectangle((ow-Device.deviveWidth)/2, (oh-Device.deviceHeight)/2, Device.deviveWidth, Device.deviceHeight);
			Starling.current.viewPort = viewPortRectangle;
			
			starling.stage.stageWidth = Device.width;
			starling.stage.stageHeight = Device.height;
			
			Device.relativeScale = Device.deviceHeight / Device.height;
			
			if (starlingCarregado)
			{
				var mainsClass:Main = Main(starling.root);
				if (mainsClass)
					mainsClass.onResize();
			}
		}
		
		private function activate(e:Event):void 
		{
			if (starlingCarregado)
			{
				if (GameData.gamePaused == true)
				{
					TweenMax.resumeAll();
					SoundManager.SoundOn();
					InputManager.resume();
				}
				
				if (!GameData.pauseScreen)
					GameData.gamePaused = false;
				
				starling.start();
			}
		}

		private function deactivate(e:Event):void 
		{
			if (starlingCarregado)
			{
				var mainsClass:Main = Main(starling.root);
				if (mainsClass.game != null && mainsClass.game.loaded == true)
				{
					mainsClass.game.pause(function():void 
					{
						TweenMax.pauseAll();
					});
				}else if(mainsClass.startScreen !=null)
				{
					/*if (mainsClass.startScreen.webView)
					{
						mainsClass.startScreen.closeWebView(0.6, function():void 
						{
							TweenMax.pauseAll();
						});
					}else
					{
						TweenMax.pauseAll();
					}*/
					TweenMax.pauseAll();
				}else
				{
					TweenMax.pauseAll();
				}
				
				InputManager.pause();
				SoundManager.SoundOff();
				GameData.gamePaused = true;
				starling.stop();
			}
		}
		
		private function orientationChangeListener(e:StageOrientationEvent):void 
		{
			e.stopImmediatePropagation();
			if (e.afterOrientation == StageOrientation.DEFAULT || e.afterOrientation ==  StageOrientation.UPSIDE_DOWN) 
			{
				e.preventDefault();
			}
		}
	}
}