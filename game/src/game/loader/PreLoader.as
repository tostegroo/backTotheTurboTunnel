package game.loader 
{
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quint;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import game.game.sounds.SoundManager;
	import org.flashdevelop.utils.FlashConnect;
	import game.game.objects.TitleObject;
	import game.utils.math.MathHelper;
	import starling.display.Quad;
	import starling.display.Sprite;
	import game.assets.Assets;
	import game.assets.Device;
	import starling.display.Image;
	import starling.events.Event;
	import starling.text.BitmapFont;
	import starling.text.TextField;
	import starling.textures.TextureSmoothing;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class PreLoader extends Sprite
	{
		private var background:Quad;
		private var frogSprite:Sprite;
		private var frog:Image;
		private var frame0:Image;
		private var frame1:Image;
		private var frame2:Image;
		private var tung:Image;
		private var tungContainer:Sprite;
		private var smoke:Image;
		private var smoke2:Image;
		private var eye1:Image;
		private var eye2:Image;
		private var title:TitleObject;
		private var fly:Fly;
		private var tweenFly:TweenMax;
		private var tweenEye1:TweenMax;
		private var tweenEye2:TweenMax;
		private var tweenFrog:TweenMax;
		private var tweenTung:TweenMax;
		private var particles:Sprite;
		private var txt:TextField;
		private var textFont:BitmapFont;
		
		private var xt:Number;
		private var yt:Number;
		private var xpos:Number;
		private var ypos:Number;
		
		public var onComplete:Function = null;
		
		private var isFinish:Boolean = false;
		private var tweenAni:TweenMax;
		
		private var frames:Object = { totalFrames:3, frame:0 };
		private var frogframes:Vector.<Image> = new Vector.<Image>();
		
		public function PreLoader() 
		{
			textFont = Assets.getFont("textDisplay");
			textFont.smoothing = TextureSmoothing.TRILINEAR;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			background = new Quad(stage.stageWidth, stage.stageHeight, 0x000000);
			addChild(background);
			
			title = new TitleObject(Assets.getAtlas('preloader', 1).getTexture('text'));
			title.x = (stage.stageWidth/ 2) + 20;
			title.y = 470 * Device.scale;
			addChild(title);
			
			txt = new TextField(900, 70, "Friendly Reminder! See how many toads died at\n bogdoggames.com/turbotunnel", textFont.name, 30, 0xe9e9e9);
			txt.alpha = 0.8;
			txt.hAlign = HAlign.CENTER;
			txt.x = (stage.stageWidth - txt.width) / 2;
			txt.y = 570 * Device.scale;
			addChild(txt);
			
			frog = new Image(Assets.getAtlas('preloader', 1).getTexture('frog_body'));
			frog.y = 70;
			
			frame0 = new Image(Assets.getAtlas('preloader', 1).getTexture('frog_f0'));
			frame0.x = 23.8;
			frame0.y = 0;
			frame0.visible = true;
			frogframes.push(frame0);
			
			frame1 = new Image(Assets.getAtlas('preloader', 1).getTexture('frog_f1'));
			frame1.x = 23.8;
			frame1.y = 0;
			frame1.visible = false;
			frogframes.push(frame1);
			
			frame2 = new Image(Assets.getAtlas('preloader', 1).getTexture('frog_f2'));
			frame2.x = 23.8;
			frame2.y = -9;
			frame2.visible = false;
			frogframes.push(frame2);
			
			frogSprite = new Sprite();
			frogSprite.pivotX = frog.width / 2;
			frogSprite.pivotY = 161;
			frogSprite.x = ((stage.stageWidth/ 2)) - (5 * Device.scale);
			frogSprite.y = 410 * Device.scale;
			
			frogSprite.scaleX = 0.98;
			addChild(frogSprite);
			
			frogSprite.addChild(frame0);
			frogSprite.addChild(frame1);
			frogSprite.addChild(frame2);
			frogSprite.addChild(frog);
			
			eye1 = new Image(Assets.getAtlas('preloader', 1).getTexture('eye'));
			eye1.x = 55;
			eye1.y = 4;
			frogSprite.addChild(eye1);
			
			eye2 = new Image(Assets.getAtlas('preloader', 1).getTexture('eye'));
			eye2.x = 75;
			eye2.y = 4;
			frogSprite.addChild(eye2);
			
			tungContainer = new Sprite();
			tungContainer.x = 80;
			tungContainer.y = 57;
			frogSprite.addChild(tungContainer);
			
			tung = new Image(Assets.getAtlas('preloader', 1).getTexture('tung'));
			tung.pivotX = tung.width / 2;
			tung.pivotY = tung.height;
			tung.scaleX = 1.2;
			tung.height = 0;
			tung.alpha = 1;
			tungContainer.addChild(tung);
			
			xt = ((frogSprite.x - (frogSprite.width / 2)) + 100);
			yt = ((frogSprite.y - frogSprite.height) + 26);
			
			smoke = new Image(Assets.getAtlas('preloader', 1).getTexture('smoke'));
			smoke.width = 540;
			smoke.height = 156;
			smoke.x = (((stage.stageWidth - smoke.width) / 2)) - (23 * Device.scale);
			smoke.y = 288 * Device.scale;
			addChild(smoke);
			
			smoke2 = new Image(Assets.getAtlas('preloader', 1).getTexture('smoke'));
			smoke2.width = 540;
			smoke2.height = 156;
			smoke2.x = (((stage.stageWidth - smoke.width) / 2)) - (23 * Device.scale);
			smoke2.y = 288 * Device.scale;
			addChild(smoke2);
			
			fly = new Fly();
			fly.x = (stage.stageWidth / 2) - (200 * Device.scale) + (Math.random() * (400 * Device.scale));
			fly.y = 150 * Device.scale;
			addChild(fly);
			
			createParticles();
			
			TweenMax.to(this, 0, { autoAlpha:0 } );
		}
		
		private function createParticles():void
		{
			particles = new Sprite();
			particles.x = 50;
			particles.y = 33;
			
			var img:Image;
			for (var i:int = 0; i < 4; i++) 
			{
				img = new Image(Assets.getAtlas('preloader', 1).getTexture('particle'));
				img.scaleX = img.scaleY = 0.1 + (Math.random() * 0.1);
				img.pivotX = img.width / 2;
				img.pivotY = img.height / 2;
				img.alpha = 0;
				img.y = -3 * i;
				img.x = 15 * i;
				particles.addChild(img);
			}
			frogSprite.addChild(particles);
		}
		
		private function particleAnimation():void
		{
			var img:*;
			var totalParticles:int = particles.numChildren;
			for (var i:int = 0; i < totalParticles; i++) 
			{
				img = particles.getChildAt(i);
				img.scaleX = img.scaleY = 0.1 + (Math.random() * 0.1);
				img.alpha = 0;
				img.y = -3 * i;
				img.x = 15 * i;
				
				var posix:Number = (20 + (Math.random() * 10));
				var posfx:Number = posix + 70;
				
				posix = (i < 2) ? - posix : posix;
				posfx = (i < 2) ? - posfx : posfx;
				
				var posiy:Number = -(5 + (Math.random() * 8)); 
				var posfy:Number = 50;
				
				TweenMax.to(img, 0.01, { alpha:1, delay:0.02 * i } );
				TweenMax.to(img, 0.4, { bezier: { timeResolution:3, values:[ { x:img.x + posix, y:img.y + posiy }, { x:img.x + posfx, y:posfy } ] }, scaleX:0, scaleY:0, delay: (0.02 * i), ease:Sine.easeIn } );
				TweenMax.to(img, 0.2, { alpha:0, delay:0.2 + (0.02 * i), ease:Sine.easeIn } );
			}
		}
		
		private function flyAnimation():void
		{
			xpos = (isFinish == true) ? (stage.stageWidth / 2) + (120 * Device.scale) + (Math.random() * (60 * Device.scale)) : (stage.stageWidth / 2) - (200 * Device.scale) + (Math.random() * (400 * Device.scale));
			ypos = (120 * Device.scale) + (Math.random() * 80 * Device.scale);
			
			var pcty:Number = (ypos - (100 * Device.scale)) / (100 * Device.scale);
			var pctx:Number = (xpos - ((stage.stageWidth / 2) - (200 * Device.scale))) / (400 * Device.scale);
			
			pctx = (pctx - 0.5) * 2;
			pcty = (pcty - 0.5) * 2;
			
			tweenEye1 = TweenMax.to(eye1, 1.3, { x:55 + (7 * pctx), y:4 + (2 * pcty), delay:0.1 } );
			tweenEye2 = TweenMax.to(eye2, 1.3, { x:75 + (7 * pctx), y:4 + (2 * pcty), delay:0.1 } );
			
			tweenFly = TweenMax.to(fly, 0.3, { x:xpos, y:ypos, ease:Sine.easeInOut, onComplete:function():void 
			{
				if (isFinish == true)
				{
					var hip:Number = MathHelper.dist2D(xt, ypos, xpos, yt) * 1.1;
					xpos = (xpos > (stage.stageWidth / 2)) ? xpos - (20 * Device.scale) : xpos;
					var angle:Number = Math.atan2(yt - ypos,  xt - xpos) - (Math.PI / 2);
					
					tung.height = 0;
					tungContainer.rotation = angle;
					
					frames.frame = 0;
					tweenAni = TweenMax.to(frames, 0.1, { frame:frames.totalFrames - 0.01, ease:Linear.easeNone, onUpdate:function():void
					{
						var frm:int = Math.floor(frames.frame);
						for (var i:int = 0; i < frames.totalFrames; i++) 
						{
							frogframes[i].visible = false;
						}
						if (frm == 2)
						{
							tweenEye2 = TweenMax.to(eye2, 0, { x:75, y:-2 } );
							tweenEye1 = TweenMax.to(eye1, 0, { x:53, y:5 } ); 
						}
						frogframes[frm].visible = true;
					}});
					tweenTung = TweenMax.to(tung, 0.05, { height:hip, ease:Sine.easeOut, delay:0.1, onComplete:function():void 
					{
						particleAnimation();
						fly.alpha = 0;
						SoundManager.stopSound("flyflying");
						
						tweenTung = TweenMax.to(tung, 0.05, { height:0, delay:0, ease:Sine.easeOut } );
						tweenAni = TweenMax.to(frames, 0.1, { frame:0, delay:0.04, ease:Linear.easeNone, onUpdate:function():void
						{
							var frm:int = Math.floor(frames.frame);
							for (var i:int = 0; i < frames.totalFrames; i++) 
							{
								frogframes[i].visible = false;
							}
							if (frm == 1)
							{
								tweenEye2 = TweenMax.to(eye2, 0, { x:77, y:8 } );
								tweenEye1 = TweenMax.to(eye1, 0, { x:55, y:8 } ); 
							}
							frogframes[frm].visible = true;
						}, onComplete:function():void 
						{
							tweenEye1 = TweenMax.to(eye1, 0.05, { x:53, y:7, ease:Sine.easeOut } );
							tweenEye2 = TweenMax.to(eye2, 0.05, { x:75, y:7, ease:Sine.easeOut, onComplete:function():void 
							{
								TweenMax.delayedCall(1.5, function():void 
								{
									isFinish = false;
									onClose();
									//open();
								});
							}});
						}});
					}});
				}else
				{
					flyAnimation();
				}
			}});
		}
		
		public function open(time:Number = 0):void
		{
			TweenMax.killAll();
			TweenMax.to(this, time, { autoAlpha:1 } );
			fly.alpha = 1;
			fly.resume();
			frogSprite.scaleX = 0.98;
			tweenFrog = TweenMax.to(frogSprite, 0.5, { scaleY:0.95, scaleX:1, ease:Sine.easeInOut, repeat: -1, yoyo:true } );
			
			SoundManager.playSound("flyflying", "", -1, 0.3);
			flyAnimation();
		}
		
		public function close(time:Number = 0.2):void
		{
			if (title)
				title.open();
			
			TweenMax.delayedCall(2, function():void
			{
				isFinish = true;
				
				if(tweenEye1)
					tweenEye1.kill();
				
				if(tweenEye2)
					tweenEye2.kill();
				
				if(tweenFly)
					tweenFly.kill();
				
				if(tweenTung)
					tweenTung.kill();
				
				if(tweenFrog)
					tweenFrog.kill();
				
				if (tweenAni)
					tweenAni.kill();
				
				flyAnimation();
			});
		}
		
		private function onClose(time:Number = 0):void
		{
			TweenMax.to(this, time, { autoAlpha:0, delay:0, onComplete:function():void 
			{
				if (fly)
					fly.pause();
				
				if (title)
					title.close();
				
				if(tweenEye1)
					tweenEye1.kill();
				
				if(tweenEye2)
					tweenEye2.kill();
				
				if(tweenFly)
					tweenFly.kill();
				
				if(tweenTung)
					tweenTung.kill();
				
				if(tweenFrog)
					tweenFrog.kill();
				
				if (tweenAni)
					tweenAni.kill();
				
				if (onComplete != null)
				{
					onComplete();
					onComplete = null;
				}
			} } );
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
	}
}