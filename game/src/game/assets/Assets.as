package game.assets
{
	/**
	 * ...
	 * @author Fabio Toste
	 */
	import dragonBones.objects.SkeletonData;
	import dragonBones.objects.XMLDataParser;
	import flash.display.Bitmap;
	import flash.text.Font;
	import starling.text.BitmapFont;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.text.TextField;
	import starling.extensions.PDParticleSystem;
	
	public class Assets
	{
		private static var gameSkeleton:Dictionary = new Dictionary();
		private static var gameTextures:Dictionary = new Dictionary();
		private static var gameTextureAtlas:Dictionary = new Dictionary();
		private static var gameFonts:Dictionary = new Dictionary();
		private static var gameParticles:Dictionary = new Dictionary();
		private static var gameSounds:Dictionary = new Dictionary();
		public static var textureScale:Number = 1.0;
		
		//fonts
		//[Embed(source="../../../lib/assets/textures/fonts/soupofjustice.ttf", embedAsCFF = "false", fontName="Soup of Justice", mimeType = "application/x-font")]
		//public static const soj:Class;
		
		//loader
		[Embed(source = "../../../lib/assets/textures/loader/loader.png")]
		public static const preloaderTextureAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/loader/loader.xml", mimeType="application/octet-stream")]
		public static const preloaderXMLAtlas:Class;
		
		// Fonts =-=-=-=-=-=-=-
		[Embed(source="../../../lib/assets/textures/fonts/text_font.png")]
		public static const textDisplayTexture:Class;
		
		[Embed(source="../../../lib/assets/textures/fonts/text_font.fnt", mimeType="application/octet-stream")]
		public static const textDisplayXML:Class;
		
		[Embed(source="../../../lib/assets/textures/fonts/hud_font.png")]
		public static const textHUDTexture:Class;
		
		[Embed(source="../../../lib/assets/textures/fonts/hud_font.fnt", mimeType="application/octet-stream")]
		public static const textHUDXML:Class;
		
		//Textures =-=-=-=-=-=-=-
		[Embed(source = "../../../lib/assets/textures/scanlines.png")]
		public static const scanlinesTexture:Class;
		
		[Embed(source = "../../../lib/assets/textures/interface/interface.png")]
		public static const interfaceTextureAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/interface/interface.xml", mimeType = "application/octet-stream")]
		public static const interfaceXMLAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/interface/interface_hud.png")]
		public static const interface_hudTextureAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/interface/interface_hud.xml", mimeType="application/octet-stream")]
		public static const interface_hudXMLAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/interface/interface_intro.png")]
		public static const interface_introTextureAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/interface/interface_intro.xml",mimeType="application/octet-stream")]
		public static const interface_introXMLAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/level.xml", mimeType="application/octet-stream")]
		public static const levelXMLAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/level.png")]
		public static const levelTextureAtlas:Class;
		
		//animacoes
		[Embed(source = "../../../lib/assets/textures/game/frog/skeleton.xml", mimeType = "application/octet-stream")]
		public static const frogSkeletonAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/frog/texture.xml", mimeType = "application/octet-stream")]
		public static const frogXMLAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/frog/texture.png")]
		public static const frogTextureAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/explosion/skeleton.xml", mimeType = "application/octet-stream")]
		public static const explosionSkeletonAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/explosion/texture.xml", mimeType = "application/octet-stream")]
		public static const explosionXMLAtlas:Class;
		
		[Embed(source = "../../../lib/assets/textures/game/explosion/texture.png")]
		public static const explosionTextureAtlas:Class;
		
		//sounds
		[Embed(source = "../../../lib/assets/sound/game/flyflying.mp3")]
		public static const flyflying:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/bats_flying_cave.mp3")]
		public static const bats:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/ambience.mp3")]
		public static const ambience:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/crash_1.mp3")]
		public static const crash1:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/crash_2.mp3")]
		public static const crash2:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/crash_3.mp3")]
		public static const crash3:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/crash_4.mp3")]
		public static const crash4:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/crash_5.mp3")]
		public static const crash5:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/crash_6.mp3")]
		public static const crash6:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/dead_music.mp3")]
		public static const dead:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/jump.mp3")]
		public static const jump:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/start_motor.mp3")]
		public static const startMotor:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/motor.mp3")]
		public static const motor:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/music_game.mp3")]
		public static const musicGame:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/music_menu.mp3")]
		public static const musicMenu:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/music_pause.mp3")]
		public static const musicPause:Class;
		
		[Embed(source = "../../../lib/assets/sound/game/pass.mp3")]
		public static const pass:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/click.mp3")]
		public static const click:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/init.mp3")]
		public static const init:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/keydown.mp3")]
		public static const keydown:Class;
		
		[Embed(source="../../../lib/assets/sound/ui/ok.mp3")]
		public static const ok:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/menu_in.mp3")]
		public static const menuIn:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/menu_out.mp3")]
		public static const menuOut:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/no_connection.mp3")]
		public static const noConnection:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/over.mp3")]
		public static const over:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/over_out.mp3")]
		public static const overOut:Class;
		
		[Embed(source = "../../../lib/assets/sound/ui/select.mp3")]
		public static const select:Class;
		
		public static function disposeTextureAtlas(atlas:String):void
		{
			Texture(gameTextures[atlas + 'TextureAtlas']).dispose();
			TextureAtlas(gameTextureAtlas[atlas]).dispose();
			gameTextureAtlas[atlas] = null;
			gameTextures[atlas + 'TextureAtlas'] = null;
			delete gameTextureAtlas[atlas];
			delete gameTextures[atlas + 'TextureAtlas'];
		}
		
		public static function getSkeleton(name:String):SkeletonData
		{
			if (gameSkeleton[name] == undefined)
			{
				var xml:XML = XML(new Assets[name + 'SkeletonAtlas']);
				gameSkeleton[name] = XMLDataParser.parseSkeletonData(xml);
			}
			return gameSkeleton[name];
		}
		
		public static function getAtlas(atlas:String, scale:Number = -1):TextureAtlas
		{
			if (gameTextureAtlas[atlas] == undefined)
			{
				var texture:Texture = getTexture(atlas + 'TextureAtlas', scale);
				var xml:XML = XML(new Assets[atlas + 'XMLAtlas']);
				gameTextureAtlas[atlas] = new TextureAtlas(texture, xml);
			}
			return gameTextureAtlas[atlas];
		}
		
		public static function getFont(name:String):BitmapFont
		{
			if (gameFonts[name] == undefined)
			{
				var texture:Texture = getTexture(name + 'Texture', textureScale);
				var xml:XML = XML(new Assets[name + 'XML']);
				gameFonts[name] = new BitmapFont(texture, xml);
				TextField.registerBitmapFont(gameFonts[name]);
			}
			return gameFonts[name];
		}
		
		public static function getParticle(name:String, tex:String):PDParticleSystem
		{
			var texture:Texture = getTexture(tex + 'ParticleTexture', textureScale);
			var xml:XML = XML(new Assets[name + 'ParticleXML']);
			var prt:PDParticleSystem = new PDParticleSystem(xml, texture);
			return prt;
		}
		
		public static function getTexture(name:String, scale:Number):Texture
		{
			if (gameTextures[name] == undefined)
			{
				var scl:Number = (scale!=-1) ? scale : textureScale;
				var bitmap:Bitmap = new Assets[name]();
				gameTextures[name] = Texture.fromBitmap(bitmap, true, false, scl);
				bitmap.bitmapData.dispose();
			}
			return gameTextures[name];
		}
		
		public static function getSound(name:String):Sound
		{
			if (gameSounds[name] == undefined)
			{
				gameSounds[name] = new Assets[name]() as Sound;
			}
			return gameSounds[name];
		}
		
		public static function tileTexture(image:Image, h:int, v:int):void
		{
			image.setTexCoords(1, new Point(h, 0));
			image.setTexCoords(2, new Point(0, v));
			image.setTexCoords(3, new Point(h, v));
		}
		
		public static function createParallaxSprite(texturas:Array):Sprite
		{
			var spt:Sprite = new Sprite();
			var img:Image;
			
			var counter:int = 1;
			for each (var textura:Texture in texturas) 
			{
				img = new Image(textura);
				img.x = spt.width - counter;
				spt.addChild(img);
				counter ++;
			}
			
			img = new Image(texturas[0]);
			img.x = spt.width - (counter +1);
			spt.addChild(img);
			
			return spt;
		}
	}
}