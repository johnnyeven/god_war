package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_Spell extends SendingBase
	{
		public var attackerCard: String;
		public var defenderGuid: String = "";
		public var skillId: String;
		
		public function Send_BattleRoom_Spell()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_ACTION_SPELL);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(attackerCard.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(attackerCard);
			
			_byteData.writeInt(defenderGuid.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(defenderGuid);
			
			_byteData.writeInt(skillId.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(skillId);
		}
	}
}