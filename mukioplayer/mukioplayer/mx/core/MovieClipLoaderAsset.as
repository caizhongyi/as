package mx.core
{
    import flash.display.*;
    import flash.events.*;
    import flash.system.*;
    import flash.utils.*;

    public class MovieClipLoaderAsset extends MovieClipAsset implements IFlexAsset, IFlexDisplayObject
    {
        protected var initialHeight:Number = 0;
        private var loader:Loader = null;
        private var initialized:Boolean = false;
        protected var initialWidth:Number = 0;
        private var requestedHeight:Number;
        private var requestedWidth:Number;
        static const VERSION:String = "3.6.0.12937";

        public function MovieClipLoaderAsset()
        {
            var _loc_1:* = new LoaderContext();
            _loc_1.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            if ("allowLoadBytesCodeExecution" in _loc_1)
            {
                _loc_1["allowLoadBytesCodeExecution"] = true;
            }
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
            loader.loadBytes(movieClipData, _loc_1);
            addChild(loader);
            return;
        }// end function

        override public function get width() : Number
        {
            if (!initialized)
            {
                return initialWidth;
            }
            return super.width;
        }// end function

        override public function set width(param1:Number) : void
        {
            if (!initialized)
            {
                requestedWidth = param1;
            }
            else
            {
                loader.width = param1;
            }
            return;
        }// end function

        override public function get measuredHeight() : Number
        {
            return initialHeight;
        }// end function

        private function completeHandler(event:Event) : void
        {
            initialized = true;
            initialWidth = loader.width;
            initialHeight = loader.height;
            if (!isNaN(requestedWidth))
            {
                loader.width = requestedWidth;
            }
            if (!isNaN(requestedHeight))
            {
                loader.height = requestedHeight;
            }
            dispatchEvent(event);
            return;
        }// end function

        override public function set height(param1:Number) : void
        {
            if (!initialized)
            {
                requestedHeight = param1;
            }
            else
            {
                loader.height = param1;
            }
            return;
        }// end function

        override public function get measuredWidth() : Number
        {
            return initialWidth;
        }// end function

        override public function get height() : Number
        {
            if (!initialized)
            {
                return initialHeight;
            }
            return super.height;
        }// end function

        public function get movieClipData() : ByteArray
        {
            return null;
        }// end function

    }
}
