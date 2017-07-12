package org.libspark.betweenas3.core.utils
{
    import __AS3__.vec.*;
    import flash.utils.*;

    public class ClassRegistry extends Object
    {
        private var _subclasses:Dictionary;
        private var _classes:Dictionary;

        public function ClassRegistry()
        {
            this._classes = new Dictionary();
            this._subclasses = new Dictionary();
            return;
        }// end function

        private function getClassTree(param1:Class) : Vector.<Class>
        {
            var superClassName:String;
            var klass:* = param1;
            var tree:* = new Vector.<Class>;
            var c:* = klass;
            while (c != null)
            {
                
                tree.push(c);
                var _loc_3:* = getQualifiedSuperclassName(c);
                superClassName = getQualifiedSuperclassName(c);
                if (_loc_3 != null)
                {
                    try
                    {
                        c = getDefinitionByName(superClassName) as Class;
                    }
                    catch (e:ReferenceError)
                    {
                        c = Object;
                    }
                    continue;
                }
                c;
            }
            return tree;
        }// end function

        public function registerClassWithTargetClassAndPropertyNames(param1:Class, param2:Class, param3:Array) : void
        {
            var _loc_4:* = param3.length;
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_4)
            {
                
                this.registerClassWithTargetClassAndPropertyName(param1, param2, param3[_loc_5]);
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

        public function getClassByTargetClassAndPropertyName(param1:Class, param2:String) : Class
        {
            var _loc_4:* = undefined;
            var _loc_3:* = this._classes[param1];
            if (_loc_3 != null)
            {
                var _loc_5:* = _loc_3[param2];
                _loc_4 = _loc_3[param2];
                if (_loc_5 != null)
                {
                    return _loc_4 as Class;
                }
                var _loc_5:* = _loc_3["*"];
                _loc_4 = _loc_3["*"];
                if (_loc_5 != null)
                {
                    return _loc_4 as Class;
                }
            }
            else
            {
                this.buildCacheFor(param1);
                return this.getClassByTargetClassAndPropertyName(param1, param2);
            }
            return null;
        }// end function

        public function registerClassWithTargetClassAndPropertyName(param1:Class, param2:Class, param3:String) : void
        {
            var _loc_7:uint = 0;
            var _loc_8:uint = 0;
            var _loc_9:Class = null;
            if (this._classes[param2] == undefined)
            {
                this.buildCacheFor(param2);
            }
            var _loc_4:* = this._classes;
            var _loc_5:* = this._classes[param2][param3] as Class;
            _loc_4[param2][param3] = param1;
            var _loc_6:* = this._subclasses[param2] as Vector.<Class>;
            if (this._subclasses[param2] as Vector.<Class> != null)
            {
                _loc_7 = _loc_6.length;
                _loc_8 = 0;
                while (_loc_8 < _loc_7)
                {
                    
                    _loc_9 = _loc_6[_loc_8];
                    if (_loc_4[_loc_9][param3] == _loc_5)
                    {
                        _loc_4[_loc_9][param3] = param1;
                    }
                    _loc_8 = _loc_8 + 1;
                }
            }
            return;
        }// end function

        private function buildCacheFor(param1:Class) : void
        {
            var _loc_8:Class = null;
            var _loc_9:Dictionary = null;
            var _loc_10:String = null;
            var _loc_11:Dictionary = null;
            var _loc_12:Dictionary = null;
            var _loc_13:Vector.<Class> = null;
            var _loc_14:int = 0;
            var _loc_15:Class = null;
            var _loc_2:* = this._classes;
            var _loc_3:* = this._subclasses;
            var _loc_4:* = new Dictionary();
            var _loc_5:* = this.getClassTree(param1);
            var _loc_6:* = this.getClassTree(param1).length;
            var _loc_7:* = this.getClassTree(param1).length;
            while (--_loc_7 >= 0)
            {
                
                _loc_8 = _loc_5[_loc_7];
                _loc_9 = _loc_2[_loc_8] as Dictionary;
                if (_loc_9 != null)
                {
                    _loc_11 = new Dictionary();
                    if (_loc_4 != null)
                    {
                        for (_loc_10 in _loc_4)
                        {
                            
                            _loc_11[_loc_10] = _loc_4[_loc_10];
                            if (!(_loc_10 in _loc_9))
                            {
                                _loc_9[_loc_10] = _loc_4[_loc_10];
                            }
                        }
                    }
                    for (_loc_10 in _loc_9)
                    {
                        
                        _loc_11[_loc_10] = _loc_9[_loc_10];
                    }
                    _loc_4 = _loc_11;
                }
                else
                {
                    _loc_12 = new Dictionary();
                    for (_loc_10 in _loc_4)
                    {
                        
                        _loc_12[_loc_10] = _loc_4[_loc_10];
                    }
                    _loc_2[_loc_8] = _loc_12;
                }
                if (_loc_3[_loc_8] != undefined)
                {
                    _loc_13 = _loc_3[_loc_8] as Vector.<Class>;
                    _loc_14 = _loc_7 - 1;
                    while (_loc_14 >= 0)
                    {
                        
                        _loc_15 = _loc_5[_loc_14];
                        if (_loc_13.indexOf(_loc_15) == -1)
                        {
                            _loc_13.push(_loc_15);
                        }
                        _loc_14 = _loc_14 - 1;
                    }
                    continue;
                }
                _loc_3[_loc_8] = _loc_5.slice(0, _loc_7);
            }
            return;
        }// end function

    }
}
