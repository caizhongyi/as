package org.lala.comments
{
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import fl.transitions.*;
    import fl.transitions.easing.*;
    import flash.display.*;
    import flash.events.*;
    import flash.text.*;
    import org.lala.events.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class CommentViewManager extends EventDispatcher
    {
        protected var tp:TextPool;
        protected var getter:CommentGetter;
        protected var cview:CommentView;
        protected var bplay:Boolean = true;
        protected var cfilter:CommentFilter;
        protected var mainArray:Array;
        protected var bordered_count:int = 0;
        protected var Width:int;
        protected var freePool:Array;
        protected var btrack:Boolean = false;
        protected var oldPos:Number = 0;
        protected var displayPools:Array;
        protected var mainPointer:int = 0;
        protected var Height:int;
        protected var _stage:Sprite;
        public static var aa:String = "normal";

        public function CommentViewManager(param1:CommentView, param2:CommentGetter, param3:CommentFilter) : void
        {
            this.displayPools = [];
            this.freePool = [];
            this.mainArray = [];
            this.Width = Player.WIDTH;
            this.Height = Player.HEIGHT;
            this.cview = param1;
            this.cview.addEventListener(CommentViewEvent.TIMER, this.timmerHandler);
            this.cview.addEventListener(CommentViewEvent.RESIZE, this.resizeHandler);
            this.cview.addEventListener(CommentViewEvent.PLAY, this.playHandler);
            this.cview.addEventListener(CommentViewEvent.PAUSE, this.pauseHandler);
            this.cview.addEventListener(CommentViewEvent.TRACKTOGGLE, this.trackToggleHandler);
            this.getter = param2;
            this.getter.addEventListener(CommentDataManagerEvent.NEW, this.newCommentDataHandler);
            this.addGetterListener();
            this._stage = param1.clip;
            this.tp = param1.tp;
            this.cfilter = param3;
            return;
        }// end function

        public function innerValidate(param1:Object) : Boolean
        {
            if (MukioConfigger.CMTMAX > 0 && this.commentLines > MukioConfigger.CMTMAX)
            {
                return false;
            }
            if (param1.trimmed == "")
            {
                return false;
            }
            if (param1.strWidth > MukioConfigger.CMTMAXWIDTH)
            {
                return false;
            }
            if (param1.strHeight > MukioConfigger.CMTMAXHEIGHT)
            {
                return false;
            }
            return true;
        }// end function

        protected function getSpeed(param1:Object) : Number
        {
            return (this.Width + Strings.innerSize(param1.size)) / MukioConfigger.CMTVCEF;
        }// end function

        protected function compareToBottom(param1:Object, param2:Object) : int
        {
            if (param1.bottom < param2.bottom)
            {
                return -1;
            }
            if (param1.bottom > param2.bottom)
            {
                return 1;
            }
            return 0;
        }// end function

        protected function getFormate(param1:Number, param2:String, param3:int) : TextFormat
        {
            return new TextFormat(param2, param1, param3, MukioConfigger.CMTBOLD);
        }// end function

        protected function validateCheck(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:int) : Boolean
        {
            var _loc_7:* = param1 + param4;
            var _loc_8:* = param2 + param3;
            var _loc_9:Array = [];
            var _loc_10:* = this.displayPools[param6] as Array;
            var _loc_11:int = 0;
            while (_loc_11 < _loc_10.length)
            {
                
                if (_loc_10[_loc_11].y > _loc_7 || _loc_10[_loc_11].bottom < param1)
                {
                    ;
                }
                else if (_loc_10[_loc_11].txtItem.x > _loc_8 || _loc_10[_loc_11].txtItem.x + _loc_10[_loc_11].txtItem.width < param2)
                {
                    _loc_9.push(_loc_10[_loc_11]);
                    ;
                }
                else
                {
                    return false;
                }
                _loc_11++;
            }
            _loc_11 = 0;
            while (_loc_11 < _loc_9.length)
            {
                
                if ((_loc_9[_loc_11].txtItem.x + _loc_9[_loc_11].txtItem.width) / (this.Width + _loc_9[_loc_11].txtItem.width - 1 / 3 * MukioConfigger.CMTSTARTPOS) < (this.Width - MukioConfigger.CMTSTARTPOS) / (this.Width + param3 - 1 / 3 * MukioConfigger.CMTSTARTPOS))
                {
                    ;
                }
                else
                {
                    return false;
                }
                _loc_11++;
            }
            return true;
        }// end function

        protected function del(param1:Object) : void
        {
            var _loc_2:int = 0;
            if (param1.poolIndex == -1)
            {
                _loc_2 = this.freePool.indexOf(param1);
                this.freePool.splice(_loc_2, 1);
                return;
            }
            _loc_2 = this.displayPools[param1.poolIndex].indexOf(param1);
            this.displayPools[param1.poolIndex].splice(_loc_2, 1);
            return;
        }// end function

        protected function newCommentDataHandler(event:CommentDataManagerEvent) : void
        {
            this.mainArray = [];
            this.mainPointer = 0;
            this.oldPos = 0;
            return;
        }// end function

        protected function timmerHandler(event:CommentViewEvent) : void
        {
            var _loc_2:* = Number(event.data) - 0.001;
            if (this.mainPointer >= this.mainArray.length || Math.abs(_loc_2 - this.oldPos) > 2)
            {
                this.seekToPoint(_loc_2);
                this.oldPos = _loc_2;
                if (this.mainPointer == this.mainArray.length)
                {
                    return;
                }
            }
            else
            {
                this.oldPos = _loc_2;
            }
            while (this.mainPointer < this.mainArray.length)
            {
                
                if (this.mainArray[this.mainPointer]["stime"] <= _loc_2)
                {
                    if (this.cfilter.validate(this.mainArray[this.mainPointer]) && this.innerValidate(this.mainArray[this.mainPointer]) && !this.mainArray[this.mainPointer]["on"])
                    {
                        this.addToPool(this.mainArray[this.mainPointer]);
                    }
                }
                else
                {
                    return;
                }
                var _loc_3:String = this;
                var _loc_4:* = this.mainPointer + 1;
                _loc_3.mainPointer = _loc_4;
            }
            return;
        }// end function

        protected function findPos2(param1:Object, param2:Array, param3:Function) : int
        {
            var _loc_6:int = 0;
            if (param2.length == 0)
            {
                return 0;
            }
            if (this.param3(param1, param2[0]) < 0)
            {
                return 0;
            }
            if (this.param3(param1, param2[(param2.length - 1)]) >= 0)
            {
                return param2.length;
            }
            var _loc_4:int = 0;
            var _loc_5:* = param2.length - 1;
            var _loc_7:int = 0;
            while (_loc_4 <= _loc_5)
            {
                
                _loc_6 = int((_loc_4 + _loc_5 + 1) / 2);
                _loc_7++;
                if (this.param3(param1, param2[(_loc_6 - 1)]) >= 0 && this.param3(param1, param2[_loc_6]) < 0)
                {
                    return _loc_6;
                }
                if (this.param3(param1, param2[(_loc_6 - 1)]) < 0)
                {
                    _loc_5 = _loc_6 - 1;
                }
                else if (this.param3(param1, param2[_loc_6]) >= 0)
                {
                    _loc_4 = _loc_6;
                }
                else
                {
                    trace("Error!");
                }
                if (_loc_7 > 1000)
                {
                    break;
                }
            }
            return -1;
        }// end function

        protected function addToPool(param1:Object) : void
        {
            var _loc_2:* = this.tp.txt;
            _loc_2.defaultTextFormat = this.getFormate(Strings.innerSize(param1.size), MukioConfigger.CMTFONT, param1.color);
            _loc_2.autoSize = "left";
            if (MukioConfigger.CMTMAXSTYLED >= 0 && this.bordered_count >= MukioConfigger.CMTMAXSTYLED)
            {
                _loc_2.filters = [];
            }
            else
            {
                _loc_2.filters = param1.color ? (MukioConfigger.CMTFILTER) : (MukioConfigger.CMTFILTERBLACK);
                var _loc_4:String = this;
                var _loc_5:* = this.bordered_count + 1;
                _loc_4.bordered_count = _loc_5;
            }
            param1.on = true;
            _loc_2.text = param1.text;
            _loc_2.x = this.Width - MukioConfigger.CMTSTARTPOS;
            param1.height = _loc_2.height;
            param1.width = _loc_2.width;
            _loc_2.border = param1.border;
            _loc_2.borderColor = 6750207;
            param1.txtItem = _loc_2;
            param1.speed = this.getSpeed(param1);
            var _loc_3:* = new Tween(_loc_2, "x", None.easeOut, this.Width - MukioConfigger.CMTSTARTPOS, -param1.txtItem.width - MukioConfigger.CMTSTARTPOS / 1.5, param1.speed, true);
            param1.tween = _loc_3;
            if (_loc_2.height > this.Height)
            {
                param1.poolIndex = -1;
                this.freePool.push(param1);
                param1["on"] = true;
                _loc_2.y = this.transformY(0, param1);
            }
            else
            {
                this.insertPool(param1);
            }
            _loc_3.addEventListener(TweenEvent.MOTION_FINISH, this.onEnd(param1));
            _loc_3.resume();
            if (this.btrack)
            {
                this.cview.dispatchCommentViewEvent(CommentViewEvent.TRACK, param1.id);
            }
            return;
        }// end function

        protected function seekToPoint(param1:Number) : void
        {
            this.mainPointer = this.findPos(param1, this.mainArray, "stime");
            return;
        }// end function

        protected function trackToggleHandler(event:CommentViewEvent) : void
        {
            this.btrack = event.data;
            return;
        }// end function

        protected function compareTo(param1:Object, param2:Object) : int
        {
            if (param1.stime < param2.stime)
            {
                return -1;
            }
            if (param1.stime > param2.stime)
            {
                return 1;
            }
            if (param1.date < param2.date)
            {
                return -1;
            }
            if (param1.date > param2.date)
            {
                return 1;
            }
            return 0;
        }// end function

        protected function findPos(param1:Number, param2:Array, param3:String) : int
        {
            var _loc_6:int = 0;
            if (param2.length == 0)
            {
                return 0;
            }
            if (param1 < param2[0][param3])
            {
                return 0;
            }
            if (param1 >= param2[(param2.length - 1)][param3])
            {
                return param2.length;
            }
            var _loc_4:int = 0;
            var _loc_5:* = param2.length - 1;
            var _loc_7:int = 0;
            while (_loc_4 <= _loc_5)
            {
                
                _loc_6 = int((_loc_4 + _loc_5 + 1) / 2);
                _loc_7++;
                if (param1 >= param2[(_loc_6 - 1)][param3] && param1 < param2[_loc_6][param3])
                {
                    return _loc_6;
                }
                if (param1 < param2[(_loc_6 - 1)][param3])
                {
                    _loc_5 = _loc_6 - 1;
                }
                else if (param1 >= param2[_loc_6][param3])
                {
                    _loc_4 = _loc_6;
                }
                else
                {
                    trace("Error!");
                }
                if (_loc_7 > 1000)
                {
                    break;
                }
            }
            return -1;
        }// end function

        protected function addGetterListener() : void
        {
            this.getter.addEventListener(CommentDataManagerEvent.NORMAL_FLOW_RTL, this.addHandler);
            this.getter.addEventListener(CommentDataManagerEvent.BIG_BLUE_FLOW_RTL, this.addHandler);
            this.getter.addEventListener(CommentDataManagerEvent.NORMAL_ORANGE_FLOW_RTL, this.addHandler);
            return;
        }// end function

        public function get commentLines() : int
        {
            return this.tp.onstage;
        }// end function

        protected function addHandler(event:CommentDataManagerEvent) : void
        {
            var _loc_4:String = null;
            var _loc_2:* = /(\t|\n|\s)/g;
            var _loc_3:Object = {on:false};
            for (_loc_4 in event.data)
            {
                
                _loc_3[_loc_4] = event.data[_loc_4];
            }
            _loc_3.strWidth = Strings.strWidth(event.data["text"], Strings.innerSize(event.data.size));
            _loc_3.strHeight = Strings.strHeight(event.data["text"], Strings.innerSize(event.data.size));
            _loc_3.trimmed = String(event.data["text"]).replace(_loc_2, "");
            if (_loc_3.border)
            {
                if (event.data["prev"])
                {
                    _loc_3.border = false;
                    this.addToPool(_loc_3);
                    return;
                }
                this.addToPool(_loc_3);
            }
            var _loc_5:* = this.findPos2(_loc_3, this.mainArray, this.compareTo);
            this.mainArray.splice(_loc_5, 0, _loc_3);
            if (this.mainPointer >= _loc_5)
            {
                var _loc_6:String = this;
                var _loc_7:* = this.mainPointer + 1;
                _loc_6.mainPointer = _loc_7;
            }
            return;
        }// end function

        protected function transformY(param1:int, param2:Object) : int
        {
            return param1;
        }// end function

        protected function pauseHandler(event:CommentViewEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (!this.bplay)
            {
                return;
            }
            _loc_2 = 0;
            while (_loc_2 < this.displayPools.length)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this.displayPools[_loc_2].length)
                {
                    
                    this.displayPools[_loc_2][_loc_3].tween.stop();
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < this.freePool.length)
            {
                
                this.freePool[_loc_2].tween.stop();
                _loc_2++;
            }
            this.bplay = false;
            return;
        }// end function

        protected function insertPool(param1:Object, param2:int = 0) : void
        {
            var y:int;
            var i:int;
            var displayPool:Array;
            var a:* = param1;
            var index:* = param2;
            try
            {
                y;
                i;
                if (!this.displayPools[index])
                {
                    this.displayPools[index] = [];
                }
                displayPool = this.displayPools[index] as Array;
                if (displayPool.length == 0)
                {
                    a["poolIndex"] = index;
                    a.txtItem.y = this.transformY(y, a);
                    a.y = y;
                    a.bottom = y + a.height;
                    displayPool.push(a);
                    return;
                }
                if (this.validateCheck(y, this.Width - MukioConfigger.CMTSTARTPOS, a.txtItem.width, a.height, a.speed, index))
                {
                    a["poolIndex"] = index;
                    a.txtItem.y = this.transformY(y, a);
                    a.y = y;
                    a.bottom = y + a.height;
                    displayPool.splice(this.findPos2(a, displayPool, this.compareToBottom), 0, a);
                    return;
                }
                i;
                while (i < displayPool.length)
                {
                    
                    y = (displayPool[i].bottom + 1);
                    if (this.validateCheck(y, this.Width - MukioConfigger.CMTSTARTPOS, a.txtItem.width, a.height, a.speed, index))
                    {
                        if (y + a.height > this.Height)
                        {
                            break;
                        }
                        else
                        {
                            a["poolIndex"] = index;
                            a.txtItem.y = this.transformY(y, a);
                            a.y = y;
                            a.bottom = y + a.height;
                            displayPool.splice(this.findPos2(a, displayPool, this.compareToBottom), 0, a);
                            return;
                        }
                    }
                    if (displayPool.length == 0)
                    {
                        break;
                    }
                    i = (i + 1);
                }
                this.insertPool(a, (index + 1));
            }
            catch (e:Error)
            {
                trace(e.name + ": " + e.message);
            }
            return;
        }// end function

        protected function playHandler(event:CommentViewEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (this.bplay)
            {
                return;
            }
            _loc_2 = 0;
            while (_loc_2 < this.displayPools.length)
            {
                
                _loc_3 = 0;
                while (_loc_3 < this.displayPools[_loc_2].length)
                {
                    
                    this.displayPools[_loc_2][_loc_3].tween.resume();
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < this.freePool.length)
            {
                
                this.freePool[_loc_2].tween.resume();
                _loc_2++;
            }
            this.bplay = true;
            return;
        }// end function

        protected function onEnd(param1:Object) : Function
        {
            var self:CommentViewManager;
            var a:* = param1;
            self;
            return function () : void
            {
                self.tp.txt = a.txtItem;
                if (a.txtItem.filters.length)
                {
                    var _loc_2:* = bordered_count - 1;
                    bordered_count = _loc_2;
                }
                delete a.tween;
                self.del(a);
                a.on = false;
                return;
            }// end function
            ;
        }// end function

        protected function resizeHandler(event:CommentViewEvent) : void
        {
            var _loc_2:* = event.data.w / this.Width;
            var _loc_3:* = event.data.h / this.Height;
            if (_loc_2 < _loc_3)
            {
                var _loc_4:* = _loc_2;
                this._stage.scaleX = _loc_2;
                this._stage.scaleY = _loc_4;
            }
            else
            {
                var _loc_4:* = _loc_3;
                this._stage.scaleX = _loc_3;
                this._stage.scaleY = _loc_4;
            }
            return;
        }// end function

        public static function getDeviceTextField() : TextField
        {
            return new DeviceTextFieldFactory().holdTextField;
        }// end function

    }
}
