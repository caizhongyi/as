package de.alex_uhlmann.animationpackage.animation {

import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;
import de.alex_uhlmann.animationpackage.utility.BezierToolkit;

import flash.geom.Point;

public class MoveOnCubicCurve extends AnimationCore implements ISingleAnimatable {	

	private var x1:Number;
	private var y1:Number;
	private var x2:Number;
	private var y2:Number;
	private var x3:Number;
	private var y3:Number;
	private var x4:Number;
	private var y4:Number;
	private var myBezierToolkit:BezierToolkit;
	private var p1:Point;
	private var p2:Point;
	private var p3:Point;
	private var p4:Point;
	private var withControlpoints:Boolean = false;
	private var x2ControlPoint:Number;
	private var y2ControlPoint:Number;
	private var x3ControlPoint:Number;
	private var y3ControlPoint:Number;
	private var rotateTo:Boolean = false;
	private var rotateOn:Boolean = false;
	private var overriddenRounded:Boolean = false;
	
	/*
	* cache for last point calculated by getPointsOnCurve. 
	* Used to calculate slope/rotation
	*/
	private var lastPoint:Point;
	
	public function MoveOnCubicCurve(...arguments:Array) {
		super();
		this.mc = arguments[0];
		if(arguments.length > 1) {			
			this.initAnimation.apply(this, arguments.slice(1));
		}
	}
	
	public function run(...arguments:Array):void {		
		this.initAnimation.apply(this, arguments);
		this.invokeAnimation(0, 100);		
	}

	public function animate(start:Number, end:Number):void {		
		this.invokeAnimation(start, end);
	}

	public function setCurrentPercentage(percentage:Number):void {
		this.invokeAnimation(percentage, NaN);
	}
	
	private function initAnimation(...arguments:Array):void {		
		
		var x1:Number = arguments[0];
		var y1:Number = arguments[1];
		var x2:Number = arguments[2];
		var y2:Number = arguments[3];
		var x3:Number = arguments[4];
		var y3:Number = arguments[5];
		var x4:Number = arguments[6];
		var y4:Number = arguments[7];
		var withControlpoints:* = arguments[8];
		var duration:* = arguments[9];
		var easing:* = arguments[10];
		
		var paramLen:Number = 8;		
		var temp:*;
		if(withControlpoints is Number) {
			temp = withControlpoints;
			var temp_ms:Number = temp;                  
			var temp_easing:* = duration;
			duration = temp_ms;
			easing = temp_easing;		
			this.animationStyle(temp_ms, easing);
		} else if (arguments.length > paramLen) {
			temp = duration;
			this.animationStyle(temp, easing);
		} else {
			this.animationStyle(this.duration, this.easing);
		}
		this.myBezierToolkit = new BezierToolkit();
		if(withControlpoints is Boolean) {
			temp = withControlpoints;
			this.withControlpoints = temp;
		}
		if(this.withControlpoints == false) {		
			this.x2ControlPoint = x2;
			this.y2ControlPoint = y2;
			this.x3ControlPoint = x3;
			this.y3ControlPoint = y3;
			var controlPoint:Object = this.myBezierToolkit.getCubicControlPoints(x1, y1, x2, y2, x3, y3, x4, y4);
			x2 = controlPoint.x1;
			y2 = controlPoint.y1;
			x3 = controlPoint.x2;
			y3 = controlPoint.y2;
		}
		this.init(x1, y1, x2, y2, x3, y3, x4, y4);
		this.setStartValue(0);
		this.setEndValue(100);		
	}
	
	private function init(...arguments:Array):void {
				
		this.x1 = arguments[0];
		this.y1 = arguments[1];
		this.x2 = arguments[2];
		this.y2 = arguments[3];
		this.x3 = arguments[4];
		this.y3 = arguments[5];
		this.x4 = arguments[6];
		this.y4 = arguments[7];
		this.p1 = new Point(this.x1, this.y1);
		this.p2 = new Point(this.x2, this.y2);
		this.p3 = new Point(this.x3, this.y3);
		this.p4 = new Point(this.x4, this.y4);		
	}
	
	private function invokeAnimation(start:Number, end:Number):void {		
		this.startInitialized = false;
		
		this.myAnimator = new Animator();
		this.myAnimator.caller = this;
		this.myAnimator.start = [0];
		this.myAnimator.end = [100];
		if(this.rotateTo == true) {
			this.myAnimator.setter = [[this,"moveAndRotateTo"]];
		} else if(this.rotateOn == true) {
			this.myAnimator.setter = [[this,"moveAndRotateOn"]];
		} else {
			this.myAnimator.setter = [[this,"move"]];				
		}
		if(!isNaN(end)) {
			this.myAnimator.animationStyle(this.duration, this.easing);
			this.myAnimator.animate(start, end);
		} else {
			this.myAnimator.setCurrentPercentage(start);
		}
	}	

	public function move(targ:Number):void {
		var p:Point = this.myBezierToolkit.getPointsOnCubicCurve(targ, this.p1, this.p2, this.p3, this.p4);
		if(overriddenRounded) {
			this.mc.x = Math.round(p.x);
			this.mc.y = Math.round(p.y);			
		}
		else {
			this.mc.x = p.x;
			this.mc.y = p.y;			
		}
	}
	
	public function moveAndRotateTo(targ:Number):void {
		var p:Point = this.myBezierToolkit.getPointsOnCubicCurve(targ, 
												this.p1, 
												this.p2, 
												this.p3, 
												this.p4);
		if(overriddenRounded) {
			this.mc.x = Math.round(p.x);
			this.mc.y = Math.round(p.y);
			this.mc.rotation = Math.round(this.computeRotation(targ, p) - 90);
		}
		else {
			this.mc.x = p.x;
			this.mc.y = p.y;
			this.mc.rotation = this.computeRotation(targ, p) - 90;
		}		
	}
	
	public function moveAndRotateOn(targ:Number):void {
		var p:Point = this.myBezierToolkit.getPointsOnCubicCurve(targ, 
												this.p1, 
												this.p2, 
												this.p3, 
												this.p4);
		if(overriddenRounded) {
			this.mc.x = Math.round(p.x);
			this.mc.y = Math.round(p.y);
			this.mc.rotation = Math.round(this.computeRotation(targ, p));
		}
		else {
			this.mc.x = p.x;
			this.mc.y = p.y;
			this.mc.rotation = this.computeRotation(targ, p);
		}
	}
	
	private function computeRotation(targ:Number, p:Point):Number {
		if (this.lastPoint == null) {
			//just calculated the first point. Store it.
			this.lastPoint = p;
			//go 1% forward to get next point
			p = this.myBezierToolkit.getPointsOnCubicCurve(
									targ + 1, 
									this.p1, 
									this.p2, 
									this.p3, 
									this.p4);
		}
		var degrees:Number = Math.atan2(this.lastPoint.y-p.y, this.lastPoint.x-p.x)/(Math.PI/180);
		//update cache
		this.lastPoint = p;
		return degrees;
	}

	public function orientToPath(bool:Boolean):void {
		if(bool) {
			this.rotateOn = false;
		}
		this.rotateTo = bool;
	}

	public function orientOnPath(bool:Boolean):void {
		if(bool) {
			this.rotateTo = false;
		}
		this.rotateOn = bool;
	}

	public function useControlPoints(withControlpoints:Boolean):void {
		if(withControlpoints) {
			this.x2 = this.x2ControlPoint;
			this.y2 = this.y2ControlPoint;
			this.x3 = this.x3ControlPoint;
			this.y3 = this.y3ControlPoint;
			this.p2 = new Point(this.x2, this.y2);
			this.p3 = new Point(this.x3, this.y3);
		}
		this.withControlpoints = withControlpoints;		
	}

	override public function checkIfRounded():Boolean {
		return this.overriddenRounded;
	}
	
	override public function roundResult(overriddenRounded:Boolean):void {
		this.overriddenRounded = overriddenRounded;
	}
}
}