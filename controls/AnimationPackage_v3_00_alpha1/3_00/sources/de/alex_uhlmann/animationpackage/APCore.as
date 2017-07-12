package de.alex_uhlmann.animationpackage {

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;

public dynamic class APCore extends EventDispatcher implements IAnimationPackage {       
	
	public static var frame:int;
	private static var animationClip:Sprite;
	private static var apCoreInstance:APCore;
	private static var instanceCount:Number = 0;
	private var ID:Number;

	public function APCore() {}
	
	protected function registerInstance(...arguments:Array):void {
		this.ID = ++APCore.instanceCount;
	}

	public static function initialize(animationClip:Sprite):APCore {		
		if(APCore.apCoreInstance == null) {			
			APCore.apCoreInstance = new APCore();
			if (APCore.animationClip == null) {			
				APCore.setAnimationClip(animationClip);
			}
		}		
		return APCore.apCoreInstance;
	}	

	public static function getAnimationClip():Sprite {
		return APCore.animationClip;
	}

	public static function setAnimationClip(target:Sprite):void {
		var apCoreInstance:APCore = APCore.apCoreInstance;
		var animationClip:Sprite = new Sprite();
		APCore.animationClip = Sprite(target.addChild(animationClip));
		APCore.animationClip.addEventListener(Event.ENTER_FRAME, frameCounter);
	}
	
	private static function frameCounter(event:Event):void {
		frame++;
	}
	
	public static function getFPS():Number {
		return APCore.animationClip.stage.frameRate;
	}
	
	public static function setFPS(frameRate:Number):void {
		APCore.animationClip.stage.frameRate = frameRate;
	}

	public static function milliseconds2frames(ms:Number):Number {
		return Math.round(ms / 1000 * APCore.getFPS());
	}
	
	/*common used methods*/	
	public function createClip(timelineObj:Object):Sprite {
		
		var mc:Sprite = timelineObj.mc;
		var parentMC:Sprite = timelineObj.parentMC;
		var name:String =  timelineObj.name;		
		var x:Number = timelineObj.x;
		var y:Number = timelineObj.y;
		/*
		* Either
		* -create a new movieclip inside another
		* -create a new movieclip inside animationClip.
		* -positions an already created movieclip.
		*/
		if(parentMC != null) {
			mc = this.createMC(parentMC, name);
		} else if(mc == null) {
			var containerClip:Sprite;
			containerClip = APCore.animationClip;		
			mc = this.createMC(containerClip, name);
		}		
		if(!isNaN(x) && !isNaN(y)) {		    
			mc.x = x;
			mc.y = y;
		}
		return mc;
	}
	
	private function createMC(parentMC:Sprite, name:String):Sprite {
		return parentMC.addChild( new Sprite() as DisplayObject ) as Sprite;
	}
	
	public function getID():Number {
		return this.ID;
	}
}
}