package org.lala.comments
{
    import org.lala.events.*;
    import org.lala.plugins.*;
    import org.lala.utils.*;

    public class NTopCommentViewManager extends NBottomCommentViewManager
    {

        public function NTopCommentViewManager(param1:CommentView, param2:CommentGetter, param3:CommentFilter)
        {
            super(param1, param2, param3);
            return;
        }// end function

        override protected function addGetterListener() : void
        {
            getter.addEventListener(CommentDataManagerEvent.NORMAL_GREEN_TOP_DISPLAY, addHandler);
            return;
        }// end function

        override protected function transformY(param1:int, param2:Object) : int
        {
            return param1;
        }// end function

    }
}
