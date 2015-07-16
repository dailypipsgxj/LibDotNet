/*
 * DESCRIPTION      Unit tests for LibDotNet.
 * PROJECT          LibDotNet
 * AUTHOR           Chris Daley <chebizarro@gmail.com>
 *
 * Copyright (C) Chris Daley 2015
 * Code is present with MIT licence.
 */

using LibDotNet;
using System.Collections.Generic;

public class SystemCollectionsGenricListTests : LibDotNet.TestCase {
	
	public SystemCollectionsGenricListTests () {
		base ("System.Collections.Generic.List");
		
		add_test ("[System.Collections.Generic][List] New List<String> with default constructor", string_list_new_with_default_constructor);
		add_test ("[System.Collections.Generic][List] New List<String> with IEnumerable", string_list_new_with_enumerable);
		add_test ("[System.Collections.Generic][List] New List<String> with capacity", string_list_new_with_capacity);
		add_test ("[System.Collections.Generic][List] List<String> properties get Capacity", string_list_properties_get_capacity);
		add_test ("[System.Collections.Generic][List] List<String> properties set Capacity", string_list_properties_set_capacity);
		add_test ("[System.Collections.Generic][List] List<String> properties get Count", string_list_properties_get_count);
		add_test ("[System.Collections.Generic][List] List<String> properties get IsFixedSize", string_list_properties_get_fixed_size);
		
	}

	public void string_list_new_with_default_constructor () {
		var myL = new List<string> ();
		GLib.assert_true (myL is System.Collections.Generic.List);
		GLib.assert_true (myL.Capacity == 4);
	}

	public void string_list_new_with_enumerable () {
		string[] input = { "Brachiosaurus", 
                           "Amargasaurus", 
                           "Mamenchisaurus" };
		var myL = new System.Collections.Generic.List<string> (input as IEnumerable<string>);
		GLib.assert_true (myL is System.Collections.Generic.List);
		GLib.assert_true (myL.Capacity == 3);
		GLib.assert_true (myL.Count == 3);
		GLib.assert_true (myL[0] == "Brachiosaurus");
		GLib.assert_true (myL[1] == "Amargasaurus");
		GLib.assert_true (myL[2] == "Mamenchisaurus");
		
	}

	public void string_list_new_with_capacity () {
		var myL = new System.Collections.Generic.List<string>.WithCapacity(12);
		GLib.assert_true (myL is System.Collections.Generic.List);
		GLib.assert_true (myL.Capacity == 12);
	}

	public void string_list_properties_get_capacity () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.Capacity == 4);
	}

	public void string_list_properties_set_capacity () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Capacity = 2;
		GLib.assert_true (myL.Capacity == 2);
		myL.Add("Hello");
		myL.Add("World");
		myL.Add("!");
		GLib.assert_true (myL.Capacity == 3);
		myL.Capacity = 2;
		GLib.assert_true (myL.Capacity == 3);
	}

	public void string_list_properties_get_count () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.Count == 0);
		myL.Add("Hello");
		myL.Add("World");
		myL.Add("!");
		GLib.assert_true (myL.Count == 3);
	}

	public void string_list_properties_get_fixed_size () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.IsFixedSize == false);
	}


}

