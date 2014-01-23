package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Receive_BattleRoom_Spell extends ReceivingBase
	{
		public var attackerGuid: String;
		public var attackerCard: String;
		public var defenderGuid: String;
		public var defenderCard: String;
		public var skillId: String;
		
		public function Receive_BattleRoom_Spell()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_ACTION_SPELL);
		}
	}
}