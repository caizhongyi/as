package com.jeroenwijering.utils
{
    import flash.display.*;
    import flash.text.*;
    import flash.utils.*;

    public class Draw extends Object
    {

        public function Draw()
        {
            return;
        }// end function

        public static function size(param1:DisplayObject, param2:Number, param3:Number) : void
        {
            var obj:* = param1;
            var wid:* = param2;
            var hei:* = param3;
            try
            {
                obj.width = Math.round(wid);
                obj.height = Math.round(hei);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        public static function set(param1:DisplayObject, param2:String, param3:Object) : void
        {
            var obj:* = param1;
            var prp:* = param2;
            var val:* = param3;
            try
            {
                obj[prp] = val;
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        public static function pos(param1:DisplayObject, param2:Number, param3:Number) : void
        {
            var obj:* = param1;
            var xps:* = param2;
            var yps:* = param3;
            try
            {
                obj.x = Math.round(xps);
                obj.y = Math.round(yps);
            }
            catch (err:Error)
            {
            }
            return;
        }// end function

        public static function text(param1:Sprite, param2:String, param3:String, param4:Number = 12, param5:String = "Arial", param6:Boolean = false, param7:Number = 100, param8:Number = 0, param9:Number = 0, param10:String = "left") : TextField
        {
            var _loc_11:* = new TextField();
            var _loc_12:* = new TextFormat();
            _loc_11.autoSize = "left";
            _loc_11.selectable = false;
            if (param6)
            {
                _loc_11.width = param7;
                _loc_11.multiline = true;
                _loc_11.wordWrap = true;
            }
            else
            {
                _loc_11.autoSize = param10;
            }
            _loc_11.x = param8;
            _loc_11.y = param9;
            _loc_12.font = param5;
            _loc_12.color = uint("0x" + param3);
            _loc_12.size = param4;
            _loc_12.underline = false;
            _loc_11.defaultTextFormat = _loc_12;
            _loc_11.text = param2;
            param1.addChild(_loc_11);
            return _loc_11;
        }// end function

        public static function rect(param1:Sprite, param2:String, param3:Number, param4:Number, param5:Number = 0, param6:Number = 0, param7:Number = 1) : Sprite
        {
            var _loc_8:Sprite = null;
            _loc_8 = new Sprite();
            _loc_8.x = param5;
            _loc_8.y = param6;
            _loc_8.graphics.beginFill(uint("0x" + param2), param7);
            _loc_8.graphics.drawRect(0, 0, param3, param4);
            param1.addChild(_loc_8);
            return _loc_8;
        }// end function

        public static function clear(param1:DisplayObjectContainer) : void
        {
            var _loc_2:* = param1.numChildren;
            var _loc_3:Number = 0;
            while (_loc_3 < _loc_2)
            {
                
                param1.removeChildAt(0);
                _loc_3 = _loc_3 + 1;
            }
            var _loc_4:int = 1;
            param1.scaleY = 1;
            param1.scaleX = _loc_4;
            return;
        }// end function

        public static function clone(param1:Sprite, param2:Boolean = false) : MovieClip
        {
            var cls:Class;
            var idx:Number;
            var tgt:* = param1;
            var adc:* = param2;
            var nam:* = getQualifiedClassName(tgt);
            try
            {
                cls = tgt.loaderInfo.applicationDomain.getDefinition(nam) as Class;
            }
            catch (e:Error)
            {
                cls = Object(tgt).constructor;
            }
            var dup:* = new cls;
            dup.transform = tgt.transform;
            dup.filters = tgt.filters;
            dup.cacheAsBitmap = tgt.cacheAsBitmap;
            dup.opaqueBackground = tgt.opaqueBackground;
            if (adc == true)
            {
                idx = tgt.parent.getChildIndex(tgt);
                tgt.parent.addChildAt(dup, (idx + 1));
            }
            return dup;
        }// end function

    }
}
