package com.jeroenwijering.plugins
{
    import com.jeroenwijering.utils.*;
    import flash.display.*;
    import flash.events.*;

    dynamic public class DockButton extends MovieClip
    {
        private var colors:Object;

        public function DockButton(param1:DisplayObject, param2:String, param3:Function, param4:Object = ) : void
        {
            mouseChildren = false;
            buttonMode = true;
            if (param1)
            {
                this.setImage(param1);
            }
            this.field.text = param2;
            addEventListener(MouseEvent.CLICK, param3);
            if (param4)
            {
                this.colors = param4;
                this.back.transform.colorTransform = this.colors["back"];
                this.icon.transform.colorTransform = this.colors["front"];
                addEventListener(MouseEvent.MOUSE_OVER, this.overHandler);
                addEventListener(MouseEvent.MOUSE_OUT, this.outHandler);
                this.field.textColor = this.colors["front"].color;
            }
            return;
        }// end function

        private function setImage(param1:DisplayObject) : void
        {
            Draw.clear(this.icon);
            this.icon.addChild(param1);
            this.icon.x = Math.round(width / 2 - this.icon.width / 2);
            this.icon.y = Math.round(height / 2 - this.icon.height / 2);
            return;
        }// end function

        private function outHandler(event:MouseEvent) : void
        {
            this.back.transform.colorTransform = this.colors["back"];
            return;
        }// end function

        private function overHandler(event:MouseEvent) : void
        {
            this.back.transform.colorTransform = this.colors["light"];
            return;
        }// end function

    }
}
