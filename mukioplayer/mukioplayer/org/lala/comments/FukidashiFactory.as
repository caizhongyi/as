package org.lala.comments
{
    import flash.display.*;

    public class FukidashiFactory extends Object
    {

        public function FukidashiFactory()
        {
            return;
        }// end function

        public static function getFukidashi(param1:String) : MovieClip
        {
            var _loc_2:MovieClip = null;
            switch(param1)
            {
                case "loud":
                {
                    _loc_2 = new telopLoud();
                    break;
                }
                case "think":
                {
                    _loc_2 = new telopThink();
                    break;
                }
                default:
                {
                    _loc_2 = new telopNormal();
                    break;
                    break;
                }
            }
            _loc_2.gotoAndStop("RB");
            return _loc_2;
        }// end function

    }
}
