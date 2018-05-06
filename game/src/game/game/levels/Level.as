package game.game.levels
{
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import game.assets.Device;
	import game.data.ObjectData;
	import game.game.chars.Player;
	import game.game.objects.BatColony;
	import game.game.objects.BgObject;
	import game.game.objects.Particles;
	
	import game.assets.Assets;
	import game.game.objects.BgRepeater;
	import game.game.objects.ObjectMaker;
	
	import starling.animation.Juggler;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class Level extends Sprite
	{
		public var totalLength:Number = 100000;
		private var createBats:Boolean = false;
		
		private var bg:BgRepeater;
		private var bgLayer1:BgRepeater;
		private var bgLayer2:BgRepeater;
		private var bgLayer3:BgRepeater;
		private var smokebgLayer1:BgRepeater;
		private var smokebgLayer2:BgRepeater;
		private var floor:BgRepeater;
		private var floorDetail:BgRepeater;
		public var actionLayer:ObjectMaker;
		public var explosion:Sprite;
		private var frontLayer:BgRepeater;
		private var frontDetail:BgRepeater;
		private var frontLayer1:BgRepeater;
		private var frontLayer2:BgRepeater;
		private var smokefrontLayer1:BgRepeater;
		private var smokefrontLayer2:BgRepeater;
		
		public var batColony:BatColony;
		
		private var penumbraLeft:Image;
		private var penumbraRight:Image;
		
		private var particles:Particles;
		
		private var playerSprite:Player;
		
		public function Level(playerSprite:Player, useBats:Boolean = false)
		{
			this.createBats = useBats;
			this.playerSprite = playerSprite;
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var d:Number = -3;
			
			bg = new BgRepeater([
				Assets.getAtlas('level').getTexture('background')
			], { distance:d, repeat:true } );
			bg.y = stage.stageHeight - 300;
			addChild(bg);
			
			smokebgLayer2 = new BgRepeater([
				Assets.getAtlas('level').getTexture('smoke_1')
			], { distance:-400, distanceVariation:300, yVariation:50, scale:2, repeat:true, repeatCount:8} );
			smokebgLayer2.y = stage.stageHeight - 285;
			smokebgLayer2.alpha = 0.3;
			addChild(smokebgLayer2);
			
			smokebgLayer1 = new BgRepeater([
				Assets.getAtlas('level').getTexture('smoke_1')
			], { distance:-400, distanceVariation:300, yVariation:50, scale:2, repeat:true, repeatCount:8} );
			smokebgLayer1.y = stage.stageHeight - 265;
			smokebgLayer1.alpha = 0.3;
			addChild(smokebgLayer1);
			
			floor = new BgRepeater([
				Assets.getAtlas('level').getTexture('floor')
			], { distance:d, repeat:true} );
			floor.y = stage.stageHeight - 100;
			addChild(floor);
			
			floorDetail = new BgRepeater([
				new BgObject(Assets.getAtlas('level').getTexture('floor_detail_1')).setyVariation(5).setxVariation(1500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_detail_2')).setyVariation(60).setxVariation(1500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_detail_3')).setyVariation(15).setxVariation(1500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_1')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_2')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_3')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_4')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_1')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_2')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_3')).setyVariation(80).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('floor_rock_4')).setyVariation(80).setxVariation(300)
			], { distance:900, random:true, pivotY:-1} );
			floorDetail.y = stage.stageHeight - 338;
			addChild(floorDetail);
			
			explosion = new Sprite();
			playerSprite.explosionLayer = explosion;
			
			actionLayer = new ObjectMaker("level", playerSprite);
			actionLayer.baseY = floor.y - 128;
			this.addChild(actionLayer);
			
			addChild(explosion);
			
			bgLayer3 = new BgRepeater([
				Assets.getAtlas('level').getTexture('top_front')
			], { pivotY:-1, scale:0.7, distance: d, repeat:true } );
			bgLayer3.alpha = 0.5;
			bgLayer3.y = 80;
			addChild(bgLayer3);
			
			bgLayer2 = new BgRepeater([
				Assets.getAtlas('level').getTexture('top_front')
			], { pivotY:-1, distance:d, repeat:true} );
			bgLayer2.y = 0;
			addChild(bgLayer2);
			
			particles = new Particles();
			this.addChild(particles);
			
			smokefrontLayer1 = new BgRepeater([
				Assets.getAtlas('level').getTexture('smoke_1')
			], { distance:-400, distanceVariation:300, yVariation:30, scale:2, repeat:true, repeatCount:8} );
			smokefrontLayer1.y = stage.stageHeight - 40;
			smokefrontLayer1.alpha = 0.3;
			addChild(smokefrontLayer1);
			
			frontLayer = new BgRepeater([
				Assets.getAtlas('level').getTexture('floor_front')
			], { distance:d, repeat:true} );
			frontLayer.y = stage.stageHeight + 60;
			addChild(frontLayer);
			
			frontDetail = new BgRepeater([
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_1')).setyVariation(70).setxVariation(200),
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_2')).setyVariation(70).setxVariation(200),
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_3')).setyVariation(77).setxVariation(200),
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_4')).setyVariation(70).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_5')).setyVariation(70).setxVariation(300),
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_6')).setyVariation(70).setxVariation(200),
				new BgObject(Assets.getAtlas('level').getTexture('bone_front_7')).setyVariation(70).setxVariation(200),
				new BgObject(Assets.getAtlas('level').getTexture('car_1')).setyVariation(70).setxVariation(200)
			], { distance:40, distanceVariation:200, yVariation:70} );
			frontDetail.y = stage.stageHeight - 75;
			addChild(frontDetail);
			
			smokefrontLayer2 = new BgRepeater([
				Assets.getAtlas('level').getTexture('smoke_1')
			], { distance:-400, distanceVariation:300, yVariation:30, scale:2, repeat:true, repeatCount:8} );
			smokefrontLayer2.y = stage.stageHeight + 20;
			smokefrontLayer2.alpha = 0.3;
			addChild(smokefrontLayer2);
			
			frontLayer1 = new BgRepeater([
				Assets.getAtlas('level').getTexture('floor_front_2')
			], { distance:-12,  repeat:true} );
			frontLayer1.y = stage.stageHeight + 20;
			addChild(frontLayer1);
			
			if (createBats == true)
			{
				batColony = new BatColony();
				addChild(batColony);
			}
			
			bgLayer1 = new BgRepeater([
				Assets.getAtlas('level').getTexture('top_foreground'),
			], { pivotY:-1, distance:-10, distanceVariation:100, scale:2, yVariation:-160, repeat:true} );
			bgLayer1.y = 0;
			addChild(bgLayer1);
			
			frontLayer2 = new BgRepeater([
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_1')).setxVariation(2800).setScale(100),
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_2')).setxVariation(3500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_3')).setxVariation(3500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_4')).setxVariation(3500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_5')).setxVariation(3500),
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_6')).setxVariation(3500).setY(-stage.stageHeight).setPivotY(-1),
				new BgObject(Assets.getAtlas('level').getTexture('floor_foreground_7')).setxVariation(3500)
			], { distance:5500, scale:2, random:true} );
			frontLayer2.y = stage.stageHeight;
			addChild(frontLayer2);
			
			var penumbraOffset:Number = Device.stageOffset - (438 * 0.4);
			penumbraOffset = (penumbraOffset > 0) ? 0 : penumbraOffset;
			
			penumbraLeft = new Image(Assets.getAtlas('level').getTexture('penumbra'));
			penumbraLeft.height = stage.stageHeight;
			penumbraLeft.scaleX = penumbraLeft.scaleY;
			penumbraLeft.x = penumbraOffset;
			addChild(penumbraLeft);
			
			penumbraRight = new Image(Assets.getAtlas('level').getTexture('penumbra'));
			penumbraRight.height = stage.stageHeight;
			penumbraRight.scaleX = -penumbraRight.scaleY;
			penumbraRight.scaleY *= -1;
			penumbraRight.y = stage.stageHeight;
			penumbraRight.x = stage.stageWidth - penumbraOffset;
			addChild(penumbraRight);
		}
		
		public function update(deltaTime:Number = 1/60):void 
		{
			bg.update(Math.floor(ObjectData.backgroundMeter * deltaTime * playerSprite.speed));
			bgLayer1.update(Math.floor(ObjectData.background_L3_Meter * deltaTime * playerSprite.speed));
			bgLayer2.update(Math.floor(ObjectData.background_L2_Meter * deltaTime * playerSprite.speed));
			bgLayer3.update(Math.floor(ObjectData.background_L1_Meter * deltaTime * playerSprite.speed));
			smokebgLayer2.update(Math.floor(ObjectData.backgroundMeter * 1.7 * deltaTime * playerSprite.speed) + (8 * deltaTime));
			smokebgLayer1.update(Math.floor(ObjectData.backgroundMeter * 2.6 * deltaTime * playerSprite.speed) + (15 * deltaTime));
			floor.update(Math.floor(ObjectData.basePixelMeter * deltaTime * playerSprite.speed));
			smokefrontLayer1.update(Math.floor(ObjectData.basePixelMeter * 0.8 * deltaTime * playerSprite.speed) + (18 * deltaTime));
			floorDetail.update(Math.floor(ObjectData.basePixelMeter * deltaTime * playerSprite.speed));
			frontDetail.update(Math.floor(ObjectData.basePixelMeter * deltaTime * playerSprite.speed));
			actionLayer.update(Math.floor(ObjectData.basePixelMeter * deltaTime * playerSprite.speed), deltaTime);
			smokefrontLayer2.update(Math.floor(ObjectData.basePixelMeter * 0.9 * deltaTime * playerSprite.speed) + (20 * deltaTime));
			frontLayer.update(Math.floor(ObjectData.basePixelMeter * deltaTime * playerSprite.speed));
			frontLayer1.update(Math.floor(ObjectData.foreground_L2_Meter * deltaTime * playerSprite.speed));
			frontLayer2.update(Math.floor(ObjectData.foreground_L3_Meter * deltaTime * playerSprite.speed));
			
			if (batColony)
			{
				batColony.x -= ObjectData.background_L2_Meter * deltaTime * playerSprite.speed;
			}
			
			if (particles)
			{
				particles.update(Math.floor(ObjectData.background_L1_Meter * deltaTime * playerSprite.speed), deltaTime);
			}
		}
		
		public function reset():void
		{}
	}
}