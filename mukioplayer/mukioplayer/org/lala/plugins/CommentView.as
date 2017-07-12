package org.lala.plugins
{
    import com.jeroenwijering.events.*;
    import flash.display.*;
    import flash.events.*;
    import org.lala.comments.*;
    import org.lala.events.*;
    import org.lala.utils.*;

    public class CommentView extends EventDispatcher implements PluginInterface
    {
        public var config:Object;
        private var bcvm:NBottomCommentViewManager;
        private var getter:CommentGetter;
        public var clip:Sprite;
        private var cvm:CommentViewManager;
        private var cfilter:CommentFilter;
        private var popocvm:PopoCommentViewManager;
        private var popotcvm:PopoTopCommentViewManager;
        public var view:AbstractView;
        private var tcvm:NTopCommentViewManager;
        private var commentUI:CommentListSender;
        private var popobcvm:PopoBottomCommentViewManager;
        public var tp:TextPool;

        public function CommentView(param1:CommentGetter, param2:CommentListSender) : void
        {
            this.config = {};
            this.clip = new Sprite();
            this.clip.mouseChildren = false;
            this.clip.mouseEnabled = false;
            this.tp = new TextPool(this.clip);
            this.tp.init();
            this.getter = param1;
            this.commentUI = param2;
            this.commentUI.cview = this;
            this.cfilter = new CommentFilter(this);
            this.commentUI.addEventListener(CommentListViewEvent.COMMENTALPHA, this.commentAlphaHandler);
            return;
        }// end function

        private function filterAddHandler(event:CommentListViewEvent) : void
        {
            this.cfilter.addItem(event.data as String);
            this.cfilter.savetoSharedObject();
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent) : void
        {
            this.clip.x = this.config["x"];
            this.clip.y = this.config["y"];
            this.clip.height = this.config["height"];
            this.clip.width = this.config["width"];
            this.clip.scaleX = 1;
            this.clip.scaleY = 1;
            dispatchEvent(new CommentViewEvent(CommentViewEvent.RESIZE, {w:this.config["width"], h:this.config["height"]}));
            return;
        }// end function

        private function filterDeleteHandler(event:CommentListViewEvent) : void
        {
            this.cfilter.deleteItem(event.data as int);
            this.cfilter.savetoSharedObject();
            return;
        }// end function

        private function trackToggleHandler(event:CommentListViewEvent) : void
        {
            dispatchEvent(new CommentViewEvent(CommentViewEvent.TRACKTOGGLE, event.data));
            return;
        }// end function

        private function commentAlphaHandler(event:CommentListViewEvent) : void
        {
            this.clip.alpha = event.data.alpha;
            return;
        }// end function

        public function log(param1) : void
        {
            this.commentUI.log(param1);
            return;
        }// end function

        private function timeHandler(event:ModelEvent) : void
        {
            return;
        }// end function

        public function filterCheckBoxToggleHandler(event:CommentListViewEvent) : void
        {
            this.cfilter.savetoSharedObject();
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            this.view = param1;
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.view.addModelListener(ModelEvent.TIME, this.timeHandler);
            this.view.addModelListener(ModelEvent.STATE, this.stateHandler);
            this.commentUI.addEventListener(CommentListViewEvent.DISPLAYTOGGLE, this.toggleDisplayHandler);
            this.commentUI.addEventListener(CommentListViewEvent.TRACKTOGGLE, this.trackToggleHandler);
            this.commentUI.addEventListener(CommentListViewEvent.FILTERADD, this.filterAddHandler);
            this.commentUI.addEventListener(CommentListViewEvent.FILTERLISTENABLETOGGLE, this.filterEnableToggleHandler);
            this.commentUI.addEventListener(CommentListViewEvent.FILTERCHECKBOXTOGGLE, this.filterCheckBoxToggleHandler);
            this.commentUI.addEventListener(CommentListViewEvent.FILTERDELETE, this.filterDeleteHandler);
            this.tcvm = new NTopCommentViewManager(this, this.getter, this.cfilter);
            this.bcvm = new NBottomCommentViewManager(this, this.getter, this.cfilter);
            this.cvm = new CommentViewManager(this, this.getter, this.cfilter);
            this.popocvm = new PopoCommentViewManager(this, this.getter, this.cfilter);
            this.popobcvm = new PopoBottomCommentViewManager(this, this.getter, this.cfilter);
            this.popotcvm = new PopoTopCommentViewManager(this, this.getter, this.cfilter);
            this.getter.viewReady();
            this.cfilter.loadFromSharedObject();
            return;
        }// end function

        private function toggleDisplayHandler(event:CommentListViewEvent) : void
        {
            if (this.clip.visible == event.data)
            {
                return;
            }
            this.clip.visible = event.data;
            return;
        }// end function

        public function dispatchCommentViewEvent(param1:String, param2:Object) : void
        {
            dispatchEvent(new CommentViewEvent(param1, param2));
            return;
        }// end function

        private function stateHandler(event:ModelEvent = ) : void
        {
            switch(this.view.config["state"])
            {
                case ModelStates.PLAYING:
                case ModelStates.BUFFERING:
                {
                    dispatchEvent(new CommentViewEvent(CommentViewEvent.PLAY, null));
                    break;
                }
                case ModelStates.PAUSED:
                {
                    dispatchEvent(new CommentViewEvent(CommentViewEvent.PAUSE, null));
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function filterEnableToggleHandler(event:CommentListViewEvent) : void
        {
            this.cfilter.setEnable(event.data.id, event.data.enable);
            this.cfilter.savetoSharedObject();
            return;
        }// end function

    }
}
