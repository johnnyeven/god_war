package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_ChangeFormation extends SendingBase
	{
		public var cardOut: String;
		public var cardIn: String;
		
		public function Send_BattleRoom_ChangeFormation()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_STANDBY_CHANGE_FORMATION);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(cardOut.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(cardOut);
			
			_byteData.writeInt(cardIn.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(cardIn);
		}
	}
}