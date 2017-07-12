package de.alex_uhlmann.animationpackage.utility {
	
import de.alex_uhlmann.animationpackage.utility.IVisitor;

public interface IVisitorElement {
	function accept(visitor:IVisitor):void;
}

}