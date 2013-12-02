package com.xgame.godwar.common.commands.sending
{
	import com.xgame.godwar.common.parameters.CardGroupParameter;
	import com.xgame.godwar.configuration.SocketContextConfig;

	public class Send_Info_SaveCardConfig extends SendingBase
	{
		public var currentGroupId: int;
		public var list: Vector.<CardGroupParameter>;
		
		public function Send_Info_SaveCardConfig()
		{
			super(SocketContextConfig.INFO_SAVE_CARD_GROUP);
		}
		
		override public function fill():void
		{
			super.fill();
			
			_byteData.writeInt(4);
			_byteData.writeByte(SocketContextConfig.TYPE_INT);
			_byteData.writeInt(currentGroupId);
			
			for(var i: int = 0; i<list.length; i++)
			{
				_byteData.writeInt(4);
				_byteData.writeByte(SocketContextConfig.TYPE_INT);
				_byteData.writeInt(list[i].groupId);
				
				var cards: String = list[i].cards;
				_byteData.writeInt(cards.length);
				_byteData.writeByte(SocketContextConfig.TYPE_STRING);
				_byteData.writeUTF(cards);
			}
		}
	}
}