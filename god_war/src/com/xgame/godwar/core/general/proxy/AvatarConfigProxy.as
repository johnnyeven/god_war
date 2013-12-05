package com.xgame.godwar.core.general.proxy
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.XMLLoader;
	import com.xgame.godwar.common.parameters.AvatarParameter;
	import com.xgame.godwar.core.loading.mediators.LoadingIconMediator;
	import com.xgame.godwar.core.login.mediators.CreateRoleMediator;
	import com.xgame.godwar.utils.manager.LanguageManager;
	
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class AvatarConfigProxy extends Proxy implements IProxy
	{
		public static const NAME: String = "AvatarConfigProxy";
		private var _avatarBasePath: String;
		private var _avatarIndex: Dictionary;
		
		public function AvatarConfigProxy()
		{
			super(NAME, null);
		}
		
		public function getAvatarConfig(): void
		{
			var _loader: XMLLoader = new XMLLoader("config/" + LanguageManager.language + "/avatar_config.xml", {onComplete: onGetAvatarConfig});
			_loader.load();
			
			sendNotification(LoadingIconMediator.LOADING_SHOW_NOTE);
		}
		
		private function onGetAvatarConfig(evt: LoaderEvent): void
		{
			var _config: XML = (evt.currentTarget as XMLLoader).content;
			var _container: Vector.<AvatarParameter> = new Vector.<AvatarParameter>();
			
			_avatarIndex = new Dictionary();
			_avatarBasePath = _config.base_path;
			
			for(var i: int = 0; i < _config.avatar.length(); i++)
			{
				var parameter: AvatarParameter = new AvatarParameter();
				parameter.id = _config.avatar[i].@id;
				parameter.bigPath = _config.avatar[i].big;
				parameter.normalPath = _config.avatar[i].normal;
				_container.push(parameter);
				
				_avatarIndex[parameter.id] = i;
			}
			setData(_container);
			
			sendNotification(LoadingIconMediator.LOADING_HIDE_NOTE);
			facade.sendNotification(CreateRoleMediator.SHOW_AVATAR_NOTE, _container);
		}

		public function get avatarBasePath():String
		{
			return _avatarBasePath;
		}

		public function get avatarIndex():Dictionary
		{
			return _avatarIndex;
		}


	}
}