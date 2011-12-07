/* LALR(1) Parser generation for Scala
 * John Boyland
 * This file may be used, copied and/or modified for any purpose.
 */
package edu.uwm.cs.cool.meta.parser;

case class AnnounceAction(val rule : Rule) extends Action {
  override def toString = "announce rule " + rule
}
