package game.core 
{
	import com.freshplanet.nativeExtensions.AirNetworkInfo;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import air.net.URLMonitor;
	import flash.net.URLRequest;
	import flash.events.StatusEvent;
	
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.progress.NativeProgress;
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class Notification
	{
		private static var instance:Notification = null;
		
		private static var onOKFunction:Function = null;
		private static var onCancelFunction:Function = null;
		
		public static function getInstance():Notification
		{
			if (Notification.instance == null) Notification.instance = new Notification();
			return Notification.instance;
		}
		
		public static function showMessage(msg:String = "", title:String = "", onOK:Function = null, onCancel:Function = null):void
		{
			if (NativeAlert.isSupported)
			{
				onOKFunction = onOK;
				onCancelFunction = onCancel;
				NativeAlert.show(msg, title, "Cancelar", "OK", messageFeedback);
			}
		}
		
		public static function messageFeedback(e:NativeDialogEvent):void
		{
			if (int(e.index) == 1)
			{
				if (onOKFunction != null)
				{
					onOKFunction();
				}
			}else
			{
				if (onCancelFunction != null)
				{
					onCancelFunction();
				}
			}
			onOKFunction = null;
			onCancelFunction = null;
		}
		
		public static function showNetworkActivity():void
		{
			if (NativeProgress.isSupported)
			{
				NativeProgress.showNetworkActivityIndicatoror(true);
			}
		}
		
		public static function hideNetworkActivity():void
		{
			if (NativeProgress.isSupported)
			{
				NativeProgress.showNetworkActivityIndicatoror(false);
			}
		}
		
		public static function getNetWorkStatus():Boolean
		{
			var netinfo:Boolean = false;
			if (NetworkInfo.isSupported)
			{
			 	var netinterfaces:Vector.<NetworkInterface> = NetworkInfo.networkInfo.findInterfaces();
				var netlength:int = netinterfaces.length;
				for (var i:int = 0; i < netlength; i++) 
				{
					var isLocalHost:Boolean = (netinterfaces[i].displayName.indexOf("Loopback Pseudo-Interface") != -1) ? true : false;
					var isBluetooth:Boolean = (netinterfaces[i].displayName.indexOf("Bluetooth") != -1) ? true : false;
					if (!isLocalHost && !isBluetooth && netinterfaces[i].active == true)
					{
						netinfo = true;
						break;
					}
				}
			}else
			{
				netinfo = AirNetworkInfo.networkInfo.isConnected();
			}
			return netinfo;
		}
	}
}