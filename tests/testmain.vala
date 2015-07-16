/*
 * DESCRIPTION      Unit tests for LibDotNet.
 * PROJECT          LibDotNet
 * AUTHOR           Chris Daley <chebizarro@gmail.com>
 *
 * Copyright (C) Chris Daley 2015
 * Code is present with MIT licence.
 */
using LibDotNet;
using GLib;

void main (string[] args) {
	
	Test.init (ref args);

	//TestSuite.get_root ().add_suite (new SystemCollectionsArrayListTests ().get_suite ());
	TestSuite.get_root ().add_suite (new SystemCollectionsGenricListTests ().get_suite ());
	
	Test.run ();
}
