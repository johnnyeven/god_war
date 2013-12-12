package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_PlayerSelectHero extends SendingBase
	{
		public var cardId: String;
		
		public function Send_BattleRoom_PlayerSelectHero()
		{
			super(SocketContextConfig.BATTLEROOM_PLAYER_SELECTED_HERO);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(cardId.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(cardId);
		}
	}
}