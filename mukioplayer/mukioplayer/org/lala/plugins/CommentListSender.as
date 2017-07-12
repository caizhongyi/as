package org.lala.plugins
{
    import com.jeroenwijering.events.*;
    import com.jeroenwijering.player.*;
    import com.jeroenwijering.utils.*;
    import fl.controls.*;
    import fl.controls.dataGridClasses.*;
    import fl.data.*;
    import fl.events.*;
    import fl.managers.*;
    import flash.desktop.*;
    import flash.display.*;
    import flash.events.*;
    import flash.net.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;
    import org.lala.components.*;
    import org.lala.events.*;
    import org.lala.utils.*;

    public class CommentListSender extends EventDispatcher implements PluginInterface
    {
        private var tooltip:TextField;
        private var getter:CommentGetter;
        private var listPad:Sprite;
        private var listIco:MovieClip;
        private var filterLable:TextField;
        private var filterInput:TextField;
        private var sender:CommentSender;
        private var filterRegEnableCB:CheckBox;
        public var config:Object;
        private var alphaRegulator:AlphaSlider;
        private var trackIndex:int = 0;
        private var filterWhitelistCB:CheckBox;
        public var clip:Sprite;
        private var CommentIcon:Class;
        private var CycleIcon:Class;
        private var idIndex:Array;
        private var commentBtn:Object;
        private var tabs:TabButtons;
        private var dg:DataGrid;
        private var filterDatagrid:DataGrid;
        public var cview:CommentView;
        private var filterAddButton:Button;
        public var view:AbstractView;
        private var commentInput:TextField;
        private var modeStyleControl:ModeSelectControl;
        private var selectedModeButton:Button;
        private var windowWidth:int;
        private var filterEnableCB:CheckBox;
        private var trackTimer:Timer;
        private var mkconf:MukioConfigger;
        private var commentIco:Bitmap;
        private var oldTrackIndex:int = 0;
        private var cycleIco:Bitmap;
        private var _stime:Number = 0;
        private var colorPicker:ColorPicker;
        private var sendButton:Button;
        private var commentCountLabel:TextField;
        private var trackCommentButton:CheckBox;
        public static var BG_COLOR:int = 14606079;
        public static var FNT_COLOR2:int = 6447714;
        public static var WIDTH:int = 950;
        public static var HEIGHT:int = Y0 + 27;
        public static var tf2:TextFormat;
        public static var FNT_COLOR:int = 3289650;
        public static var Y0:int = Player.HEIGHT + 21;
        public static var X0:int = Player.WIDTH;
        public static var tf:TextFormat;

        public function CommentListSender(param1:CommentGetter) : void
        {
            this.config = {};
            this.CommentIcon = CommentListSender_CommentIcon;
            this.CycleIcon = CommentListSender_CycleIcon;
            this.idIndex = [];
            this.clip = new Sprite();
            var _loc_2:* = new ContextMenu();
            _loc_2.hideBuiltInItems();
            this.clip.contextMenu = _loc_2;
            this.listPad = new Sprite();
            this.listPad.graphics.beginFill(BG_COLOR);
            this.listPad.graphics.drawRoundRect(0, 0, WIDTH - X0, Y0 - 23, 5, 5);
            this.listPad.graphics.endFill();
            this.clip.addChild(this.listPad);
            this.getter = param1;
            this.getter.addEventListener(CommentDataManagerEvent.SETDATA, this.setData);
            this.getter.addEventListener(CommentDataManagerEvent.ADDONE, this.addItem);
            this.getter.addEventListener(CommentDataManagerEvent.NEW, this.newCommentDataHandler);
            this.getter.listReady();
            this.trackTimer = new Timer(500);
            this.trackTimer.addEventListener(TimerEvent.TIMER, this.trackTimerHandler);
            this.sender = new CommentSender(this, this.getter);
            addEventListener(CommentListViewEvent.COLDTRICKER, this.coldTrickerHandler);
            this.createUI();
            this.setStyle();
            return;
        }// end function

        private function filterAddHandler(event:MouseEvent) : void
        {
            if (this.filterInput.text != "")
            {
                this.dispatchCommentListViewEvent(CommentListViewEvent.FILTERADD, this.filterInput.text);
                this.filterInput.text = "";
            }
            return;
        }// end function

        private function dgSortedHandler(event:DataGridEvent) : void
        {
            this.trackCommentButton.selected = false;
            this.dispatchCommentListViewEvent(CommentListViewEvent.TRACKTOGGLE, false);
            return;
        }// end function

        private function commentAlphaHandler(event:CommentListViewEvent) : void
        {
            var _loc_2:* = SharedObject.getLocal("org.lala", "/");
            _loc_2.data["comment.alpha"] = event.data.value;
            _loc_2.flush();
            this.dispatchCommentListViewEvent(CommentListViewEvent.COMMENTALPHA, {alpha:event.data.value / 100});
            return;
        }// end function

        private function trackCommentHandler(event:Event) : void
        {
            var _loc_2:* = event.target as CheckBox;
            this.dispatchCommentListViewEvent(CommentListViewEvent.TRACKTOGGLE, _loc_2.selected);
            if (_loc_2.selected)
            {
                this.dg.dataProvider.sortOn("时间标签", Array.NUMERIC);
                this.trackTimer.start();
            }
            else
            {
                this.trackTimer.stop();
            }
            return;
        }// end function

        private function sendButtonHandler(event:MouseEvent = null) : void
        {
            if (this.parseCmd(this.commentInput.text))
            {
                return;
            }
            if (this.commentInput.text.length > 0)
            {
                this.dispatchCommentListViewEvent(CommentListViewEvent.SENDCOMMENT, {stime:this._stime, text:this.commentInput.text, am:false});
                this.commentInput.text = "";
            }
            return;
        }// end function

        private function newCommentDataHandler(event:CommentDataManagerEvent) : void
        {
            this.dg.removeAll();
            this.commentCountLabel.text = "当前评论条目 0";
            this.tabs.bt(0).label = "评论 0";
            return;
        }// end function

        private function setData(event:CommentDataManagerEvent) : void
        {
            var _loc_2:* = new DataProvider();
            var _loc_3:* = event.data;
            this.idIndex.length = _loc_3.length;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                _loc_2.addItem({时间标签:_loc_3[_loc_4]["stime"], 评论:_loc_3[_loc_4]["text"], 发布日期:_loc_3[_loc_4]["date"], id:_loc_3[_loc_4]["id"]});
                this.idIndex[_loc_3[_loc_4].id] = _loc_2.getItemAt((_loc_2.length - 1));
                _loc_4++;
            }
            this.dg.dataProvider = _loc_2;
            return;
        }// end function

        private function trackTimerHandler(event:TimerEvent) : void
        {
            if (this.trackCommentButton.selected && this.oldTrackIndex != this.trackIndex)
            {
                this.dg.selectedItem = this.idIndex[this.trackIndex];
                this.dg.scrollToSelected();
                this.oldTrackIndex = this.trackIndex;
            }
            return;
        }// end function

        private function inputEnterHandler(event:KeyboardEvent = null) : void
        {
            if (!event || event.keyCode == Keyboard.ENTER)
            {
                this.sendButtonHandler();
            }
            return;
        }// end function

        public function log(param1) : void
        {
            this.commentInput.text = Strings.cut(String(param1));
            return;
        }// end function

        private function showTooltip(event:ListEvent) : void
        {
            if (event.type == ListEvent.ITEM_ROLL_OUT)
            {
                this.tooltip.visible = false;
            }
            else if (event.columnIndex == 1)
            {
                this.tooltip.text = event.item["评论"];
                this.tooltip.y = this.listPad.mouseY + 2;
                this.tooltip.x = this.listPad.mouseX + 2;
                this.tooltip.visible = true;
            }
            return;
        }// end function

        private function inputFocusHandler(event:FocusEvent) : void
        {
            if (event.type == FocusEvent.FOCUS_IN)
            {
                this.view.skin.stage.addEventListener(MouseEvent.CLICK, this.stageClickHandler);
            }
            return;
        }// end function

        private function addItem(event:CommentDataManagerEvent) : void
        {
            var _loc_2:* = this.dg.dataProvider;
            _loc_2.addItem({时间标签:event.data["stime"], 评论:event.data["text"], 发布日期:event.data["date"], id:event.data["id"], author:event.data["author"]});
            var _loc_3:* = this.idIndex;
            var _loc_4:* = this.idIndex.length + 1;
            _loc_3.length = _loc_4;
            this.idIndex[event.data.id] = _loc_2.getItemAt((_loc_2.length - 1));
            this.commentCountLabel.text = "当前评论条目 " + _loc_2.length;
            this.tabs.bt(0).label = "评论 " + _loc_2.length;
            return;
        }// end function

        private function setStyle() : void
        {
            this.filterAddButton.setStyle("upSkin", YellowUpSkin);
            this.filterAddButton.setStyle("overSkin", YellowOverSkin);
            this.filterAddButton.setStyle("downSkin", YellowDownSkin);
            this.selectedModeButton.setStyle("upSkin", YellowUpSkin);
            this.selectedModeButton.setStyle("overSkin", YellowOverSkin);
            this.selectedModeButton.setStyle("downSkin", YellowDownSkin);
            this.selectedModeButton.setStyle("icon", ModelIcon);
            this.sendButton.setStyle("upSkin", YellowUpSkin);
            this.sendButton.setStyle("overSkin", YellowOverSkin);
            this.sendButton.setStyle("downSkin", YellowDownSkin);
            this.sendButton.setStyle("icon", SendIcon);
            this.tabs.bt(0).setStyle("icon", ListIcon);
            this.tabs.bt(1).setStyle("icon", ConfigIcon);
            return;
        }// end function

        public function dispatchCommentListViewEvent(param1:String, param2:Object) : void
        {
            dispatchEvent(new CommentListViewEvent(param1, param2));
            return;
        }// end function

        private function filerListEnableHandler(event:ListEvent) : void
        {
            if (event.columnIndex == 3)
            {
                this.dispatchCommentListViewEvent(CommentListViewEvent.FILTERLISTENABLETOGGLE, {id:event.item.id, enable:event.item.enable});
            }
            return;
        }// end function

        private function trackHandler(event:CommentViewEvent) : void
        {
            this.trackIndex = event.data as int;
            return;
        }// end function

        private function parseCmd(param1:String) : Boolean
        {
            return false;
        }// end function

        private function filterCheckBoxInitial(event:CommentViewEvent) : void
        {
            this.filterEnableCB.selected = CommentFilter.bEnable;
            this.filterRegEnableCB.selected = CommentFilter.bRegEnable;
            this.filterWhitelistCB.selected = CommentFilter.bWhiteList;
            return;
        }// end function

        private function createUI() : void
        {
            tf = new TextFormat("simsum", "12", FNT_COLOR);
            tf2 = new TextFormat("simsum", "12", FNT_COLOR2);
            StyleManager.setStyle("textFormat", tf);
            this.tabs = new TabButtons(this.listPad, 0, 0, WIDTH - X0, HEIGHT - 27 - 27 - 23);
            this.tabs.addTab("评论列表");
            this.tabs.addTab("过滤设置");
            this.tabs.addEventListener(CommentListViewEvent.TBBUTTONCHANGE, this.tabChangeHandler);
            this.dg = new DataGrid();
            this.dg.x = 1;
            this.dg.y = 0;
            this.dg.width = WIDTH - X0;
            this.dg.height = HEIGHT - 27 - 27 - 23;
            this.dg.columns = ["时间标签", "评论", "发布日期"];
            this.dg.columns[0].width = 60;
            this.dg.columns[0].sortOptions = Array.NUMERIC;
            this.dg.columns[0].labelFunction = function (param1:Object) : String
            {
                return Strings.digits(param1["时间标签"]);
            }// end function
            ;
            this.dg.columns[1].labelFunction = function (param1:Object) : String
            {
                return Strings.cut(param1["评论"]);
            }// end function
            ;
            this.dg.columns[1].width = 220;
            this.dg.columns[2].width = 128;
            this.dg.rowHeight = 20;
            this.dg.addEventListener(ListEvent.ITEM_ROLL_OUT, this.showTooltip);
            this.dg.addEventListener(ListEvent.ITEM_ROLL_OVER, this.showTooltip);
            this.dg.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, this.seekHandler);
            this.dg.addEventListener(DataGridEvent.HEADER_RELEASE, this.dgSortedHandler);
            this.dg.setStyle("cellRenderer", AlternatingRowColors);
            this.tabs.addItem(0, this.dg);
            this.dg.cacheAsBitmap = true;
            this.dg.opaqueBackground = 15856127;
            var dgCopyItm:* = new ContextMenuItem("复制选中评论");
            dgCopyItm.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (event:ContextMenuEvent) : void
            {
                if (dg.selectedIndex == -1)
                {
                    return;
                }
                Clipboard.generalClipboard.clear();
                Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT, dg.selectedItem["评论"]);
                return;
            }// end function
            );
            var dgCopyMn:* = new ContextMenu();
            dgCopyMn.hideBuiltInItems();
            dgCopyMn.customItems.push(dgCopyItm);
            this.dg.contextMenu = dgCopyMn;
            this.trackCommentButton = new CheckBox();
            this.trackCommentButton.move(625.5, (Y0 + 1));
            this.trackCommentButton.setSize(83, 25.4);
            this.trackCommentButton.selected = false;
            this.trackCommentButton.label = "追踪弹幕";
            this.trackCommentButton.addEventListener(Event.CHANGE, this.trackCommentHandler);
            this.filterEnableCB = new CheckBox();
            this.filterEnableCB.move(2, 7);
            this.filterEnableCB.setSize(100, 22);
            this.filterEnableCB.label = "启用过滤器";
            this.filterEnableCB.selected = true;
            this.tabs.addItem(1, this.filterEnableCB);
            this.filterRegEnableCB = new CheckBox();
            this.filterRegEnableCB.move(109, 7);
            this.filterRegEnableCB.setSize(140, 22);
            this.filterRegEnableCB.label = "启用正则表达式";
            this.filterRegEnableCB.selected = false;
            this.tabs.addItem(1, this.filterRegEnableCB);
            this.filterWhitelistCB = new CheckBox();
            this.filterWhitelistCB.move(238, 7);
            this.filterWhitelistCB.setSize(100, 22);
            this.filterWhitelistCB.label = "白名单模式";
            this.filterWhitelistCB.selected = false;
            this.tabs.addItem(1, this.filterWhitelistCB);
            this.filterEnableCB.addEventListener(Event.CHANGE, this.filterCheckHandler);
            this.filterRegEnableCB.addEventListener(Event.CHANGE, this.filterCheckHandler);
            this.filterWhitelistCB.addEventListener(Event.CHANGE, this.filterCheckHandler);
            this.filterLable = new TextField();
            this.filterLable.text = "屏蔽关键词或表达式:";
            this.filterLable.autoSize = "left";
            this.filterLable.setTextFormat(tf);
            this.filterLable.x = 0;
            this.filterLable.y = 41;
            this.filterLable.selectable = false;
            this.tabs.addItem(1, this.filterLable);
            this.filterInput = new TextField();
            this.filterInput.type = TextFieldType.INPUT;
            this.filterInput.border = true;
            this.filterInput.borderColor = 15658734;
            this.filterInput.background = true;
            this.filterInput.backgroundColor = 16777215;
            this.filterInput.x = 120;
            this.filterInput.y = 41;
            this.filterInput.width = 214;
            this.filterInput.height = 22;
            this.tabs.addItem(1, this.filterInput);
            this.filterAddButton = new Button();
            this.filterAddButton.x = 339;
            this.filterAddButton.y = 39;
            this.filterAddButton.width = 70;
            this.filterAddButton.height = 25.4;
            this.filterAddButton.label = "添加";
            this.tabs.addItem(1, this.filterAddButton);
            this.filterAddButton.addEventListener(MouseEvent.CLICK, this.filterAddHandler);
            this.filterDatagrid = new DataGrid();
            this.filterDatagrid.x = 1;
            this.filterDatagrid.y = 95 - 27;
            this.filterDatagrid.width = WIDTH - X0;
            this.filterDatagrid.height = HEIGHT - 61 - 34 - 27 - 23;
            this.filterDatagrid.columns = ["过滤类别", "关键词", "源"];
            this.filterDatagrid.columns[0].width = 70;
            this.filterDatagrid.columns[0].labelFunction = function (param1:Object) : String
            {
                var _loc_2:Array = ["模式", "颜色", "内容"];
                return _loc_2[param1["过滤类别"]];
            }// end function
            ;
            this.filterDatagrid.columns[1].labelFunction = function (param1:Object) : String
            {
                var _loc_2:Array = null;
                if (param1["过滤类别"] == 0)
                {
                    _loc_2 = [null, "从右往左", "从左往右", "从右往左-底部", "底部", "顶部", "从左往右"];
                    return _loc_2[param1["关键词"]] ? (_loc_2[param1["关键词"]]) : ("不合理的模式值");
                }
                else
                {
                }
                return param1["关键词"];
            }// end function
            ;
            this.filterDatagrid.setStyle("cellRenderer", AlternatingRowColors);
            var checkCol:* = new DataGridColumn("enable");
            checkCol.cellRenderer = CheckCellRenderer;
            checkCol.headerText = "使用状态";
            this.filterDatagrid.addColumn(checkCol);
            this.filterDatagrid.addEventListener(ListEvent.ITEM_CLICK, this.filerListEnableHandler);
            this.tabs.addItem(1, this.filterDatagrid);
            this.filterDatagrid.allowMultipleSelection = true;
            var mnItem:* = new ContextMenuItem("删除选中关键字");
            mnItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (event:ContextMenuEvent) : void
            {
                var _loc_2:Object = null;
                if (filterDatagrid.selectedIndices.length < 1)
                {
                    return;
                }
                for each (_loc_2 in filterDatagrid.selectedItems)
                {
                    
                    dispatchCommentListViewEvent(CommentListViewEvent.FILTERDELETE, _loc_2["id"]);
                    filterDatagrid.removeItem(_loc_2);
                }
                filterDatagrid.clearSelection();
                return;
            }// end function
            );
            var ctxMenu:* = new ContextMenu();
            ctxMenu.hideBuiltInItems();
            ctxMenu.customItems.push(mnItem);
            this.filterDatagrid.contextMenu = ctxMenu;
            this.tooltip = new TextField();
            this.tooltip.x = X0 + 60;
            this.tooltip.background = true;
            this.tooltip.backgroundColor = BG_COLOR;
            this.tooltip.border = true;
            this.tooltip.borderColor = FNT_COLOR;
            this.tooltip.autoSize = "left";
            this.tooltip.defaultTextFormat = tf;
            this.tooltip.visible = false;
            this.tooltip.y = 0;
            this.tooltip.text = "";
            this.selectedModeButton = new Button();
            this.selectedModeButton.move(2, (Y0 + 1));
            this.selectedModeButton.setSize(71, 25.4);
            this.selectedModeButton.label = "样式";
            this.clip.addChild(this.selectedModeButton);
            this.modeStyleControl = new ModeSelectControl();
            this.modeStyleControl.x = 0;
            this.modeStyleControl.y = (Y0 + 1) - 187 - 2;
            this.modeStyleControl.ref = this.selectedModeButton;
            this.clip.addChild(this.modeStyleControl);
            this.modeStyleControl.addEventListener(CommentListViewEvent.MODESTYLESIZECHANGE, this.modeStyleHandler);
            this.colorPicker = new ColorPicker();
            this.colorPicker.x = this.selectedModeButton.x + this.selectedModeButton.width + 3;
            this.colorPicker.y = this.selectedModeButton.y + 1;
            this.colorPicker.selectedColor = 16777215;
            this.colorPicker.addEventListener(ColorPickerEvent.CHANGE, function (event:ColorPickerEvent) : void
            {
                sender.color = colorPicker.selectedColor;
                return;
            }// end function
            );
            this.clip.addChild(this.colorPicker);
            this.commentInput = new TextField();
            this.commentInput.type = TextFieldType.INPUT;
            this.commentInput.x = 76 + 28;
            this.commentInput.y = Y0 + 2.5 - 2;
            this.commentInput.width = 332.6 + 28;
            this.commentInput.height = 22 + 2;
            this.commentInput.border = true;
            this.commentInput.borderColor = 16763678;
            this.commentInput.background = true;
            this.commentInput.backgroundColor = 15856127;
            this.commentInput.defaultTextFormat = new TextFormat("simhei", "20", 0);
            this.commentInput.setTextFormat(this.commentInput.defaultTextFormat);
            this.clip.addChild(this.commentInput);
            this.commentInput.addEventListener(FocusEvent.FOCUS_IN, this.inputFocusHandler);
            this.commentInput.addEventListener(FocusEvent.FOCUS_OUT, this.inputFocusHandler);
            this.commentInput.addEventListener(KeyboardEvent.KEY_DOWN, this.inputEnterHandler);
            this.sendButton = new Button();
            this.sendButton.x = 413.4 + 56;
            this.sendButton.y = Y0 + 1;
            this.sendButton.width = 71;
            this.sendButton.height = 25.4;
            this.sendButton.label = "发表";
            this.clip.addChild(this.sendButton);
            this.sendButton.addEventListener(MouseEvent.CLICK, this.sendButtonHandler);
            this.commentCountLabel = new TextField();
            this.commentCountLabel.x = 714;
            this.commentCountLabel.y = Y0 + 4;
            this.commentCountLabel.autoSize = "left";
            this.commentCountLabel.multiline = false;
            this.commentCountLabel.text = "";
            this.commentCountLabel.selectable = false;
            this.commentCountLabel.defaultTextFormat = tf;
            this.listPad.addChild(this.tooltip);
            return;
        }// end function

        private function filterListAdd(event:CommentViewEvent) : void
        {
            var _loc_2:* = this.filterDatagrid.dataProvider;
            _loc_2.addItem({过滤类别:event.data.mode, 关键词:event.data.exp, 源:event.data.data, id:event.data.id, enable:event.data.enable});
            this.filterDatagrid.selectedIndex = _loc_2.length - 1;
            this.filterDatagrid.scrollToSelected();
            return;
        }// end function

        private function resizeSendPad(param1:Number, param2:Number) : void
        {
            this.sendButton.x = param1 - this.sendButton.width;
            this.commentInput.width = param1 - this.selectedModeButton.width - this.colorPicker.width - this.sendButton.width - 12;
            var _loc_3:* = param2 - 27;
            this.sendButton.y = param2 - 27;
            var _loc_3:* = _loc_3;
            this.commentInput.y = _loc_3;
            var _loc_3:* = _loc_3;
            this.colorPicker.y = _loc_3;
            this.selectedModeButton.y = _loc_3;
            this.modeStyleControl.y = param2 - 216;
            (this.colorPicker.y + 1);
            this.listPad.y = param2 - 27 - Y0;
            this.listPad.x = param1 - WIDTH + X0;
            this.clip.graphics.clear();
            this.clip.graphics.beginFill(16777215);
            this.clip.graphics.drawRect(0, param2 - 27, param1, 27);
            this.clip.graphics.endFill();
            return;
        }// end function

        private function seekHandler(event:ListEvent) : void
        {
            this.view.sendEvent("SEEK", event.item["时间标签"]);
            trace("seek to " + event.item["时间标签"]);
            return;
        }// end function

        private function timeHandler(event:ModelEvent) : void
        {
            this._stime = event.data.position;
            return;
        }// end function

        private function stageClickHandler(event:MouseEvent) : void
        {
            if (!this.commentInput.hitTestPoint(event.stageX, event.stageY))
            {
                this.sendButton.setFocus();
                this.view.skin.stage.removeEventListener(MouseEvent.CLICK, this.stageClickHandler);
            }
            return;
        }// end function

        private function itemHandler(event:ControllerEvent) : void
        {
            var _loc_2:* = this.view.config["item"];
            var _loc_3:* = this.view.playlist[_loc_2];
            if (_loc_3["cid"] == undefined && _loc_3["vid"] != "-1")
            {
                _loc_3["cid"] = _loc_3["vid"];
            }
            if (_loc_3["nico"] != undefined)
            {
                _loc_3["nico"] = true;
            }
            else
            {
                _loc_3["nico"] = false;
            }
            if (_loc_3["cfile"])
            {
                this.getter.load(_loc_3["cfile"], _loc_3["type"], true, _loc_3["nico"], true);
            }
            else if (_loc_3["cid"])
            {
                this.getter.load(_loc_3["cid"], _loc_3["type"], false, false, true);
            }
            else
            {
                this.getter.load("", _loc_3["type"], true, false, true, false);
            }
            return;
        }// end function

        public function get stime() : Number
        {
            return this._stime;
        }// end function

        private function filterCheckHandler(event:Event) : void
        {
            CommentFilter.bEnable = this.filterEnableCB.selected;
            CommentFilter.bRegEnable = this.filterRegEnableCB.selected;
            CommentFilter.bWhiteList = this.filterWhitelistCB.selected;
            this.dispatchCommentListViewEvent(CommentListViewEvent.FILTERCHECKBOXTOGGLE, null);
            return;
        }// end function

        private function modeStyleHandler(event:CommentListViewEvent) : void
        {
            this.sender.mode = this.modeStyleControl.mode;
            this.sender.size = this.modeStyleControl.size;
            this.sender.color = this.modeStyleControl.color;
            this.colorPicker.selectedColor = this.modeStyleControl.color;
            return;
        }// end function

        public function initializePlugin(param1:AbstractView) : void
        {
            var vw:* = param1;
            this.view = vw;
            this.view.addControllerListener(ControllerEvent.RESIZE, this.resizeHandler);
            this.view.addControllerListener(ControllerEvent.ITEM, this.itemHandler);
            this.view.addModelListener(ModelEvent.TIME, this.timeHandler);
            this.cview.addEventListener(CommentViewEvent.TRACK, this.trackHandler);
            this.cview.addEventListener(CommentViewEvent.FILTERADD, this.filterListAdd);
            this.cview.addEventListener(CommentViewEvent.FILTEINITIAL, this.filterCheckBoxInitial);
            this.cycleIco = new this.CycleIcon() as Bitmap;
            this.cycleIco.alpha = 0.5;
            this.view.getPlugin("controlbar").addButton(this.cycleIco, "repeat", function (event:MouseEvent) : void
            {
                if (view.config["repeat"] != "single")
                {
                    view.config["repeat"] = "single";
                    cycleIco.alpha = 1;
                }
                else
                {
                    view.config["repeat"] = "none";
                    cycleIco.alpha = 0.5;
                }
                return;
            }// end function
            );
            this.alphaRegulator = new AlphaSlider();
            this.alphaRegulator.addEventListener(CommentListViewEvent.COMMENTALPHA, this.commentAlphaHandler);
            var cke:* = SharedObject.getLocal("org.lala", "/");
            if (typeof(cke.data["comment.alpha"]) == "number")
            {
                this.alphaRegulator.value = cke.data["comment.alpha"];
            }
            this.commentIco = new this.CommentIcon() as Bitmap;
            this.commentBtn = this.view.getPlugin("controlbar").addButton(this.commentIco, "comment", function (event:MouseEvent) : void
            {
                if (view.config["comment"] != false)
                {
                    view.config["comment"] = false;
                    commentIco.alpha = 0.5;
                    alphaRegulator.enabled = false;
                }
                else
                {
                    view.config["comment"] = true;
                    commentIco.alpha = 1;
                    alphaRegulator.enabled = true;
                }
                dispatchCommentListViewEvent(CommentListViewEvent.DISPLAYTOGGLE, view.config["comment"]);
                return;
            }// end function
            );
            this.alphaRegulator.rel = this.commentBtn;
            this.commentBtn.parent.addChild(this.alphaRegulator);
            this.commentBtn.addEventListener(MouseEvent.MOUSE_OVER, function (event:MouseEvent) : void
            {
                if (view.config["comment"] != false)
                {
                    alphaRegulator.show();
                    ;
                }
                return;
            }// end function
            );
            this.commentBtn.addEventListener(MouseEvent.MOUSE_OUT, function (event:MouseEvent) : void
            {
                alphaRegulator.hide();
                return;
            }// end function
            );
            this.mkconf = MukioConfigger.getInst();
            this.mkconf.load(this.clip.root.loaderInfo.url);
            this.listIco = new ListIcon();
            this.listPad.visible = false;
            this.view.getPlugin("controlbar").addButton(this.listIco, "listview", function (event:MouseEvent) : void
            {
                if (view.config["listview"] != true)
                {
                    view.config["listview"] = true;
                    listIco.alpha = 0.5;
                    listPad.visible = true;
                    view.sendEvent(ViewEvent.PLAY, false);
                }
                else
                {
                    view.config["listview"] = false;
                    listIco.alpha = 1;
                    listPad.visible = false;
                }
                return;
            }// end function
            );
            return;
        }// end function

        private function tabChangeHandler(event:CommentListViewEvent) : void
        {
            this.trackCommentButton.selected = false;
            this.dispatchCommentListViewEvent(CommentListViewEvent.TRACKTOGGLE, false);
            return;
        }// end function

        private function coldTrickerHandler(event:CommentListViewEvent) : void
        {
            this.sendButton.enabled = event.data.enable;
            this.sendButton.label = event.data.label;
            this.commentInput.type = event.data.enable ? (TextFieldType.INPUT) : (TextFieldType.DYNAMIC);
            return;
        }// end function

        private function resizeHandler(event:ControllerEvent = null) : void
        {
            this.clip.x = this.config["x"];
            this.clip.y = this.config["y"];
            this.clip.height = this.config["height"];
            this.clip.width = this.config["width"];
            this.clip.visible = this.config["visible"];
            var _loc_2:int = 1;
            this.clip.scaleY = 1;
            this.clip.scaleX = _loc_2;
            this.trackCommentButton.selected = false;
            this.dispatchCommentListViewEvent(CommentListViewEvent.TRACKTOGGLE, false);
            this.resizeSendPad(this.clip.stage.stageWidth, this.clip.stage.stageHeight);
            return;
        }// end function

    }
}
