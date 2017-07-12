package com.jeroenwijering.player
{
    import flash.utils.*;
    import mx.core.*;

    public class Player_EmbeddedSkin extends MovieClipLoaderAsset
    {
        public var dataClass:Class;
        private static var bytes:ByteArray = null;

        public function Player_EmbeddedSkin()
        {
            this.dataClass = Player_EmbeddedSkin_dataClass;
            initialWidth = 8800 / 20;
            initialHeight = 6000 / 20;
            return;
        }// end function

        override public function get movieClipData() : ByteArray
        {
            if (bytes == null)
            {
                bytes = ByteArray(new this.dataClass());
            }
            return bytes;
        }// end function

    }
}
