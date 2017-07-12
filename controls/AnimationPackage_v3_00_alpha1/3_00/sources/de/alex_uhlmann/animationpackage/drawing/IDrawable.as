package de.alex_uhlmann.animationpackage.drawing {

import de.alex_uhlmann.animationpackage.IAnimationPackage;
import flash.geom.Matrix;

public interface IDrawable extends IAnimationPackage {
	function lineStyle(thickness:Number = 1.0, color:uint = 0, alpha:Number = 1.0, pixelHinting:Boolean = false, scaleMode:String = "normal", caps:String = null, joints:String = null, miterLimit:Number = 3):void;
	function fillStyle(color:uint, alpha:Number = 1.0):void;
	function gradientStyle(type:String, colors:Array, alphas:Array, ratios:Array, matrix:Matrix = null, spreadMethod:String = "pad", interpolationMethod:String = "rgb", focalPointRatio:Number = 0):void;
	function draw():void;
	function drawBy():void;
	function setRegistrationPoint(registrationObj:Object):void;
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