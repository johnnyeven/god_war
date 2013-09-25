package com.xgame.godwar.core.general.proxy
{
	import com.xgame.godwar.common.commands.CommandList;
	import com.xgame.godwar.common.commands.receiving.Receive_Base_VerifyMap;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.core.center.CommandCenter;
	import com.xgame.godwar.utils.debug.Debug;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class MapProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "MapProxy";
		
		public function MapProxy(data:Object=null)
		{
			super(NAME, data);
			
			CommandCenter.instance.add(SocketContextConfig.BASE_VERIFY_MAP, onMapDataReceive);
			CommandList.instance.bind(SocketContextConfig.BASE_VERIFY_MAP, Receive_Base_VerifyMap);
		}
		
		private function onMapDataReceive(protocol: Receive_Base_VerifyMap): void
		{
			if(protocol.mapId != int.MIN_VALUE)
			{
				setData(protocol);
			}
			else
			{
				Debug.error(this, "地图验证信息错误，未获取到MapID");
			}
		}
	}
}