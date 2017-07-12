package com.jeroenwijering.events
{
    import flash.display.*;
    import flash.events.*;

    public class AbstractView extends EventDispatcher
    {

        public function AbstractView()
        {
            return;
        }// end function

        public function loadPlugin(param1:String, param2:String = null) : Boolean
        {
            return true;
        }// end function

        public function sendEvent(param1:String, param2:Object = ) : void
        {
            return;
        }// end function

        public function get config() : Object
        {
            return new Object();
        }// end function

        public function get skin() : MovieClip
        {
            return new MovieClip();
        }// end function

        public function getPlugin(param1:String) : Object
        {
            return {};
        }// end function

        public function getPluginConfig(param1:Object) : Object
        {
            return {};
        }// end function

        public function addControllerListener(param1:String, param2:Function) : void
        {
            return;
        }// end function

        public function get playlist() : Array
        {
            return new Array();
        }// end function

        public function removeControllerListener(param1:String, param2:Function) : void
        {
            return;
        }// end function

        public function removeModelListener(param1:String, param2:Function) : void
        {
            return;
        }// end function

        public function addViewListener(param1:String, param2:Function) : void
        {
            return;
        }// end function

        public function addModelListener(param1:String, param2:Function) : void
        {
            return;
        }// end function

        public function removeViewListener(param1:String, param2:Function) : void
        {
            return;
        }// end function

    }
}
