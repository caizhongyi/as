package com.jeroenwijering.utils
{
    import flash.events.*;
    import flash.external.*;
    import flash.net.*;

    public class Logger extends Object
    {
        private static var _output:String = "none";
        public static const ARTHROPOD:String = "arthropod";
        public static const TRACE:String = "trace";
        private static const CONNECTION_NAME:String = "app#com.carlcalderon.Arthropod.161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1:arthropod";
        public static const CONSOLE:String = "console";
        private static const CONNECTION:LocalConnection = new LocalConnection();
        public static const NONE:String = "none";

        public function Logger()
        {
            return;
        }// end function

        private static function object(param1:Object, param2:String) : void
        {
            var _loc_4:String = null;
            var _loc_3:* = param2.toUpperCase() + " ({";
            for (_loc_4 in param1)
            {
                
                if (param1[_loc_4] is Object)
                {
                    _loc_3 = _loc_3 + (_loc_4 + ":" + param1[_loc_4].toString() + ", ");
                }
            }
            _loc_3 = _loc_3.substr(0, _loc_3.length - 2);
            if (_loc_4)
            {
                _loc_3 = _loc_3 + "})";
            }
            Logger.send(_loc_3);
            return;
        }// end function

        public static function log(param1, param2:String = "log") : void
        {
            if (param1 == undefined)
            {
                send(param2.toUpperCase());
            }
            else if (param1 is String)
            {
                send(param2.toUpperCase() + " (" + param1 + ")");
            }
            else if (param1 is Boolean || param1 is Number || param1 is Array)
            {
                send(param2.toUpperCase() + " (" + param1.toString() + ")");
            }
            else
            {
                Logger.object(param1, param2);
            }
            return;
        }// end function

        public static function get output() : String
        {
            return Logger._output;
        }// end function

        public static function set output(param1:String) : void
        {
            if (param1 == ARTHROPOD)
            {
                CONNECTION.allowInsecureDomain("*");
                CONNECTION.addEventListener(StatusEvent.STATUS, Logger.status);
            }
            SharedObject.getLocal("com.jeroenwijering", "/").data["debug"] = param1;
            Logger._output = param1;
            return;
        }// end function

        private static function send(param1:String) : void
        {
            switch(Logger._output)
            {
                case ARTHROPOD:
                {
                    CONNECTION.send(CONNECTION_NAME, "debug", "CDC309AF", param1, 13421772);
                    break;
                }
                case CONSOLE:
                {
                    ExternalInterface.call("console.log", param1);
                    break;
                }
                case TRACE:
                {
                    trace(param1);
                    break;
                }
                case NONE:
                {
                    break;
                }
                default:
                {
                    ExternalInterface.call(Logger._output, param1);
                    break;
                    break;
                }
            }
            return;
        }// end function

        private static function status(event:StatusEvent) : void
        {
            return;
        }// end function

    }
}
