package game.game.chars 
{
	import dragonBones.Armature;
    import dragonBones.animation.WorldClock;
	import dragonBones.events.AnimationEvent;
    import dragonBones.factorys.StarlingFactory;
	import game.data.ObjectData;
	import game.game.sounds.SoundManager;
	
	import com.greensock.easing.Sine;
	import com.greensock.easing.Quint;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import game.data.PlayerData;
	import game.data.GameData;
	
	import starling.display.DisplayObject;
	import starling.animation.Juggler;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.PDParticleSystem;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.display.Quad;
	import starling.textures.TextureSmoothing;
	import starling.utils.deg2rad;
	
	import game.assets.Assets;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class Player extends Sprite 
	{
		private var canUpdate:Boolean = false;
		private var canUpdatePlayer:Boolean = false;
		private var localPoint:Point = new Point(0, 0);
		private var globalPoint:Point = new Point(0, 0);
		private var running:Boolean = false;
		private var stoping:Boolean = false;
		
		public var hitbox:Quad;
		public var zbox:Quad;
		public var sizebox:Quad;
		public var boundbox:Quad;
		
		public var speed:Number = 0;
		public var state:int = 0;
		public var canChangeAnimation:Boolean = true;
		public var positionY:Number = 0;
		public var offsetY:Number = 0;
		public var offsetSpriteY:Number = 0;
		
		public var maxPos:Point = new Point(0, 0);
		public var minPos:Point = new Point(0, 0);
		
		private var textureName:String = "";
		public var realY:Number = 0;
		
		private var oldPos:Number = 0;
		public var oldSpeed:Number = 0;
		private var inclination:Number = 0;
		
		public var currentLane:Number = 0;
		public var currentCircuitPosition:Number = 0;
		
		public var jumpPos:Number = 0;
		public var jumpP:Number = 0;
		
		public var gravityForce:Number = 0;
		public var speedRotForce:Number = 0;
		public var jumpSpeed:Number = 0;
		public var jumpping:Boolean = false;
		public var canJump:Boolean = true;
		
		private var jumpRotation:Number = 0;
		private var antiGravity:Number = 0;
		private var angle:Number = 0;
		private var antiGravitySpeed:Number = PlayerData.antiGravitySpeedBase;
		private var antiGravityPow:Number = PlayerData.antiGravityPowBase;
		
		private var defaultState:Image;
		private var downFF:MovieClip;
		private var downRR:MovieClip;
		private var upFF:MovieClip;
		private var upRR:MovieClip;
		private var sombra:Image;
		private var upmax:Boolean = false;
		private var downmax:Boolean = false;
		
		public var currState:int = -1;
		
		private var factory:StarlingFactory;
		private var armature:Armature;
		private var armatureClip:Sprite;
		private var explosion:Armature;
		private var explosionClip:Sprite;
		
		private var containerSprite:Sprite;
		private var containerFaiscaFront:Sprite;
		private var faiscando:Boolean = false;
		
		public var offsetPosition:Point = new Point(0, 0);
		
		public var position:Point = new Point(0, 0);
		public var moveDirection:Point = new Point(0, 0);
		public var direction:Point = new Point(0, 0);
		public var olddirection:Point = new Point(0, 0);
		public var drag:Point = new Point(25, 25);
		public var idx:int = 1;
		public var explosionLayer:Sprite = null;
		
		public var zboxRect:Rectangle = new Rectangle(0, 0, 0, 0);
		public var sizeRect:Rectangle = new Rectangle(0, 0, 0, 0);
		
		public function Player(name:String = "") 
		{
			state = PlayerData.STATE_LIVE;
			textureName = name;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			factory = new StarlingFactory();
			factory.addSkeletonData(Assets.getSkeleton("frog"));
			factory.addTextureAtlas(Assets.getAtlas("frog"), "frog");
			factory.addSkeletonData(Assets.getSkeleton("explosion"));
			factory.addTextureAtlas(Assets.getAtlas("explosion"), "explosion");
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, remove);
			
			containerSprite = new Sprite();
			addChild(containerSprite);
			
			resetLimits();
			
			sombra = new Image(Assets.getAtlas('level').getTexture('shadow'));
			sombra.alpha = 0.6;
			sombra.pivotX = sombra.width / 2;
			sombra.pivotY = sombra.height / 2;
			sombra.scaleX = 1;
			sombra.x = 10;
			sombra.y = 65;
			addChild(sombra);
			
			armature = factory.buildArmature("frog", null, null, "frog");
			armatureClip = armature.display as Sprite;
			armatureClip.scaleX = armatureClip.scaleY = 0.95;
			armatureClip.x = 200;
			armatureClip.y = -20;
			addChild(armatureClip);
			
			explosion = factory.buildArmature("explosion", null, null, "explosion");
			explosionClip = explosion.display as Sprite;
			explosionClip.scaleX = explosionClip.scaleY = 0.8;
			explosionClip.x = this.x;
			explosionClip.y = this.y;
			explosionClip.visible = false;
			
			offsetSpriteY = -20;
			
			explosion.animation.timeScale = 1
			armature.animation.timeScale = 1;
			
			boundbox = new Quad(300, 160, 0x000000);
			boundbox.alpha = (PlayerData.debug == true) ? PlayerData.debug_alpha : 0;
			boundbox.pivotX = boundbox.width / 2;
			boundbox.pivotY = boundbox.height / 2;
			boundbox.x = 0;
			boundbox.y = 0;
			containerSprite.addChild(boundbox);
			
			hitbox = new Quad(110, 30, 0xFF0000);
			hitbox.alpha = (PlayerData.debug == true) ? PlayerData.debug_alpha : 0;
			hitbox.absoluteWidth = hitbox.width;
			hitbox.absoluteHeight = hitbox.height;
			hitbox.pivotX = hitbox.width / 2;
			hitbox.pivotY = hitbox.height / 2;
			hitbox.x = 0;
			hitbox.y = 20;
			containerSprite.addChild(hitbox);
			
			sizebox = new Quad(110, 75, 0x0000FF);
			sizebox.alpha = (PlayerData.debug == true) ? PlayerData.debug_alpha : 0;
			sizebox.x = -(sizebox.width / 2) + 20;
			sizebox.y = -22;
			addChild(sizebox);
			
			zbox = new Quad(150, 16, 0x00FF00);
			zbox.alpha = (PlayerData.debug == true) ? PlayerData.debug_alpha : 0;
			zbox.x = -(zbox.width / 2);
			zbox.y = 50;
			addChild(zbox);
			
			position.x = this.x;
			position.y = this.y;
			
			armature.animation.stop();
			explosion.animation.stop();
			canUpdate = true;
			canUpdatePlayer = true;
		}
		
		public function reset():void
		{
			changeAnimation(PlayerData.IDLE, false);
			position.x = this.x;
			position.y = this.y;
			
			if (explosionLayer != null)
				explosionLayer.addChild(explosionClip);
			
			resetLimits();
		}
		
		public function resetLimits():void
		{
			offsetPosition.x = 0;
			offsetPosition.y = 0;
		}
		
		private function remove(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, remove);
		}
		
		public function run():void 
		{
			running = true;
			stoping = false;
			
			WorldClock.clock.add(armature);
			WorldClock.clock.add(explosion);
			
			armature.animation.gotoAndPlay("jumping_down", -1, 0, 1);
			changeAnimation(PlayerData.IDLE);
		}
		
		public function stop():void 
		{
			running = false;
			stoping = true;
		}
		
		public function moveAxisX(direction:Number = 0):void 
		{
			this.direction.x = direction;
			
			if (direction > 0)
			{	
				if (currState != PlayerData.IDLE && currState != PlayerData.FRONTIN && canChangeAnimation)
				{
					changeAnimation(PlayerData.FRONTIN);
				}
			}else if (direction < 0)
			{	
				if (currState != PlayerData.IDLE && currState != PlayerData.BACKIN && canChangeAnimation)
				{
					changeAnimation(PlayerData.BACKIN);
				}
			}else
			{
				if (currState != PlayerData.IDLE && currState == PlayerData.BACKIN&&canChangeAnimation)
					changeAnimation(PlayerData.BACKOUT);
				
				if (currState != PlayerData.IDLE && currState == PlayerData.FRONTIN&&canChangeAnimation)
					changeAnimation(PlayerData.FRONTOUT);
			}
		}
		
		public function moveAxisY(direction:Number = 0):void 
		{
			this.direction.y = direction;
			
			if (direction > 0)
			{
				upmax = false;
				if (currState != PlayerData.IDLE && currState != PlayerData.DOWNIN && canChangeAnimation && downmax==false)
				{
					changeAnimation(PlayerData.DOWNIN);
				}
			}else if (direction < 0)
			{
				downmax = false;
				if (currState != PlayerData.IDLE && currState != PlayerData.UPIN && canChangeAnimation && upmax==false)
				{
					changeAnimation(PlayerData.UPIN);
				}
			}else
			{
				if (currState != PlayerData.IDLE && currState == PlayerData.UPIN && canChangeAnimation)
					changeAnimation(PlayerData.UPOUT);
				
				if (currState != PlayerData.IDLE && currState == PlayerData.DOWNIN && canChangeAnimation)
					changeAnimation(PlayerData.DOWNOUT);
			}
		}
		
		public function moveX(value:Number):void
		{
			this.moveAxisX(value);
		}
		public function moveY(value:Number):void
		{
			this.moveAxisY(value);
		}
		
		public function moveLeft():void
		{
			this.moveAxisX(-1);
		}
		public function moveRight():void
		{
			this.moveAxisX(1);
		}
		public function stopMoveX():void
		{
			this.moveAxisX(0);
		}
		
		public function moveUp():void
		{
			this.moveAxisY(-1);
		}
		public function moveDown():void
		{
			this.moveAxisY(1);
		}
		public function stopMoveY():void
		{
			this.moveAxisY(0);
		}
		
		public function jump():void 
		{
			if (currState != PlayerData.IDLE && canJump == true)
			{
				canChangeAnimation = false;
				changeAnimation(PlayerData.JUMPING);
				this.jumpP = PlayerData.jumpPower;
				this.jumpSpeed = speed;
				this.jumpping = true;
				this.canJump = false;
				this.offsetY = 0;
			}
		}
		
		public function stopJump(force:Boolean = false):void 
		{
			if (force==true && currState == PlayerData.JUMPING && currState != PlayerData.DEAD)
			{
				armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteJumpUp);
				changeAnimation(PlayerData.FALLING_FORCE);
			}
		}
		
		public function hitObject(newState:int = PlayerData.STATE_DEAD, hitID:String = ""):void
		{
			if (PlayerData.canDie == true)
			{
				idx = Math.random() * 60;
				idx = Math.round(idx / 10);
				idx = (idx < 1) ? 1 : idx;
				idx = (idx > 6) ? 6 : idx;
				idx = (hitID == "wall_3" && idx == 3) ? 4 : idx;
				this.jumpPos = (idx == 3) ? 0 : this.jumpPos;
				
				canChangeAnimation = false;
				armatureClip.y = -5;
				TweenMax.to(this, 0, { speed:0 } );
				this.state = newState;
				this.canJump = false;
				
				explosionClip.x = this.x + 35;
				explosionClip.y = (this.y + 44) + this.jumpPos;
				
				if (idx != 3)
				{
					var yposO:Number = (idx == 1 || idx == 2) ? -10 : (idx == 4) ? -3 : (idx == 6) ? -5 : 5;
					position.y = realY + yposO;
					this.y = position.y;
				}
				//this.canUpdatePlayer = false;
				this.direction.x = 0;
				this.direction.y = 0;
				
				SoundManager.stopSound("motor");
				SoundManager.playSound("dead", "dead", 1, 0.2);
				
				explosionClip.visible = true;
				explosion.animation.gotoAndPlay("explode", -1, 0.7, 1);
				explosion.removeEventListener(AnimationEvent.COMPLETE, onExplode);
				explosion.addEventListener(AnimationEvent.COMPLETE,  onExplode);
				
				TweenMax.killTweensOf(explosionClip);
				TweenMax.to(explosionClip, 0.2, { scaleX:1.5, scaleY:1.5, ease:Sine.easeOut } );
				
				GameData.main.game.gameMusic.stop();
				GameData.main.game.gameoverOpen = true;
				
				if (hitID == "wall_1a" || hitID == "wall_1")
				{
					changeAnimation(PlayerData.DEAD);
				}else if (hitID == "wall_2" || hitID == "wall_1b" || hitID == "wall_1c")
				{
					changeAnimation(PlayerData.DEAD);
				}else if (hitID == "wall_3")
				{
					idx = (idx == 3) ? 4 : idx;
					changeAnimation(PlayerData.DEAD);
				}
				
				TweenMax.delayedCall(2, function():void 
				{
					GameData.main.game.gameOver();
				});
			}else
			{
				trace("died");
			}
			//TweenMax.killDelayedCallsTo(resetGame);
			//TweenMax.delayedCall(2, resetGame);
		}
		
		private function onExplode(e:AnimationEvent):void 
		{
			explosionClip.visible = false;
			TweenMax.to(explosionClip, 0, { scaleX:0.8, scaleY:0.8 } );
		}
		
		public function resetGame():void 
		{
			this.gravityForce = 0;
			this.angle = 0;
			this.jumpPos = 0;
			this.jumpping = false;
			this.jumpP = 0;
			this.offsetY = 0;
			this.currentCircuitPosition = 0;
			this.state = PlayerData.STATE_LIVE;
			this.canJump = true;
			this.canUpdatePlayer = true;
			//GameData.position = currentCircuitPosition;
			GameData.main.game.replay();
			canChangeAnimation = true;
		}
		
		public function changeAnimation(state:int, playsound:Boolean = true):void 
		{
			switch(state)
			{
				case PlayerData.IDLE:
					armature.animation.gotoAndPlay("Idle", -1, 0.6, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.addEventListener(AnimationEvent.COMPLETE, onBackToRun);
					if (playsound == true)
					{
						SoundManager.stopSound("motor");
						SoundManager.playSound("startMotor", "startMotor", 1, 0.3);
					}
					break;
				
				case PlayerData.RUNNING:
					armature.animation.gotoAndPlay("running", -1, 0.15, 0);
					if (playsound == true)
					{
						SoundManager.playSound("motor", "motor", -1, 0.15);
						SoundManager.setVolumeByName("motor", 0.15);
					}
					break;
				
				case PlayerData.JUMPING:
					SoundManager.setVolumeByName("motor", 0.1);
					SoundManager.playSound("jump", "jump", 1, 0.4);
					canChangeAnimation = false;
					armature.animation.gotoAndPlay("jumping_up", -1, 0.3, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteJumpUp);
					armature.addEventListener(AnimationEvent.COMPLETE, onCompleteJumpUp);
					break;
				
				case PlayerData.FALLING:
					canChangeAnimation = false;
					armature.animation.gotoAndPlay("jumping_down", -1, 0.6, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteJump);
					armature.addEventListener(AnimationEvent.COMPLETE, onCompleteJump);
					break;
				
				case PlayerData.FALLING_FORCE:
					canChangeAnimation = false;
					armature.animation.gotoAndPlay("running", -1, 0.15, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteJump);
					armature.addEventListener(AnimationEvent.COMPLETE, onCompleteJump);
					break;
				
				case PlayerData.UPIN:
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.animation.gotoAndPlay("up_in", -1, 0.2, 1);
					break;
				
				case PlayerData.UPOUT:
					armature.animation.gotoAndPlay("up_out", -1, 0.2, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.addEventListener(AnimationEvent.COMPLETE, onBackToRun);
					break;
				
				case PlayerData.DOWNIN:
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.animation.gotoAndPlay("down_in", -1, 0.2, 1);
					break;
				
				case PlayerData.DOWNOUT:
					armature.animation.gotoAndPlay("down_out", -1, 0.2, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.addEventListener(AnimationEvent.COMPLETE, onBackToRun);
					break;
				
				case PlayerData.BACKIN:
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.animation.gotoAndPlay("back_in", -1, 0.3, 1);
					break;
				
				case PlayerData.BACKOUT:
					armature.animation.gotoAndPlay("back_out", -1, 0.3, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.addEventListener(AnimationEvent.COMPLETE, onBackToRun);
					break;
				
				case PlayerData.FRONTIN:
					armature.animation.gotoAndPlay("front_in", -1, 0.3, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					break;
				
				case PlayerData.FRONTOUT:
					armature.animation.gotoAndPlay("front_out", -1, 0.3, 1);
					armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
					armature.addEventListener(AnimationEvent.COMPLETE, onBackToRun);
					break;
				
				case PlayerData.DEAD:
					
					if (playsound == true)
						SoundManager.playSound("crash" + idx);
					
					armature.animation.gotoAndPlay("dead_" + idx, -1, 2, 1);
					break;
				
				default:
					break;
			}
			currState = state;
		}
		
		private function onCompleteJump(e:AnimationEvent):void 
		{
			if (state != PlayerData.STATE_DEAD)
				changeAnimation(PlayerData.RUNNING);
			
			canChangeAnimation = true;
			armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteJump);
		}
		
		private function onCompleteJumpUp(e:AnimationEvent):void 
		{
			if (state != PlayerData.STATE_DEAD)
				changeAnimation(PlayerData.FALLING);
			
			canChangeAnimation = false;
			armature.removeEventListener(AnimationEvent.COMPLETE, onCompleteJumpUp);
		}
		
		private function onBackToRun(e:AnimationEvent):void 
		{
			if (state != PlayerData.STATE_DEAD)
				changeAnimation(PlayerData.RUNNING);
			
			armature.removeEventListener(AnimationEvent.COMPLETE, onBackToRun);
		}
		
		public function pause():void
		{
			SoundManager.pauseSound("crash1");
			SoundManager.pauseSound("crash2");
			SoundManager.pauseSound("crash3");
			SoundManager.pauseSound("crash4");
			SoundManager.pauseSound("crash5");
			SoundManager.pauseSound("crash6");
			SoundManager.pauseSound("motor");
			SoundManager.pauseSound("startMotor");
			SoundManager.pauseSound("dead");
			SoundManager.pauseSound("jump");
			canUpdate = false;
		}
		
		public function resume():void
		{
			SoundManager.resumeSound("crash1");
			SoundManager.resumeSound("crash2");
			SoundManager.resumeSound("crash3");
			SoundManager.resumeSound("crash4");
			SoundManager.resumeSound("crash5");
			SoundManager.resumeSound("crash6");
			SoundManager.resumeSound("motor");
			SoundManager.resumeSound("startMotor");
			SoundManager.resumeSound("dead");
			SoundManager.resumeSound("jump");
			canUpdate = true;
		}
		
		public function update(deltaTime:Number = 1/60):void
		{
			if (canUpdate)
			{
				WorldClock.clock.advanceTime(deltaTime);
				if (canUpdatePlayer)
				{
					if (this.state != PlayerData.STATE_DEAD)
					{
						if (running == true)
						{
							speed += (PlayerData.speedMax - speed) * deltaTime;
						}else
						{
							speed -= speed * 0.4 * deltaTime;
						}
						if (stoping == true)
						{
							speed -= speed * PlayerData.breakForce * deltaTime;
						}
						speed = (speed > PlayerData.speedMax)? PlayerData.speedMax : speed;
						speed = (speed < 0.001)? 0 : speed;
					}
					var jspd:Number = 0.4 + ((jumpSpeed / PlayerData.speedMax) * 0.6);
					var inverseSpeed:Number = 0.2 + ((1-(speed / PlayerData.speedMax)) * 0.8);
					
					if (jumpping == true)
					{
						antiGravityPow = 0;
						jumpPos += (PlayerData.debug==true) ? (-jumpP + gravityForce + offsetY) * deltaTime : (-(jumpP * jspd) + gravityForce + offsetY) * deltaTime;
						gravityForce += GameData.gravity * deltaTime;
					}
					
					if (jumpPos > 0)
					{
						antiGravityPow = 19 * jspd;
						antiGravitySpeed = 780 * jspd;
						angle = 0;
						jumpPos = 0;
						canJump = (this.state != PlayerData.STATE_DEAD) ? true : false;
						jumpping = false;
						jumpP = 0;
						gravityForce = 0;
						offsetY = 0;
					}
					
					if (this.state != PlayerData.STATE_DEAD)
					{
						antiGravityPow -= antiGravityPow * 0.3 * deltaTime;
						antiGravityPow = (antiGravityPow > 0 && antiGravityPow < PlayerData.antiGravityPowBase) ? PlayerData.antiGravityPowBase * inverseSpeed : antiGravityPow;
						antiGravitySpeed -= antiGravitySpeed * 0.9 * deltaTime;
						antiGravitySpeed = (antiGravitySpeed < PlayerData.antiGravitySpeedBase) ? PlayerData.antiGravitySpeedBase : antiGravitySpeed;
						angle += antiGravitySpeed * deltaTime;
						antiGravity = (speed > 0.001)? 0 : Math.sin(deg2rad(angle)) * antiGravityPow;
					}
					jumpRotation += (((jumpPos - oldPos) * 3) - jumpRotation) * 12 * deltaTime;
					
					//var nrot:Number = ((oldSpeed - speed) < 0) ? 350 : (stoping==true) ? 350 : 80; 
					//speedRotForce += (((oldSpeed - speed) * nrot) - speedRotForce) * 0.03 * 2 * deltaTime;
					//defaultState.rotation = deg2rad(speedRotForce);
					
					if (this.state != PlayerData.STATE_DEAD)
					{
						if (position.x > maxPos.x && direction.x >= 0)
						{
							position.x += (maxPos.x - position.x) * 8 * deltaTime;
							direction.x = 0;
						}else if (position.x < minPos.x && direction.x <= 0)
						{
							position.x += (minPos.x - position.x) * 8 * deltaTime;
							direction.x = 0;
						}
						
						moveDirection.x += (direction.x - olddirection.x) * drag.x * deltaTime;
						moveDirection.x = (Math.abs(moveDirection.x) < 0.01) ? 0 : moveDirection.x;
						position.x += PlayerData.moveforce.x * moveDirection.x * deltaTime;
						
						if (position.y < maxPos.y && direction.y <= 0)
						{
							position.y += (maxPos.y - position.y) * 8 * deltaTime;
							direction.y = 0;
							
							if (this.currState == PlayerData.UPIN)
							{
								upmax = true;
								changeAnimation(PlayerData.UPOUT);
							}
							
						}else if (position.y > minPos.y && direction.y >= 0)
						{
							position.y += (minPos.y - position.y) * 8 * deltaTime;
							direction.y = 0;
							
							if (this.currState == PlayerData.DOWNIN)
							{
								downmax = true;
								changeAnimation(PlayerData.DOWNOUT);
							}
						}
						
						moveDirection.y += (direction.y - olddirection.y) * drag.y * deltaTime;
						moveDirection.y = (Math.abs(moveDirection.y) < 0.01) ? 0 : moveDirection.y;
						position.y += PlayerData.moveforce.y * moveDirection.y * deltaTime;
					}
					
					localPoint.setTo(zbox.x, zbox.y);
					globalPoint = localToGlobal(localPoint);
					zboxRect.x = globalPoint.x;
					zboxRect.width = zbox.width;
					zboxRect.y = globalPoint.y;
					zboxRect.height = zbox.height;
					
					localPoint.setTo(sizebox.x,sizebox.y);
					globalPoint = localToGlobal(localPoint);
					sizeRect.x = globalPoint.x;
					sizeRect.width = sizebox.width;
					sizeRect.y = globalPoint.y;
					sizeRect.height = sizebox.height;
					
					resetLimits();
				}
			}
		}
		
		public function validateUpdate(deltaTime:Number = 1/60):void
		{
			if (canUpdate)
			{
				if (canUpdatePlayer)
				{
					containerSprite.rotation = deg2rad(jumpRotation);
					containerSprite.y = jumpPos + antiGravity;
					if (this.state != PlayerData.STATE_DEAD)
					{
						armatureClip.y = -20 + (jumpPos * 0) + antiGravity;
					}
					if (containerSprite.y > 18)
					{	
						containerSprite.y = 18;
						offsetY = 0;
					}
					sombra.scaleX = 1 - (containerSprite.y / -500);
					sombra.scaleY = 1 - (containerSprite.y / -900);
					
					sizebox.y = containerSprite.y - 22;
					positionY = -(containerSprite.y * 1.2);
					
					position.x += offsetPosition.x;
					position.y += offsetPosition.y;
					
					this.x = position.x;
					this.y = position.y;
					
					olddirection.y = moveDirection.y;
					olddirection.x = moveDirection.x;
					
					oldPos = jumpPos;
					oldSpeed = speed;
					//currentCircuitPosition += (deltaTime * speed);
					//GameData.position = currentCircuitPosition + (this.x / ObjectData.basePixelMeter);
					
					currentLane = 0;
				}
			}
		}
	}
}