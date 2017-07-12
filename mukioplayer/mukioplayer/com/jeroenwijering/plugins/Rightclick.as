package com.jeroenwijering.plugins
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.net.*;
    import flash.system.*;
    import flash.ui.*;

    public class Rightclick extends Object implements PluginInterface
    {
        public var config:Object;
        private var view:AbstractView;
        private var about:ContextMenuItem;
        private var context:ContextMenu;
        private var debug:ContextMenuItem;
        private var fullscreen:ContextMenuItem;
        private var stretching:ContextMenuItem;

        public function Rightclick() : void
        {
            this.config = {};
            this.context = new ContextMenu();
            this.context.hideBuiltInItems();
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            var vie:* = param1;
            this.view = vie;
            this.view.skin.contextMenu = this.context;
            try
            {
                this.fullscreen = new ContextMenuItem("全屏切换...");
                this.addItem(this.fullscreen, this.fullscreenHandler);
            }
            catch (err:Error)
            {
            }
            this.stretching = new ContextMenuItem("缩放切换 " + this.getInfo(this.view.config["stretching"]) + "...");
            this.addItem(this.stretching, this.stretchHandler);
            if (this.view.config["abouttext"] == "JW Player" || this.view.config["abouttext"] == undefined)
            {
                this.about = new ContextMenuItem("About JW Player " + this.view.config["version"] + "...");
            }
            else
            {
                this.about = new ContextMenuItem("关于 " + this.view.config["abouttext"] + "...");
            }
            this.addItem(this.about, this.aboutHandler);
            if (Capabilities.isDebugger == true || this.view.config["debug"] != "none")
            {
                this.debug = new ContextMenuItem("Logging to " + Logger.output + "...");
                this.addItem(this.debug, this.debugHandler);
            }
            return;
        }// end function

        private function fullscreenHandler(event:ContextMenuEvent) : void
        {
            this.view.sendEvent(ViewEvent.FULLSCREEN);
            return;
        }// end function

        private function aboutHandler(event:ContextMenuEvent) : void
        {
            navigateToURL(new URLRequest(this.view.config["aboutlink"]), "_blank");
            return;
        }// end function

        private function addItem(param1:ContextMenuItem, param2:Function) : void
        {
            param1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, param2);
            param1.separatorBefore = true;
            this.context.customItems.push(param1);
            return;
        }// end function

        private function debugHandler(event:ContextMenuEvent) : void
        {
            var _loc_2:* = new Array(Logger.NONE, Logger.ARTHROPOD, Logger.CONSOLE, Logger.TRACE);
            var _loc_3:* = _loc_2.indexOf(Logger.output);
            if (_loc_3 == (_loc_2.length - 1))
            {
                _loc_3 = 0;
            }
            else
            {
                _loc_3 = _loc_3 + 1;
            }
            this.debug.caption = "Logging to " + _loc_2[_loc_3] + "...";
            Logger.output = _loc_2[_loc_3];
            return;
        }// end function

        private function stretchHandler(event:ContextMenuEvent) : void
        {
            var _loc_2:* = new Array(Stretcher.UNIFORM, Stretcher._16X9, Stretcher._4X3, Stretcher.FILL, Stretcher.EXACTFIT, Stretcher.NONE);
            var _loc_3:* = new Array("适合", "16:9", "4:3", "满屏", "拉伸", "原始大小");
            var _loc_4:* = _loc_2.indexOf(this.view.config["stretching"]);
            if (_loc_2.indexOf(this.view.config["stretching"]) == (_loc_2.length - 1))
            {
                _loc_4 = 0;
            }
            else
            {
                _loc_4 = _loc_4 + 1;
            }
            this.view.config["stretching"] = _loc_2[_loc_4];
            this.stretching.caption = "缩放切换 " + _loc_3[_loc_4] + "...";
            this.view.sendEvent(ViewEvent.REDRAW);
            return;
        }// end function

        private function getInfo(param1:String) : String
        {
            var _loc_2:* = new Array(Stretcher.UNIFORM, Stretcher._16X9, Stretcher._4X3, Stretcher.FILL, Stretcher.EXACTFIT, Stretcher.NONE);
            var _loc_3:* = new Array("适合", "16:9", "4:3", "满屏", "拉伸", "原始大小");
            var _loc_4:int = 0;
            while (_loc_4 < _loc_2.length)
            {
                
                if (_loc_2[_loc_4] == param1)
                {
                    return _loc_3[_loc_4];
                }
                _loc_4++;
            }
            return "未知";
        }// end function

    }
}
