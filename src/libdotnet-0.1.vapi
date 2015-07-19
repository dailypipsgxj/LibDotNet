/* libdotnet-0.1.vapi generated by valac 0.29.2.5-8632-dirty, do not modify. */

namespace System {
	namespace Collections {
		namespace Generic {
			[CCode (cheader_filename = "libdotnet.h")]
			public abstract class AbstractDictionary<TKey,TValue> : GLib.Object, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>, System.Collections.Generic.IDictionary<TKey,TValue> {
				public AbstractDictionary ();
				public abstract void Add (TKey key, TValue value);
				public abstract void Clear ();
				public abstract new bool Contains (System.Collections.Generic.KeyValuePair<TKey,TValue> keyValuePair, System.Collections.Generic.IEqualityComparer<System.Collections.Generic.KeyValuePair>? comparer = null);
				public abstract bool ContainsKey (TKey key);
				public abstract bool ContainsValue (TValue value);
				public abstract void CopyTo (System.Collections.Generic.KeyValuePair<TKey,TValue>[] array, int index = 0);
				public abstract System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey,TValue>> GetEnumerator ();
				public abstract void OnDeserialization (GLib.Object sender);
				public abstract new bool Remove (TKey key, TValue value = null);
				public abstract bool TryGetValue (TKey key, out TValue value);
				public abstract bool contains (System.Collections.Generic.KeyValuePair<TKey,TValue> item);
				public abstract new TValue @get (TKey key);
				public abstract GLib.Type get_element_type ();
				public abstract System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey,TValue>> iterator ();
				public abstract new void @set (TKey key, TValue item);
				public abstract System.Collections.Generic.IEqualityComparer<TKey> Comparer { get; }
				public abstract int Count { get; }
				public abstract bool IsFixedSize { get; }
				public abstract bool IsReadOnly { get; }
				public abstract bool IsSynchronized { get; }
				public abstract System.Collections.Generic.ICollection<TKey> Keys { owned get; }
				public abstract GLib.Object SyncRoot { get; }
				public abstract System.Collections.Generic.ICollection<TValue> Values { owned get; }
				public abstract int size { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public abstract class AbstractList<T> : GLib.Object, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IList<T>, System.Collections.Generic.ICollection<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T> {
				public AbstractList ();
				public abstract void Add (T item);
				public abstract void AddRange (System.Collections.Generic.IEnumerable<T> collection);
				public abstract System.Collections.ObjectModel.ReadOnlyCollection<T> AsReadOnly ();
				public abstract int BinarySearch (int index, int count, T item, System.Collections.Generic.IComparer<T> comparer);
				public abstract void Clear ();
				public abstract void CopyTo (T[] array, int arrayIndex = 0);
				public abstract bool Exists (System.Predicate<T> match);
				public abstract T Find (System.Predicate<T> match);
				public abstract System.Collections.Generic.List<T> FindAll (System.Predicate<T> match);
				public abstract int FindIndex (System.Predicate<T> match);
				public abstract T FindLast (System.Predicate<T> match);
				public abstract int FindLastIndex (System.Predicate<T> match);
				public abstract void ForEach (System.Action<T> action);
				public abstract System.Collections.Generic.IEnumerator<T> GetEnumerator ();
				public abstract System.Collections.Generic.List<T> GetRange (int index, int count);
				public abstract int IndexOf (T item, int startIndex = 0);
				public abstract void Insert (int index, T item);
				public abstract void InsertRange (int index, System.Collections.Generic.IEnumerable<T> collection);
				public abstract int LastIndexOf (T item);
				public abstract bool Remove (T item);
				public abstract int RemoveAll (System.Predicate<T> match);
				public abstract void RemoveAt (int index);
				public abstract void RemoveRange (int index, int count);
				public abstract void Reverse ();
				public abstract void Sort (System.Collections.Generic.IComparer<T>? comparer = null);
				public abstract T[] ToArray ();
				public abstract void TrimExcess ();
				public abstract bool TrueForAll (System.Predicate<T> match);
				public abstract bool contains (T item);
				public abstract new T @get (int index);
				public abstract GLib.Type get_element_type ();
				public abstract System.Collections.Generic.IEnumerator<T> iterator ();
				public abstract new void @set (int index, T item);
				public abstract int Capacity { get; set; }
				public abstract int Count { get; }
				public abstract bool IsFixedSize { get; }
				public abstract bool IsReadOnly { get; }
				public abstract bool IsSynchronized { get; }
				public abstract GLib.Object SyncRoot { get; }
				public abstract int size { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public abstract class Comparer<T> : System.Collections.Generic.IComparer<T> {
				public Comparer ();
				public abstract int Compare (T x, T y);
				public static System.Collections.Generic.Comparer<T> Create<T> (System.Comparison<T> comparison);
				public static System.Collections.Generic.Comparer<T> Default<T> ();
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public class Dictionary<TKey,TValue> : System.Collections.Generic.AbstractDictionary<TKey,TValue> {
				public Dictionary (System.Collections.Generic.IEqualityComparer<TKey>? key_equal_func = null);
				public override void Add (TKey key, TValue value);
				public override void Clear ();
				public override bool Contains (System.Collections.Generic.KeyValuePair<TKey,TValue> keyValuePair, System.Collections.Generic.IEqualityComparer<System.Collections.Generic.KeyValuePair>? comparer = null);
				public override bool ContainsKey (TKey key);
				public override bool ContainsValue (TValue value);
				public override void CopyTo (System.Collections.Generic.KeyValuePair<TKey,TValue>[] array, int index);
				public override System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey,TValue>> GetEnumerator ();
				public override void OnDeserialization (GLib.Object sender);
				public override bool Remove (TKey key, TValue value = null);
				public override bool TryGetValue (TKey key, out TValue value);
				public Dictionary.WithDictionary (System.Collections.Generic.IDictionary<TKey,TValue> dictionary, System.Collections.Generic.IEqualityComparer<TKey>? comparer = null);
				public override bool contains (System.Collections.Generic.KeyValuePair<TKey,TValue> item);
				public override TValue @get (TKey key);
				public override GLib.Type get_element_type ();
				public override System.Collections.Generic.IEnumerator<System.Collections.Generic.KeyValuePair<TKey,TValue>> iterator ();
				public override void @set (TKey key, TValue value);
				public override System.Collections.Generic.IEqualityComparer<TKey> Comparer { get; }
				public override int Count { get; }
				public override bool IsFixedSize { get; }
				public override bool IsReadOnly { get; }
				public override bool IsSynchronized { get; }
				public override System.Collections.Generic.ICollection<TKey> Keys { owned get; }
				public override GLib.Object SyncRoot { get; }
				public override System.Collections.Generic.ICollection<TValue> Values { owned get; }
				public override int size { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public class DictionaryEntry<TKey,TValue> {
				public DictionaryEntry (TKey key, TValue value);
				public TKey Key { get; set; }
				public TValue Value { get; set; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public abstract class EqualityComparer<T> : GLib.Object, System.Collections.Generic.IEqualityComparer<T> {
				public EqualityComparer ();
				public static System.Collections.Generic.EqualityComparer<T> Default<T> ();
				public abstract bool Equals (T x, T y);
				public virtual uint GetHashCode (T obj);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public class KeyValuePair<TKey,TValue> {
				public KeyValuePair (TKey key, TValue value);
				public string ToString (GLib.StringBuilder s);
				public TKey Key { get; }
				public TValue Value { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public class List<T> : System.Collections.Generic.AbstractList<T> {
				public List (System.Collections.Generic.IEnumerable<T>? enumerable = null);
				public override void Add (T item);
				public override void AddRange (System.Collections.Generic.IEnumerable<T> collection);
				public override System.Collections.ObjectModel.ReadOnlyCollection<T> AsReadOnly ();
				public override int BinarySearch (int index, int count, T item, System.Collections.Generic.IComparer<T> comparer);
				public override void Clear ();
				public override void CopyTo (T[] array, int arrayIndex = 0);
				public override bool Exists (System.Predicate<T> match);
				public override T Find (System.Predicate<T> match);
				public override System.Collections.Generic.List<T> FindAll (System.Predicate<T> match);
				public override int FindIndex (System.Predicate<T> match);
				public override T FindLast (System.Predicate<T> match);
				public override int FindLastIndex (System.Predicate<T> match);
				public override void ForEach (System.Action<T> action);
				public override System.Collections.Generic.IEnumerator<T> GetEnumerator ();
				public override System.Collections.Generic.List<T> GetRange (int index, int count);
				public override int IndexOf (T item, int startIndex = 0);
				public override void Insert (int index, T item);
				public override void InsertRange (int index, System.Collections.Generic.IEnumerable<T> collection);
				public override int LastIndexOf (T item);
				public override bool Remove (T item);
				public override int RemoveAll (System.Predicate<T> match);
				public override void RemoveAt (int index);
				public override void RemoveRange (int index, int count);
				public override void Reverse ();
				public override void Sort (System.Collections.Generic.IComparer<T>? comparer = null);
				public override T[] ToArray ();
				public override void TrimExcess ();
				public override bool TrueForAll (System.Predicate<T> match);
				public List.WithCapacity (int defaultCapacity = 4);
				public override bool contains (T item);
				public override T @get (int index);
				public override GLib.Type get_element_type ();
				public override System.Collections.Generic.IEnumerator<T> iterator ();
				public override void @set (int index, T item);
				public override int Capacity { get; set; }
				public override int Count { get; }
				public override bool IsFixedSize { get; }
				public override bool IsReadOnly { get; }
				public override bool IsSynchronized { get; }
				public override GLib.Object SyncRoot { get; }
				public override int size { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public class Queue<T> : GLib.Object, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.ICollection<T>, System.Collections.Generic.IReadOnlyCollection<T> {
				public class Enumerator<T> : GLib.Object, System.Collections.Generic.IEnumerator<T> {
					public void Dispose ();
				}
				public Queue (System.Collections.Generic.IEnumerable<T>? collection = null);
				public T Dequeue ();
				public void Enqueue (T item);
				public T Peek ();
				public T[] ToArray ();
				public void TrimExcess ();
				public new T @get (int item);
				public bool IsSynchronized { get; }
				public GLib.Object SyncRoot { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public class Stack<T> : GLib.Object, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.ICollection<T>, System.Collections.Generic.IReadOnlyCollection<T> {
				public class Enumerator<T> : GLib.Object, System.Collections.Generic.IEnumerator<T> {
					public Enumerator (System.Collections.Generic.Stack<T> stack);
					public void Dispose ();
				}
				public Stack (System.Collections.Generic.IEnumerable<T>? collection = null);
				public T Peek ();
				public T Pop ();
				public void Push (T item);
				public T[] ToArray ();
				public void TrimExcess ();
				public Stack.WithCapacity (int capacity);
				public new T @get (int item);
				public bool IsSynchronized { get; }
				public GLib.Object SyncRoot { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface ICollection<T> : System.Collections.Generic.IEnumerable<T> {
				public abstract void Add (T item);
				public abstract void Clear ();
				public virtual bool Contains (T item);
				public abstract void CopyTo (T[] array, int arrayIndex = 0);
				public abstract bool Remove (T item);
				public abstract bool contains (T item);
				public abstract int Count { get; }
				public abstract bool IsReadOnly { get; }
				public abstract int size { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IComparer<T> {
				public abstract int Compare (T x, T y);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			[GenericAccessors]
			public interface IDictionary<TKey,TValue> : GLib.Object, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>> {
				public abstract void Add (TKey key, TValue value);
				public abstract bool Contains (System.Collections.Generic.KeyValuePair<TKey,TValue> keyValuePair, System.Collections.Generic.IEqualityComparer<System.Collections.Generic.KeyValuePair>? comparer = null);
				public abstract bool ContainsKey (TKey key);
				public abstract bool ContainsValue (TValue value);
				public virtual System.Collections.Generic.IEnumerator GetEnumerator ();
				public abstract bool Remove (TKey key, TValue value = null);
				public abstract bool TryGetValue (TKey key, out TValue value);
				public abstract TValue @get (TKey key);
				public abstract System.Collections.Generic.IEnumerator iterator ();
				public abstract void @set (TKey key, TValue value);
				public abstract System.Collections.Generic.ICollection<TKey> Keys { owned get; }
				public abstract System.Collections.Generic.ICollection<TValue> Values { owned get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IDictionaryEnumerator<TKey,TValue> {
				public abstract System.Collections.Generic.KeyValuePair<TKey,TValue>? Current { owned get; }
				public abstract System.Collections.Generic.DictionaryEntry<TKey,TValue> Entry { owned get; }
				public abstract TKey Key { owned get; }
				public abstract TValue Value { owned get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			[GenericAccessors]
			public interface IEnumerable<T> : GLib.Object {
				public virtual System.Collections.Generic.IEnumerator<T> GetEnumerator ();
				public virtual GLib.Type get_element_type ();
				public abstract System.Collections.Generic.IEnumerator<T> iterator ();
			}
			[CCode (cheader_filename = "libdotnet.h")]
			[GenericAccessors]
			public interface IEnumerator<T> : GLib.Object {
				public abstract bool MoveNext ();
				public abstract void Reset ();
				public abstract T @get ();
				public virtual bool next ();
				public abstract T Current { owned get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEqualityComparer<T> : GLib.Object {
				public abstract bool Equals (T x, T y);
				public abstract uint GetHashCode (T obj);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IList<T> : System.Collections.Generic.IEnumerable<T> {
				public abstract int IndexOf (T item, int index = 0);
				public abstract void Insert (int index, T item);
				public abstract void RemoveAt (int index);
				public abstract T @get (int index);
				public abstract void @set (int index, T item);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IReadOnlyCollection<T> {
				public abstract int Count { get; }
				public abstract int size { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IReadOnlyDictionary<TKey,TValue> : System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey,TValue>> {
				public abstract bool ContainsKey (TKey key);
				public abstract bool TryGetValue (TKey key, out TValue value);
				public abstract System.Collections.Generic.IEnumerable<TKey> Keys { get; }
				public abstract System.Collections.Generic.IEnumerable<TValue> Values { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			[GenericAccessors]
			public interface IReadOnlyList<T> : System.Collections.Generic.IReadOnlyCollection<T> {
				public abstract T @get (int index);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface ISet<T> : Gee.Set<T>, System.Collections.Generic.ICollection<T> {
				public virtual bool Add (T value);
				public abstract void ExceptWith (System.Collections.Generic.IEnumerable<T> other);
				public abstract void IntersectWith (System.Collections.Generic.IEnumerable<T> other);
				public abstract bool IsProperSubsetOf (System.Collections.Generic.IEnumerable<T> other);
				public abstract bool IsProperSupersetOf (System.Collections.Generic.IEnumerable<T> other);
				public abstract bool IsSubsetOf (System.Collections.Generic.IEnumerable<T> other);
				public abstract bool IsSupersetOf (System.Collections.Generic.IEnumerable<T> other);
				public abstract bool Overlaps (System.Collections.Generic.IEnumerable<T> other);
				public abstract bool SetEquals (System.Collections.Generic.IEnumerable<T> other);
				public abstract void SymmetricExceptWith (System.Collections.Generic.IEnumerable<T> other);
				public abstract void UnionWith (System.Collections.Generic.IEnumerable<T> other);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public delegate bool EqualDataFunc<T> (T a, T b);
			[CCode (cheader_filename = "libdotnet.h")]
			public delegate uint HashDataFunc<T> (T v);
		}
		namespace ObjectModel {
			[CCode (cheader_filename = "libdotnet.h")]
			public class ReadOnlyCollection<T> : GLib.Object, System.Collections.Generic.IEnumerable<T>, System.Collections.Generic.IList<T>, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T> {
				public ReadOnlyCollection (System.Collections.Generic.IList<T> list);
				public void Add (T value);
				public void Clear ();
				public bool Contains (T value);
				public void CopyTo (T[] array, int index);
				public bool Remove (T value);
				public bool IsFixedSize { get; }
				public bool IsReadOnly { get; }
				public bool IsSynchronized { get; }
				protected System.Collections.Generic.IList<T> Items { get; }
			}
		}
	}
	namespace Diagnostics {
		namespace CodeAnalysis {
		}
		namespace Contracts {
		}
	}
	namespace Globalization {
		namespace CultureInfo {
			[CCode (cheader_filename = "libdotnet.h")]
			public enum StringComparison {
				CurrentCulture,
				CurrentCultureIgnoreCase,
				InvariantCulture,
				InvariantCultureIgnoreCase,
				Ordinal,
				OrdinalIgnoreCase
			}
		}
	}
	namespace Linq {
	}
	namespace Reflection {
	}
	namespace Runtime {
		namespace CompilerServices {
		}
		namespace InteropServices {
		}
		namespace Remoting {
		}
		namespace Serialization {
		}
	}
	namespace Security {
		namespace Permissions {
		}
	}
	namespace Text {
	}
	namespace Threading {
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public class Nullable<T> {
		public Nullable (T value);
		public bool Equals (GLib.Object other);
		public int GetHashCode ();
		public T GetValueOrDefault (T defaultValue);
		public string ToString ();
		public bool HasValue { get; }
		public T Value { get; }
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public interface ICloneable {
		public abstract GLib.Object Clone ();
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public interface IComparable<T> : GLib.Object {
		public abstract int CompareTo (T other);
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public interface IDisposable {
		public abstract void Dispose ();
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public interface IEquatable<T> {
		public abstract bool Equals (T other);
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public errordomain ArgumentOutOfRangeException {
		INDEX,
		VALUE,
		NEEDNONNEGNUM,
		BEGININDEXNOTNEGATIVE,
		LENGTHNOTNEGATIVE
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public errordomain Error {
		NOELEMENTS
	}
	[CCode (cheader_filename = "libdotnet.h")]
	public delegate void Action<T> (T obj);
	[CCode (cheader_filename = "libdotnet.h")]
	public delegate int Comparison<T> (T x, T y);
	[CCode (cheader_filename = "libdotnet.h")]
	public delegate TResult Func<T,TResult> (T arg);
	[CCode (cheader_filename = "libdotnet.h")]
	public delegate bool Predicate<T> (T obj);
}
