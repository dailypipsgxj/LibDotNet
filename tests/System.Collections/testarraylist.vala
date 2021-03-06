/*
 * DESCRIPTION      Unit tests for Dia3.
 * PROJECT          Dia3
 * AUTHOR           Chris Daley <chebizarro@gmail.com>
 *
 * Copyright (C) Chris Daley 2015
 * Code is present with GPL licence.
 */

using LibDotNet;
using System.Collections;

public class SystemCollectionsArrayListTests : LibDotNet.TestCase {
	
	public SystemCollectionsArrayListTests () {
		base ("System.Collections.ArrayList");
		
		add_test ("[System.Collections][ArrayList] New Array List with default constructor", new_with_default_constructor);
		add_test ("[System.Collections][ArrayList] New Array List with Collection", new_with_collection);
		add_test ("[System.Collections][ArrayList] New Array List with Capacity", new_with_capacity);
		add_test ("[System.Collections][ArrayList] Get Capacity Property", properties_get_capacity);
		add_test ("[System.Collections][ArrayList] Set Capacity Property", properties_set_capacity);
		add_test ("[System.Collections][ArrayList] Get Count Property", properties_get_count);
		add_test ("[System.Collections][ArrayList] Get IsFixedSize Property", properties_get_fixed_size);
		add_test ("[System.Collections][ArrayList] Get IsReadOnly Property", properties_get_read_only);
		add_test ("[System.Collections][ArrayList] Get IsSynchronized Property", properties_get_synchronized);
		add_test ("[System.Collections][ArrayList] Get Item Property", properties_get_item);
		add_test ("[System.Collections][ArrayList] Set Item Property", properties_set_item);
		add_test ("[System.Collections][ArrayList] Get SyncRoot Property", properties_get_syncroot);
		add_test ("[System.Collections][ArrayList] Adapter Method", methods_adapter);
		add_test ("[System.Collections][ArrayList] Add Method", methods_add);
		add_test ("[System.Collections][ArrayList] AddRange Method", methods_add_range);
		add_test ("[System.Collections][ArrayList] BinarySearch Method", methods_binary_search);
		add_test ("[System.Collections][ArrayList] BinarySearch Method with Comparer", methods_binary_search_with_comparer);
		add_test ("[System.Collections][ArrayList] BinarySearch Method from Index", methods_binary_search_from_index);
		add_test ("[System.Collections][ArrayList] BinarySearch Method from Index with comparer", methods_binary_search_from_index_with_comparer);
		add_test ("[System.Collections][ArrayList] Clear Method", methods_clear);
		add_test ("[System.Collections][ArrayList] Cotains Method", methods_contains);
		add_test ("[System.Collections][ArrayList] CopyTo Method", methods_copy_to);
		add_test ("[System.Collections][ArrayList] CopyTo with Index Method", methods_copy_to_index);
		add_test ("[System.Collections][ArrayList] CopyTo with Index with Count Method", methods_copy_to_index_with_count);
		add_test ("[System.Collections][ArrayList] FixedSized method with ArrayList return", methods_fixed_size_array_list);
		add_test ("[System.Collections][ArrayList] FixedSized method with List return", methods_fixed_size_list);
		add_test ("[System.Collections][ArrayList] GetEnumerator method", methods_get_enumerator);
		add_test ("[System.Collections][ArrayList] GetEnumerator method within range", methods_get_enumerator_within_range);
		add_test ("[System.Collections][ArrayList] GetRange method", methods_get_range);
		add_test ("[System.Collections][ArrayList] IndexOf method", methods_index_of);
		add_test ("[System.Collections][ArrayList] IndexOf method with start position", methods_index_of_with_start);
		add_test ("[System.Collections][ArrayList] IndexOf method with range", methods_index_of_with_range);
		
	}

