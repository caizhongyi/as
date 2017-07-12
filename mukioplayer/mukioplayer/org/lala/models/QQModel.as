package org.lala.models
{
    import com.jeroenwijering.models.*;
    import com.jeroenwijering.player.*;
    import org.lala.utils.*;

    public class QQModel extends VideoModel
    {

        public function QQModel(param1:Model)
        {
            super(param1);
            return;
        }// end function

        protected function getUrl(param1:String) : String
        {
            trace("MukioConfigger.QID2URI.replace(/{$id}/ig, vid) : " + MukioConfigger.QID2URI.replace(/\{\$id\}/ig, param1));
            trace("MukioConfigger.QID2URI : " + MukioConfigger.QID2URI);
            return MukioConfigger.QID2URI.replace(/\{\$id\}/ig, param1);
        }// end function

        override public function load(param1:Object) : void
        {
            this.item = param1;
            item.file = this.getUrl(param1.vid);
            super.load(item);
            return;
        }// end function

    }
}
