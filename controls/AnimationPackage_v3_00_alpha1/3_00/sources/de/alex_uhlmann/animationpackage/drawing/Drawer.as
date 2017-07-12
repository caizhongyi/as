package de.alex_uhlmann.animationpackage.drawing {
	
import de.alex_uhlmann.animationpackage.APCore;
import de.alex_uhlmann.animationpackage.animation.AnimationEvent;
import de.alex_uhlmann.animationpackage.animation.IAnimatable;
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.SequenceEvent;
import de.alex_uhlmann.animationpackage.utility.IComposite;
import de.alex_uhlmann.animationpackage.utility.IVisitor;
import de.alex_uhlmann.animationpackage.utility.IVisitorElement;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;

public class Drawer extends Shape implements ISingleAnimatable, IOutline, IVisitorElement, IComposite {	

	public static const JOIN:String = "JOIN";
	public static const EACH:String = "EACH";
	
	private var childsArr:Array;
	private var start:Number;
	private var end:Number;	
	private var firstChild:*;
	private var currentChild:*;
	private var childDuration:Number;
	private var position:Number = 0;
	private var animateMode:String = "JOIN";
	private var percentages:Array;
	private var backwards:Boolean = false;
	private var sequenceArr:Array;
	private var redraw:Boolean = true;	
	private var areMovieclipsInjected:Boolean = false;
	private var m_lineMovieclip:Sprite;
	private var m_fillMovieclip:Sprite;	
	
	public function Drawer(...arguments:Array) {			
		super();		
		if(arguments[0] is Sprite) {					
			this.mc = arguments[0];
		} else {	
			this.mc = this.createClip({name:"apDraw", x:0, y:0});
		}
		this.childsArr = new Array();
		this.sequenceArr = new Array();
		super.lineStyle(0);
		this.fillStyle(0);
	}
	
	public function run(...arguments:Array):void {	
	}

	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}	

	public function draw():void {
		this.redraw = true;
		
		this.initLineMovieclip();
		this.injectNewMovieclipsToChilds();
		
		this.firstChild = this.childsArr[0];
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child is Drawer) {				
				child.draw();
			} else {
				this.lineMovieclip.graphics.clear();
				if(this.fillMovieclip != null)
					this.fillMovieclip.graphics.clear();					
				child.draw();
			}			
		}
	}

	public function drawBy():void {	
		this.redraw = false;
		
		this.initLineMovieclip();		 	
		this.injectSingleMovieclipToChilds();
	
		this.lineMovieclip.graphics.lineStyle(this.lineThickness, this.lineRGB, 
									this.lineAlpha, this.linePixelHinting, 
									this.lineScaleMode, this.lineCaps, 
									this.lineJoints, this.lineMiterLimit);
		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child is Drawer) {				
				child.drawBy();
			} else {
				if(this.firstChild == null) {
					this.firstChild = child;
					this.lineMovieclip.graphics.moveTo(child.getX1(), child.getY1());
				}
				child.reset();
				child.drawTo();
			}	
		}
		//this.firstChild = null;
		this.firstChild = this.childsArr[0];
	}
	
	public function drawTo():void {		
		//fails silently
	}	
	
	public function invokeAnimation(start:Number, end:Number):void {		
		
		var isGoto:Boolean;
		var percentage:Number;
		var child:Object;
		
		if(isNaN(end)) {
			isGoto = true;
			percentage = end = start;
			start = 0;			
		} else {
			isGoto = false;
			this.start = start;
			this.end = end;
			this.setTweening(true);
		}
			
		var i:Number, len:Number = this.childsArr.length;
		var fChild:Object;
		
		var posStart:Number = start / 100 * len;
		var posEnd:Number = end / 100 * len;
		
		this.setStartValue(posStart);
		this.setEndValue(posEnd);

		if(this.initialized == false) {
			this.initLineMovieclip();
			if(this.redraw) {				
				this.injectNewMovieclipsToChilds();
			} else {			 	
				this.injectSingleMovieclipToChilds();
				this.lineMovieclip.graphics.lineStyle(this.lineThickness, this.lineRGB, 
									this.lineAlpha, this.linePixelHinting, 
									this.lineScaleMode, this.lineCaps, 
									this.lineJoints, this.lineMiterLimit);
			}
			this.initialized = true;
		} else {
			if(this.redraw) {				
				this.fillMovieclip.graphics.clear();
			} else {
				this.lineMovieclip.graphics.clear();
				this.fillMovieclip.graphics.clear();			
				this.lineMovieclip.graphics.lineStyle(this.lineThickness, this.lineRGB, 
									this.lineAlpha, this.linePixelHinting, 
									this.lineScaleMode, this.lineCaps, 
									this.lineJoints, this.lineMiterLimit);				
			}
		}
		
		if(this.animateMode == Drawer.JOIN) {		
		
			if(!isGoto) {
				var details:Object = this.getAnimateDetails(start, end, this.childsArr);
				this.backwards = details.backwards;
				this.position = details.position;			
				var roundedPosStart:Number = details.roundedPosStart;
				var roundedPosEnd:Number = details.roundedPosEnd;
				this.percentages = details.percentages;				
				
				fChild = this.currentChild = this.childsArr[roundedPosStart];
				this.firstChild = fChild;
				if(this.redraw) {
					fChild.movieclip.graphics.clear();
					if(isCurve(fChild))
						fChild.initControlPoints();
					fChild.setInitialized(true);
					fChild.animate(this.percentages[this.position-1].start, this.percentages[this.position-1].end);
				} else {
					this.lineMovieclip.graphics.moveTo(fChild.getX1(), fChild.getY1());
					if(isCurve(fChild))
						fChild.initControlPoints();
					fChild.setInitialized(true);					
					fChild.animateTo(this.percentages[this.position-1].start, this.percentages[this.position-1].end);
				}

			} else {				

				if(percentage < 0) {
					this.invokeAnimation(0, NaN);
					return;
				} else if(percentage > 100) {
					this.invokeAnimation(100, NaN);
					return;
				}
				var posPerc:Number = percentage / 100 * (len);
				var roundedPosPerc:Number = Math.floor(posPerc);	
				var perc_loc:Number = (posPerc - roundedPosPerc) * 100;
				this.position = roundedPosPerc + 1;
				this.currentChild = this.childsArr[roundedPosPerc];				
				
				for (i = 0; i < len; i++) {
					child = this.childsArr[i];
					if(i < roundedPosPerc) {
						child.setCurrentPercentage(100);
					} else {
						child.setCurrentPercentage(0);
					}
				}
				
				this.childsArr[roundedPosPerc].setCurrentPercentage(perc_loc);
				
				if(percentage == 0) {					
					this.dispatchEvent(new SequenceEvent(AnimationEvent.START, 
									this.getStartValue(),
									this.childDuration));
				} else if(percentage == 100) {
					this.dispatchEvent(new SequenceEvent(AnimationEvent.END, 
									this.getEndValue(),
									this.childDuration));
				} else {
					this.dispatchEvent(new SequenceEvent(AnimationEvent.UPDATE, 
									this.getCurrentValue(),
									this.childDuration));
				}			
			}
			
		} else {

			this.percentages = new Array();
			this.position = 1;
			for (i = 0; i < len; i++) {
				child = this.childsArr[i];
				this.sequenceArr.push(this.childsArr[i+1]);
				child.addEventListener(AnimationEvent.END, onEnd);		
				this.percentages[i] = {start:start, end:end};
			}		
			fChild = this.currentChild = this.childsArr[0];
			this.firstChild = fChild;
			if(start > end) {
				this.backwards = true;				
			} else {
				this.backwards = false;
			}		
			if(this.redraw) {
				fChild.setInitialized(true);
				if(isCurve(fChild))
					fChild.initControlPoints();		
				fChild.movieclip.graphics.clear();							
				fChild.animate(start, end);
			} else {
				this.lineMovieclip.graphics.moveTo(fChild.getX1(), fChild.getY1());
				fChild.setInitialized(true);
				if(isCurve(fChild))
					fChild.initControlPoints();				
				fChild.animateTo(start, end);
			}
		}
		if(!isGoto) {
			this.myAnimator = fChild.myAnimator;
			this.childDuration = fChild.duration;												
			this.dispatchEvent(new SequenceEvent(AnimationEvent.START, 
															this.getStartValue(),
															this.childDuration,
															null,
															IAnimatable(fChild)));													
		}		
	}
	
	private function isCurve(child:*):Boolean {
		return (child is QuadCurve || child is CubicCurve);
	}
	
	private function initLineMovieclip():void {	
		if(this.m_lineMovieclip == null) {
			this.m_lineMovieclip = this.createClip({parentMC:this.mc, name:"apDraw"});
		}
	}
	
	private function injectNewMovieclipsToChilds():void {
		if(!this.areMovieclipsInjected) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {				
				var child:Object = this.childsArr[i];
				child.movieclip = this.createClip({parentMC:this.m_lineMovieclip, name:"apDraw"});
			}
			this.areMovieclipsInjected = true;
		}
	}
	
	private function injectSingleMovieclipToChilds():void {	
		if(!this.areMovieclipsInjected) {
			var i:Number, len:Number = this.childsArr.length;
			for (i = 0; i < len; i++) {
				var child:Object = this.childsArr[i];
				child.movieclip = this.m_lineMovieclip;
				child.reset();
			}		
			this.areMovieclipsInjected = true;
		}
	}	

	public function animate(start:Number, end:Number):void {	
		this.redraw = true;
		this.invokeAnimation(start, end);
	}

	public function animateBy(start:Number, end:Number):void {
		this.redraw = false;		
		this.invokeAnimation(start, end);
	}

	public function fill():void {
		
		this.m_fillMovieclip = this.createClip({parentMC:this.mc, name:"apDraw"});
		/*
		* TRICKY: Drawer creates two movieclips. One for the outline and one for the fill. 
		* This workaround is needed because MovieClip.beginFill 
		* and MovieClip.endFill only work in one frame. If the user uses animate and wants to fill 
		* the shape afterwards this workaround comes into play. Furthermore, the user can manipulate the 
		* fill and outline by itself.
		*/
		this.m_fillMovieclip.graphics.lineStyle(0,0,0);
		var penPos:Object = this.firstChild.getPenPosition();
		penPos.x = this.firstChild.getX1();
		penPos.y = this.firstChild.getY1();
		/*
		* TRICKY: prevent the MovieClip.moveTo() to be invoked on every child.
		* Tell each child that the pen position is already in place.
		* In MovieClip.beginFill() - endFill() blocks the moveTo() method 
		* shall only be invoked once before beginFill().
		*/
		this.m_fillMovieclip.graphics.moveTo(penPos.x, penPos.y);
		this.firstChild.setPenPosition(penPos);		
		
		if (!isNaN(this.fillRGB) && this.fillGradient == false) {			
			this.m_fillMovieclip.graphics.beginFill(this.fillRGB, this.fillAlpha);
		} else if (this.fillGradient == true){
			this.m_fillMovieclip.graphics.beginGradientFill(this.gradientFillType, 
													this.gradientColors, 
													this.gradientAlphas, 
													this.gradientRatios, 
													this.gradientMatrix,
													this.gradientSpreadMethod,
													this.gradientInterpolationMethod,
													this.gradientFocalPointRatio);
		}
		//Hijack children to draw the outline of the fill movieclip.
		this.drawFillOutline();
		//The fill should stay behind the outline.
		this.swapChilds(this.mc, this.m_lineMovieclip, this.m_fillMovieclip);
		this.m_fillMovieclip.graphics.endFill();
	}
	
	private function swapChilds(parentChild:DisplayObjectContainer, bottomChild:DisplayObjectContainer, topChild:DisplayObject):void {
		var removed:DisplayObject = parentChild.removeChild(topChild);
		parentChild.addChildAt(removed, bottomChild.getChildIndex + 1);	
	}
		
	private function drawFillOutline():void {
		var lastChild:Object = this.firstChild;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child is DashLine) {
				child.reset();
				child = new Line(child.getX1(),child.getY1(),
								child.getX2(),child.getY2());
			}
			//the fill doesn't need an outline. But save properties before overwriting.
			var lineThickness:Number = child.lineThickness;
			var lineRGB:Number = child.lineRGB;
			var lineAlpha:Number = child.lineAlpha;
			var linePixelHinting:Number = child.linePixelHinting;
			var lineScaleMode:Number = child.lineScaleMode;
			var lineCaps:Number = child.lineCaps;
			var lineJoints:Number = child.lineJoints;			
			var lineMiterLimit:Number = child.lineMiterLimit;			
			
			child.lineStyle(0,0,0);
			child.setPenPosition(lastChild.getPenPosition());
			var origMC:Sprite = child.movieclip;
			child.movieclip = this.m_fillMovieclip;
			if(child is Drawer) {
				child.draw();
			} else {
				child.reset();
				child.drawBy();				
			}
			if(isCurve(child))
				child.initControlPoints();
			if(this.redraw) {
				child.setInitialized(false);
			}
			child.movieclip = origMC;
			child.lineStyle(lineThickness, lineRGB, lineAlpha, linePixelHinting, 
									lineScaleMode, lineCaps, lineJoints, lineMiterLimit);
			lastChild = child;
		}		
	}
		
	private function getAnimateDetails(start:Number, end:Number, 
										childsArr:Array):Object {
		
		var child:Object
		var backwards:Boolean;
		if(start > end) {
			backwards = true;				
		} else {
			backwards = false;
		}
		/*			
		* To compute start and end values for all childs combined, 
		* I first compute the childs where the tween will start and end. (rule of three)
		* The integer part of the number posStart and posEnd represents that.
		* The fractional part of those numbers represent the percentage to be animated in integer child.
		*/
		var i:Number, len:Number = this.childsArr.length;
		var posStart:Number = start / 100 * (len);
		var posEnd:Number = end / 100 * (len);
		
		var roundedPosStart:Number = Math.floor(posStart);
		var roundedPosEnd:Number = Math.floor(posEnd);			
		var start_loc:Number;
		if(posStart > roundedPosStart) {				
			start_loc = (posStart - roundedPosStart) * 100;					
		} else {
			if(backwards) {
				roundedPosStart--;
				start_loc = 100;
			} else {					
				start_loc = 0;
			}
		}			
		var end_loc:Number;
		if(posEnd > roundedPosEnd) {				
			end_loc = (posEnd - roundedPosEnd) * 100;					
		} else {				
			if(backwards) {
				end_loc = 0;
			} else {
				roundedPosEnd--;
				end_loc = 100;
			}				
		}
		
		this.position = roundedPosStart+1;		
		
		//apply animate state to all children.			
		for (i = 0; i < len; i++) {
			child = this.childsArr[i];			
			if(!this.redraw) {
				child.mode = "DRAWTO";
			}
			if(backwards) {
				if(i > roundedPosStart) {
					child.setCurrentPercentage(0);
				} else {
					child.setCurrentPercentage(100);
				}
			}
		}
		
		for (i = len-1; i > -1; i--) {
			child = this.childsArr[i];
			if(!this.redraw) {
				child.mode = "DRAWTO";
			}		
			if(!backwards) {
				if(i < roundedPosStart) {
					child.setCurrentPercentage(100);
				} else {
					child.setCurrentPercentage(0);
				}
			}
			child.addEventListener(AnimationEvent.UPDATE, onUpdate);
		}		

		//reset succossors.
		this.sequenceArr = new Array();
		
		var percentages:Array = new Array();
		//for forward tweening
		for (i = roundedPosStart; i < roundedPosEnd; i++) {
			child = childsArr[i];
			this.sequenceArr.push(this.childsArr[i+1]);
			child.addEventListener(AnimationEvent.END, onEnd);
			if(i == roundedPosStart) {
				percentages[i] = {start:start_loc, end:100};
			} else {
				percentages[i] = {start:0, end:100};
			}
		}
		//for backward tweening
		for (i = roundedPosStart; i > roundedPosEnd; i--) {
			child = childsArr[i];
			this.sequenceArr.push(this.childsArr[i-1]);
			child.addEventListener(AnimationEvent.END, onEnd);
			if(i == roundedPosStart) {
				percentages[i] = {start:start_loc, end:0};
			} else {
				percentages[i] = {start:100, end:0};
			}
		}
		child = childsArr[roundedPosEnd];
		child.addEventListener(AnimationEvent.END, onEnd);
		if(backwards) {
			percentages[roundedPosEnd] = {start:100, end:end_loc};
		} else {
			percentages[roundedPosEnd] = {start:0, end:end_loc};
		}
		
		var details:Object = new Object();
		details.backwards = backwards;
		details.position = roundedPosStart+1;
		details.roundedPosStart = roundedPosStart;
		details.roundedPosEnd = roundedPosEnd;		
		details.percentages = percentages;		
		return details;
	}
	
	public function onStart(event:AnimationEvent):void {	
		this.dispatchEvent(new SequenceEvent(AnimationEvent.START, 
						this.getStartValue(),
						this.childDuration));
	}	
	
	public function onUpdate(event:AnimationEvent):void {	
		this.dispatchEvent(new SequenceEvent(AnimationEvent.UPDATE, 
						this.getCurrentValue(),
						this.childDuration));
	}
	
	public function onEnd(event:AnimationEvent):void {
		
		event.currentTarget.removeEventListener(AnimationEvent.END, onEnd);
		var successor:IOutline = this.sequenceArr.shift();

		if(successor == null) {
			this.setTweening(false);
			this.duration = 0;
				
			this.dispatchEvent(new SequenceEvent(AnimationEvent.END, 
									this.getEndValue(),
									NaN,
									IAnimatable(event.target),
									null));	
		} else {
			
			/*backwards will only be true in Sequence mode JOIN*/
			if(this.animateMode == Drawer.JOIN && this.backwards) {
				this.position--;
			} else {
				this.position++;
			}		
			this.currentChild = successor;
			this.childDuration = IAnimatable(successor).duration;
			
			if(this.redraw) {
				IAnimatable(successor).movieclip.graphics.clear();
				IAnimatable(successor).movieclip.graphics.lineStyle(IDrawable(successor).lineThickness, 
											IDrawable(successor).lineRGB, 
											IDrawable(successor).lineAlpha,
											IDrawable(successor).linePixelHinting,
											IDrawable(successor).lineScaleMode,
											IDrawable(successor).lineCaps,
											IDrawable(successor).lineJoints,
											IDrawable(successor).lineMiterLimit);
			}			
			
			this.dispatchEvent(new SequenceEvent(SequenceEvent.UPDATE_POSITION, 
															this.getCurrentValue(),
															this.childDuration,
															IAnimatable(event.target),
															IAnimatable(successor)));
			
			var animateMeth:String;
			if(this.redraw) {				
				animateMeth = "animate";
			} else {
				animateMeth = "animateTo";
			}
			var _successor:* = successor;
			if(isCurve(_successor))
				_successor.initControlPoints();
			_successor.setInitialized(true);
			successor[animateMeth].apply(successor, [this.percentages[this.position-1].start, 
												this.percentages[this.position-1].end]);
			this.myAnimator = IAnimatable(successor).myAnimator;
		}		
	}
	
	override public function lineStyle(thickness:Number = 1.0, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void {		
		super.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {			
			this.childsArr[i].lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);			
		}
	}
	
	override public function animationStyle(duration:Number, easing:* = null):void {
		super.animationStyle(duration, easing);
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].animationStyle(duration, easing);
		}
		this.duration = duration;
	}
	
	public function setAnimateMode(animateMode:String):Boolean {
		if(animateMode == Drawer.EACH || animateMode == Drawer.JOIN) {	
			this.animateMode = animateMode;
		} else {
			return false;
		}
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];
			if(child is Drawer) {
				child.setAnimateMode(animateMode);
			}
		}
		return true;	
	}

	public function getAnimateMode():String {
		return this.animateMode;
	}

	public function getChild():IOutline {		
		return IOutline(this.currentChild);
	}

	public function getChildren():Array {
		return this.childsArr;
	}

	public function getNextChild():IOutline {
		if(this.animateMode == Drawer.JOIN && this.backwards) {
			return IOutline(this.childsArr[this.position-2]);
		} else {
			return IOutline(this.childsArr[this.position]);
		}
	}

	public function getPreviousChild():IOutline {		
		if(this.animateMode == Drawer.JOIN && this.backwards) {
			if(this.position-1 == this.childsArr.length) {
				return IOutline(this.childsArr[this.position-1]);
			} else {
				return IOutline(this.childsArr[this.position]);
			}			
		} else {
			return IOutline(this.childsArr[this.position-2]);
		}
	}	
	
	public function getChildDuration():Object {		
		return this.childDuration;
	}

	public function addChild(component:IOutline):IOutline {
			this.childsArr.push(component);
			return component;
	}

	public function removeChild(component:IOutline):void {		
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			if(this.childsArr[i] == component) {
				this.childsArr.splice(i, 1);
			}
		}
	}

	override public function clear():void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			var child:Object = this.childsArr[i];			
			child.mc.graphics.clear();			
		}
		this.fillMovieclip.graphics.clear();
	}	

	override public function accept(visitor:IVisitor):void {
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			visitor.visit(this.childsArr[i]);			
		}
	}
	
	public function get lineMovieclip():Sprite {
		return this.m_lineMovieclip;
	}
	
	public function set lineMovieclip(m_lineMovieclip:Sprite):void {
		this.m_lineMovieclip= m_lineMovieclip;
	}	
	
	public function get fillMovieclip():Sprite {
		return this.m_fillMovieclip;
	}
	
	public function set fillMovieclip(m_fillMovieclip:Sprite):void {
		this.m_fillMovieclip= m_fillMovieclip;
	}
	
	override public function setOptimizationMode(optimize:Boolean):void {
		this.equivalentsRemoved = optimize;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			this.childsArr[i].setOptimizationMode(optimize);		
		}
	}	

	override public function setTweenMode(tweenMode:String):Boolean {
		super.setTweenMode(tweenMode);
		var isSet:Boolean;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			isSet =this.childsArr[i].setTweenMode(tweenMode);		
		}
		return isSet;
	}	

	override public function setDurationMode(durationMode:String):Boolean {
		super.setDurationMode(durationMode);
		var isSet:Boolean;
		var i:Number, len:Number = this.childsArr.length;
		for (i = 0; i < len; i++) {
			isSet = this.childsArr[i].setDurationMode(durationMode);		
		}
		return isSet;
	}
	
	override public function getStartValue():Number {		
		var startValue:Number = super.getStartValue();
		if(isNaN(startValue)) {
			startValue = 0;
		}		
		return startValue;
	}	

	override public function getEndValue():Number {		
		var endValue:Number = super.getEndValue();
		if(isNaN(endValue)) {
			endValue = 100;
		}
		return endValue;
	}	

	override public function getCurrentValue():Number {
		return this.position;
	}	

	override public function getCurrentPercentage():Number {
		var pos:Number = this.getCurrentValue()-1;
		var perc:Number = this.currentChild.getCurrentPercentage();
		if(isNaN(perc)) {
			perc = 0;			
		}
		if(this.animateMode == Drawer.EACH && this.backwards == true) {
			pos = this.getEndValue() - (pos - (this.getStartValue() - 1));
		}
		var currentValue:Number = pos + perc / 100;
		var currentPerc:Number = currentValue / (this.childsArr.length) * 100;		
		return currentPerc;	
	}	
}
}