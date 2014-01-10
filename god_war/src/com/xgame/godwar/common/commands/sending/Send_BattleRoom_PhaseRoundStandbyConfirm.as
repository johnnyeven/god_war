package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_PhaseRoundStandbyConfirm extends SendingBase
	{
		public var soulCount: int;
		public var supplyCount: int;
		
		public function Send_BattleRoom_PhaseRoundStandbyConfirm()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CONFIRM);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(soulCount);
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(supplyCount);
		}
	}
}