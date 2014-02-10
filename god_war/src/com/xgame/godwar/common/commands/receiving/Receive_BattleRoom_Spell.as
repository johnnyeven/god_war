package com.xgame.godwar.common.commands.receiving
{
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.enum.AttackInfo;
	
	import flash.utils.ByteArray;

	public class Receive_BattleRoom_Spell extends ReceivingBase
	{
		public var attackInfo: Vector.<AttackInfo>;
		
		public function Receive_BattleRoom_Spell()
		{
			super(SocketContextConfig.BATTLEROOM_ROUND_ACTION_SPELL);
			attackInfo = new Vector.<AttackInfo>();
		}
		
		override public function fill(data:ByteArray):void
		{
			super.fill(data);
			
			if (message == SocketContextConfig.ACK_CONFIRM)
			{
				var length: int;
				var type: int;
				var info: AttackInfo = new AttackInfo();
				while (data.bytesAvailable > 8)
				{
					length = data.readInt();
					type = data.readByte();
					switch(type)
					{
						case SocketContextConfig.TYPE_STRING:
							if(info.skillId == null)
							{
								info.skillId = data.readUTFBytes(length);
							}
							else if(info.attackerGuid == null)
							{
								info.attackerGuid = data.readUTFBytes(length);
							}
							else if(info.defenderGuid == null)
							{
								info.defenderGuid = data.readUTFBytes(length);
							}
							else if(info.attackerCard == null)
							{
								info.attackerCard = data.readUTFBytes(length);
							}
							else if(info.defenderCard == null)
							{
								info.defenderCard = data.readUTFBytes(length);
							}
							break;
						case SocketContextConfig.TYPE_INT:
							if(info.attackerCardPosition == int.MIN_VALUE)
							{
								info.attackerCardPosition = data.readInt();
							}
							else if (info.defenderCardPosition == int.MIN_VALUE)
							{
								info.defenderCardPosition = data.readInt();
							}
							else if (info.attackerAttackChange == int.MIN_VALUE)
							{
								info.attackerAttackChange = data.readInt();
							}
							else if(info.attackerAttack == int.MIN_VALUE)
							{
								info.attackerAttack = data.readInt();
							}
							else if(info.attackerDefChange == int.MIN_VALUE)
							{
								info.attackerDefChange = data.readInt();
							}
							else if(info.attackerDef == int.MIN_VALUE)
							{
								info.attackerDef = data.readInt();
							}
							else if(info.attackerMdefChange == int.MIN_VALUE)
							{
								info.attackerMdefChange = data.readInt();
							}
							else if(info.attackerMdef == int.MIN_VALUE)
							{
								info.attackerMdef = data.readInt();
							}
							else if(info.attackerHealthChange == int.MIN_VALUE)
							{
								info.attackerHealthChange = data.readInt();
							}
							else if(info.attackerHealth == int.MIN_VALUE)
							{
								info.attackerHealth = data.readInt();
							}
							else if(info.attackerHealthMaxChange == int.MIN_VALUE)
							{
								info.attackerHealthMaxChange = data.readInt();
							}
							else if(info.attackerHealthMax == int.MIN_VALUE)
							{
								info.attackerHealthMax = data.readInt();
							}
							else if(info.attackerRemainRound == int.MIN_VALUE)
							{
								info.attackerRemainRound = data.readInt();
							}
							else if(info.defenderAttackChange == int.MIN_VALUE)
							{
								info.defenderAttackChange = data.readInt();
							}
							else if(info.defenderAttack == int.MIN_VALUE)
							{
								info.defenderAttack = data.readInt();
							}
							else if(info.defenderDefChange == int.MIN_VALUE)
							{
								info.defenderDefChange = data.readInt();
							}
							else if(info.defenderDef == int.MIN_VALUE)
							{
								info.defenderDef = data.readInt();
							}
							else if(info.defenderMdefChange == int.MIN_VALUE)
							{
								info.defenderMdefChange = data.readInt();
							}
							else if(info.defenderMdef == int.MIN_VALUE)
							{
								info.defenderMdef = data.readInt();
							}
							else if(info.defenderHealthChange == int.MIN_VALUE)
							{
								info.defenderHealthChange = data.readInt();
							}
							else if(info.defenderHealth == int.MIN_VALUE)
							{
								info.defenderHealth = data.readInt();
							}
							else if(info.defenderHealthMaxChange == int.MIN_VALUE)
							{
								info.defenderHealthMaxChange = data.readInt();
							}
							else if(info.defenderHealthMax == int.MIN_VALUE)
							{
								info.defenderHealthMax = data.readInt();
							}
							else if(info.defenderRemainRound == int.MIN_VALUE)
							{
								info.defenderRemainRound = data.readInt();
							}
							break;
						case SocketContextConfig.TYPE_BOOL:
							if(!info.isSetAttackerCardUp)
							{
								info.attackCardUp = data.readBoolean();
								info.isSetAttackerCardUp = true;
							}
							else if(!info.isSetAttackerCardDisabled)
							{
								info.attackCardDisabled = data.readBoolean();
								info.isSetAttackerCardDisabled = true;
							}
							else if(!info.isSetDefenderCardUp)
							{
								info.defenderCardUp = data.readBoolean();
								info.isSetDefenderCardUp = true;
							}
							else if(!info.isSetDefenderCardDisabled)
							{
								info.defenderCardDisabled = data.readBoolean();
								info.isSetDefenderCardDisabled = true;
							}
							else if(!info.isSetAttackerStatus)
							{
								info.attackerIsStatus = data.readBoolean();
								info.isSetAttackerStatus = true;
							}
							else if(!info.isSetDefenderStatus)
							{
								info.defenderIsStatus = data.readBoolean();
								info.isSetDefenderStatus = true;
							}
							break;
					}
					if(info.attackerGuid != null && info.defenderGuid != null &&
					info.attackerCardPosition != int.MIN_VALUE && info.defenderCardPosition != int.MIN_VALUE &&
					info.isSetAttackerCardUp != false && info.isSetDefenderCardUp != false &&
					info.isSetAttackerCardDisabled != false && info.isSetDefenderCardDisabled != false &&
					info.attackerCard != null && info.defenderCard != null &&
					info.attackerAttackChange != int.MIN_VALUE && info.attackerAttack != int.MIN_VALUE &&
					info.attackerDefChange != int.MIN_VALUE && info.attackerDef != int.MIN_VALUE &&
					info.attackerMdefChange != int.MIN_VALUE && info.attackerMdef != int.MIN_VALUE &&
					info.attackerHealthChange != int.MIN_VALUE && info.attackerHealth != int.MIN_VALUE &&
					info.attackerHealthMaxChange != int.MIN_VALUE && info.attackerHealthMax != int.MIN_VALUE &&
					info.isSetAttackerStatus && info.attackerRemainRound != int.MIN_VALUE &&
					info.defenderAttackChange != int.MIN_VALUE && info.defenderAttack != int.MIN_VALUE &&
					info.defenderDefChange != int.MIN_VALUE && info.defenderDef != int.MIN_VALUE &&
					info.defenderMdefChange != int.MIN_VALUE && info.defenderMdef != int.MIN_VALUE &&
					info.defenderHealthChange != int.MIN_VALUE && info.defenderHealth != int.MIN_VALUE &&
					info.defenderHealthMaxChange != int.MIN_VALUE && info.defenderHealthMax != int.MIN_VALUE &&
					info.isSetDefenderStatus && info.defenderRemainRound != int.MIN_VALUE)
					{
						attackInfo.push(info);
					}
				}
			}
		}
	}
}