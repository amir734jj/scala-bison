/* LALR(1) Parser generation for Scala
 * John Boyland
 * This file may be used, copied and/or modified for any purpose.
 */
package edu.uwm.cs.cool.meta.parser;

import scala.collection.immutable.ListSet;
import scala.collection.Set;

class Terminal(s : String, t : String) extends Symbol(s,t) {
}
