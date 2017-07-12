package org.lala.comments
{
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.text.*;
    import flash.utils.*;
    import org.lala.events.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class NBottomCommentViewManager extends CommentViewManager
    {

        public function NBottomCommentViewManager(param1:CommentView, param2:CommentGetter, param3:CommentFilter)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override protected function addGetterListener() : void
        {
            getter.addEventListener(CommentDataManagerEvent.NORMAL_BOTTOM_DISPLAY, addHandler);
            return;
        }// end function

        override protected function validateCheck(param1:int, param2:int, param3:int, param4:int, param5:Number, param6:int) : Boolean
        {
            var _loc_7:* = param1 + param4;
            var _loc_8:* = displayPools[param6] as Array;
            var _loc_9:int = 0;
            while (_loc_9 < _loc_8.length)
            {
                
                if (_loc_8[_loc_9].y > _loc_7 || _loc_8[_loc_9].bottom < param1)
                {
                    ;
                }
                else
                {
                    return false;
                }
                _loc_9++;
            }
            return true;
        }// end function

        override protected function pauseHandler(event:CommentViewEvent) : void
        {
            super.pauseHandler(event);
            return;
        }// end function

        override protected function playHandler(event:CommentViewEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            if (bplay)
            {
                return;
            }
            _loc_2 = 0;
            while (_loc_2 < displayPools.length)
            {
                
                _loc_3 = 0;
                while (_loc_3 < displayPools[_loc_2].length)
                {
                    
                    displayPools[_loc_2][_loc_3].tween.start();
                    _loc_3++;
                }
                _loc_2++;
            }
            _loc_2 = 0;
            while (_loc_2 < freePool.length)
            {
                
                freePool[_loc_2].tween.start();
                _loc_2++;
            }
            bplay = true;
            return;
        }// end function

        override protected function addToPool(param1:Object) : void
        {
            var _loc_2:* = tp.txt;
            _loc_2.defaultTextFormat = getFormate(Strings.innerSize(param1.size), MukioConfigger.CMTFONT, param1.color);
            _loc_2.autoSize = "left";
            if (MukioConfigger.CMTMAXSTYLED >= 0 && bordered_count > MukioConfigger.CMTMAXSTYLED)
            {
                _loc_2.filters = [];
            }
            else
            {
                _loc_2.filters = param1.color ? (MukioConfigger.CMTFILTER) : (MukioConfigger.CMTFILTERBLACK);
                var _loc_5:* = bordered_count + 1;
                bordered_count = _loc_5;
            }
            _loc_2.text = param1.text;
            param1.on = true;
            param1.height = _loc_2.height;
            param1.width = _loc_2.width;
            _loc_2.border = param1.border;
            _loc_2.borderColor = 6750207;
            _loc_2.x = (Width - _loc_2.width) / 2;
            param1.txtItem = _loc_2;
            param1.speed = 0;
            var _loc_3:* = new Timer(300, 10);
            param1.tween = _loc_3;
            if (_loc_2.height > Height)
            {
                param1.poolIndex = -1;
                freePool.push(param1);
                param1["on"] = true;
                _loc_2.y = this.transformY(0, param1);
            }
            else
            {
                insertPool(param1);
            }
            _loc_3.addEventListener(TimerEvent.TIMER_COMPLETE, onEnd(param1));
            _loc_3.start();
            if (btrack)
            {
                cview.dispatchCommentViewEvent(CommentViewEvent.TRACK, param1.id);
            }
            return;
        }// end function

        override protected function transformY(param1:int, param2:Object) : int
        {
            return Height - param1 - param2.height;
        }// end function

    }
}
