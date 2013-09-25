package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.common.commands.CommandBase;
	import com.xgame.godwar.common.interfaces.protocols.ISending;
	import com.xgame.godwar.configuration.SocketContextConfig;
	import com.xgame.godwar.utils.Int64;
	
	import flash.utils.ByteArray;
	
	public class SendingBase extends CommandBase implements ISending
	{
		protected var _byteData: ByteArray;
		
		public function SendingBase(protocolId:uint)
		{
			super(protocolId);
			_byteData = new ByteArray();
		}
		
		public function get byteData():ByteArray
		{
			return _byteData;
		}
		
		public function fill():void
		{
			_byteData.clear();
			_byteData.writeShort(protocolId);
		}
		
		public function fillTimestamp(): void
		{
			var time: Number = new Date().time;
			var time64: Int64 = Int64.fromNumber(time);
			
			_byteData.writeInt(8);
			_byteData.writeByte(SocketContextConfig.TYPE_LONG);
			_byteData.writeInt(time64.high);
			_byteData.writeUnsignedInt(time64.low);
		}
		
		public function get protocolName():String
		{
			return "SendingBase";
		}
	}
}