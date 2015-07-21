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

public class SystemCollectionsGenricListTests : LibDotNet.TestCase {
	
	public SystemCollectionsGenricListTests () {
		base ("System.Collections.Generic.List");
		
		add_test ("New List<String> with default constructor", string_list_new_with_default_constructor);
		add_test ("New List<String> with IEnumerable", string_list_new_with_enumerable);
		add_test ("New List<String> with capacity", string_list_new_with_capacity);
		add_test ("List<String> properties get Capacity", string_list_properties_get_capacity);
		add_test ("List<String> properties set Capacity", string_list_properties_set_capacity);
		add_test ("List<String> properties get Count", string_list_properties_get_count);
		add_test ("List<String> properties get IsFixedSize", string_list_properties_get_fixed_size);
		add_test ("List<String> properties get IsReadOnly", string_list_properties_get_read_only);
		add_test ("List<String> properties get IsSynchronized", string_list_properties_get_synchronized);
		add_test ("List<String> properties get SyncRoot", string_list_properties_get_sync_root);
		add_test ("List<String> properties get size", string_list_properties_get_size);
		add_test ("List<String> methods Add", string_list_methods_add);
		add_test ("List<String> methods AddRange", string_list_methods_add_range);
		add_test ("List<String> methods AsReadOnly", string_list_methods_as_read_only);
		add_test ("List<String> methods Clear", string_list_methods_clear);
		add_test ("List<String> methods Contains", string_list_methods_contains);
		add_test ("List<String> methods CopyTo", string_list_methods_copy_to);
		add_test ("List<String> methods Exists", string_list_methods_exists);
		add_test ("List<String> methods Find", string_list_methods_find);
		add_test ("List<String> methods FindAll", string_list_methods_find_all);
		add_test ("List<String> methods FindIndex", string_list_methods_find_index);
		add_test ("List<String> methods FindLast", string_list_methods_find_last);
		add_test ("List<String> methods FindLastIndex", string_list_methods_find_last_index);
		add_test ("List<String> methods ForEach", string_list_methods_foreach);
		add_test ("List<String> methods GetEnumerator", string_list_methods_get_enumerator);
		add_test ("List<String> methods GetRange", string_list_methods_get_range);
		add_test ("List<String> methods IndexOf", string_list_methods_index_of);
		add_test ("List<String> methods Insert", string_list_methods_insert);
		add_test ("List<String> methods LastIndexOf", string_list_methods_last_index_of);
		add_test ("List<String> methods Remove", string_list_methods_remove);
		add_test ("List<String> methods Reverse", string_list_methods_reverse);
		add_test ("List<String> methods RemoveAll", string_list_methods_remove_all);
		add_test ("List<String> methods RemoveAt", string_list_methods_remove_at);
		add_test ("List<String> methods RemoveRamge", string_list_methods_remove_range);
		add_test ("List<String> methods Sort", string_list_methods_sort);
		add_test ("List<String> methods ToArray", string_list_methods_to_array);
		add_test ("List<String> methods TrimExcess", string_list_methods_trim_excess);
		add_test ("List<String> methods TrueForAll", string_list_methods_true_for_all);
		add_test ("List<String> Linq methods Where ", string_list_linq_where);
	}

	public void string_list_new_with_default_constructor () {
		var myL = new List<string> ();
		GLib.assert_true (myL is System.Collections.Generic.List);
		GLib.assert_true (myL.Capacity == 4);
	}

