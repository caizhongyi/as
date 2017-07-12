package 
{
    import MySlider.*;
    import fl.controls.*;

    public class MySlider extends Slider
    {

        public function MySlider()
        {
            return;
        }// end function

        override protected function configUI() : void
        {
            super.configUI();
            thumb.setSize(16, 16);
            thumb.useHandCursor = true;
            track.useHandCursor = true;
            track.setSize(-10, 6);
            return;
        }// end function

    }
}
