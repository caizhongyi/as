package org.lala.comments
{
    import flash.display.*;
    import org.lala.events.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class PopoCommentViewManager extends CommentViewManager
    {

        public function PopoCommentViewManager(param1:CommentView, param2:CommentGetter, param3:CommentFilter)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override protected function addGetterListener() : void
        {
            getter.addEventListener(CommentDataManagerEvent.POPO_NORMAL, addHandler);
            getter.addEventListener(CommentDataManagerEvent.POPO_THINK, addHandler);
            getter.addEventListener(CommentDataManagerEvent.POPO_LOUD, addHandler);
            return;
        }// end function

        protected function getCompleteHandler(param1:Object, param2:Sprite) : Function
        {
            var self:PopoCommentViewManager;
            var a:* = param1;
            var popo:* = param2;
            self;
            return function () : void
            {
                self._stage.removeChild(popo);
                a.on = false;
                return;
            }// end function
            ;
        }// end function

        override protected function pauseHandler(event:CommentViewEvent) : void
        {
            return;
        }// end function

        override protected function playHandler(event:CommentViewEvent) : void
        {
            return;
        }// end function

        override protected function addToPool(param1:Object) : void
        {
            param1.on = true;
            var _loc_2:* = new PopoComment(param1);
            _loc_2.completeHandler = this.getCompleteHandler(param1, _loc_2);
            _stage.addChild(_loc_2);
            _loc_2.start();
            return;
        }// end function

    }
}
