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
using System.Collections.Generic;

public class SystemCollectionsGenricStackTests : LibDotNet.TestCase {
	
	public SystemCollectionsGenricStackTests () {
		base ("System.Collections.Generic.Stack");
		
		add_test ("New Stack<string> with default constructor", string_stack_new_with_default_constructor);
		add_test ("New Stack<string> with IEnumerable", string_stack_new_with_enumerable);
		add_test ("New Stack<string> with capacity", string_stack_new_with_capacity);
		add_test ("Stack<string> properties get Count", string_stack_properties_get_count);
		add_test ("Stack<string> properties get IsReadOnly", string_stack_properties_get_read_only);
		add_test ("Stack<string> properties get IsSynchronized", string_stack_properties_get_synchronized);
		add_test ("Stack<string> properties get SyncRoot", string_stack_properties_get_sync_root);
		add_test ("Stack<string> properties get size", string_stack_properties_get_size);
		add_test ("Stack<string> methods Peek", string_stack_methods_peek);
		add_test ("Stack<string> methods Pop", string_stack_methods_pop);
		add_test ("Stack<string> methods Push", string_stack_methods_push);
		add_test ("Stack<string> methods Clear", string_stack_methods_clear);
		add_test ("Stack<string> methods Contains", string_stack_methods_contains);
		add_test ("Stack<string> methods CopyTo", string_stack_methods_copy_to);
		add_test ("Stack<string> methods GetEnumerator", string_stack_methods_get_enumerator);
		add_test ("Stack<string> methods ToArray", string_stack_methods_to_array);
		add_test ("Stack<string> methods TrimExcess", string_stack_methods_trim_excess);
		
	}

	public void string_stack_new_with_default_constructor () {
		var testStack = new Stack<string> ();
		GLib.assert_true (testStack is System.Collections.Generic.Stack);
	}

	public void string_stack_new_with_enumerable () {
		var input = new List<string> ();
		input.Add ("Brachiosaurus"); 
        input.Add ("Amargasaurus"); 
        input.Add ("Mamenchisaurus");
                           
		var testStack = new Stack<string> (input);
		GLib.assert_true (testStack is System.Collections.Generic.Stack);
		GLib.assert_true (testStack.Count == 3);
		GLib.assert_true (testStack[0] == "Brachiosaurus");
		GLib.assert_true (testStack[1] == "Amargasaurus");
		GLib.assert_true (testStack[2] == "Mamenchisaurus");
		
	}

	public void string_stack_new_with_capacity () {
		var testStack = new System.Collections.Generic.Stack<string>.WithCapacity(12);
		GLib.assert_true (testStack is System.Collections.Generic.Stack);
	}

	public void string_stack_properties_get_count () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.Count == 0);
		testStack.Push("Hello");
		testStack.Push("World");
		testStack.Push("!");
		GLib.assert_true (testStack.Count == 3);
	}


	public void string_stack_properties_get_read_only () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.IsReadOnly == false);
	}

	public void string_stack_properties_get_synchronized () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.IsSynchronized == false);
	}

	public void string_stack_properties_get_sync_root () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.Object syncroot = testStack.SyncRoot;
		GLib.assert_true (syncroot is GLib.Object);
	}

	public void string_stack_properties_get_size () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.size == 0);
		testStack.Push("Hello");
		testStack.Push("World");
		testStack.Push("!");
		GLib.assert_true (testStack.size == 3);
	}

	public void string_stack_methods_peek () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.size == 0);
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        testStack.Push("Compsognathus");
		GLib.assert_true (testStack.size == 5);
        GLib.assert_true (testStack.Peek() == "Compsognathus");
		GLib.assert_true (testStack.size == 5);
	}

	public void string_stack_methods_pop () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.size == 0);
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        testStack.Push("Compsognathus");
		GLib.assert_true (testStack.size == 5);
        GLib.assert_true (testStack.Pop() == "Compsognathus");
		GLib.assert_true (testStack.size == 4);
        GLib.assert_true (testStack.Peek() == "Deinonychus");
	}

	public void string_stack_methods_push () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		GLib.assert_true (testStack.size == 0);
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        testStack.Push("Compsognathus");
		GLib.assert_true (testStack.size == 5);
		GLib.assert_true (testStack.size == 5);
        GLib.assert_true (testStack.Peek() == "Compsognathus");
	}


	public void string_stack_methods_clear () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
		GLib.assert_true (testStack.size == 4);
		testStack.Clear();
		GLib.assert_true (testStack.size == 0);
		
	}

	public void string_stack_methods_contains () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
		GLib.assert_true (testStack.Contains("Tyrannosaurus"));
		GLib.assert_true (testStack.Contains("Amargasaurus"));
	}

	public void string_stack_methods_copy_to () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        string[] array = new string[testStack.Count];
        testStack.CopyTo(array);
		GLib.assert_true (array[3] == "Tyrannosaurus");
        GLib.assert_true (array[2] == "Amargasaurus");
        GLib.assert_true (array[1] == "Mamenchisaurus");
        GLib.assert_true (array[0] == "Deinonychus");
        array.resize(testStack.Count+3);
        testStack.CopyTo(array, 3);
 	}

	public void string_stack_methods_get_enumerator () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        testStack.Push("Amargasaurus");
        string newstr = "";
		foreach (var item in testStack) {
			newstr += item;
		}
        GLib.assert_true (newstr == "TyrannosaurusAmargasaurusMamenchisaurusDeinonychusAmargasaurus");
 	}

	public void string_stack_methods_to_array () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        testStack.Push("Amargasaurus");
		var newArray = testStack.ToArray();
        GLib.assert_true (newArray.length == 5);
        GLib.assert_true (newArray[0] == "Amargasaurus");
        GLib.assert_true (newArray[1] == "Deinonychus");
        GLib.assert_true (newArray[2] == "Mamenchisaurus");
        GLib.assert_true (newArray[3] == "Amargasaurus");
        GLib.assert_true (newArray[4] == "Tyrannosaurus");
 	}

	public void string_stack_methods_trim_excess () {
		var testStack = new System.Collections.Generic.Stack<string> ();
		testStack.Push("Tyrannosaurus");
        testStack.Push("Amargasaurus");
        testStack.Push("Mamenchisaurus");
        testStack.Push("Deinonychus");
        testStack.Push("Amargasaurus");
		testStack.TrimExcess();
		
		//GLib.stdout.puts(@"$testStack.Peek()");
		
 	}

}

