package  {
	
	import fl.controls.*;
    import fl.managers.*;
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
	import CSSLoader;

	public class Main extends MovieClip{

		public function Main() {
			// constructor code
		   	/*var sprite : Sprite = new Sprite();
			var textbox :TextInput  = new TextInput();
			textbox.x = 100;
			var button : Button = new Button();
			button.x = 200;
			this.addChild(sprite);
			this.addChild(textbox);
			this.addChild(button);*/
			var tmp_txt:TextField=new TextField();
			addChild(tmp_txt);
			tmp_txt.htmlText="<a href='event:th' style='width:100px; height:20px; background:#000;color:red;'>替换</a>";
			tmp_txt.addEventListener(MouseEvent.CLICK,txtHandler);
			function txtHandler(evt:MouseEvent):void {
    			var xtxt:String=(tmp_txt.htmlText).split("替换").join("非常棒!");
    			tmp_txt.htmlText=xtxt;
			}
			
			var button:TextField=new TextField();
			button.x = 100;
			addChild(button);
			button.htmlText="<input type='text' class='textbox'  style='width:100px; height:20px; background:#000;'/>";
			button.addEventListener(MouseEvent.CLICK,btnHandler);
			function btnHandler(evt:MouseEvent):void {
    			var xtxt:String=(button.htmlText).split("click").join("ok!");
			}
			
			var cssloader : CSSLoader = new CSSLoader();
			cssloader.load('test.css',button);
		}

	}
	
}
