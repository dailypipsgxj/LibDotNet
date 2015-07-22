/*
 * DESCRIPTION      Unit tests for LibDotNet.
 * PROJECT          LibDotNet
 * AUTHOR           Chris Daley <chebizarro@gmail.com>
 *
 * Copyright (C) Chris Daley 2015
 * Code is present with MIT licence.
 */

using LibDotNet;
using System;
using System.Text;

public class SystemTextStringBuilderTests : LibDotNet.TestCase {
	
	public SystemTextStringBuilderTests () {
		base ("System.Text.StringBuilder");
		
		add_test ("New StringBuilder with default constructor", stringbuilder_new_with_default_constructor);

		add_test ("StringBuilder properties get Capacity", stringbuilder_properties_get_capacity);
		add_test ("StringBuilder properties set Capacity", stringbuilder_properties_set_capacity);
		add_test ("StringBuilder properties get Chars", stringbuilder_properties_get_chars);
		add_test ("StringBuilder properties get Length", stringbuilder_properties_get_length);
		add_test ("StringBuilder properties get MaxCapacity", stringbuilder_properties_get_max_capacity);

		add_test ("StringBuilder methods Append", stringbuilder_methods_append);
		add_test ("StringBuilder methods AppendLine", stringbuilder_methods_append_line);
		add_test ("StringBuilder methods Clear", stringbuilder_methods_clear);
		add_test ("StringBuilder methods Equals", stringbuilder_methods_equals);
		add_test ("StringBuilder methods Insert", stringbuilder_methods_insert);
		add_test ("StringBuilder methods Remove", stringbuilder_methods_remove);
		add_test ("StringBuilder methods Replace", stringbuilder_methods_replace);
		add_test ("StringBuilder methods ToString", stringbuilder_methods_to_string);

	}

	public void stringbuilder_new_with_default_constructor () {
		StringBuilder testStrBldr = new System.Text.StringBuilder ("");
		//GLib.assert_true (testStrBldr is System.Text.StringBuilder);
	}

	public void stringbuilder_properties_get_capacity () {
		StringBuilder testStrBldr = new StringBuilder ("");
		//GLib.stdout.printf("Capacity: %d", testStrBldr.Capacity);
		GLib.assert_true (testStrBldr.Capacity == 4);
	}

	public void stringbuilder_properties_set_capacity () {
		// Does nothing at the moment...
	}

	public void stringbuilder_properties_get_chars () {
		StringBuilder testStrBldr = new StringBuilder ("Brachiosaurus");
		GLib.assert_true (testStrBldr.Capacity == 16);
		GLib.assert_true (testStrBldr[0] == 66);
		GLib.assert_true (testStrBldr[1] == 114);
		GLib.assert_true (testStrBldr[2] == 97);
		GLib.assert_true (testStrBldr[8] == 97);
		GLib.assert_true (testStrBldr[13] == 0);
		
	}

	public void stringbuilder_properties_get_length () {
		StringBuilder testStrBldr = new StringBuilder ("Brachiosaurus");
		GLib.assert_true (testStrBldr.Length == 13);
	}

	public void stringbuilder_properties_get_max_capacity () {
		StringBuilder testStrBldr = new StringBuilder ("Brachiosaurus");
		GLib.assert_true (testStrBldr.MaxCapacity == int32.MAX);
	}

	public void stringbuilder_methods_append () {
		StringBuilder testStrBldr = new StringBuilder ();
		testStrBldr.Append("Brachiosaurus");
		GLib.assert_true (testStrBldr.Length == 13);
		GLib.assert_true (testStrBldr.ToString() == "Brachiosaurus");
	}

	public void stringbuilder_methods_append_line () {
		StringBuilder testStrBldr = new StringBuilder ();
		testStrBldr.AppendLine("Brachiosaurus");
		GLib.assert_true (testStrBldr.Length == 14);
		GLib.assert_true (testStrBldr.ToString() == "Brachiosaurus\n");
		testStrBldr.AppendLine();
		GLib.assert_true (testStrBldr.Length == 15);
		GLib.assert_true (testStrBldr.ToString() == "Brachiosaurus\n\n");
	}

	public void stringbuilder_methods_clear () {
		StringBuilder testStrBldr = new StringBuilder ();
		testStrBldr.Append("Brachiosaurus");
		testStrBldr.Clear();
		GLib.assert_true (testStrBldr.Length == 0);
		GLib.assert_true (testStrBldr[0] == 0);
	}

	public void stringbuilder_methods_equals () {
		StringBuilder testStrBldr = new StringBuilder ();
		testStrBldr.Append("Brachiosaurus");
		StringBuilder copyStrBldr = new StringBuilder ();
		copyStrBldr.Append("Brachiosaurus");
		
		GLib.assert_true (testStrBldr.Equals(copyStrBldr));
	}

	public void stringbuilder_methods_insert () {
		StringBuilder testStrBldr = new StringBuilder ();
		testStrBldr.Append("Brachiosaurus");
		GLib.assert_true (testStrBldr.Length == 13);
		testStrBldr.Insert(0, "Mamenchisaurus");
		GLib.assert_true (testStrBldr.Length == 27);
		GLib.assert_true (testStrBldr.ToString() == "MamenchisaurusBrachiosaurus");
	}

	public void stringbuilder_methods_remove () {
		StringBuilder testStrBldr = new StringBuilder ("MamenchisaurusBrachiosaurus");
		testStrBldr.Remove(13,13);
		GLib.assert_true (testStrBldr.ToString() == "Mamenchisaurus");
		GLib.assert_true (testStrBldr.Length == 14);
		testStrBldr.Append("Brachiosaurus");
		GLib.assert_true (testStrBldr.Length == 27);
		GLib.assert_true (testStrBldr.ToString() == "MamenchisaurusBrachiosaurus");
		testStrBldr.Remove(0,14);
		GLib.assert_true (testStrBldr.ToString() == "Brachiosaurus");
	}

	public void stringbuilder_methods_replace () {
		StringBuilder testStrBldr = new StringBuilder ("MamenchisaurusBrachiosaurus");
		testStrBldr.Replace("Brachiosaurus", "Deinonychus");
		GLib.assert_true (testStrBldr.Length == 25);
		GLib.assert_true (testStrBldr.ToString() == "MamenchisaurusDeinonychus");
	}

	public void stringbuilder_methods_to_string () {
		StringBuilder testStrBldr = new StringBuilder ("CompsognathusBrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus");
		GLib.assert_true (testStrBldr.ToString() == "CompsognathusBrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus");
		GLib.assert_true (testStrBldr.ToString(13) == "BrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus");
		GLib.assert_true (testStrBldr.ToString(13, 26) == "BrachiosaurusTyrannosaurus");
		
	}


}

