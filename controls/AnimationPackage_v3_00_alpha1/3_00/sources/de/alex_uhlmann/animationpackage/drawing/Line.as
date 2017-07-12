package de.alex_uhlmann.animationpackage.drawing {
	
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.IOutline;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.display.Sprite;
import flash.geom.Point;

public class Line extends Shape implements ISingleAnimatable, IDrawable, IOutline {

	public static var x1_def:Number = 0;
	public static var y1_def:Number = 0;
	public static var x2_def:Number = 550;
	public static var y2_def:Number = 400;	
	public var x1:Number;
	public var y1:Number;
	public var x2:Number;
	public var y2:Number;
	private var x1Orig:Number;
	private var y1Orig:Number;
	private var x2Orig:Number;
	private var y2Orig:Number;
	public var mode:String = "REDRAW";
	
	public function Line(...arguments:Array) {
		super();
		if(arguments[0] === false) {
			return;
		}
		this.init.apply(this,arguments);
		this.lineStyle(NaN);
		this.animationStyle(NaN);
	}
	
	public function run(...arguments:Array):void {
		this.init.apply(this, arguments);
		this.invokeAnimation(0, 100);
	}

	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}

	private function init():void {
		if(arguments[0] is Sprite) {				
			this.initCustom.apply(this,arguments);
		} else {			
			this.initAuto.apply(this,arguments);
		}			
	}
	
	private function initCustom(...arguments:Array):void {
		this.mc = this.createClip({mc:arguments[0], x:0, y:0});
		this.initShape.apply(this,arguments.slice(1));
	}
	
	private function initAuto(...arguments:Array):void {
		
		this.mc = this.createClip({name:"apDraw", x:0, y:0});
		this.initShape.apply(this,arguments);
	}
	
	protected function initShape(...arguments:Array):void {
		this.x1 = (isNaN(arguments[0])) ? Line.x1_def : arguments[0];
		this.y1 = (isNaN(arguments[1])) ? Line.y1_def : arguments[1];		
		this.x2 = (isNaN(arguments[2])) ? Line.x2_def : arguments[2];
		this.y2 = (isNaN(arguments[3])) ? Line.y2_def : arguments[3];
		this.x1Orig = this.x1;
		this.y1Orig = this.y1;
		this.x2Orig = this.x2;
		this.y2Orig = this.y2;
	}

	public function draw():void {
		this.setInitialized(false);
		this.setDefaultRegistrationPoint({position:"CENTER"});
		this.clearDrawing();
		this.mc.graphics.moveTo(this.x1, this.y1);
		this.drawNewPoint(this.x2, this.y2);		
	}

	public function drawBy():void {
		if(this.lineStyleModified) {
			this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
		}
		if(this.penX != this.x1 || this.penY != this.y1) {			
			this.mc.graphics.moveTo(this.x1, this.y1);
		}
		this.drawNewPoint(this.x2, this.y2);
	}
	
	public function drawTo():void {		
		this.drawNewPoint(this.x2, this.y2);
	}
	
	private function drawNewPoint(x2:Number, y2:Number):void {		
		this.mc.graphics.lineTo(x2, y2);
		this.penX = x2;
		this.penY = y2;
	}
	
	private function invokeAnimation(start:Number, end:Number):void {
		var isGoto:Boolean;
		if(isNaN(end)) {
			isGoto = true;
			end = start;
			start = 0;			
		} else {
			isGoto = false;
		}
		var setter:String;	
		if(this.mode == "REDRAW") {
			this.setDefaultRegistrationPoint({position:"CENTER"});
			setter = "drawLine";
		} else if(this.mode == "DRAW") {
			if(this.penX != this.x1 || this.penY != this.y1) {			
				if(this.lineStyleModified) {
					this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
				}
				this.mc.graphics.moveTo(this.x1, this.y1);
				this.mc.graphics.lineTo(this.x1, this.y1);
			}			
			setter = "drawLineBy";
		} else {
			setter = "drawLineTo";
		}
		this.setStartValue(0);
		this.setEndValue(100);
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		this.myAnimator.setter = [[this, setter]];
		if(isGoto == false) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			if(this.mode == "DRAWTO")return;
			this.myAnimator.setCurrentPercentage(end);
		}
	}	

	public function animate(start:Number, end:Number):void {
		this.mode = "REDRAW";
		this.invokeAnimation(start, end);
	}

	public function animateBy(start:Number, end:Number):void {
		this.mode = "DRAW";		
		this.invokeAnimation(start, end);
	}
	
	public function animateTo(start:Number, end:Number):void {
		this.mode = "DRAWTO";
		this.invokeAnimation(start, end);
	}
	
	public function drawLine(v:Number):void {
		this.clearDrawing();
		this.mc.graphics.moveTo(this.x1, this.y1);
		var p:Object = this.getPointsOnLine(v);
		this.drawNewPoint(p.x, p.y);
	}

	public function drawLineBy(v:Number):void {
		this.mc.graphics.moveTo(this.x1, this.y1);
		var p:Object = this.getPointsOnLine(v);
		this.drawNewPoint(p.x, p.y);
	}
	
	public function drawLineTo(v:Number):void {
		var p:Object = this.getPointsOnLine(v);
		this.drawNewPoint(p.x, p.y);
	}	
		
	protected function getPointsOnLine(t:Number):Point {
		var v:Number = t / 100;
		var p:Point = new Point();
		p.x = (v * (this.x2 - this.x1))+this.x1;
		p.y = (v * (this.y2 - this.y1))+this.y1;	
		return p;
	}	

	public function setRegistrationPoint(registrationObj:Object):void {
		var centerX:Number;
		var centerY:Number;
		
		var minX:Number = Math.min(this.x1Orig, this.x2Orig);
		var maxX:Number = Math.max(this.x1Orig, this.x2Orig);
		var minY:Number = Math.min(this.y1Orig, this.y2Orig);
		var maxY:Number = Math.max(this.y1Orig, this.y2Orig);			
		
		if(registrationObj.position == "CENTER") {
			centerX = (maxX - minX) / 2 + minX;
			centerY = (maxY - minY) / 2 + minY;		
		} else if (registrationObj.x != null || registrationObj.y != null) {
			centerX = minX + registrationObj.x;
			centerY = minY + registrationObj.y;
		} else {
			centerX = 0;
			centerY = 0;
		}
		this.mc.x = centerX;
		this.mc.y = centerY;	
		this.x1 = this.x1Orig - centerX;
		this.y1 = this.y1Orig - centerY;
		this.x2 = this.x2Orig - centerX;
		this.y2 = this.y2Orig - centerY;
		this.initialized = true;
	}
	
	protected function setDefaultRegistrationPoint(registrationObj:Object):void {		
		if(!this.initialized) {
			this.setRegistrationPoint(registrationObj);
		}
	}
	
	public function reset():void {
		this.x1 = this.x1Orig;
		this.y1 = this.y1Orig;
		this.x2 = this.x2Orig;
		this.y2 = this.y2Orig;
	}

	public function getX1():Number {
		return this.x1;
	}

	public function setX1(x1:Number):void {
		this.x1Orig = x1;
		this.x1 = x1;
	}

	public function getY1():Number {
		return this.y1;
	}

	public function setY1(y1:Number):void {
		this.y1Orig = y1;
		this.y1 = y1;
	}	

	public function getX2():Number {
		return this.x2;
	}

	public function setX2(x2:Number):void {
		this.x2Orig = x2;
		this.x2 = x2;
	}

	public function getY2():Number {
		return this.y2;
	}
	
	public function setY2(y2:Number):void {
		this.y2Orig = y2;
		this.y2 = y2;
	}	
}
}