	public void string_list_new_with_enumerable () {
		var input = new List<string> ();
		input.Add ("Brachiosaurus"); 
        input.Add ("Amargasaurus"); 
        input.Add ("Mamenchisaurus");
                           
		var myL = new System.Collections.Generic.List<string> (input);
		GLib.assert_true (myL is System.Collections.Generic.List);
		GLib.assert_true (myL.Capacity == 4);
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
		GLib.assert_true (myL.Capacity == 4);
		// Design decision - throw or assert?
		// How to test?
		/*
		try {
			myL.Capacity = 2;
		} catch (ArgumentOutOfRangeException e) {
			GLib.assert_true (e.message == "Value is lower than current List size");
		}
		*/
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

	public void string_list_properties_get_read_only () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.IsReadOnly == false);
	}

	public void string_list_properties_get_synchronized () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.IsSynchronized == false);
	}

	public void string_list_properties_get_sync_root () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.Object syncroot = myL.SyncRoot;
		GLib.assert_true (syncroot is GLib.Object);
	}

	public void string_list_properties_get_size () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.size == 0);
		myL.Add("Hello");
		myL.Add("World");
		myL.Add("!");
		GLib.assert_true (myL.size == 3);
	}

	public void string_list_methods_add () {
		var myL = new System.Collections.Generic.List<string> ();
		GLib.assert_true (myL.size == 0);
		GLib.assert_true (myL.Capacity == 4);
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Compsognathus");
		GLib.assert_true (myL.size == 5);
		// Capicity should be doubled when a new element is added past the initial capacity
		GLib.assert_true (myL.Capacity == 8);
		GLib.assert_true (myL[0] == "Tyrannosaurus");
        GLib.assert_true (myL[1] == "Amargasaurus");
        GLib.assert_true (myL[2] == "Mamenchisaurus");
        GLib.assert_true (myL[3] == "Deinonychus");
        GLib.assert_true (myL[4] == "Compsognathus");
		
	}

	public void string_list_methods_add_range () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
		GLib.assert_true (myL.size == 4);
		GLib.assert_true (myL.Capacity == 4);

		var newL = new System.Collections.Generic.List<string> ();
		newL.Add("Velociraptor");
		newL.Add("Brachiosaurus");
        newL.Add("Compsognathus");
		GLib.assert_true (newL.size == 3);
		GLib.assert_true (newL.Capacity == 4);

		myL.AddRange(newL);
		GLib.assert_true (myL.size == 7);
		GLib.assert_true (myL.Capacity == 8);
		GLib.assert_true (myL[0] == "Tyrannosaurus");
        GLib.assert_true (myL[1] == "Amargasaurus");
        GLib.assert_true (myL[2] == "Mamenchisaurus");
        GLib.assert_true (myL[3] == "Deinonychus");
		GLib.assert_true (myL[4] == "Velociraptor");
		GLib.assert_true (myL[5] == "Brachiosaurus");
        GLib.assert_true (myL[6] == "Compsognathus");
		
	}

	public void string_list_methods_as_read_only () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");

		var newL = myL.AsReadOnly ();
		GLib.assert_true (newL.IsReadOnly);
		GLib.assert_true (newL.size == 4);
		GLib.assert_true (newL[0] == "Tyrannosaurus");
        GLib.assert_true (newL[1] == "Amargasaurus");
        GLib.assert_true (newL[2] == "Mamenchisaurus");
        GLib.assert_true (newL[3] == "Deinonychus");
	
	}

	public void string_list_methods_clear () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
		GLib.assert_true (myL.size == 4);
		GLib.assert_true (myL.Capacity == 4);
		myL.Clear();
		GLib.assert_true (myL.Count == 0);
		GLib.assert_true (myL.size == 0);
		GLib.assert_true (myL.Capacity == 4);
		
	}

	public void string_list_methods_contains () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
		GLib.assert_true (myL.Contains("Tyrannosaurus"));
		GLib.assert_true (myL.Contains("Amargasaurus"));
	}

	public void string_list_methods_copy_to () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        string[] array = new string[myL.Count];
        myL.CopyTo(array);
		GLib.assert_true (array[0] == "Tyrannosaurus");
        GLib.assert_true (array[1] == "Amargasaurus");
        GLib.assert_true (array[2] == "Mamenchisaurus");
        GLib.assert_true (array[3] == "Deinonychus");
        array.resize(myL.Count+3);
        myL.CopyTo(array, 3);
 	}

	public void string_list_methods_exists () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        GLib.assert_true (myL.Exists( x => x == "Mamenchisaurus" || x == "Deinonychus"));
        GLib.assert_true (myL.Exists( x => x != "Squid"));
 	}

	public void string_list_methods_find () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        GLib.assert_true (myL.Find( x => x == "Mamenchisaurus") == "Mamenchisaurus");
        GLib.assert_true (myL.Find( x => x == "Squid") == null);
 	}

	public void string_list_methods_find_all () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        GLib.assert_true (myL.FindAll( x => x == "Mamenchisaurus" || x == "Deinonychus").size == 2);
        GLib.assert_true (myL.FindAll( x => x == "Squid").size == 0);
 	}

	public void string_list_methods_find_index () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        GLib.assert_true (myL.FindIndex( x => x == "Mamenchisaurus") == 2);
        GLib.assert_true (myL.FindIndex( x => x == "Squid") == -1);
 	}

	public void string_list_methods_find_last () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        GLib.assert_true (myL.FindLast( x => x == "Mamenchisaurus") == "Mamenchisaurus");
        GLib.assert_true (myL.FindLast( x => x == "Squid") == null);
        GLib.assert_true (myL.FindLast( x => x == "Amargasaurus") == "Amargasaurus");
 	}

	public void string_list_methods_find_last_index () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        GLib.assert_true (myL.FindLastIndex( x => x == "Mamenchisaurus") == 2);
        GLib.assert_true (myL.FindLastIndex( x => x == "Squid") == -1);
        GLib.assert_true (myL.FindLastIndex( x => x == "Amargasaurus") == 4);
        GLib.assert_true (myL.FindIndex( x => x == "Amargasaurus") == 1);
 	}

	public void string_list_methods_foreach () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        string newstr = "";
        myL.ForEach( x => newstr += x);
        //myL.ForEach( x => GLib.stdout.puts(x + "\n"));
        GLib.assert_true (newstr == "TyrannosaurusAmargasaurusMamenchisaurusDeinonychusAmargasaurus");

 	}

	public void string_list_methods_get_enumerator () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        string newstr = "";
		foreach (var item in myL) {
			newstr += item;
		}
        GLib.assert_true (newstr == "TyrannosaurusAmargasaurusMamenchisaurusDeinonychusAmargasaurus");
 	}

	public void string_list_methods_get_range () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
		var newL = myL.GetRange (1,3);
        GLib.assert_true (newL.Count == 3);
        GLib.assert_true (newL[0] == "Amargasaurus");
        GLib.assert_true (newL[1] == "Mamenchisaurus");
        GLib.assert_true (newL[2] == "Deinonychus");
 	}

	public void string_list_methods_index_of () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        GLib.assert_true (myL.IndexOf("Amargasaurus") == 1);
        GLib.assert_true (myL.IndexOf("Mamenchisaurus") == 2);
        GLib.assert_true (myL.IndexOf("Amargasaurus", 2) == 4);
 	}

	public void string_list_methods_insert () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        myL.Insert(3, "Tyrannosaurus");
        GLib.assert_true (myL.Count == 6);
        GLib.assert_true (myL[3] == "Tyrannosaurus");
 	}

	public void string_list_methods_last_index_of () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        GLib.assert_true (myL.Count == 5);
		GLib.assert_true (myL.FindLastIndex( x => x == "Amargasaurus") == 4);
        GLib.assert_true (myL.LastIndexOf("Amargasaurus") == 4);
        GLib.assert_true (myL.LastIndexOf("Mamenchisaurus") == 2);
 	}

	public void string_list_methods_remove () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        myL.Remove("Amargasaurus");
        GLib.assert_true (myL.Count == 4);
        GLib.assert_true (myL.LastIndexOf("Amargasaurus") == 3);
 	}

	public void string_list_methods_reverse () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        myL.Reverse();
        GLib.assert_true (myL.LastIndexOf("Amargasaurus") == 3);
        GLib.assert_true (myL[0] == "Amargasaurus");
        GLib.assert_true (myL[1] == "Deinonychus");
        GLib.assert_true (myL[2] == "Mamenchisaurus");
        GLib.assert_true (myL[3] == "Amargasaurus");
        GLib.assert_true (myL[4] == "Tyrannosaurus");
 	}

	public void string_list_methods_remove_all () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        int removed = myL.RemoveAll(x => x == "Amargasaurus");
        GLib.assert_true (removed == 2);
        GLib.assert_true (myL.Count == 3);
        GLib.assert_true (myL[0] == "Tyrannosaurus");
        GLib.assert_true (myL[1] == "Mamenchisaurus");
        GLib.assert_true (myL[2] == "Deinonychus");
 	}

	public void string_list_methods_remove_at () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        myL.RemoveAt(1);
        myL.RemoveAt(3);
        GLib.assert_true (myL.Count == 3);
        GLib.assert_true (myL[0] == "Tyrannosaurus");
        GLib.assert_true (myL[1] == "Mamenchisaurus");
        GLib.assert_true (myL[2] == "Deinonychus");
 	}

	public void string_list_methods_remove_range () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        myL.RemoveRange(1,2);
        GLib.assert_true (myL.Count == 3);
        GLib.assert_true (myL[0] == "Tyrannosaurus");
        GLib.assert_true (myL[1] == "Deinonychus");
        GLib.assert_true (myL[2] == "Amargasaurus");
 	}

	public void string_list_methods_sort () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        myL.Sort();
        GLib.assert_true (myL[0] == "Amargasaurus");
        GLib.assert_true (myL[1] == "Amargasaurus");
        GLib.assert_true (myL[2] == "Deinonychus");
        GLib.assert_true (myL[3] == "Mamenchisaurus");
        GLib.assert_true (myL[4] == "Tyrannosaurus");
 	}

	public void string_list_methods_to_array () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
		var newArray = myL.ToArray();
        GLib.assert_true (newArray.length == 5);
        GLib.assert_true (newArray[1] == "Amargasaurus");
        GLib.assert_true (newArray[4] == "Amargasaurus");
        GLib.assert_true (newArray[3] == "Deinonychus");
        GLib.assert_true (newArray[2] == "Mamenchisaurus");
        GLib.assert_true (newArray[0] == "Tyrannosaurus");
 	}

	public void string_list_methods_trim_excess () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        GLib.assert_true (myL.Capacity == 8);
		myL.TrimExcess();
        GLib.assert_true (myL.Capacity == 5);
 	}

	public void string_list_methods_true_for_all () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
		GLib.assert_true (myL.TrueForAll(x => x.has_suffix("us")));
        GLib.assert_true (myL.TrueForAll(x => x.has_suffix("rus"))!= true);
 	}

	public void string_list_linq_where () {
		var myL = new System.Collections.Generic.List<string> ();
		myL.Add("Tyrannosaurus");
        myL.Add("Amargasaurus");
        myL.Add("Mamenchisaurus");
        myL.Add("Deinonychus");
        myL.Add("Amargasaurus");
        
        IEnumerable<string> query = myL.Where(dino => dino.length > 13);
        string dinolist = "";
        foreach (var dino in query)
        {
			dinolist += dino;
        }
 		GLib.assert_true (dinolist == "Mamenchisaurus" );

		string testString = String.Join(",", myL.Where(dino => dino.length > 11));
 		GLib.assert_true (testString == "Tyrannosaurus,Amargasaurus,Mamenchisaurus,Amargasaurus" );
 		//GLib.assert_true (myL.TrueForAll(x => x.has_suffix("us")));
        //GLib.assert_true (myL.TrueForAll(x => x.has_suffix("rus"))!= true);
        
        
        
 	}

}

