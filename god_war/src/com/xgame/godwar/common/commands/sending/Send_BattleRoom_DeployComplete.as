package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_BattleRoom_DeployComplete extends SendingBase
	{
		public var defenser: String;
		public var attacker1: String;
		public var attacker2: String;
		public var attacker3: String;
		
		public function Send_BattleRoom_DeployComplete()
		{
			super(SocketContextConfig.BATTLEROOM_DEPLOY_COMPLETE);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(defenser.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(defenser);
			
			_byteData.writeInt(attacker1.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(attacker1);
			
			_byteData.writeInt(attacker2.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(attacker2);
			
			_byteData.writeInt(attacker3.length);
			_byteData.writeByte(SocketContextConfig.TYPE_STRING);
			_byteData.writeUTF(attacker3);
		}
	}
}