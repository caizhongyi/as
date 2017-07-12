﻿package de.alex_uhlmann.animationpackage.drawing {

import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.drawing.IDrawable;
import de.alex_uhlmann.animationpackage.drawing.IOutline;
import de.alex_uhlmann.animationpackage.drawing.Shape;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.BezierToolkit;

import flash.display.Sprite;
import flash.geom.Point;

public class QuadCurve extends Shape implements IDrawable, IOutline, ISingleAnimatable {	

	public static var x1_def:Number = 0;
	public static var y1_def:Number = 0;	
	public static var x2_def:Number = 275;
	public static var y2_def:Number = 200;	
	public static var x3_def:Number = 550;
	public static var y3_def:Number = 0;	
	private var myBezierToolkit:BezierToolkit;	
	/*start, control and end points of curve*/
	private var x1:Number;
	private var y1:Number;
	private var x2:Number;
	private var y2:Number;
	private var x3:Number;
	private var y3:Number;
	private var p1:Point;
	private var p2:Point;
	private var p3:Point;
	private var x1Orig:Number;
	private var y1Orig:Number;
	private var x2Orig:Number;
	private var y2Orig:Number;
	private var x3Orig:Number;
	private var y3Orig:Number;
	private var mcXOrig:Number;
	private var mcYOrig:Number;	
	private var withControlpoints:Boolean = false;
	private var x2ControlPoint:Number;
	private var y2ControlPoint:Number;
	public var mode:String = "REDRAW";
	private var lastStep:Number = 0;
	private var overriddenRounded:Boolean = true;
	private var overriddedOptimize:Boolean = true;
	
	public function QuadCurve(...arguments:Array) {
		super();
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

	private function init(...arguments:Array):void {		
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
		
	private function initShape(...arguments:Array):void {
	
		var x1:Number = arguments[0];
		var y1:Number = arguments[1];
		var x2:Number = arguments[2];
		var y2:Number = arguments[3];
		var x3:Number = arguments[4];
		var y3:Number = arguments[5];
		
		this.x1 = (isNaN(x1)) ? QuadCurve.x1_def : x1;
		this.y1 = (isNaN(y1)) ? QuadCurve.y1_def : y1;
		this.x2 = (isNaN(x2)) ? QuadCurve.x2_def : x2;
		this.y2 = (isNaN(y2)) ? QuadCurve.y2_def : y2;
		this.x3 = (isNaN(x3)) ? QuadCurve.x3_def : x3;
		this.y3 = (isNaN(y3)) ? QuadCurve.y3_def : y3;
		if(withControlpoints != false) {
			this.withControlpoints = withControlpoints;
		}
		this.x1Orig = this.x1;
		this.y1Orig = this.y1;
		this.x2Orig = this.x2;
		this.y2Orig = this.y2;
		this.x3Orig = this.x3;
		this.y3Orig = this.y3;
		this.mcXOrig = this.mc.x;
		this.mcYOrig = this.mc.y;
		this.myBezierToolkit = new BezierToolkit();
	}

	public function draw():void {
		this.setInitialized(false);
		this.setDefaultRegistrationPoint({position:"CENTER"});
		this.clearDrawing();
		this.mc.graphics.moveTo(this.x1, this.y1);
		this.drawNew();
	}

	public function drawBy():void {
		
		this.initControlPoints();
		
		if(this.lineStyleModified) {
			this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
		}
		if(this.penX != this.x1 || this.penY != this.y1) {
			this.mc.graphics.moveTo(this.x1, this.y1);
		}
		this.drawNew();
	}
	
	public function drawTo():void {
		this.drawNew();
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
			this.setInitialized(false);
			this.setDefaultRegistrationPoint({position:"CENTER"});	
			if(overriddedOptimize) {
				setter = "drawLineCurve";
			} else {
				setter = "drawLineCurveSecure";
			}
		} else if(this.mode == "DRAW"){
			this.initControlPoints();			
			if(this.penX != this.x1 || this.penY != this.y1) {			
				if(this.lineStyleModified) {
					this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
				}
				this.mc.graphics.moveTo(this.x1, this.y1);
			}
			if(overriddedOptimize) {
				setter = "drawLineCurveBy";
			} else {
				setter = "drawLineCurveBySecure";
			}			
		} else {
			setter = "drawLineCurveBy";
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

	private function drawNew():void {
		this.mc.graphics.curveTo(this.x2, this.y2, this.x3, this.y3);
		this.penX = this.x3;
		this.penY = this.y3;
	}
	
	public function drawLineCurve(v:Number):void {		
		if(this.lastStep == 0) {
			if(this.lineStyleModified) {
				this.mc.graphics.lineStyle(this.lineThickness, this.lineRGB, this.lineAlpha);
			}
			this.mc.graphics.moveTo(this.x1, this.y1);
		}
		var len:Number;
		
		if(overriddenRounded) {
			len = Math.round(v);	
		} else {
			len = v;
		}

		var s:Number;
		if(len < this.lastStep) {
			this.clearDrawing();
			this.mc.graphics.moveTo(this.x1, this.y1);
			s = this.getStartValue();
		} else {
			s = this.lastStep;
		}
		if(len == this.lastStep) {
			return;
		}
		this.lastStep = len;
		var p:Point;
		var i:Number;
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnQuadCurve(i, this.p1, this.p2, this.p3);
			this.mc.graphics.lineTo(p.x, p.y);			
		}
	}

	public function drawLineCurveBy(v:Number):void {		
		var p:Object;
		var s:Number = (isNaN(this.lastStep)) ? this.getStartValue() : this.lastStep;		
		var len:Number;
		if(overriddenRounded) {
			len = Math.round(v);	
		} else {
			len = v;
		}
		if(len == this.lastStep) {
			return;
		}		
		this.lastStep = len;
		var i:Number;		
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnQuadCurve(i, this.p1, this.p2, this.p3);
			this.mc.graphics.lineTo(p.x, p.y);				
		}
	}
	
	//clunky and slow. I don't like it. But it does the job.
	public function drawLineCurveSecure(v:Number):void {		
		this.clearDrawing();
		this.mc.graphics.moveTo(this.x1, this.y1);		
		var p:Point;
		var s:Number = this.getStartValue();		
		var len:Number = Math.round(v);		
		var i:Number;
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnQuadCurve(i, this.p1, this.p2, this.p3);
			this.mc.graphics.lineTo(p.x, p.y);	
		}
	}
	
	public function drawLineCurveBySecure(v:Number):void {		
		this.mc.graphics.moveTo(this.x1, this.y1);
		var p:Point;
		var s:Number = this.getStartValue();		
		var len:Number = Math.round(v);
		var i:Number;
		for(i = s; i <= len; i++) {
			p = this.myBezierToolkit.getPointsOnQuadCurve(i, this.p1, this.p2, this.p3);
			this.mc.graphics.lineTo(p.x, p.y);				
		}
	}	

	public function useControlPoints(withControlpoints:Boolean):void {		
		if(withControlpoints == true && this.initialized == true) {
			this.x2 = this.x2ControlPoint;
			this.y2 = this.y2ControlPoint;
			this.p2 = new Point(this.x2, this.y2);
		}
		this.withControlpoints = withControlpoints;		
	}
	
	public function initControlPoints():void {		
		if(!this.initialized) {
			if(this.withControlpoints == false) {
				this.x2ControlPoint = this.x2;
				this.y2ControlPoint = this.y2;
				var controlPoint:Object = this.myBezierToolkit.getQuadControlPoints(this.x1, this.y1, 
								this.x2, this.y2, this.x3, this.y3);
				this.x2 = controlPoint.x;
				this.y2 = controlPoint.y;		
			}
			this.p1 = new Point(this.x1, this.y1);
			this.p2 = new Point(this.x2, this.y2);
			this.p3 = new Point(this.x3, this.y3);
			this.initialized = true;		
		}
	}

	public function setRegistrationPoint(registrationObj:Object):void {	
		this.initialized = false;
		
		var minX:Number = Math.min(Math.min(this.x1Orig, this.x2Orig), this.x3Orig);
		var maxX:Number = Math.max(Math.max(this.x1Orig, this.x2Orig), this.x3Orig);
		var minY:Number = Math.min(Math.min(this.y1Orig, this.y2Orig), this.y3Orig);
		var maxY:Number = Math.max(Math.max(this.y1Orig, this.y2Orig), this.y3Orig);

		var centerX:Number;
		var centerY:Number;

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
		this.x3 = this.x3Orig - centerX;
		this.y3 = this.y3Orig - centerY;	
		this.initControlPoints();
	}
	
	private function setDefaultRegistrationPoint(registrationObj:Object):void {		
		if(!this.initialized) {
			this.setRegistrationPoint(registrationObj);
		}		
	}
	
	public function reset():void {
		this.x1 = this.x1Orig;
		this.y1 = this.y1Orig;
		this.x2 = this.x2Orig;
		this.y2 = this.y2Orig;
		this.x3 = this.x3Orig;
		this.y3 = this.y3Orig;
		this.initialized = false;
		this.initControlPoints();
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
	
	public function getX3():Number {
		return this.x3;
	}
	
	public function setX3(x3:Number):void {
		this.x3Orig = x3;
		this.x3 = x3;
	}
	
	public function getY3():Number {
		return this.y3;
	}
	
	public function setY3(y3:Number):void {
		this.y3Orig = y3;
		this.y3 = y3;
	}

	override public function checkIfRounded():Boolean {
		return this.overriddenRounded;
	}
	
	override public function roundResult(overriddenRounded:Boolean):void {
		this.overriddenRounded = overriddenRounded;
	}
	
	override public function getOptimizationMode():Boolean {		
		return this.overriddedOptimize;
	}
	
	override public function setOptimizationMode(overriddedOptimize:Boolean):void {		
		this.overriddedOptimize = overriddedOptimize;
	}
}
}