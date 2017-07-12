package org.lala.utils
{
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.utils.*;
    import org.lala.events.*;
    import org.lala.plugins.*;

    public class CommentSender extends EventDispatcher
    {
        private var _mode:int = 1;
        private var getter:CommentGetter;
        private var coldTime:Timer;
        private var bBusy:Boolean = false;
        private var latestComment:String = "";
        private var _size:int = 25;
        private var _color:int = 16777215;
        private var _userId:String = "aristotle_1987@126.com";
        private var commentUI:CommentListSender;
        private var nColdmsec:Number;
        public static var COLDTIME:int = 3000;

        public function CommentSender(param1:CommentListSender, param2:CommentGetter)
        {
            this.nColdmsec = CommentSender.COLDTIME;
            this.commentUI = param1;
            this.commentUI.addEventListener(CommentListViewEvent.SENDCOMMENT, this.sendCommentHandler);
            this.commentUI.addEventListener(CommentListViewEvent.SENDPOPOCOMMENT, this.sendPopoCommentHandler);
            this.commentUI.addEventListener(CommentListViewEvent.PREVIEWCOMMENT, this.previewCommentHandler);
            this.getter = param2;
            this.coldTime = new Timer(CommentSender.COLDTIME / 20, 20);
            this.coldTime.addEventListener(TimerEvent.TIMER_COMPLETE, this.coldDownHandler);
            this.coldTime.addEventListener(TimerEvent.TIMER, this.coldTrickHandler);
            return;
        }// end function

        public function get size() : Number
        {
            return this._size;
        }// end function

        public function set mode(param1:int) : void
        {
            this._mode = param1;
            return;
        }// end function

        public function set size(param1:Number) : void
        {
            this._size = param1;
            return;
        }// end function

        public function set color(param1:int) : void
        {
            this._color = param1;
            return;
        }// end function

        private function previewCommentHandler(event:CommentListViewEvent) : void
        {
            var _loc_2:Object = {stime:event.data.stime, text:event.data.text, mode:event.data.mode, color:event.data.color, size:event.data.size, date:Strings.date(), border:true, prev:true};
            this.getter.preview(_loc_2);
            return;
        }// end function

        private function coldDownHandler(event:TimerEvent) : void
        {
            this.bBusy = false;
            this.nColdmsec = CommentSender.COLDTIME;
            this.commentUI.dispatchCommentListViewEvent(CommentListViewEvent.COLDTRICKER, {enable:true, label:"·¢±í"});
            return;
        }// end function

        public function get mode() : int
        {
            return this._mode;
        }// end function

        public function get color() : int
        {
            return this._color;
        }// end function

        private function sendCommentHandler(event:CommentListViewEvent) : void
        {
            var _loc_2:Object = null;
            if (!event.data.am)
            {
                if (this.latestComment == event.data.text || this.bBusy)
                {
                    return;
                }
                _loc_2 = {stime:event.data.stime, text:event.data.text, mode:this._mode, color:this._color, size:this._size, date:Strings.date(), border:true};
                this.getter.send(_loc_2);
                this.latestComment = event.data.text;
                if (this.getter.loadable)
                {
                    this.bBusy = true;
                    this.coldTime.reset();
                    this.coldTime.start();
                }
            }
            else
            {
                _loc_2 = {stime:event.data.stime, text:event.data.text, mode:event.data.mode, color:event.data.color, size:event.data.size, date:Strings.date(), border:true};
                this.getter.send(_loc_2);
                this.latestComment = event.data.text;
            }
            return;
        }// end function

        private function sendPopoCommentHandler(event:CommentListViewEvent) : void
        {
            this.getter.sendPopo(event.data);
            return;
        }// end function

        private function coldTrickHandler(event:TimerEvent) : void
        {
            this.nColdmsec = this.nColdmsec - CommentSender.COLDTIME / 20;
            var _loc_2:* = String(this.nColdmsec / 1000);
            if (_loc_2.length == 3)
            {
                _loc_2 = _loc_2.concat("0");
            }
            else if (_loc_2.length == 2)
            {
                _loc_2 = _loc_2.concat("00");
            }
            else if (_loc_2.length == 1)
            {
                _loc_2 = _loc_2.concat(".00");
            }
            this.commentUI.dispatchCommentListViewEvent(CommentListViewEvent.COLDTRICKER, {enable:false, label:_loc_2 + "s CD"});
            return;
        }// end function

    }
}
