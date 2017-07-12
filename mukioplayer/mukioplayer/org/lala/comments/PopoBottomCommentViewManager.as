package org.lala.comments
{
    import flash.events.*;
    import flash.utils.*;
    import org.lala.events.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class PopoBottomCommentViewManager extends NBottomCommentViewManager
    {

        public function PopoBottomCommentViewManager(param1:CommentView, param2:CommentGetter, param3:CommentFilter)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override protected function addGetterListener() : void
        {
            getter.addEventListener(CommentDataManagerEvent.POPO_BOTTOM_SUBTITLE, addHandler);
            return;
        }// end function

        override protected function addToPool(param1:Object) : void
        {
            var _loc_2:* = new PopoSubtitleComment(param1);
            _loc_2.x = (Width - _loc_2.width) / 2;
            param1.on = true;
            param1.width = _loc_2.width;
            param1.height = _loc_2.height;
            param1.txtItem = _loc_2;
            param1.speed = 0;
            if (_loc_2.height > Height)
            {
                _loc_2.y = transformY(0, param1);
                param1.poolIndex = -1;
                freePool.push(param1);
            }
            else
            {
                insertPool(param1);
            }
            _stage.addChild(_loc_2);
            var _loc_3:* = new Timer(param1.duration, 1);
            _loc_3.addEventListener(TimerEvent.TIMER_COMPLETE, onEnd(param1));
            param1.tween = _loc_3;
            _loc_3.start();
            return;
        }// end function

    }
}
