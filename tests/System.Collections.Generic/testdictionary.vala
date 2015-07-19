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

public class SystemCollectionsGenricDictionaryTests : LibDotNet.TestCase {
	
	public SystemCollectionsGenricDictionaryTests () {
		base ("System.Collections.Generic.Dictionary");
		
		add_test ("New Dictionary<string, string> with default constructor", str_str_dict_new_with_default_constructor);
		add_test ("New Dictionary<string, string> with IEnumerable", str_str_dict_new_with_dictionary);
		
		add_test ("Dictionary<string, string> properties get Comparer", str_str_dict_properties_get_comparer);
		add_test ("Dictionary<string, string> properties get Count", str_str_dict_properties_get_count);
		add_test ("Dictionary<string, string> properties get IsFixedSize", str_str_dict_properties_get_fixed_size);
		add_test ("Dictionary<string, string> properties get IsReadOnly", str_str_dict_properties_get_read_only);
		add_test ("Dictionary<string, string> properties get IsSynchronized", str_str_dict_properties_get_synchronized);
		add_test ("Dictionary<string, string> properties get Keys", str_str_dict_properties_get_keys);
		add_test ("Dictionary<string, string> properties get size", str_str_dict_properties_get_size);
		add_test ("Dictionary<string, string> properties get SyncRoot", str_str_dict_properties_get_sync_root);
		add_test ("Dictionary<string, string> properties get Value", str_str_dict_properties_get_values);
		
		add_test ("Dictionary<string, string> methods Add", str_str_dict_methods_add);
		add_test ("Dictionary<string, string> methods Clear", str_str_dict_methods_clear);
		add_test ("Dictionary<string, string> methods Contains", str_str_dict_methods_contains);
		add_test ("Dictionary<string, string> methods ContainsKey", str_str_dict_methods_contains_key);
		add_test ("Dictionary<string, string> methods ContainsValue", str_str_dict_methods_contains_value);
		add_test ("Dictionary<string, string> methods CopyTo", str_str_dict_methods_copy_to);
		add_test ("Dictionary<string, string> methods GetEnumerator", str_str_dict_methods_get_enumerator);
		add_test ("Dictionary<string, string> methods GetObjectData", str_str_dict_methods_get_object_data);
		add_test ("Dictionary<string, string> methods OnDeserialization", str_str_dict_methods_on_deserialization);
		add_test ("Dictionary<string, string> methods Remove", str_str_dict_methods_remove);
		//add_test ("Dictionary<string, string> methods ToString", str_str_dict_methods_to_string);
		add_test ("Dictionary<string, string> methods TryGetValue", str_str_dict_methods_try_get_value);
		
	}

	public void str_str_dict_new_with_default_constructor () {
		var testDict = new Dictionary<string, string> ();
		GLib.assert_true (testDict is System.Collections.Generic.Dictionary);
	}

	public void str_str_dict_new_with_dictionary () {
		var input = new Dictionary<string, string> ();
		input.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        input.Add ("Amargasaurus", "AMARGASAURUS"); 
        input.Add ("Mamenchisaurus", "MAMENCHISAURUS");
                           
		var testDict = new Dictionary<string, string>.WithDictionary (input);
		GLib.assert_true (testDict is System.Collections.Generic.Dictionary);
		GLib.assert_true (testDict.Count == 3);
		
		GLib.assert_true (testDict["Brachiosaurus"] == "BRACHIOSAURUS");
		GLib.assert_true (testDict["Amargasaurus"] == "AMARGASAURUS");
		GLib.assert_true (testDict["Mamenchisaurus"] == "MAMENCHISAURUS");
	}

