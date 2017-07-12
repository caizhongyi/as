package de.alex_uhlmann.animationpackage.animation {
	
import de.alex_uhlmann.animationpackage.animation.ISingleAnimatable;
import de.alex_uhlmann.animationpackage.animation.AnimationCore;
import de.alex_uhlmann.animationpackage.utility.Animator;

import flash.geom.Point;

public class MoveOnCurve extends AnimationCore implements ISingleAnimatable {	
	
	private var points:Array;
	private var n:Number;
	private var rotateTo:Boolean = false;
	private var rotateOn:Boolean = false;
	private var overriddenRounded:Boolean = false;	
	/*
	* cache for last point calculated by getPointsOnCurve. 
	* Used to calculate slope/rotation
	*/
	private var lastPoint:Point;	
	
	public function MoveOnCurve(...arguments:Array) {				
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
		
		var paramLen:Number = 1;
		if (arguments.length > paramLen) {			
			this.animationStyle(arguments[1], arguments[2]);
		} else {
			this.animationStyle(this.duration, this.easing);
		}		
		this.points = arguments[0];
		this.n = this.points.length-1;
		this.setStartValue(0);
		this.setEndValue(100);
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
		var p:Point = this.getPointsOnCurve(targ);		
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
		var p:Point = this.getPointsOnCurve(targ);
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
		var p:Point = this.getPointsOnCurve(targ);
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
			p = this.getPointsOnCurve(targ + 1);
		}
		var degrees:Number = Math.atan2(this.lastPoint.y-p.y, this.lastPoint.x-p.x)/(Math.PI/180);
		//update cache
		this.lastPoint = p;	
		return degrees;
	}
	
	/*
	* de.alex_uhlmann.animationpackage.drawing.CubicCurve needs to access this method.
	* Adapted from Paul Bourke.
	*/
	public function getPointsOnCurve(targ:Number):Point {
		var v:Number = targ / 100;
		var k:Number, kn:Number, nn:Number, nkn:Number, blend:Number, muk:Number, munk:Number;
		var n:Number = this.n;
		var p:Array = this.points;
		var b:Point = new Point(0,0);
		if(v != 1) {
			//calculate for all control points 
			//but the last point on the path
			muk = 1;		
			munk = Math.pow(1 - v, n);		
			for (k = 0; k <= n; k++) {			
				nn = n;
				kn = k;
				nkn = n - k;			
				blend = muk * munk;			
				muk *= v;
				munk /= (1 - v);			
				while (nn >= 1) {
					blend *= nn;				
					nn--;
					if (kn > 1) {
						blend /= kn;
						kn--;
					}
					if (nkn > 1) {
						blend /= nkn;
						nkn--;
					}
				}
				b.x += p[k].x * blend;
				b.y += p[k].y * blend;		
			}
			return b;
		} else {
		//Calculate the last point 
		//- it is NOT a control point
			var l:Number = p.length - 1;
			b.x = p[l].x;
			b.y = p[l].y;
			return b;
		}
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

	override public function checkIfRounded():Boolean {
		return this.overriddenRounded;
	}
	
	override public function roundResult(overriddenRounded:Boolean):void {
		this.overriddenRounded = overriddenRounded;
	}
}
}