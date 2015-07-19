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

public class SystemCollectionsGenricQueueTests : LibDotNet.TestCase {
	
	public SystemCollectionsGenricQueueTests () {
		base ("System.Collections.Generic.Stack");
		
		add_test ("New Queue<string> with default constructor", string_queue_new_with_default_constructor);
		add_test ("New Queue<string> with IEnumerable", string_queue_new_with_enumerable);
		
		add_test ("Queue<string> properties get Count", string_queue_properties_get_count);
		add_test ("Queue<string> properties get IsReadOnly", string_queue_properties_get_read_only);
		add_test ("Queue<string> properties get IsSynchronized", string_queue_properties_get_synchronized);
		add_test ("Queue<string> properties get SyncRoot", string_queue_properties_get_sync_root);
		add_test ("Queue<string> properties get size", string_queue_properties_get_size);
		
		add_test ("Queue<string> methods Clear", string_queue_methods_clear);
		add_test ("Queue<string> methods Contains", string_queue_methods_contains);
		add_test ("Queue<string> methods CopyTo", string_queue_methods_copy_to);
		add_test ("Queue<string> methods Dequeue", string_queue_methods_dequeue);
		add_test ("Queue<string> methods Enqueue", string_queue_methods_enqueue);
		add_test ("Queue<string> methods GetEnumerator", string_queue_methods_get_enumerator);
		add_test ("Queue<string> methods Peek", string_queue_methods_peek);
		add_test ("Queue<string> methods ToArray", string_queue_methods_to_array);
		add_test ("Queue<string> methods TrimExcess", string_queue_methods_trim_excess);
		
	}

	public void string_queue_new_with_default_constructor () {
		var testQueue = new Queue<string> ();
		GLib.assert_true (testQueue is System.Collections.Generic.Queue);
	}

	public void string_queue_new_with_enumerable () {
		var input = new List<string> ();
		input.Add ("Brachiosaurus"); 
        input.Add ("Amargasaurus"); 
        input.Add ("Mamenchisaurus");
                           
		var testQueue = new Queue<string> (input);
		GLib.assert_true (testQueue is System.Collections.Generic.Queue);
		GLib.assert_true (testQueue.Count == 3);
		GLib.assert_true (testQueue[0] == "Brachiosaurus");
		GLib.assert_true (testQueue[1] == "Amargasaurus");
		GLib.assert_true (testQueue[2] == "Mamenchisaurus");
		
	}

	public void string_queue_properties_get_count () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.Count == 0);
		testQueue.Enqueue("Hello");
		testQueue.Enqueue("World");
		testQueue.Enqueue("!");
		GLib.assert_true (testQueue.Count == 3);
	}


	public void string_queue_properties_get_read_only () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.IsReadOnly == false);
	}

	public void string_queue_properties_get_synchronized () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.IsSynchronized == false);
	}

	public void string_queue_properties_get_sync_root () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.Object syncroot = testQueue.SyncRoot;
		GLib.assert_true (syncroot is GLib.Object);
	}

	public void string_queue_properties_get_size () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.size == 0);
		testQueue.Enqueue("Hello");
		testQueue.Enqueue("World");
		testQueue.Enqueue("!");
		GLib.assert_true (testQueue.size == 3);
	}

	public void string_queue_methods_clear () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
		GLib.assert_true (testQueue.size == 4);
		testQueue.Clear();
		GLib.assert_true (testQueue.size == 0);
		
	}

	public void string_queue_methods_contains () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
		GLib.assert_true (testQueue.Contains("Tyrannosaurus"));
		GLib.assert_true (testQueue.Contains("Amargasaurus"));
	}

	public void string_queue_methods_copy_to () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        string[] array = new string[testQueue.Count];
        testQueue.CopyTo(array);
		GLib.assert_true (array[0] == "Tyrannosaurus");
        GLib.assert_true (array[1] == "Amargasaurus");
        GLib.assert_true (array[2] == "Mamenchisaurus");
        GLib.assert_true (array[3] == "Deinonychus");
        array.resize(testQueue.Count+3);
        testQueue.CopyTo(array, 3);
 	}

	public void string_queue_methods_dequeue () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.size == 0);
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        testQueue.Enqueue("Compsognathus");
		GLib.assert_true (testQueue.size == 5);
        GLib.assert_true (testQueue.Dequeue() == "Tyrannosaurus");
		GLib.assert_true (testQueue.size == 4);
        GLib.assert_true (testQueue.Peek() == "Amargasaurus");
	}


	public void string_queue_methods_enqueue () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.size == 0);
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        testQueue.Enqueue("Compsognathus");
		GLib.assert_true (testQueue.size == 5);
        GLib.assert_true (testQueue.Peek() == "Tyrannosaurus");
	}



	public void string_queue_methods_get_enumerator () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        testQueue.Enqueue("Amargasaurus");
        string newstr = "";
		foreach (var item in testQueue) {
			newstr += item;
		}
        GLib.assert_true (newstr == "TyrannosaurusAmargasaurusMamenchisaurusDeinonychusAmargasaurus");
 	}


	public void string_queue_methods_peek () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		GLib.assert_true (testQueue.size == 0);
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        testQueue.Enqueue("Compsognathus");
		GLib.assert_true (testQueue.size == 5);
        GLib.assert_true (testQueue.Peek() == "Tyrannosaurus");
		GLib.assert_true (testQueue.size == 5);
	}


	public void string_queue_methods_to_array () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        testQueue.Enqueue("Amargasaurus");
		var newArray = testQueue.ToArray();
        GLib.assert_true (newArray.length == 5);
        GLib.assert_true (newArray[4] == "Amargasaurus");
        GLib.assert_true (newArray[3] == "Deinonychus");
        GLib.assert_true (newArray[2] == "Mamenchisaurus");
        GLib.assert_true (newArray[1] == "Amargasaurus");
        GLib.assert_true (newArray[0] == "Tyrannosaurus");
 	}

	public void string_queue_methods_trim_excess () {
		var testQueue = new System.Collections.Generic.Queue<string> ();
		testQueue.Enqueue("Tyrannosaurus");
        testQueue.Enqueue("Amargasaurus");
        testQueue.Enqueue("Mamenchisaurus");
        testQueue.Enqueue("Deinonychus");
        testQueue.Enqueue("Amargasaurus");
		GLib.assert_true (testQueue.size == 5);
		testQueue.TrimExcess();
		GLib.assert_true (testQueue.size == 5);

 	}

}

