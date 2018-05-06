package game.data 
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;	
	/**
	 * ...
	 * @author Fabio Toste
	 */
	public class NetworkData 
	{
		public static var GROUP_ID:String = "grupo";
		public static var connection:NetConnection;
		public static var netGroup:NetGroup;		
		
		public function NetworkData() 
		{
		}
		
		public static function init():void
		{
			connection = new NetConnection();
			connection.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			connection.connect("rtmfp:");
		}
		
		private static function netStatus(e:NetStatusEvent):void
		{
			switch(e.info.code)
			{
				case "NetConnection.Connect.Success":
					trace("conectado");
					setupGroup();
					break;
				case "NetGroup.Connect.Success": // e.info.group
                    trace("netgroup:conectado " + e.info.group);
                    break;
                case "NetGroup.Connect.Rejected": // e.info.group
					trace("netgroup:rejeitada " + e.info.group);
                case "NetGroup.Connect.Failed": // e.info.group
                    trace("netgroup:falhou " + e.info.group);
                    break;
                case "NetGroup.Posting.Notify": // e.info.message, e.info.messageID
                    trace("netgroup:" + e.info.message);
                    break;
				case "NetGroup.SendTo.Notify": // e.info.message, e.info.from, e.info.fromLocal
					trace("netgroup:" + e.info.message);
					break;
                case "NetGroup.LocalCoverage.Notify": //
					trace("netgroup: local " + e.info.message);
					break;
                case "NetGroup.Neighbor.Connect": // e.info.neighbor
					trace("netgroup: connect " + e.info.neighbor);
					break;
                case "NetGroup.Neighbor.Disconnect": // e.info.neighbor
					trace("netgroup: disconnect " + e.info.neighbor);
					break;
                case "NetGroup.MulticastStream.PublishNotify": // e.info.name
					trace("netgroup: PublishNotify " + e.info.name);
					break;
                case "NetGroup.MulticastStream.UnpublishNotify": // e.info.name
					trace("netgroup: UnpublishNotify " + e.info.name);
					break;
                case "NetGroup.Replication.Fetch.SendNotify": // e.info.index
                case "NetGroup.Replication.Fetch.Failed": // e.info.index
                case "NetGroup.Replication.Fetch.Result": // e.info.index, e.info.object
                case "NetGroup.Replication.Request": // e.info.index, e.info.requestID
			}
		}
		
		private static function setupGroup():void
		{
			var groupspec:GroupSpecifier = new GroupSpecifier(GROUP_ID);
			groupspec.ipMulticastMemberUpdatesEnabled = true;
			groupspec.multicastEnabled = true;
			groupspec.routingEnabled = true;
			groupspec.postingEnabled = true;
		 
			// This is a multicast IP address. More info: http://en.wikipedia.org/wiki/Multicast_address
			groupspec.addIPMulticastAddress("239.254.254.2:30304");
		 
			netGroup = new NetGroup(connection, groupspec.groupspecWithAuthorizations());
			netGroup.addEventListener(NetStatusEvent.NET_STATUS, netStatus);
			
			postMessage("init");
		}
		
		public static function postMessage(msg:String = ""):void
		{
			var message:Object = new Object;	
			message.button = msg;
			netGroup.post(message);
			netGroup.sendToAllNeighbors(message);
		}
	}
}