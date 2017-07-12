package org.lala.comments
{
    import org.lala.events.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class PopoTopCommentViewManager extends PopoBottomCommentViewManager
    {

        public function PopoTopCommentViewManager(param1:CommentView, param2:CommentGetter, param3:CommentFilter)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override protected function addGetterListener() : void
        {
            getter.addEventListener(CommentDataManagerEvent.POPO_TOP_SUBTITLE, addHandler);
            return;
        }// end function

        override protected function transformY(param1:int, param2:Object) : int
        {
            return param1;
        }// end function

    }
}
