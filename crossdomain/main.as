package  {
	
	
    import flash.display.*;
    import flash.events.*;
    import flash.external.*;
	import flash.external.ExternalInterface;
    import flash.media.*;
    import flash.net.*;
    import flash.system.*;
    import flash.text.*;
    import flash.utils.*;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	
	public class main extends MovieClip{

		public function main() {
			// constructor code
			var loader:Loader = new Loader();
			loader.load(new URLRequest('http://i13.static.olcdn.com/c/201207/19/aTc2NmxlbGU=_015177.jpg'));
			this.addChild(loader)
		}

	}
	
}
