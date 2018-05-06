package game.data 
{
	import com.facebook.graph.FacebookMobile;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.LocationChangeEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	
	import game.assets.Assets;
	import game.game.menu.BarraFacebook;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class FacebookData 
	{
		public static var boderSize:Number = 12;
		public static var webView:StageWebView;
		public static var overlay:Sprite;
		public static var border:Sprite;
		public static var barra:BarraFacebook;
		
		public static var nativeSupported:Boolean = false;
		public static var appID:String = "";
		public static var initialized:Boolean = false;
		public static var isLogIn:Boolean = false;
		
		public static var onFacebookIniSuccess:Function = null;
		public static var onFacebookIniFail:Function = null;
		
		public static var onFacebookLoginSuccess:Function = null;
		public static var onFacebookLoginFail:Function = null;
		public static var onFacebookLoginCancel:Function = null;
		
		public static var onFacebookLogoutSuccess:Function = null;
		
		public static var onFacebookLoginLoad:Function = null;
		public static var onFacebookLoginComplete:Function = null;
		
		private static var instance:FacebookData = null;
		public static function getInstance():FacebookData
		{
			if (FacebookData.instance == null) FacebookData.instance = new FacebookData();
			return FacebookData.instance;
		}
		
		public static function init(appId:String = "365283856879968"):void
		{
			nativeSupported = false;
			appID = appId;
			initialized = true;
			
			boderSize *= Assets.scale;
			
			if (nativeSupported)
			{
				/*Facebook.getInstance().addEventListener(FacebookEvent.GRAPH_API_SUCCESS_EVENT, facebookInit);
				Facebook.getInstance().initFacebook(appId);
				isLogIn = Facebook.getInstance().isLogIn();
				if (onFacebookIniSuccess != null)
				{
					onFacebookIniSuccess();
					onFacebookIniSuccess = null;
				}*/
			}else
			{
				FacebookMobile.init(appId, facebookMobileInit, null);
			}
		}
		
		public static function logout():void
		{
			if (initialized)
			{
				if (nativeSupported)
				{
					/*Facebook.getInstance().addEventListener(FacebookEvent.USER_LOGGED_OUT_SUCCESS_EVENT, facebookLogout);
					Facebook.getInstance().logout();*/
				}else
				{	
					FacebookMobile.logout(facebookLogout, "https://m.facebook.com/dialog/permissions.request?app_id="+appID+"&display=touch&next=http%3A%2F%2Fwww.facebook.com%2Fconnect%2Flogin_success.html&type=user_agent&perms=publish_stream&fbconnect=1");
				}
			}
		}
		
		public static function login(permissions:Array = null):void
		{
			if (initialized)
			{
				if (nativeSupported)
				{
					/*Facebook.getInstance().addEventListener(FacebookEvent.USER_LOGGED_IN_SUCCESS_EVENT, facebookLogin);
					Facebook.getInstance().addEventListener(FacebookEvent.USER_LOGGED_IN_ERROR_EVENT, facebookLoginFail);
					Facebook.getInstance().addEventListener(FacebookEvent.USER_LOGGED_IN_FACEBOOK_ERROR_EVENT, facebookLoginFail);
					Facebook.getInstance().addEventListener(FacebookEvent.USER_LOGGED_IN_CANCEL_EVENT, facebookLoginCancel);
					Facebook.getInstance().login(permissions);*/
				}else
				{
					try
					{
						FacebookMobile.login(facebookMobileLogin, Starling.current.nativeStage, permissions, getWebView());
					}catch (e:Error)
					{
						if (onFacebookLoginFail != null)
						{
							onFacebookLoginFail();
							//onFacebookLoginFail = null;
						}
					}
				}
			}
		}
		
		public static function getUserInfo(callbackFunction:Function = null):void
		{
			if (initialized)
			{
				if (nativeSupported)
				{
					//Facebook.getInstance().getUserInfo(callbackFunction);
				}else
				{
					FacebookMobile.api('/me', callbackFunction);
				}
			}
		}
		
		private static function facebookLogout(result:Object = null):void
		{
			if (nativeSupported)
			{
				//Facebook.getInstance().removeEventListener(FacebookEvent.USER_LOGGED_OUT_SUCCESS_EVENT, facebookLogout);
			}
			
			if (onFacebookLogoutSuccess != null)
			{
				onFacebookLogoutSuccess();
				//onFacebookLogoutSuccess = null;
			}
		}
		
		private static function facebookLogin():void
		{
			/*Facebook.getInstance().removeEventListener(FacebookEvent.USER_LOGGED_IN_SUCCESS_EVENT, facebookLogin);
			if (onFacebookLoginSuccess != null)
			{
				onFacebookLoginSuccess();
				onFacebookLoginSuccess = null;
			}*/
		}
		
		private static function facebookLoginFail():void
		{
			/*Facebook.getInstance().removeEventListener(FacebookEvent.USER_LOGGED_IN_ERROR_EVENT, facebookLoginFail);
			Facebook.getInstance().removeEventListener(FacebookEvent.USER_LOGGED_IN_FACEBOOK_ERROR_EVENT, facebookLoginFail);
			if (onFacebookLoginFail != null)
			{
				onFacebookLoginFail();
				onFacebookLoginFail = null;
			}*/
		}
		
		private static function facebookLoginCancel():void
		{
			/*Facebook.getInstance().removeEventListener(FacebookEvent.USER_LOGGED_IN_CANCEL_EVENT, facebookLoginCancel);
			if (onFacebookLoginCancel != null)
			{
				onFacebookLoginCancel();
				onFacebookLoginCancel = null;
			}*/
		}
		
		private static function facebookMobileLogin(result:Object, fail:Object):void
		{
			closeOverlays();
			if (webView)
			{
				webView = null;
			}
			if (fail)
			{
				if (onFacebookLoginFail != null)
				{
					onFacebookLoginFail();
					//onFacebookLoginFail = null;
				}
			}else
			{
				if (result)
				{
					if (onFacebookLoginSuccess != null)
					{
						onFacebookLoginSuccess();
						//onFacebookLoginSuccess = null;
					}
				}else
				{
					if (onFacebookLoginFail != null)
					{
						onFacebookLoginFail();
						//onFacebookLoginFail = null;
					}
				}
			}
		}
		
		private static function facebookInit():void
		{
			/*Facebook.getInstance().removeEventListener(FacebookEvent.GRAPH_API_SUCCESS_EVENT, facebookInit);
			isLogIn = Facebook.getInstance().isLogIn();
			if (onFacebookIniSuccess != null)
			{
				onFacebookIniSuccess();
				onFacebookIniSuccess = null;
			}*/
		}
		
		private static function facebookMobileInit(result:Object, fail:Object):void
		{
			if (fail)
			{
				if (fail.type == "ioError")
				{
					if (onFacebookIniFail != null)
					{
						onFacebookIniFail();
					}
				}else
				{
					if (onFacebookIniSuccess != null)
					{
						onFacebookIniSuccess();
						//onFacebookIniSuccess = null;
					}
				}
				isLogIn = false;
			}else
			{
				if (result)
				{
					isLogIn = true;
				}
				else
				{
					isLogIn = false;
				}
				if (onFacebookIniSuccess != null)
				{
					onFacebookIniSuccess();
					//onFacebookIniSuccess = null;
				}
			}
		}
		
		private static function getWebView():StageWebView
		{
			if (webView) webView.dispose();
			webView = new StageWebView();
			webView.stage = Starling.current.nativeStage;
			webView.assignFocus();
			webView.addEventListener(Event.COMPLETE, loginCarregado);
			
			webView.addEventListener(ErrorEvent.ERROR, onWebViewError);
			
			overlay = new Sprite();
			overlay.graphics.beginFill(0x000000, 0.5);
			overlay.graphics.drawRect(0, 0, (Starling.current.stage.stageWidth  * Assets.scale), (Starling.current.stage.stageHeight * Assets.scale));
			overlay.graphics.endFill();
			overlay.visible = false;
			Starling.current.nativeStage.stage.addChild(overlay);
			
			var xx:Number = ((Starling.current.stage.stageWidth * Assets.scale) - Assets.devices[Assets.currDevice].fbw) / 2;
			var yy:Number = ((Starling.current.stage.stageHeight * Assets.scale) - Assets.devices[Assets.currDevice].fbh) / 2;
			
			barra = new BarraFacebook(Assets.devices[Assets.currDevice].fbw);
			barra.x = xx;
			barra.y = yy - (barra.height / 2) - 2;
			barra.visible = false;
			barra.bt.addEventListener(MouseEvent.MOUSE_UP, onOutClick);
			
			border = new Sprite();
			border.graphics.beginFill(0x000000, 0.7);
			border.graphics.drawRoundRect(xx-boderSize, yy-boderSize-(barra.height/2), Assets.devices[Assets.currDevice].fbw + (boderSize*2), Assets.devices[Assets.currDevice].fbh + (boderSize*2) + barra.height, boderSize, boderSize);
			border.graphics.endFill();
			border.visible = false;
			Starling.current.nativeStage.stage.addChild(border);
			
			Starling.current.nativeStage.stage.addChild(barra);
			
			webView.viewPort = new Rectangle(xx, -Assets.devices[Assets.currDevice].fbh, Assets.devices[Assets.currDevice].fbw, Assets.devices[Assets.currDevice].fbh);
			overlay.addEventListener(MouseEvent.MOUSE_UP, onOutClick);
			
			if (onFacebookLoginLoad != null)
			{
				onFacebookLoginLoad();
			}
			
			return webView;
		}
		
		static private function onWebViewError(e:ErrorEvent):void 
		{
			if (onFacebookLoginFail != null)
			{
				onFacebookLoginFail();
				//onFacebookLoginFail = null;
			}
		}
		
		static private function loginCarregado(e:Event):void 
		{
			if (webView)
			{
				var xx:Number = ((Starling.current.stage.stageWidth * Assets.scale) - Assets.devices[Assets.currDevice].fbw) / 2;
				var yy:Number = (((Starling.current.stage.stageHeight * Assets.scale) - Assets.devices[Assets.currDevice].fbh) / 2) + (barra.height/2);
				
				if (overlay) overlay.visible = true;
				if (border) border.visible = true;
				if (barra) barra.visible = true;
				
				webView.viewPort = new Rectangle(xx, yy, Assets.devices[Assets.currDevice].fbw, Assets.devices[Assets.currDevice].fbh);
				
				webView.removeEventListener(Event.COMPLETE, loginCarregado);
			}
			if (onFacebookLoginComplete != null)
			{
				onFacebookLoginComplete();
			}
		}
		
		private static function onOutClick(e:MouseEvent):void
		{
			closeOverlays();
			if (webView)
			{
				webView.dispose();
				webView = null;
			}
		}
		
		private static function closeOverlays():void
		{
			if (overlay)
			{
				overlay.removeEventListener(MouseEvent.MOUSE_UP, onOutClick);
				Starling.current.nativeStage.removeChild(overlay);
				overlay = null;
			}
			if (border)
			{
				Starling.current.nativeStage.removeChild(border);
				border = null;
			}
			if (barra)
			{
				Starling.current.nativeStage.removeChild(barra);
				barra.bt.removeEventListener(MouseEvent.MOUSE_UP, onOutClick);
				barra = null;
			}
		}
	}
}