	public void str_str_dict_properties_get_comparer () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		var comparer = testDict.Comparer;
		GLib.assert_true (comparer.Equals("BRACHIOSAURUS", "BRACHIOSAURUS"));
	}

	public void str_str_dict_properties_get_count () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		GLib.assert_true (testDict.Count == 0);
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		GLib.assert_true (testDict.Count == 3);
	}

	public void str_str_dict_properties_get_fixed_size () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		GLib.assert_true (testDict.IsFixedSize == false);
	}

	public void str_str_dict_properties_get_read_only () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		GLib.assert_true (testDict.IsReadOnly == false);
	}

	public void str_str_dict_properties_get_synchronized () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
        
	}

	public void str_str_dict_properties_get_keys () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");

		var keys = testDict.Keys;
		GLib.assert_true (keys is ICollection);
		string keystr = "";
		foreach (var item in testDict.Keys) {
			keystr += item;
		}
        GLib.assert_true (keystr == "CompsognathusBrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus" );


	}

	public void str_str_dict_properties_get_sync_root () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		GLib.Object syncroot = testDict.SyncRoot;
		GLib.assert_true (syncroot is GLib.Object);
	}

	public void str_str_dict_properties_get_size () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		GLib.assert_true (testDict.size == 0);
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		GLib.assert_true (testDict.size == 3);
	}

	public void str_str_dict_properties_get_values () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
        string valstr = "";
		foreach (var item in testDict.Values) {
			valstr += item;
		}
        GLib.assert_true (valstr == "COMPSOGNATHUSBRACHIOSAURUSTYRANNOSAURUSDEINONYCHUSAMARGASAURUSMAMENCHISAURUS");
	}


	public void str_str_dict_methods_add () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		GLib.assert_true (testDict.Count == 0);
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");

		GLib.assert_true (testDict.Count == 6);
		GLib.assert_true (testDict["Brachiosaurus"] == "BRACHIOSAURUS");
		GLib.assert_true (testDict["Amargasaurus"] == "AMARGASAURUS");
		GLib.assert_true (testDict["Mamenchisaurus"] == "MAMENCHISAURUS");
		GLib.assert_true (testDict["Tyrannosaurus"] == "TYRANNOSAURUS");
		GLib.assert_true (testDict["Deinonychus"] == "DEINONYCHUS");
		GLib.assert_true (testDict["Compsognathus"] == "COMPSOGNATHUS");
		
	}


	public void str_str_dict_methods_clear () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
		GLib.assert_true (testDict.Count == 6);
		GLib.assert_true (testDict.size == 6);
		testDict.Clear();
		GLib.assert_true (testDict.Count == 0);
		GLib.assert_true (testDict.size == 0);
		
	}

	public void str_str_dict_methods_contains () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
        var nicepair = new KeyValuePair<string, string>("Tyrannosaurus", "TYRANNOSAURUS");
		GLib.assert_true (testDict.Contains(nicepair));
	}

	public void str_str_dict_methods_contains_key () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
		GLib.assert_true (testDict.ContainsKey("Tyrannosaurus"));
	}

	public void str_str_dict_methods_contains_value () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
		GLib.assert_true (testDict.ContainsValue("TYRANNOSAURUS"));
	}

	public void str_str_dict_methods_copy_to () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
        KeyValuePair[] array = new KeyValuePair<string, string>[testDict.Count];
        testDict.CopyTo(array);
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
        array.resize(testDict.Count+3);
        testDict.CopyTo(array, 3);
        */
 	}


	public void str_str_dict_methods_get_enumerator () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
        string valstr = "";
		foreach (var item in testDict.Values) {
			valstr += item;
		}
        GLib.assert_true (valstr == "COMPSOGNATHUSBRACHIOSAURUSTYRANNOSAURUSDEINONYCHUSAMARGASAURUSMAMENCHISAURUS");
       
		string keystr = "";
		foreach (var item in testDict.Keys) {
			keystr += item;
		}
        GLib.assert_true (keystr == "CompsognathusBrachiosaurusTyrannosaurusDeinonychusAmargasaurusMamenchisaurus" );
 	}


	public void str_str_dict_methods_get_object_data () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
 	}

	public void str_str_dict_methods_on_deserialization () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
 	}


	public void str_str_dict_methods_remove () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");
        testDict.Remove("Amargasaurus");
        GLib.assert_true (testDict.Count == 5);
		GLib.assert_true (testDict["Brachiosaurus"] == "BRACHIOSAURUS");
		GLib.assert_true (testDict["Mamenchisaurus"] == "MAMENCHISAURUS");
		GLib.assert_true (testDict["Tyrannosaurus"] == "TYRANNOSAURUS");
		GLib.assert_true (testDict["Deinonychus"] == "DEINONYCHUS");
		GLib.assert_true (testDict["Compsognathus"] == "COMPSOGNATHUS");
 	}

	public void str_str_dict_methods_try_get_value () {
		var testDict = new System.Collections.Generic.Dictionary<string, string> ();
		testDict.Add ("Brachiosaurus", "BRACHIOSAURUS"); 
        testDict.Add ("Amargasaurus", "AMARGASAURUS"); 
        testDict.Add ("Mamenchisaurus", "MAMENCHISAURUS");
		testDict.Add ("Tyrannosaurus", "TYRANNOSAURUS");
        testDict.Add ("Deinonychus", "DEINONYCHUS");
        testDict.Add ("Compsognathus", "COMPSOGNATHUS");

		string val;
        GLib.assert_true(testDict.TryGetValue("Amargasaurus", out val));
		GLib.assert_true (val == "AMARGASAURUS");
 	}



}