	public void new_with_default_constructor () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL is ArrayList);
		assert_true (myAL.Capacity == 4);
	}

	public void new_with_collection () {
		ArrayList myAL = new ArrayList();
		myAL.Add("Hello" as Object);
		myAL.Add("World"as Object);
		myAL.Add("!" as Object);

		ArrayList newAL = new ArrayList.WithCollection(myAL);
		assert_true (newAL is ArrayList);
		assert_true (newAL.Count == 3);
		assert_true (newAL[0] == "Hello" as Object);
		assert_true (newAL[1] == "World" as Object);
		assert_true (newAL[2] == "!" as Object);
	}

	public void new_with_capacity () {
		ArrayList myAL = new ArrayList(12);
		assert_true (myAL is ArrayList);
		assert_true (myAL.Capacity == 12);
	}

	public void properties_get_capacity () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL.Capacity == 4);
	}

	public void properties_set_capacity () {
		ArrayList myAL = new ArrayList();
		myAL.Capacity = 2;
		assert_true (myAL.Capacity == 2);
		myAL.Add("Hello" as Object);
		myAL.Add("World" as Object);
		myAL.Add("!" as Object);
		assert_true (myAL.Capacity == 3);
		myAL.Capacity = 2;
		assert_true (myAL.Capacity == 3);
	}

	public void properties_get_count () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL.Count == 0);
		myAL.Add("Hello" as Object);
		myAL.Add("World" as Object);
		myAL.Add("!" as Object);
		assert_true (myAL.Count == 3);
	}

	public void properties_get_fixed_size () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL.IsFixedSize == false);
	}

	public void properties_get_read_only () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL.IsReadOnly == false);
	}

	public void properties_get_synchronized () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL.IsSynchronized == false);
	}

	public void properties_get_item () {
		ArrayList myAL = new ArrayList();
		myAL.Add("Hello" as Object);
		myAL.Add("World" as Object);
		myAL.Add("!" as Object);
		assert_true (myAL[0] == "Hello" as Object);
		assert_true (myAL[1] == "World" as Object);
		assert_true (myAL[2] == "!" as Object);
	}

	public void properties_set_item () {
		ArrayList myAL = new ArrayList();
		myAL.Add("Hello" as Object);
		myAL.Add("World" as Object);
		myAL.Add("!" as Object);
		myAL[0] = "Goodbye" as Object;
		myAL[2] = "?" as Object;
		assert_true (myAL[0] == "Goodbye" as Object);
		assert_true (myAL[1] == "World" as Object);
		assert_true (myAL[2] == "?" as Object);
		myAL[3] = "Forever" as Object;
	}

	public void properties_get_syncroot () {
		ArrayList myAL = new ArrayList();
		assert_true (myAL.SyncRoot is Object);
	}

	public void methods_adapter () {
		ArrayList myAL = new ArrayList();
		ArrayList testAL = new ArrayList();
		myAL.Add("Hello" as Object);
		myAL.Add("World" as Object);
		myAL.Add("!" as Object);
		assert_true (testAL.Adapter(myAL) is ArrayList);
	}

	public void methods_add () {
		ArrayList myAL = new ArrayList();
		myAL.Add("Hello" as Object);
		myAL.Add("World" as Object);
		myAL.Add("!" as Object);
		myAL.Add("!" as Object);
		myAL.Add(null);
		myAL.Add(null);
		assert_true (myAL.Count == 6);
		assert_true (myAL.Capacity == 6);
	}

	public void methods_add_range () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		var myQueue = new System.Collections.Queue();
		myQueue.Enqueue( "jumped"  as Object);
		myQueue.Enqueue( "over"  as Object);
		myQueue.Enqueue( "the"  as Object);
		myQueue.Enqueue( "lazy"  as Object);
		myQueue.Enqueue( "dog"  as Object);
		myAL.AddRange( myQueue );
		assert_true (myAL.Count == 9);
		assert_true (myAL[0] == "The" as Object);
		assert_true (myAL[1] == "quick" as Object);
		assert_true (myAL[2] == "brown" as Object);
		assert_true (myAL[3] == "fox" as Object);
		assert_true (myAL[4] == "jumped" as Object);
		assert_true (myAL[5] == "over" as Object);
		assert_true (myAL[6] == "the" as Object);
		assert_true (myAL[7] == "lazy" as Object);
		assert_true (myAL[8] == "dog" as Object);
	}

	public void methods_binary_search () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		int result = myAL.BinarySearch("brown" as Object);
		assert_true (result == 3);
	}

	public void methods_binary_search_with_comparer () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		int result = myAL.BinarySearch("brown", new SimpleStringComparer());
		assert_true (result == 3);
	}

	public void methods_binary_search_from_index () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		int result = myAL.BinarySearchFromIndex(1,3,"brown");
		assert_true (result == 3);
	}

	public void methods_binary_search_from_index_with_comparer () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		int result = myAL.BinarySearchFromIndex(1,3,"brown", new SimpleStringComparer());
		assert_true (result == 3);
	}

	public void methods_clear () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		myAL.Clear();
		assert_true (myAL.Count == 0);
	}

	public void methods_contains () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		assert_true (myAL.Contains("The"));
		assert_true (myAL.Contains("quick"));
		assert_true (myAL.Contains("brown"));
		assert_true (myAL.Contains("fox"));
	}

	public void methods_copy_to () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		Array<string> array = new Array<string>();
		MyAL.CopyTo(array);
		assert_true (array.length == 4);
		assert_true (array.data[0] == "The" as Object);
		assert_true (array.data[1] == "quick" as Object);
		assert_true (array.data[2] == "brown" as Object);
		assert_true (array.data[3] == "fox" as Object);
	}

	public void methods_copy_to_index () {
		ArrayList myAL = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		Array<string> array = new Array<string>();
		array.append("Who");
		array.append("is");
		MyAL.CopyTo(array, 2);
		assert_true (array.length == 7);
		assert_true (array.data[0] == "Who" as Object);
		assert_true (array.data[1] == "is" as Object);
		assert_true (array.data[2] == "The" as Object);
		assert_true (array.data[3] == "quick" as Object);
		assert_true (array.data[4] == "brown" as Object);
		assert_true (array.data[5] == "dog" as Object);
		assert_true (array.data[6] == "!" as Object);
	}

	public void methods_copy_to_index_with_count () {
		ArrayList myAL = new ArrayList();
		myAL.Add("jumped" as Object);
		myAL.Add("over" as Object);
		myAL.Add("lazy" as Object);
		myAL.Add("dog" as Object);
		myAL.Add("bowl" as Object);
		Array<string> array = new Array<string>();
		array.append( "The"  as Object);
		array.append( "quick"  as Object);
		array.append( "brown"  as Object);
		array.append( "fox"  as Object);
		MyAL.CopyTo(array, 4, 4);
		assert_true (array.length == 8);
		assert_true (array.data[0] == "The" as Object);
		assert_true (array.data[1] == "quick" as Object);
		assert_true (array.data[2] == "brown" as Object);
		assert_true (array.data[3] == "fox" as Object);
		assert_true (array.data[4] == "jumped" as Object);
		assert_true (array.data[5] == "over" as Object);
		assert_true (array.data[6] == "lazy" as Object);
		assert_true (array.data[7] == "dog" as Object);
	}

	public void methods_fixed_size_array_list () {
		ArrayList myVal = new ArrayList();
		assert_true (myVal.IsFixedSize == false);
		ArrayList newVal = ArrayList.FixedSize(myVal);
		assert_true (myVal is ArrayList);
		assert_true (myVal.IsFixedSize == true);
	}

	public void methods_fixed_size_list () {
		ArrayList myVal = new ArrayList();
		assert_true (myVal.IsFixedSize == false);
		ArrayList newVal = ArrayList.FixedSize(myVal);
		assert_true (myVal is IList);
		assert_true (myVal.IsFixedSize == true);
	}

	public void methods_get_enumerator () {
		ArrayList myVal = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		IEnumerator e = myVal.GetEnumerator();
		assert_true (e is IEnumerator);
		string result = "";
		while (e.MoveNext()) {
			result += e.Current;
		}
		assert_true(result == "Thequickbrownfox" as Object);
		e.Reset();
		result = "";
		while (e.MoveNext()) {
			result += e.Current;
		}
		assert_true(result == "Thequickbrownfox" as Object);
	}

	public void methods_get_enumerator_within_range () {
		ArrayList myVal = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		myAL.Add("jumped" as Object);
		myAL.Add("over" as Object);
		myAL.Add("the" as Object);
		myAL.Add("lazy" as Object);
		myAL.Add("dog" as Object);
		IEnumerator e = myVal.GetEnumerator(4,4);
		assert_true (e is IEnumerator);
		string result = "";
		while (e.MoveNext()) {
			result += e.Current;
		}
		assert_true(result == "jumpedoverthelazydog");
		e.Reset();
		result = "";
		while (e.MoveNext()) {
			result += e.Current;
		}
		assert_true(result == "jumpedoverthelazydog");
	}

	public void methods_get_range () {
		ArrayList myVal = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		myAL.Add("jumped" as Object);
		myAL.Add("over" as Object);
		myAL.Add("the" as Object);
		myAL.Add("lazy" as Object);
		myAL.Add("dog" as Object);
		var newVal = myVal.GetRange(3,3);
		assert_true(newVal is ArrayList);
		assert_true(newVal.Count = 3);
		assert_true (myAL[0] == "fox" as Object);
		assert_true (myAL[1] == "jumped" as Object);
		assert_true (myAL[2] == "over" as Object);
	}

	public void methods_index_of () {
		ArrayList myVal = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		myAL.Add("jumped" as Object);
		myAL.Add("over" as Object);
		myAL.Add("the" as Object);
		myAL.Add("lazy" as Object);
		myAL.Add("dog" as Object);
		assert_true (myAL.IndexOf("The") == 0);
		assert_true (myAL.IndexOf("quick") == 1);
		assert_true (myAL.IndexOf("brown") == 2);
		assert_true (myAL.IndexOf("fox") == 3);
		assert_true (myAL.IndexOf("jumped") == 4);
		assert_true (myAL.IndexOf("over") == 5);
		assert_true (myAL.IndexOf("the") == 6);
		assert_true (myAL.IndexOf("lazy") == 7);
		assert_true (myAL.IndexOf("dog") == 8);
	}

	public void methods_index_of_with_start () {
		ArrayList myVal = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		myAL.Add("jumped" as Object);
		myAL.Add("over" as Object);
		myAL.Add("the" as Object);
		myAL.Add("lazy" as Object);
		myAL.Add("dog" as Object);
		assert_true (myAL.IndexOf("The", 0) == 0);
		assert_true (myAL.IndexOf("The", 1) == -1);
		assert_true (myAL.IndexOf("jumped", 2) == 4);
		assert_true (myAL.IndexOf("jumped", 5) == -1);
		assert_true (myAL.IndexOf("the", 0) == 6);
		assert_true (myAL.IndexOf("the", 5) == 6);
		assert_true (myAL.IndexOf("the", 10) == -1);
		assert_true (myAL.IndexOf("the", -1) == -1);
	}

	public void methods_index_of_with_range () {
		ArrayList myVal = new ArrayList();
		myAL.Add( "The"  as Object);
		myAL.Add( "quick"  as Object);
		myAL.Add( "brown"  as Object);
		myAL.Add( "fox"  as Object);
		myAL.Add("jumped" as Object);
		myAL.Add("over" as Object);
		myAL.Add("the" as Object);
		myAL.Add("lazy" as Object);
		myAL.Add("dog" as Object);
		assert_true (myAL.IndexOf("The", 0, 7) == 0);
		assert_true (myAL.IndexOf("The", 1, 8) == -1);
		assert_true (myAL.IndexOf("jumped", 2, 7) == 4);
		assert_true (myAL.IndexOf("jumped", 5, 7) == -1);
		assert_true (myAL.IndexOf("the", 0, 7) == 6);
		assert_true (myAL.IndexOf("the", 5, 7) == 6);
		assert_true (myAL.IndexOf("the", 0, 10) == -1);
		assert_true (myAL.IndexOf("the", -1, 8) == -1);
	}

}

