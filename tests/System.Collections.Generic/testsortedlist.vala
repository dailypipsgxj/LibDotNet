/*
 * DESCRIPTION      Generic Dictionary Unit tests for LibDotNet.
 * PROJECT          LibDotNet
 * AUTHOR           Chris Daley <chebizarro@gmail.com>
 *
 * Copyright (C) Chris Daley 2015
 * Code is present with MIT licence.
 */

using LibDotNet;
using System;
using System.Collections.Generic;

public class SystemCollectionsGenricSortedListTests : LibDotNet.TestCase {
	
	public SystemCollectionsGenricSortedListTests () {
		base ("System.Collections.Generic.SortedList");
		
		add_test ("New SortedList<string, string> with default constructor", str_str_sorted_list_new_with_default_constructor);
		add_test ("New SortedList<string, string> with IEnumerable", str_str_sorted_list_new_with_dictionary);
		
		add_test ("SortedList<string, string> properties get Comparer", str_str_sorted_list_properties_get_comparer);
		add_test ("SortedList<string, string> properties get Count", str_str_sorted_list_properties_get_count);
		add_test ("SortedList<string, string> properties get IsFixedSize", str_str_sorted_list_properties_get_fixed_size);
		add_test ("SortedList<string, string> properties get IsReadOnly", str_str_sorted_list_properties_get_read_only);
		add_test ("SortedList<string, string> properties get IsSynchronized", str_str_sorted_list_properties_get_synchronized);
		add_test ("SortedList<string, string> properties get Keys", str_str_sorted_list_properties_get_keys);
		add_test ("SortedList<string, string> properties get size", str_str_sorted_list_properties_get_size);
		add_test ("SortedList<string, string> properties get SyncRoot", str_str_sorted_list_properties_get_sync_root);
		add_test ("SortedList<string, string> properties get Value", str_str_sorted_list_properties_get_values);
		
		add_test ("SortedList<string, string> methods Add", str_str_sorted_list_methods_add);
		add_test ("SortedList<string, string> methods Clear", str_str_sorted_list_methods_clear);
		add_test ("SortedList<string, string> methods Contains", str_str_sorted_list_methods_contains);
		add_test ("SortedList<string, string> methods ContainsKey", str_str_sorted_list_methods_contains_key);
		add_test ("SortedList<string, string> methods ContainsValue", str_str_sorted_list_methods_contains_value);
		add_test ("SortedList<string, string> methods CopyTo", str_str_sorted_list_methods_copy_to);
		add_test ("SortedList<string, string> methods GetEnumerator", str_str_sorted_list_methods_get_enumerator);
		add_test ("SortedList<string, string> methods GetObjectData", str_str_sorted_list_methods_get_object_data);
		add_test ("SortedList<string, string> methods OnDeserialization", str_str_sorted_list_methods_on_deserialization);
		add_test ("SortedList<string, string> methods Remove", str_str_sorted_list_methods_remove);
		//add_test ("SortedList<string, string> methods ToString", str_str_sorted_list_methods_to_string);
		add_test ("SortedList<string, string> methods TryGetValue", str_str_sorted_list_methods_try_get_value);
		
	}

	public void str_str_sorted_list_new_with_default_constructor () {
		var testSL = new SortedList<string, string> ();
		GLib.assert_true (testSL is System.Collections.Generic.SortedList);
	}

	public void str_str_sorted_list_new_with_dictionary () {
		var input = new SortedList<string, string> ();
		input.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        input.Add ("Amargasaurus", "AMARGASAURUS"); 
        input.Add ("Mamenchisaurus", "MAMENCHISAURUS");
        
        /*                   
		var testSL = new SortedList<string, string>.WithDictionary (input);
		GLib.assert_true (testSL is System.Collections.Generic.Dictionary);
		GLib.assert_true (testSL.Count == 3);
		
		GLib.assert_true (testSL["Brachiosaurus"] == "BRACHIOSAURUS");
		GLib.assert_true (testSL["Amargasaurus"] == "AMARGASAURUS");
		GLib.assert_true (testSL["Mamenchisaurus"] == "MAMENCHISAURUS");
		*/
	}

