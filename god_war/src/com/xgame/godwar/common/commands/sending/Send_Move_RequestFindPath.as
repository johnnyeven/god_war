package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Move_RequestFindPath extends SendingBase
	{
		public var startX: int = int.MIN_VALUE;
		public var startY: int = int.MIN_VALUE;
		public var endX: int = int.MIN_VALUE;
		public var endY: int = int.MIN_VALUE;
		
		public function Send_Move_RequestFindPath()
		{
			super(SocketContextConfig.REQUEST_FIND_PATH);
		}
		
		override public function fill():void
		{
			super.fill();
			
			if(startX != int.MIN_VALUE)
			{
				_byteData.writeInt(4);
				_byteData.writeByte(SocketContextConfig.TYPE_INT);
				_byteData.writeInt(startX);
			}
			if(startY != int.MIN_VALUE)
			{
				_byteData.writeInt(4);
				_byteData.writeByte(SocketContextConfig.TYPE_INT);
				_byteData.writeInt(startY);
			}
			if(endX != int.MIN_VALUE)
			{
				_byteData.writeInt(4);
				_byteData.writeByte(SocketContextConfig.TYPE_INT);
				_byteData.writeInt(endX);
			}
			if(endY != int.MIN_VALUE)
			{
				_byteData.writeInt(4);
				_byteData.writeByte(SocketContextConfig.TYPE_INT);
				_byteData.writeInt(endY);
			}
		}
	}
}