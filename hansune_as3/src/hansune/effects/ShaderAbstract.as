package hansune.effects
{
	import flash.display.Shader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.filters.ShaderFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import hansune.Hansune;

	/**
	 * @author hansoo
	 */
	 
	
	public class ShaderAbstract extends EventDispatcher
	{
		private var shaderPath : String;
		private var shaderLoader : URLLoader;
		private var shader : Shader;
		private var shaderFilter : ShaderFilter;

		public function ShaderAbstract(shader : String) : void
		{
			Hansune.copyright();
			shaderPath = shader;
		}

		public function init() : void
		{
			shaderLoader = new URLLoader();
			shaderLoader.dataFormat = URLLoaderDataFormat.BINARY;
			shaderLoader.addEventListener(Event.COMPLETE, onShaderLoaded);
			shaderLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErr);
			shaderLoader.load(new URLRequest(shaderPath));
		}
		
		public function getShaderFilter():ShaderFilter
		{
			return shaderFilter;
		}
		
		public function get data():Object
		{
			return shader.data;
		}
		
		private function onIOErr(e:IOErrorEvent):void{
			trace(e.toString());
		}

		private function onShaderLoaded(e : Event) : void
		{
			shaderLoader.removeEventListener(Event.COMPLETE, onShaderLoaded);
			shaderLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErr);
			
			shader = new Shader(e.currentTarget.data as ByteArray);
			shaderFilter = new ShaderFilter(shader);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

	}
}

