/* libdotnet-0.1.vapi generated by valac 0.29.2.5-8632-dirty, do not modify. */

namespace System {
	namespace Collections {
		namespace Generic {
			[CCode (cheader_filename = "libdotnet.h")]
			public abstract class AbstractList<T> : GLib.Object, System.Collections.Generic.IList<T>, System.Collections.Generic.ICollection<T>, System.Collections.Generic.IEnumerable<T>, System.Collections.ICollection, System.Collections.IEnumerable, System.Collections.IList, System.Collections.Generic.IReadOnlyCollection<T>, System.Collections.Generic.IReadOnlyList<T> {
				public AbstractList ();
				public abstract void Add (T item);
				public abstract void AddRange (System.Collections.Generic.IEnumerable<T> collection);
				public abstract int BinarySearch (int index, int count, T item, System.Collections.Generic.IComparer<T> comparer);
				public abstract void Clear ();
				public abstract void CopyTo (GLib.Array<T> array, int arrayIndex);
				public abstract void ForEach (System.Action<T> action);
				public abstract System.Collections.Generic.IEnumerator<T> GetEnumerator ();
				public abstract System.Collections.Generic.IList<T> GetRange (int index, int count);
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
				public abstract void TrimExcess ();
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
				public override int BinarySearch (int index, int count, T item, System.Collections.Generic.IComparer<T> comparer);
				public override void Clear ();
				public override void CopyTo (GLib.Array<T> array, int arrayIndex);
				public override void ForEach (System.Action<T> action);
				public override System.Collections.Generic.IEnumerator<T> GetEnumerator ();
				public override System.Collections.Generic.IList<T> GetRange (int index, int count);
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
				public override void TrimExcess ();
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
			public interface ICollection<T> : GLib.Object {
				public abstract void Add (T item);
				public abstract void Clear ();
				public virtual bool Contains (T item);
				public abstract void CopyTo (GLib.Array<T> array, int arrayIndex);
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
			public interface IDictionary<TKey,TValue> : System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey,TValue>>, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<TKey,TValue>>, System.Collections.IEnumerable {
				public abstract void Add (TKey key, TValue value);
				public abstract bool ContainsKey (TKey key);
				public abstract bool ContainsValue (TValue value);
				public abstract bool Remove (TKey key);
				public abstract bool TryGetValue (TKey key, out TValue value);
				public abstract TValue @get (TKey key);
				public abstract void @set (TKey key);
				public abstract System.Collections.Generic.ICollection<TKey> Keys { owned get; private set; }
				public abstract System.Collections.Generic.ICollection<TValue> Values { owned get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEnumerable<T> {
				public virtual System.Collections.Generic.IEnumerator<T> GetEnumerator ();
				public abstract GLib.Type get_element_type ();
				public abstract System.Collections.Generic.IEnumerator<T> iterator ();
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEnumerator<T> : System.Collections.IEnumerator {
				public abstract T @get ();
				public abstract T Current { owned get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEqualityComparer<T> {
				public abstract bool Equals (T x, T y);
				public abstract int GetHashCode (T obj);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IList<T> : GLib.Object {
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
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public class DictionaryEntry {
			public DictionaryEntry (GLib.Object key, GLib.Object value);
			public GLib.Object Key { get; set; }
			public GLib.Object Value { get; set; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		[Compact]
		public class KeyValuePairs {
			public GLib.Object _key;
			public GLib.Object _value;
			public KeyValuePairs (GLib.Object key, GLib.Object value);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface ICollection : GLib.Object {
			public abstract void CopyTo (GLib.Array<GLib.Object> array, int arrayIndex);
			public abstract int Count { get; }
			public abstract bool IsSynchronized { get; }
			public abstract GLib.Object SyncRoot { get; }
			public abstract int size { get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IComparer {
			public abstract int Compare (GLib.Object x, GLib.Object y);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IDictionary : System.Collections.ICollection, System.Collections.IEnumerable {
			public abstract void Add (GLib.Object key, GLib.Object value);
			public abstract void Clear ();
			public abstract bool Contains (GLib.Object key);
			public abstract System.Collections.IDictionaryEnumerator GetEnumerator ();
			public abstract void Remove (GLib.Object key);
			public abstract GLib.Object @get (GLib.Object key);
			public abstract void @set (GLib.Object key);
			public abstract bool IsFixedSize { get; }
			public abstract bool IsReadOnly { get; }
			public abstract System.Collections.ICollection? Keys { owned get; private set; }
			public abstract System.Collections.ICollection? Values { owned get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IDictionaryEnumerator : System.Collections.IEnumerator {
			public abstract System.Collections.DictionaryEntry Entry { owned get; }
			public abstract GLib.Object Key { owned get; }
			public abstract GLib.Object Value { owned get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IEnumerable : GLib.Object {
			public virtual System.Collections.IEnumerator GetEnumerator ();
			public abstract System.Collections.IEnumerator iterator ();
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IEnumerator : GLib.Object {
			public virtual bool MoveNext ();
			public abstract void Reset ();
			public abstract GLib.Object @get ();
			public abstract bool next ();
			public abstract GLib.Object Current { owned get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IEqualityComparer {
			public abstract bool Equals (GLib.Object x, GLib.Object y);
			public abstract int GetHashCode (GLib.Object obj);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IHashCodeProvider {
			public abstract int GetHashCode (GLib.Object obj);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IList : System.Collections.ICollection, System.Collections.IEnumerable {
			public abstract int Add (GLib.Object item);
			public abstract void Clear ();
			public virtual bool Contains (GLib.Object item);
			public abstract int IndexOf (GLib.Object item);
			public virtual void Insert (int index, GLib.Object value);
			public abstract void Remove (GLib.Object value);
			public abstract void RemoveAt (int index);
			public abstract bool contains (GLib.Object item);
			public abstract GLib.Object? @get (int index);
			public abstract void @set (int index, GLib.Object item);
			public abstract bool IsFixedSize { get; }
			public abstract bool IsReadOnly { get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IStructuralComparable {
			public abstract int32 CompareTo (GLib.Object other, System.Collections.IComparer comparer);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IStructuralEquatable {
			public abstract bool Equals (GLib.Object other, System.Collections.IEqualityComparer comparer);
			public abstract int GetHashCode (System.Collections.IEqualityComparer comparer);
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
	public interface IComparable<T> {
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
	public delegate void Action<T> (T obj);
	[CCode (cheader_filename = "libdotnet.h")]
	public delegate int Comparison<T> (T x, T y);
	[CCode (cheader_filename = "libdotnet.h")]
	public delegate bool Predicate<T> (T obj);
}