	public void str_str_sorted_list_properties_get_comparer () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		//var comparer = testSL.Comparer;
		//GLib.assert_true (comparer.Equals("BRACHIOSAURUS", "BRACHIOSAURUS"));
	}

	public void str_str_sorted_list_properties_get_count () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		GLib.assert_true (testSL.Count == 0);
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		GLib.assert_true (testSL.Count == 3);
	}

	public void str_str_sorted_list_properties_get_fixed_size () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		GLib.assert_true (testSL.IsFixedSize == false);
	}

	public void str_str_sorted_list_properties_get_read_only () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		GLib.assert_true (testSL.IsReadOnly == false);
	}

	public void str_str_sorted_list_properties_get_synchronized () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
        
	}

	public void str_str_sorted_list_properties_get_keys () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");

		var keys = testSL.Keys;
		GLib.assert_true (keys is ICollection);
		string keystr = "";
		foreach (var item in testSL.Keys) {
			keystr += item;
		}
        GLib.assert_true (keystr == "CompsognathusBrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus" );


	}

	public void str_str_sorted_list_properties_get_sync_root () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		GLib.Object syncroot = testSL.SyncRoot;
		GLib.assert_true (syncroot is GLib.Object);
	}

	public void str_str_sorted_list_properties_get_size () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		GLib.assert_true (testSL.size == 0);
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		GLib.assert_true (testSL.size == 3);
	}

	public void str_str_sorted_list_properties_get_values () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
        string valstr = "";
		foreach (var item in testSL.Values) {
			valstr += item;
		}
        GLib.assert_true (valstr == "COMPSOGNATHUSBRACHIOSAURUSTYRANNOSAURUSDEINONYCHUSAMARGASAURUSMAMENCHISAURUS");
	}


	public void str_str_sorted_list_methods_add () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		GLib.assert_true (testSL.Count == 0);
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");

		GLib.assert_true (testSL.Count == 6);
		GLib.assert_true (testSL["Brachiosaurus"] == "BRACHIOSAURUS");
		GLib.assert_true (testSL["Amargasaurus"] == "AMARGASAURUS");
		GLib.assert_true (testSL["Mamenchisaurus"] == "MAMENCHISAURUS");
		GLib.assert_true (testSL["Tyrannosaurus"] == "TYRANNOSAURUS");
		GLib.assert_true (testSL["Deinonychus"] == "DEINONYCHUS");
		GLib.assert_true (testSL["Compsognathus"] == "COMPSOGNATHUS");
		
	}


	public void str_str_sorted_list_methods_clear () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
		GLib.assert_true (testSL.Count == 6);
		GLib.assert_true (testSL.size == 6);
		testSL.Clear();
		GLib.assert_true (testSL.Count == 0);
		GLib.assert_true (testSL.size == 0);
		
	}

	public void str_str_sorted_list_methods_contains () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
        var nicepair = new KeyValuePair<string, string>("Tyrannosaurus", "TYRANNOSAURUS");
		GLib.assert_true (testSL.Contains(nicepair));
	}

	public void str_str_sorted_list_methods_contains_key () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
		GLib.assert_true (testSL.ContainsKey("Tyrannosaurus"));
	}

	public void str_str_sorted_list_methods_contains_value () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
		GLib.assert_true (testSL.ContainsValue("TYRANNOSAURUS"));
	}

	public void str_str_sorted_list_methods_copy_to () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
        KeyValuePair[] array = new KeyValuePair<string, string>[testSL.Count];
        testSL.CopyTo(array);
        /*
		GLib.assert_true (array[0].Key == "Brachiosaurus");
		GLib.assert_true (array[0].Value == "BRACHIOSAURUS");
        GLib.assert_true (array[1].Key == "Amargasaurus");
        GLib.assert_true (array[1].Value == "AMARGASAURUS");
        GLib.assert_true (array[2].Key == "Mamenchisaurus");
        GLib.assert_true (array[3].Value == "MAMENCHISAURUS");
        GLib.assert_true (array[3].Key == "Tyrannosaurus");
        GLib.assert_true (array[2].Value == "TYRANNOSAURUS");
        GLib.assert_true (array[4].Key == "Deinonychus");
        GLib.assert_true (array[4].Value == "DEINONYCHUS");
        GLib.assert_true (array[5].Key == "Compsognathus");
        GLib.assert_true (array[5].Value == "COMPSOGNATHUS");
        array.resize(testSL.Count+3);
        testSL.CopyTo(array, 3);
        */
 	}


	public void str_str_sorted_list_methods_get_enumerator () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
        string valstr = "";
		foreach (var item in testSL.Values) {
			valstr += item;
		}
        GLib.assert_true (valstr == "COMPSOGNATHUSBRACHIOSAURUSTYRANNOSAURUSDEINONYCHUSAMARGASAURUSMAMENCHISAURUS");
       
		string keystr = "";
		foreach (var item in testSL.Keys) {
			keystr += item;
		}
        GLib.assert_true (keystr == "CompsognathusBrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus" );
 	}


	public void str_str_sorted_list_methods_get_object_data () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
 	}

	public void str_str_sorted_list_methods_on_deserialization () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
 	}


	public void str_str_sorted_list_methods_remove () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");
        testSL.Remove("Amargasaurus");
        GLib.assert_true (testSL.Count == 5);
		GLib.assert_true (testSL["Brachiosaurus"] == "BRACHIOSAURUS");
		GLib.assert_true (testSL["Mamenchisaurus"] == "MAMENCHISAURUS");
		GLib.assert_true (testSL["Tyrannosaurus"] == "TYRANNOSAURUS");
		GLib.assert_true (testSL["Deinonychus"] == "DEINONYCHUS");
		GLib.assert_true (testSL["Compsognathus"] == "COMPSOGNATHUS");
 	}

	public void str_str_sorted_list_methods_try_get_value () {
		var testSL = new System.Collections.Generic.SortedList<string, string> ();
		testSL.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testSL.Add ("Amargasaurus", "AMARGASAURUS"); 
        testSL.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testSL.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testSL.Add ("Deinonychus", "DEINONYCHUS");
        testSL.Add ("Compsognathus", "COMPSOGNATHUS");

		string val;
        GLib.assert_true(testSL.TryGetValue("Amargasaurus", out val));
		GLib.assert_true (val == "AMARGASAURUS");
 	}



}

