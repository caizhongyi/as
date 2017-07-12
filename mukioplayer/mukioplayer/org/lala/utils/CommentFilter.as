package org.lala.utils
{
    import flash.events.*;
    import flash.net.*;
    import org.lala.events.*;
    import org.lala.plugins.*;

    public class CommentFilter extends EventDispatcher
    {
        private var fArr:Array;
        private var cview:CommentView;
        private var ids:int = 0;
        private static var Mode:Array = ["mode", "color", "text"];
        public static var bWhiteList:Boolean = false;
        public static var bRegEnable:Boolean = false;
        public static var bEnable:Boolean = true;

        public function CommentFilter(param1:CommentView)
        {
            this.fArr = [];
            this.cview = param1;
            return;
        }// end function

        private function add(param1:int, param2:String, param3:String, param4:Boolean = true) : void
        {
            var _loc_5:String = this;
            _loc_5.ids = this.ids + 1;
            this.fArr.push({mode:param1, data:param3, exp:param2, normalExp:String(param2).replace(/(\^|\$|\\|\.|\*|\+|\?|\(|\)|\[|\]|\{|\}|\||\/)/g, "\\$1"), id:this.ids++, enable:param4});
            return;
        }// end function

        public function setEnable(param1:int, param2:Boolean) : void
        {
            var _loc_3:int = 0;
            while (_loc_3 < this.fArr.length)
            {
                
                if (this.fArr[_loc_3].id == param1)
                {
                    this.fArr[_loc_3].enable = param2;
                    return;
                }
                _loc_3++;
            }
            return;
        }// end function

        public function addItem(param1:String, param2:Boolean = true) : void
        {
            var _loc_3:int = 0;
            var _loc_4:String = null;
            var _loc_5:String = null;
            if (param1.length < 3)
            {
                _loc_3 = 2;
                _loc_4 = param1;
            }
            else
            {
                _loc_5 = param1.substr(0, 2);
                _loc_4 = param1.substr(2);
                switch(_loc_5)
                {
                    case "m=":
                    {
                        _loc_3 = 0;
                        break;
                    }
                    case "c=":
                    {
                        _loc_3 = 1;
                        break;
                    }
                    case "t=":
                    {
                        _loc_3 = 2;
                        break;
                    }
                    default:
                    {
                        _loc_3 = 2;
                        _loc_4 = param1;
                        break;
                        break;
                    }
                }
            }
            this.add(_loc_3, _loc_4, param1, param2);
            this.cview.dispatchCommentViewEvent(CommentViewEvent.FILTERADD, this.fArr[(this.fArr.length - 1)]);
            this.fArr.sortOn("mode");
            return;
        }// end function

        public function loadFromSharedObject(event:Event = null) : void
        {
            var cookie:SharedObject;
            var arr:Array;
            var i:int;
            var evt:* = event;
            try
            {
                cookie = SharedObject.getLocal("MukioPlayer", "/");
                arr = cookie.data["keywords"] as Array;
                i;
                while (i < arr.length)
                {
                    
                    this.addItem(arr[i]["keyword"], arr[i]["enable"]);
                    i = (i + 1);
                }
                bEnable = cookie.data["bEnable"];
                bRegEnable = cookie.data["bRegEnable"];
                bWhiteList = cookie.data["bWhiteList"];
                this.cview.dispatchCommentViewEvent(CommentViewEvent.FILTEINITIAL, null);
            }
            catch (e:Error)
            {
            }
            trace("loading filter " + i);
            return;
        }// end function

        public function savetoSharedObject(event:Event = null) : void
        {
            var cookie:SharedObject;
            var evt:* = event;
            var arr:Array;
            var i:int;
            while (i < this.fArr.length)
            {
                
                arr.push({keyword:this.fArr[i]["data"], enable:this.fArr[i]["enable"]});
                i = (i + 1);
            }
            try
            {
                cookie = SharedObject.getLocal("MukioPlayer", "/");
                cookie.data["keywords"] = arr;
                cookie.data["bEnable"] = bEnable;
                cookie.data["bRegEnable"] = bRegEnable;
                cookie.data["bWhiteList"] = bWhiteList;
                cookie.flush();
            }
            catch (e:Error)
            {
            }
            trace("saving filter " + i);
            return;
        }// end function

        public function validate(param1:Object) : Boolean
        {
            var _loc_4:Object = null;
            if (!bEnable)
            {
                return true;
            }
            var _loc_2:* = !bWhiteList;
            var _loc_3:int = 0;
            while (_loc_3 < this.fArr.length)
            {
                
                _loc_4 = this.fArr[_loc_3];
                if (!_loc_4.enable)
                {
                }
                else if (_loc_4.mode == 0)
                {
                    if (_loc_4.exp == String(param1.mode))
                    {
                        _loc_2 = bWhiteList;
                        break;
                    }
                }
                else if (_loc_4.mode == 1)
                {
                    if (parseInt(_loc_4.exp, 16) == param1.color)
                    {
                        _loc_2 = bWhiteList;
                        break;
                    }
                }
                else if (CommentFilter.bRegEnable)
                {
                    if (String(param1.text).search(_loc_4.exp) != -1)
                    {
                        _loc_2 = bWhiteList;
                        break;
                    }
                }
                else if (String(param1.text).search(_loc_4.normalExp) != -1)
                {
                    _loc_2 = bWhiteList;
                    break;
                }
                _loc_3++;
            }
            return _loc_2;
        }// end function

        public function deleteItem(param1:int) : void
        {
            trace("delete filter " + param1);
            var _loc_2:int = 0;
            while (_loc_2 < this.fArr.length)
            {
                
                if (this.fArr[_loc_2].id == param1)
                {
                    this.fArr.splice(_loc_2, 1);
                    return;
                }
                _loc_2++;
            }
            return;
        }// end function

    }
}
