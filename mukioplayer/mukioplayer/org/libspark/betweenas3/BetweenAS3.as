package org.libspark.betweenas3
{
    import flash.display.*;
    import org.libspark.betweenas3.core.easing.*;
    import org.libspark.betweenas3.core.ticker.*;
    import org.libspark.betweenas3.core.tweens.*;
    import org.libspark.betweenas3.core.tweens.actions.*;
    import org.libspark.betweenas3.core.tweens.decorators.*;
    import org.libspark.betweenas3.core.tweens.groups.*;
    import org.libspark.betweenas3.core.updaters.*;
    import org.libspark.betweenas3.core.updaters.display.*;
    import org.libspark.betweenas3.core.updaters.geom.*;
    import org.libspark.betweenas3.core.utils.*;
    import org.libspark.betweenas3.easing.*;
    import org.libspark.betweenas3.tickers.*;
    import org.libspark.betweenas3.tweens.*;

    public class BetweenAS3 extends Object
    {
        private static var _updaterClassRegistry:ClassRegistry = new ClassRegistry();
        private static var _updaterFactory:UpdaterFactory = new UpdaterFactory(_updaterClassRegistry);
        private static var _ticker:ITicker = new EnterFrameTicker();
        public static const VERSION:String = "0.2 (Alpha)";

        public function BetweenAS3()
        {
            return;
        }// end function

        public static function addChild(param1:DisplayObject, param2:DisplayObjectContainer) : ITween
        {
            return new AddChildAction(_ticker, param1, param2);
        }// end function

        public static function func(param1:Function, param2:Array = null, param3:Boolean = false, param4:Function = null, param5:Array = null) : ITween
        {
            return new FunctionAction(_ticker, param1, param2, param3, param4, param5);
        }// end function

        public static function parallel(... args) : ITweenGroup
        {
            return parallelTweens(args);
        }// end function

        public static function scale(param1:ITween, param2:Number) : ITween
        {
            return new ScaledTween(param1 as IITween, param2);
        }// end function

        public static function parallelTweens(param1:Array) : ITweenGroup
        {
            return new ParallelTween(param1, _ticker, 0);
        }// end function

        public static function physical(param1:Object, param2:Object, param3:Object = null, param4:IPhysicalEasing = null) : IObjectTween
        {
            var _loc_5:* = new PhysicalTween(_ticker);
            new PhysicalTween(_ticker).updater = _updaterFactory.createPhysical(param1, param2, param3, param4 || Physical.exponential());
            return _loc_5;
        }// end function

        public static function removeFromParent(param1:DisplayObject) : ITween
        {
            return new RemoveFromParentAction(_ticker, param1);
        }// end function

        public static function slice(param1:ITween, param2:Number, param3:Number, param4:Boolean = false) : ITween
        {
            if (param4)
            {
                param2 = param1.duration * param2;
                param3 = param1.duration * param3;
            }
            if (param2 > param3)
            {
                return new ReversedTween(new SlicedTween(param1 as IITween, param3, param2), 0);
            }
            return new SlicedTween(param1 as IITween, param2, param3);
        }// end function

        public static function repeat(param1:ITween, param2:uint) : ITween
        {
            return new RepeatedTween(param1 as IITween, param2);
        }// end function

        public static function physicalApply(param1:Object, param2:Object, param3:Object = null, param4:Number = 1, param5:IPhysicalEasing = null) : void
        {
            var _loc_6:* = new PhysicalTween(_ticker);
            new PhysicalTween(_ticker).updater = _updaterFactory.createPhysical(param1, param2, param3, param5 || Physical.exponential());
            _loc_6.update(param4);
            return;
        }// end function

        public static function bezier(param1:Object, param2:Object, param3:Object = null, param4:Object = null, param5:Number = 1, param6:IEasing = null) : IObjectTween
        {
            var _loc_7:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.createBezier(param1, param2, param3, param4);
            _loc_7.time = param5;
            _loc_7.easing = param6 || Linear.easeNone;
            return _loc_7;
        }// end function

        public static function physicalFrom(param1:Object, param2:Object, param3:IPhysicalEasing = null) : IObjectTween
        {
            var _loc_4:* = new PhysicalTween(_ticker);
            new PhysicalTween(_ticker).updater = _updaterFactory.createPhysical(param1, null, param2, param3 || Physical.exponential());
            return _loc_4;
        }// end function

        public static function delay(param1:ITween, param2:Number, param3:Number = 0) : ITween
        {
            return new DelayedTween(param1 as IITween, param2, param3);
        }// end function

        public static function reverse(param1:ITween, param2:Boolean = true) : ITween
        {
            var _loc_3:* = param2 ? (param1.duration - param1.position) : (0);
            if (param1 is ReversedTween)
            {
                return new TweenDecorator((param1 as ReversedTween).baseTween, _loc_3);
            }
            if ((param1 as Object).constructor == TweenDecorator)
            {
                param1 = (param1 as TweenDecorator).baseTween;
            }
            return new ReversedTween(param1 as IITween, _loc_3);
        }// end function

        public static function from(param1:Object, param2:Object, param3:Number = 1, param4:IEasing = null) : IObjectTween
        {
            var _loc_5:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.create(param1, null, param2);
            _loc_5.time = param3;
            _loc_5.easing = param4 || Linear.easeNone;
            return _loc_5;
        }// end function

        public static function tween(param1:Object, param2:Object, param3:Object = null, param4:Number = 1, param5:IEasing = null) : IObjectTween
        {
            var _loc_6:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.create(param1, param2, param3);
            _loc_6.time = param4;
            _loc_6.easing = param5 || Linear.easeNone;
            return _loc_6;
        }// end function

        public static function apply(param1:Object, param2:Object, param3:Object = null, param4:Number = 1, param5:Number = 1, param6:IEasing = null) : void
        {
            var _loc_7:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.create(param1, param2, param3);
            _loc_7.time = param4;
            _loc_7.easing = param6 || Linear.easeNone;
            _loc_7.update(param5);
            return;
        }// end function

        public static function physicalTo(param1:Object, param2:Object, param3:IPhysicalEasing = null) : IObjectTween
        {
            var _loc_4:* = new PhysicalTween(_ticker);
            new PhysicalTween(_ticker).updater = _updaterFactory.createPhysical(param1, param2, null, param3 || Physical.exponential());
            return _loc_4;
        }// end function

        public static function serial(... args) : ITweenGroup
        {
            return serialTweens(args);
        }// end function

        public static function bezierFrom(param1:Object, param2:Object, param3:Object = null, param4:Number = 1, param5:IEasing = null) : IObjectTween
        {
            var _loc_6:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.createBezier(param1, null, param2, param3);
            _loc_6.time = param4;
            _loc_6.easing = param5 || Linear.easeNone;
            return _loc_6;
        }// end function

        public static function bezierTo(param1:Object, param2:Object, param3:Object = null, param4:Number = 1, param5:IEasing = null) : IObjectTween
        {
            var _loc_6:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.createBezier(param1, param2, null, param3);
            _loc_6.time = param4;
            _loc_6.easing = param5 || Linear.easeNone;
            return _loc_6;
        }// end function

        public static function to(param1:Object, param2:Object, param3:Number = 1, param4:IEasing = null) : IObjectTween
        {
            var _loc_5:* = new ObjectTween(_ticker);
            new ObjectTween(_ticker).updater = _updaterFactory.create(param1, param2, null);
            _loc_5.time = param3;
            _loc_5.easing = param4 || Linear.easeNone;
            return _loc_5;
        }// end function

        public static function serialTweens(param1:Array) : ITweenGroup
        {
            return new SerialTween(param1, _ticker, 0);
        }// end function

        _ticker.start();
        ObjectUpdater.register(_updaterClassRegistry);
        DisplayObjectUpdater.register(_updaterClassRegistry);
        MovieClipUpdater.register(_updaterClassRegistry);
        PointUpdater.register(_updaterClassRegistry);
    }
}
