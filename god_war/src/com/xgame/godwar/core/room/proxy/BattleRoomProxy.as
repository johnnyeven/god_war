package com.xgame.godwar.core.room.proxy
{
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BattleRoomProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "BattleRoomProxy";
		
		public function BattleRoomProxy()
		{
			super(NAME, null);
		}
	}
}