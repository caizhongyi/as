package fl.transitions
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;

    public class TransitionManager extends EventDispatcher
    {
        public var type:Object;
        public var _width:Number = NaN;
        public var _height:Number = NaN;
        public var _outerBounds:Rectangle;
        private var _visualPropList:Object;
        private var _triggerEvent:String;
        public var className:String = "TransitionManager";
        public var _innerBounds:Rectangle;
        private var _content:MovieClip;
        private var _contentAppearance:Object;
        private var _transitions:Object;
        private static var IDCount:int = 0;

        public function TransitionManager(param1:MovieClip)
        {
            this.type = TransitionManager;
            this._visualPropList = {x:null, y:null, scaleX:null, scaleY:null, alpha:null, rotation:null};
            this.content = param1;
            this._transitions = {};
            return;
        }// end function

        public function removeTransition(param1:Transition) : Boolean
        {
            if (!param1 || !this._transitions || !this._transitions[param1.ID])
            {
                return false;
            }
            param1.cleanUp();
            return delete this._transitions[param1.ID];
        }// end function

        public function saveContentAppearance() : void
        {
            var _loc_2:Object = null;
            var _loc_3:String = null;
            var _loc_1:* = this._content;
            if (!this._contentAppearance)
            {
                var _loc_4:* = {};
                this._contentAppearance = {};
                _loc_2 = _loc_4;
                for (_loc_3 in this._visualPropList)
                {
                    
                    _loc_2[_loc_3] = _loc_1[_loc_3];
                }
                _loc_2.colorTransform = _loc_1.transform.colorTransform;
            }
            this._innerBounds = _loc_1.getBounds(_loc_1);
            this._outerBounds = _loc_1.getBounds(_loc_1.parent);
            this._width = _loc_1.width;
            this._height = _loc_1.height;
            return;
        }// end function

        public function removeAllTransitions() : void
        {
            var _loc_1:Transition = null;
            for each (_loc_1 in this._transitions)
            {
                
                _loc_1.cleanUp();
                this.removeTransition(_loc_1);
            }
            return;
        }// end function

        function transitionInDone(param1:Object) : void
        {
            var _loc_2:Boolean = false;
            this.removeTransition(param1.target);
            if (this.numInTransitions == 0)
            {
                _loc_2 = this._content.visible;
                if (this._triggerEvent == "hide" || this._triggerEvent == "hideChild")
                {
                    this._content.visible = false;
                }
                if (_loc_2)
                {
                    this.dispatchEvent(new Event("allTransitionsInDone"));
                }
            }
            return;
        }// end function

        public function addTransition(param1:Transition) : Transition
        {
            var _loc_2:* = TransitionManager;
            _loc_2.IDCount = TransitionManager.IDCount + 1;
            param1.ID = TransitionManager.IDCount + 1;
            this._transitions[param1.ID] = param1;
            return param1;
        }// end function

        public function startTransition(param1:Object) : Transition
        {
            this.removeTransition(this.findTransition(param1));
            var _loc_2:* = param1.type;
            var _loc_3:* = new _loc_2(this._content, param1, this);
            this.addTransition(_loc_3);
            _loc_3.start();
            return _loc_3;
        }// end function

        function transitionOutDone(param1:Object) : void
        {
            var _loc_2:Boolean = false;
            this.removeTransition(param1.target);
            if (this.numOutTransitions == 0)
            {
                this.restoreContentAppearance();
                _loc_2 = this._content.visible;
                if (_loc_2 && (this._triggerEvent == "hide" || this._triggerEvent == "hideChild"))
                {
                    this._content.visible = false;
                }
                if (_loc_2)
                {
                    this.dispatchEvent(new Event("allTransitionsOutDone"));
                }
            }
            return;
        }// end function

        public function restoreContentAppearance() : void
        {
            var _loc_3:String = null;
            var _loc_1:* = this._content;
            var _loc_2:* = this._contentAppearance;
            for (_loc_3 in this._visualPropList)
            {
                
                _loc_1[_loc_3] = _loc_2[_loc_3];
            }
            _loc_1.transform.colorTransform = _loc_2.colorTransform;
            return;
        }// end function

        public function get numTransitions() : Number
        {
            var _loc_2:Transition = null;
            var _loc_1:Number = 0;
            for each (_loc_2 in this._transitions)
            {
                
                _loc_1 = _loc_1 + 1;
            }
            return _loc_1;
        }// end function

        public function findTransition(param1:Object) : Transition
        {
            var _loc_2:Transition = null;
            for each (_loc_2 in this._transitions)
            {
                
                if (_loc_2.type == param1.type)
                {
                    return _loc_2;
                }
            }
            return null;
        }// end function

        public function set content(param1:MovieClip) : void
        {
            this._content = param1;
            this.saveContentAppearance();
            return;
        }// end function

        public function get numInTransitions() : Number
        {
            var _loc_3:Transition = null;
            var _loc_1:Number = 0;
            var _loc_2:* = this._transitions;
            for each (_loc_3 in _loc_2)
            {
                
                if (!_loc_3.direction)
                {
                    _loc_1 = _loc_1 + 1;
                }
            }
            return _loc_1;
        }// end function

        public function get numOutTransitions() : Number
        {
            var _loc_3:Transition = null;
            var _loc_1:Number = 0;
            var _loc_2:* = this._transitions;
            for each (_loc_3 in _loc_2)
            {
                
                if (_loc_3.direction)
                {
                    _loc_1 = _loc_1 + 1;
                }
            }
            return _loc_1;
        }// end function

        public function get content() : MovieClip
        {
            return this._content;
        }// end function

        public function get transitionsList() : Object
        {
            return this._transitions;
        }// end function

        public function get contentAppearance() : Object
        {
            return this._contentAppearance;
        }// end function

        public static function start(param1:MovieClip, param2:Object) : Transition
        {
            if (!param1.__transitionManager)
            {
                param1.__transitionManager = new TransitionManager(param1);
            }
            if (param2.direction == 1)
            {
                param1.__transitionManager._triggerEvent = "hide";
            }
            else
            {
                param1.__transitionManager._triggerEvent = "reveal";
            }
            return param1.__transitionManager.startTransition(param2);
        }// end function

    }
}
