package Main_fla
{
    import fl.controls.*;
    import flash.display.*;

    dynamic public class pai_29 extends MovieClip
    {
        public var draw:Button;
        public var list:MovieClip;
        public var back:Button;

        public function pai_29()
        {
            this.__setProp_draw_pai_();
            this.__setProp_back_pai_();
            return;
        }// end function

        function __setProp_draw_pai_()
        {
            try
            {
                this.draw["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.draw.emphasized = false;
            this.draw.enabled = true;
            this.draw.label = "单击拍摄";
            this.draw.labelPlacement = "right";
            this.draw.selected = false;
            this.draw.toggle = false;
            this.draw.visible = true;
            try
            {
                this.draw["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

        function __setProp_back_pai_()
        {
            try
            {
                this.back["componentInspectorSetting"] = true;
            }
            catch (e:Error)
            {
            }
            this.back.emphasized = false;
            this.back.enabled = true;
            this.back.label = "返回";
            this.back.labelPlacement = "right";
            this.back.selected = false;
            this.back.toggle = false;
            this.back.visible = true;
            try
            {
                this.back["componentInspectorSetting"] = false;
            }
            catch (e:Error)
            {
            }
            return;
        }// end function

    }
}
