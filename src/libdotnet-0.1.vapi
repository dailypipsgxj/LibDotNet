/* libdotnet-0.1.vapi generated by valac 0.26.2, do not modify. */

namespace System {
	namespace Collections {
		namespace Generic {
			[CCode (cheader_filename = "libdotnet.h")]
			public class KeyValuePair<TKey,TValue> {
				public KeyValuePair (TKey key, TValue value);
				public string ToString (GLib.StringBuilder s);
				public TKey Key { get; }
				public TValue Value { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			[GenericAccessors]
			public interface ICollection<T> : GLib.Object, Gee.Collection<T>, System.Collections.Generic.IEnumerable<T> {
				public virtual void Add (T item);
				public virtual void Clear ();
				public virtual bool Contains (T item);
				public virtual void CopyTo (T[] array, int arrayIndex);
				public virtual bool Remove (T item);
				public virtual System.Collections.Generic.IEnumerator iterator ();
				public abstract int Count { get; }
				public abstract bool IsReadOnly { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IComparer<T> {
				public abstract int Compare (T x, T y);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			[GenericAccessors]
			public interface IDictionary<TKey,TValue> : Gee.Map<TKey,TValue>, System.Collections.Generic.ICollection<System.Collections.Generic.KeyValuePair<TKey,TValue>> {
				public virtual void Add (TKey key, TValue value);
				public virtual bool ContainsKey (TKey key);
				public virtual bool ContainsValue (TValue value);
				protected virtual bool IsCompatibleKey (GLib.Object key);
				public virtual bool Remove (TKey key);
				public virtual bool TryGetValue (TKey key, out TValue value);
				public abstract System.Collections.Generic.ICollection<TKey> Keys { get; }
				public abstract System.Collections.Generic.ICollection<TValue> Values { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEnumerable<T> : System.Collections.IEnumerable {
				public abstract System.Collections.Generic.IEnumerator<T> GetEnumerator ();
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEnumerator<T> : System.IDisposable, System.Collections.IEnumerator {
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IEqualityComparer<T> {
				public abstract bool Equals (T x, T y);
				public abstract int GetHashCode (T obj);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IList<T> : System.Collections.Generic.ICollection<T> {
				public abstract int IndexOf (T item);
				public abstract void Insert (int index, T item);
				public abstract void RemoveAt (int index);
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IReadOnlyCollection<T> : System.Collections.Generic.IEnumerable<T> {
				public abstract int Count { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IReadOnlyDictionary<TKey,TValue> : System.Collections.Generic.IReadOnlyCollection<System.Collections.Generic.KeyValuePair<TKey,TValue>> {
				public abstract bool ContainsKey (TKey key);
				public abstract bool TryGetValue (TKey key, out TValue value);
				public abstract System.Collections.Generic.IEnumerable<TKey> Keys { get; }
				public abstract System.Collections.Generic.IEnumerable<TValue> Values { get; }
			}
			[CCode (cheader_filename = "libdotnet.h")]
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
		public class Hashtable : Gee.HashMap<GLib.Object,GLib.Object>, System.Collections.IDictionary, System.Collections.IEnumerable, System.Collections.ICollection {
			public class HashtableEnumerator : GLib.Object, System.Collections.IDictionaryEnumerator, System.Collections.IEnumerator {
				public virtual void Reset ();
				public virtual GLib.Object Current { owned get; }
				public virtual System.Collections.DictionaryEntry Entry { owned get; }
				public virtual GLib.Object Key { owned get; }
				public virtual GLib.Object Value { owned get; }
			}
			public class KeyCollection : GLib.Object, System.Collections.ICollection, System.Collections.IEnumerable {
				public virtual System.Collections.IEnumerator GetEnumerator ();
				public virtual int Count { get; }
				public virtual bool IsSynchronized { get; }
				public virtual GLib.Object SyncRoot { get; }
			}
			public class ValueCollection : GLib.Object, System.Collections.ICollection, System.Collections.IEnumerable {
				public virtual void CopyTo (GLib.Array<GLib.Object> array, int arrayIndex);
				public virtual System.Collections.IEnumerator GetEnumerator ();
				public virtual int Count { get; }
				public virtual bool IsSynchronized { get; }
				public virtual GLib.Object SyncRoot { get; }
			}
			protected GLib.Object _syncRoot;
			public Hashtable (System.Collections.IEqualityComparer? equalityComparer = null);
			public virtual GLib.Object Clone ();
			public virtual bool ContainsKey (GLib.Object key);
			public virtual bool ContainsValue (GLib.Object value);
			protected void CopyKeys (GLib.Array<GLib.Object> array, int arrayIndex);
			protected virtual int GetHash (GLib.Object key);
			public Hashtable.WithCapacity (int capacity = 0, float loadFactor = 1.0f, System.Collections.IEqualityComparer? equalityComparer = null);
			public Hashtable.WithDictionary (System.Collections.IDictionary d, float loadFactor = 1.0f, System.Collections.IEqualityComparer? equalityComparer = null);
			public virtual int Count { get; }
			protected System.Collections.IEqualityComparer EqualityComparer { get; }
			public virtual bool IsFixedSize { get; }
			public virtual bool IsReadOnly { get; }
			public virtual bool IsSynchronized { get; }
			public virtual System.Collections.ICollection Keys { owned get; }
			public virtual GLib.Object SyncRoot { get; }
			public virtual System.Collections.ICollection Values { owned get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		[Compact]
		public class KeyValuePairs {
			public GLib.Object _key;
			public GLib.Object _value;
			public KeyValuePairs (GLib.Object key, GLib.Object value);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public class Queue : Gee.PriorityQueue<GLib.Object>, System.Collections.ICollection, System.Collections.IEnumerable {
			public class QueueEnumerator : GLib.Object, System.Collections.IEnumerator {
				public QueueEnumerator (System.Collections.Queue q);
				public virtual bool MoveNext ();
				public virtual void Reset ();
				public virtual GLib.Object Current { owned get; }
			}
			public class SynchronizedQueue : System.Collections.Queue {
				public override void Clear ();
				public override GLib.Object Clone ();
				public override bool Contains (GLib.Object obj);
				public override void CopyTo (GLib.Array array, int arrayIndex);
				public override GLib.Object Dequeue ();
				public override void Enqueue (GLib.Object value);
				public override System.Collections.IEnumerator GetEnumerator ();
				public override GLib.Object Peek ();
				public override GLib.Object[] ToArray ();
				public override void TrimToSize ();
				public override int Count { get; }
				public override bool IsSynchronized { get; }
				public override GLib.Object SyncRoot { get; }
			}
			public Queue (int capacity = 32, float growFactor = 2.0f);
			public virtual void Clear ();
			public virtual GLib.Object Clone ();
			public virtual bool Contains (GLib.Object obj);
			public virtual void CopyTo (GLib.Array array, int index);
			public virtual GLib.Object Dequeue ();
			public virtual void Enqueue (GLib.Object obj);
			public virtual System.Collections.IEnumerator GetEnumerator ();
			public virtual GLib.Object Peek ();
			public static System.Collections.Queue Synchronized (System.Collections.Queue queue);
			public virtual GLib.Object[] ToArray ();
			public virtual void TrimToSize ();
			public Queue.WithCollection (System.Collections.ICollection col);
			public virtual int Count { get; }
			public virtual bool IsSynchronized { get; }
			public virtual GLib.Object SyncRoot { get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public class SortedList : Gee.TreeMap<GLib.Object,GLib.Object>, System.Collections.IDictionary, System.Collections.ICollection, System.Collections.IEnumerable {
			public SortedList (System.Collections.IComparer? comparer = null, int capacity = _defaultCapacity);
			public virtual GLib.Object Clone ();
			public virtual bool ContainsKey (GLib.Object key);
			public virtual bool ContainsValue (GLib.Object value);
			public SortedList.FromDictionary (System.Collections.IDictionary d, System.Collections.IComparer? comparer = null);
			public virtual GLib.Object GetByIndex (int index);
			public virtual System.Collections.IDictionaryEnumerator GetEnumerator ();
			public virtual GLib.Object GetKey (int index);
			public virtual System.Collections.IList GetKeyList ();
			public virtual System.Collections.IList GetValueList ();
			public virtual int IndexOfKey (GLib.Object key);
			public virtual int IndexOfValue (GLib.Object value);
			public virtual void Remove (GLib.Object key);
			public virtual void RemoveAt (int index);
			public virtual void SetByIndex (int index, GLib.Object value);
			public static System.Collections.SortedList Synchronized (System.Collections.SortedList list);
			public virtual void TrimToSize ();
			public virtual int Capacity { get; set; }
			public virtual int Count { get; }
			public virtual bool IsFixedSize { get; }
			public virtual bool IsReadOnly { get; }
			public virtual bool IsSynchronized { get; }
			public virtual System.Collections.ICollection Keys { owned get; }
			public virtual GLib.Object SyncRoot { get; }
			public virtual System.Collections.ICollection Values { owned get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface ICollection : GLib.Object, System.Collections.IEnumerable {
			public virtual void CopyTo (GLib.Array<GLib.Object> array, int arrayIndex);
			public virtual System.Collections.IEnumerator iterator ();
			public abstract int Count { get; }
			public abstract bool IsSynchronized { get; }
			public abstract GLib.Object SyncRoot { get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IComparer : GLib.Object {
			public abstract int Compare (GLib.Object x, GLib.Object y);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IDictionary : Gee.Map, System.Collections.ICollection {
			public virtual void Add (GLib.Object key, GLib.Object value);
			public virtual void Clear ();
			public virtual bool Contains (GLib.Object key);
			public abstract System.Collections.IDictionaryEnumerator GetEnumerator ();
			public virtual void Remove (GLib.Object key);
			public abstract System.Collections.ICollection Keys { owned get; }
			public abstract System.Collections.ICollection Values { owned get; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IDictionaryEnumerator : System.Collections.IEnumerator {
			public abstract System.Collections.DictionaryEntry Entry { owned get; }
			public abstract GLib.Object Key { owned get; }
			public abstract GLib.Object Value { owned get; }
			protected abstract Gee.MapIterator<GLib.Object,GLib.Object> _iterator { get; set; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IEnumerable {
			public abstract System.Collections.IEnumerator GetEnumerator ();
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IEnumerator : GLib.Object {
			public virtual bool MoveNext ();
			public abstract void Reset ();
			public virtual GLib.Object @get ();
			public virtual bool next ();
			public abstract GLib.Object Current { owned get; }
			protected abstract GLib.Object _currentElement { get; set; }
			protected abstract Gee.Iterator<GLib.Object> _iterator { get; set; }
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IEqualityComparer : GLib.Object {
			public abstract bool Equals (GLib.Object x, GLib.Object y);
			public abstract int GetHashCode (GLib.Object obj);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IHashCodeProvider {
			public abstract int GetHashCode (GLib.Object obj);
		}
		[CCode (cheader_filename = "libdotnet.h")]
		public interface IList : Gee.List, System.Collections.ICollection {
			public virtual int Add (GLib.Object value);
			public virtual void Clear ();
			public virtual bool Contains (GLib.Object value);
			public virtual int IndexOf (GLib.Object value);
			public virtual void Insert (int index, GLib.Object value);
			public virtual void Remove (GLib.Object value);
			public virtual void RemoveAt (int index);
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
		[CCode (cheader_filename = "libdotnet.h")]
		public enum CultureInfo {
			InvariantCulture,
			CurrentCulture
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
			[CCode (cheader_filename = "libdotnet.h")]
			public interface IDeserializationCallback {
			}
			[CCode (cheader_filename = "libdotnet.h")]
			public interface ISerializable {
			}
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
}