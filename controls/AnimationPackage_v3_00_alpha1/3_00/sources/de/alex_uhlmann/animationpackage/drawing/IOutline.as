package de.alex_uhlmann.animationpackage.drawing {

import de.alex_uhlmann.animationpackage.IAnimationPackage;

public interface IOutline extends IAnimationPackage {
	function animationStyle(duration:Number, easing:* = null):void;
	function animate(start:Number, end:Number):void;
	function animateBy(start:Number, end:Number):void;
	function lineStyle(thickness:Number = 1.0, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void;	
	function draw():void;
	function drawTo():void;
	function drawBy():void;
	function getPenPosition():Object;
	function setPenPosition(p:Object):void;
	function clear():void;
	function get lineThickness():Number;
	function set lineThickness(lineThickness:Number):void;
	function get lineRGB():Number;
	function set lineRGB(lineRGB:Number):void;		
	function get lineAlpha():Number;
	function set lineAlpha(lineAlpha:Number):void;
	function get linePixelHinting():Boolean;
	function get lineScaleMode():String;
	function get lineCaps():String;
	function get lineJoints():String;
	function get lineMiterLimit():Number;	
}
}