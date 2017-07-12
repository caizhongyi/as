package org.lala.utils
{
    import com.adobe.serialization.json.*;
    import com.jeroenwijering.utils.*;
    import flash.events.*;
    import flash.net.*;
    import org.lala.events.*;

    public class CommentGetter extends EventDispatcher
    {
        private var listviewready:Boolean = false;
        private var bnico:Boolean = false;
        private var xmlLoader:URLLoader;
        private var dataServer:NetConnection;
        private var fms:Fms;
        private var id:String;
        private var bfile:Boolean = false;
        private var _loadable:Boolean = true;
        private var bnewload:Boolean = false;
        private var length:int = 0;
        private var xmlLoader2:URLLoader;
        private var commentviewready:Boolean = false;
        private var type:String;
        private var userName:String;
        public static var URI_PARENT:String = "";
        public static var baseURL:String = "";

        public function CommentGetter()
        {
            this.xmlLoader = new URLLoader();
            this.xmlLoader.addEventListener(Event.COMPLETE, this.xmlHandler);
            this.xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this.xmlLoader2 = new URLLoader();
            this.xmlLoader2.addEventListener(Event.COMPLETE, this.xmlHandler);
            this.xmlLoader2.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            this.userName = "chxs" + Math.floor(Math.random() * 1000000);
            return;
        }// end function

        public function msg(param1:String, param2:String = "内部消息") : void
        {
            var _loc_3:Object = {mode:-1, stime:10086 * 60, size:25, color:0, date:param2, text:param1, border:false, id:"-1"};
            dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, _loc_3));
            return;
        }// end function

        private function xmlHandler(event:Event) : void
        {
            var dat:XML;
            var evt:* = event;
            try
            {
                dat = XML(evt.target.data);
                this.parseComment(dat);
            }
            catch (e:Error)
            {
                trace("xmlHandler : not a xml file.");
                ioErrorHandler();
            }
            return;
        }// end function

        private function parseURL(param1:String, param2:Boolean = false) : String
        {
            var url:* = param1;
            var brand:* = param2;
            var str:* = url.replace(/\{\$(id|type|puri)\}/igm, function () : String
            {
                if (arguments[1] == "id")
                {
                    return id;
                }
                if (arguments[1] == "type")
                {
                    return type;
                }
                if (arguments[1] == "puri")
                {
                    return URI_PARENT;
                }
                return "";
            }// end function
            );
            if (brand)
            {
                str = str + (str.lastIndexOf("?") == -1 ? ("?") : ("&")) + "r=" + Math.random();
            }
            return str;
        }// end function

        private function recieveMsgHandler(event:FmsEvent) : void
        {
            if (event.data.username == this.userName)
            {
                return;
            }
            var _loc_3:String = this;
            _loc_3.length = this.length + 1;
            var _loc_2:Object = {username::event.data.username, mode:uint(event.data.mode), stime:parseFloat(event.data.playTime), size:uint(event.data.fontsize), color:uint(event.data.color), date:event.data.times, text:String(event.data.message).replace(/(\/n|\\n|\n|\r\n)/g, "\r"), border:false, id:this.length++};
            trace("tmp Text : " + _loc_2.text);
            dispatchEvent(new CommentDataManagerEvent(_loc_2.mode, _loc_2));
            dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, _loc_2));
            return;
        }// end function

        private function parseComment2(param1:XML) : void
        {
            var item:*;
            var attrs:Array;
            var tmp:Object;
            var str:String;
            var appendattr:Object;
            var xml:* = param1;
            var lst:* = xml.descendants("d");
            var i:int;
            do
            {
                
                i = (i + 1);
                item = lst[i];
                attrs = String(item.@p).split(",");
                var _loc_3:String = this;
                _loc_3.length = this.length + 1;
                tmp;
                if (uint(attrs[1]) != 9)
                {
                    str = String(item).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                    tmp.text = str;
                    dispatchEvent(new CommentDataManagerEvent(tmp.mode, tmp));
                    dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                }
                else
                {
                    try
                    {
                        appendattr = JSON.decode(item);
                        str = String(appendattr[0]).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                        tmp.text = str;
                        tmp.x = appendattr[1];
                        tmp.y = appendattr[2];
                        tmp.alpha = appendattr[3];
                        tmp.style = appendattr[4];
                        tmp.duration = appendattr[5];
                        tmp.inStyle = appendattr[6];
                        tmp.outStyle = appendattr[7];
                        tmp.position = appendattr[8];
                        tmp.tStyle = appendattr[9];
                        tmp.tEffect = appendattr[10];
                        dispatchEvent(new CommentDataManagerEvent(tmp.style + tmp.position, tmp));
                        dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                    }
                    catch (error:Error)
                    {
                        trace("JSON decode failed!");
                        msg("一条弹幕坏掉了");
                    }
                }
            }while (i < lst.length())
            return;
        }// end function

        public function set loadable(param1:Boolean) : void
        {
            this._loadable = param1;
            return;
        }// end function

        private function getXmlUrl2(param1:String) : String
        {
            return "/pcomment/" + param1 + "/permanent/?r=" + Math.random();
        }// end function

        public function viewReady() : void
        {
            this.commentviewready = true;
            return;
        }// end function

        public function preview(param1:Object) : void
        {
            param1["text"] = String(param1.text).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
            dispatchEvent(new CommentDataManagerEvent(param1.mode, param1));
            return;
        }// end function

        public function get xmlPath() : String
        {
            return this.parseURL(MukioConfigger.SERVLOAD, true);
        }// end function

        public function send(param1:Object) : void
        {
            var obj:Object;
            var data:* = param1;
            data["text"] = String(data.text).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
            var _loc_3:String = this;
            _loc_3.length = this.length + 1;
            data["id"] = this.length + 1;
            dispatchEvent(new CommentDataManagerEvent(data.mode, data));
            dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, data));
            if (this.bfile || !this._loadable)
            {
                return;
            }
            if (MukioConfigger.SERVSEND == "")
            {
                return;
            }
            var postVariables:* = new URLVariables();
            postVariables.playerID = this.id;
            postVariables.message = data.text;
            postVariables.color = data.color;
            postVariables.fontsize = data.size;
            postVariables.mode = data.mode;
            postVariables.playTime = data.stime;
            postVariables.date = data.date;
            postVariables.action = "mukio_submit";
            var postRequest:* = new URLRequest(this.serverPath);
            postRequest.method = "POST";
            postRequest.data = postVariables;
            var postLoader:* = new URLLoader();
            postLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            try
            {
                postLoader.load(postRequest);
            }
            catch (e:Error)
            {
                trace("post Error");
            }
            if (this.fms)
            {
                obj;
                this.fms.sendMsg(obj);
            }
            return;
        }// end function

        public function get gatewayPath() : String
        {
            return this.parseURL(MukioConfigger.SERVGATEWAY);
        }// end function

        private function remoteError(event:Event) : void
        {
            this.msg("弹幕加载失败(- -)/");
            return;
        }// end function

        public function listReady() : void
        {
            this.listviewready = true;
            return;
        }// end function

        public function get serverPath() : String
        {
            return this.parseURL(MukioConfigger.SERVSEND);
        }// end function

        private function remoteHandler(param1) : void
        {
            var item:*;
            var tmp:Object;
            var str:String;
            var appendattr:Object;
            var result:* = param1;
            if (!result)
            {
                return;
            }
            var _loc_3:int = 0;
            var _loc_4:* = result;
            do
            {
                
                item = _loc_4[_loc_3];
                var _loc_5:String = this;
                _loc_5.length = this.length + 1;
                tmp;
                if (tmp.mode != 9)
                {
                    str = String(item[6]).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                    tmp.text = str;
                    dispatchEvent(new CommentDataManagerEvent(tmp.mode, tmp));
                    dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                }
                else
                {
                    try
                    {
                        appendattr = JSON.decode(item[6]);
                        str = String(appendattr[0]).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                        tmp.text = str;
                        tmp.x = appendattr[1];
                        tmp.y = appendattr[2];
                        tmp.alpha = appendattr[3];
                        tmp.style = appendattr[4];
                        tmp.duration = appendattr[5];
                        tmp.inStyle = appendattr[6];
                        tmp.outStyle = appendattr[7];
                        tmp.position = appendattr[8];
                        tmp.tStyle = appendattr[9];
                        tmp.tEffect = appendattr[10];
                        dispatchEvent(new CommentDataManagerEvent(tmp.style + tmp.position, tmp));
                        dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                    }
                    catch (error:Error)
                    {
                        trace("JSON decode failed!");
                        msg("一条弹幕坏掉了");
                    }
                }
            }while (_loc_4 in _loc_3)
            return;
        }// end function

        public function load(param1:String = "", param2:String = "", param3:Boolean = false, param4:Boolean = false, param5:Boolean = false, param6:Boolean = true) : void
        {
            var _loc_7:Object = null;
            var _loc_8:URLRequest = null;
            var _loc_9:URLVariables = null;
            var _loc_10:Responder = null;
            this.id = param1;
            this.type = param2;
            this.bfile = param3;
            this.bnico = param4;
            this.bnewload = param5;
            this._loadable = param6;
            if (param5)
            {
                this.length = 0;
                dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.NEW, null));
                this.bnewload = false;
            }
            if (this.fms)
            {
                this.fms.removeEventListener(FmsEvent.ACCEPTMSG, this.recieveMsgHandler);
                this.fms = null;
            }
            if (!this.bfile && this._loadable)
            {
                _loc_7 = {username:this.userName, playType:"video", sortSina:"new", movieID:this.id};
                this.fms = new Fms(_loc_7);
                this.fms.addEventListener(FmsEvent.ACCEPTMSG, this.recieveMsgHandler);
            }
            if (this._loadable)
            {
                if (MukioConfigger.SERVGATEWAY == "")
                {
                    _loc_8 = new URLRequest(this.bfile ? (this.id) : (this.xmlPath));
                    if (MukioConfigger.LOADMETHOD == "post")
                    {
                        _loc_9 = new URLVariables();
                        _loc_9.playerID = this.id;
                        _loc_9.action = "mukio_load";
                        _loc_8.method = "POST";
                        _loc_8.data = _loc_9;
                    }
                    this.xmlLoader.load(_loc_8);
                }
                else
                {
                    this.dataServer = new NetConnection();
                    this.dataServer.objectEncoding = ObjectEncoding.AMF3;
                    this.dataServer.connect(this.gatewayPath);
                    _loc_10 = new Responder(this.remoteHandler, this.remoteError);
                    this.dataServer.call("mukio.Getter.getcomments", _loc_10, this.id);
                }
            }
            return;
        }// end function

        private function ioErrorHandler(event:IOErrorEvent = null) : void
        {
            trace("io Error");
            this.msg("评论文件加载失败,或者发送失败");
            return;
        }// end function

        public function sendPopo(param1:Object) : void
        {
            var data:* = param1;
            var _loc_3:String = this;
            _loc_3.length = this.length + 1;
            data["id"] = this.length + 1;
            dispatchEvent(new CommentDataManagerEvent(data.style + data.position, data));
            dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, data));
            if (this.bfile || !this._loadable)
            {
                return;
            }
            if (MukioConfigger.SERVSEND == "")
            {
                return;
            }
            var textData:Array;
            var postVariables:* = new URLVariables();
            postVariables.playerID = this.id;
            postVariables.message = JSON.encode(textData);
            postVariables.color = data.color;
            postVariables.fontsize = data.size;
            postVariables.mode = data.mode;
            postVariables.playTime = data.stime;
            postVariables.date = data.date;
            postVariables.action = "mukio_submit";
            var postRequest:* = new URLRequest(this.serverPath);
            postRequest.method = "POST";
            postRequest.data = postVariables;
            var postLoader:* = new URLLoader();
            postLoader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
            try
            {
                postLoader.load(postRequest);
            }
            catch (e:Error)
            {
                trace("post Error");
            }
            return;
        }// end function

        public function get loadable() : Boolean
        {
            return this._loadable;
        }// end function

        private function parseComment(param1:XML) : void
        {
            var item:*;
            var tmp:Object;
            var str:String;
            var appendattr:Object;
            var attrs:Array;
            var xml:* = param1;
            var lst:* = xml.descendants("data");
            var i:int;
            do
            {
                
                i = (i + 1);
                item = lst[i];
                var _loc_3:String = this;
                _loc_3.length = this.length + 1;
                tmp;
                if (tmp.mode != 9)
                {
                    str = String(item.message).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                    tmp.text = str;
                    dispatchEvent(new CommentDataManagerEvent(tmp.mode, tmp));
                    dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                }
                else
                {
                    try
                    {
                        appendattr = JSON.decode(item.message);
                        str = String(appendattr[0]).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                        tmp.text = str;
                        tmp.x = appendattr[1];
                        tmp.y = appendattr[2];
                        tmp.alpha = appendattr[3];
                        tmp.style = appendattr[4];
                        tmp.duration = appendattr[5];
                        tmp.inStyle = appendattr[6];
                        tmp.outStyle = appendattr[7];
                        tmp.position = appendattr[8];
                        tmp.tStyle = appendattr[9];
                        tmp.tEffect = appendattr[10];
                        dispatchEvent(new CommentDataManagerEvent(tmp.style + tmp.position, tmp));
                        dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                    }
                    catch (error:Error)
                    {
                        trace("JSON decode failed!");
                        msg("一条弹幕坏掉了");
                    }
                }
            }while (i < lst.length())
            if (xml.l.length())
            {
                var _loc_3:int = 0;
                var _loc_4:* = xml.l;
                do
                {
                    
                    item = _loc_4[_loc_3];
                    try
                    {
                        attrs = String(item.@i).split(",");
                        tmp;
                        tmp.stime = parseFloat(attrs[0]);
                        tmp.size = uint(attrs[1]);
                        tmp.color = uint(attrs[2]);
                        tmp.mode = uint(attrs[3]);
                        tmp.date = Strings.date(new Date(parseInt(attrs[5])));
                        tmp.author = attrs[4];
                        tmp.border = false;
                        var _loc_5:String = this;
                        _loc_5.length = this.length + 1;
                        tmp.id = this.length + 1;
                        tmp.text = String(item).replace(/(\/n|\\n|\n|\r\n)/g, "\r");
                        dispatchEvent(new CommentDataManagerEvent(tmp.mode, tmp));
                        dispatchEvent(new CommentDataManagerEvent(CommentDataManagerEvent.ADDONE, tmp));
                    }
                    catch (e:Error)
                    {
                        msg("一条弹幕解析出错,继续下一条...");
                    }
                }while (_loc_4 in _loc_3)
            }
            this.parseComment2(xml);
            return;
        }// end function

    }
}
