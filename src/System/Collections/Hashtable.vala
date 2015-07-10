// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

/*============================================================
**
** Class:  Hashtable
**
** Purpose: Represents a collection of key/value pairs
**          that are organized based on the hash code
**          of the key.
**
===========================================================*/

using System;
using System.Diagnostics;
using System.Diagnostics.Contracts;
using System.Runtime;
using System.Runtime.CompilerServices;
using System.Threading;

namespace System.Collections
{
    // The Hashtable class represents a dictionary of associated keys and values
    // with constant lookup time.
    // 
    // Objects used as keys in a hashtable must implement the GetHashCode
    // and Equals methods (or they can rely on the default implementations
    // inherited from Object if key equality is simply reference
    // equality). Furthermore, the GetHashCode and Equals methods of
    // a keyObjectmust produce the same results given the same parameters for the
    // entire time the key is present in the hashtable. In practical terms, this
    // means that key objects should be immutable, at least for the time they are
    // used as keys in a hashtable.
    // 
    // When entries are added to a hashtable, they are placed into
    // buckets based on the hashcode of their keys. Subsequent lookups of
    // keys will use the hashcode of the keys to only search a particular bucket,
    // thus substantially reducing the number of key comparisons required to find
    // an entry. A hashtable's maximum load factor, which can be specified
    // when the hashtable is instantiated, determines the maximum ratio of
    // hashtable entries to hashtable buckets. Smaller load factors cause faster
    // average lookup times at the cost of increased memory consumption. The
    // default maximum load factor of 1.0 generally provides the best balance
    // between speed and size. As entries are added to a hashtable, the hashtable's
    // actual load factor increases, and when the actual load factor reaches the
    // maximum load factor value, the number of buckets in the hashtable is
    // automatically increased by approximately a factor of two (to be precise, the
    // number of hashtable buckets is increased to the smallest prime number that
    // is larger than twice the current number of hashtable buckets).
    // 
    // EachObjectprovides their own hash function, accessed by calling
    // GetHashCode().  However, one can write their ownObject// implementing IEqualityComparer and pass it to a constructor on
    // the Hashtable.  That hash function (and the equals method on the 
    // IEqualityComparer) would be used for all objects in the table.
    //
// [DebuggerTypeProxy(typeof(System.Collections.Hashtable.HashtableDebugView))]

// [DebuggerDisplay("Count = {Count}")]

    public class Hashtable : Gee.HashMap, IDictionary
    {
        /*
          This Hashtable uses double hashing.  There are hashsize buckets in the 
          table, and each bucket can contain 0 or 1 element.  We assign a bit to mark
          whether there's been a collision when we inserted multiple elements
          (ie, an inserted item was hashed at least a second time and we probed 
          this bucket, but it was already in use).  Using the collision bit, we
          can terminate lookups & removes for elements that aren't in the hash
          table more quickly.  We steal the most significant bit from the hash code
          to store the collision bit.

          Our hash function is of the following form:
    
          h(key, n) = h1(key) + n*h2(key)
    
          where n is the number of times we've hit a collided bucket and rehashed
          (on this particular lookup).  Here are our hash functions:
    
          h1(key) = GetHash(key);  // default implementation calls key.GetHashCode();
          h2(key) = 1 + (((h1(key) >> 5) + 1) % (hashsize - 1));
    
          The h1 can return any number.  h2 must return a number between 1 and
          hashsize - 1 that is relatively prime to hashsize (not a problem if 
          hashsize is prime).  (Knuth's Art of Computer Programming, Vol. 3, p. 528-9)
          If this is true, then we are guaranteed to visit every bucket in exactly
          hashsize probes, since the least common multiple of hashsize and h2(key)
          will be hashsize * h2(key).  (This is the first number where adding h2 to
          h1 mod hashsize will be 0 and we will search the same bucket twice).
          
          We previously used a different h2(key, n) that was not constant.  That is a 
          horrifically bad idea, unless you can prove that series will never produce
          any identical numbers that overlap when you mod them by hashsize, for all
          subranges from i to i+hashsize, for all i.  It's not worth investigating,
          since there was no clear benefit from using that hash function, and it was
          broken.
    
          For efficiency reasons, we've implemented this by storing h1 and h2 in a 
          temporary, and setting a variable called seed equal to h1.  We do a probe,
          and if we collided, we simply add h2 to seed each time through the loop.
    
          A good test for h2() is to subclass Hashtable, provide your own implementation
          of GetHash() that returns a constant, then add many items to the hash table.
          Make sure Count equals the number of items you inserted.

          Note that when we remove an item from the hash table, we set the key
          equal to buckets, if there was a collision in this bucket.  Otherwise
          we'd either wipe out the collision bit, or we'd still have an item in
          the hash table.

           -- 
        */

        internal const int32 HashPrime = 101;
        private const int32 InitialSize = 3;
        private const string LoadFactorName = "LoadFactor";
        private const string VersionName = "Version";
        private const string ComparerName = "Comparer";
        private const string HashCodeProviderName = "HashCodeProvider";
        private const string HashSizeName = "HashSize";  // Must save buckets.Length
        private const string KeysName = "Keys";
        private const string ValuesName = "Values";
        private const string KeyComparerName = "KeyComparer";

        // Deleted entries have their key set to buckets

        // The hash table data.
        // This cannot be serialized
        private struct bucket
        {
            public Object key;
            public Object val;
            public int hash_coll;   // Store hash code; sign bit means there was a collision.
        }

        private bucket[] _buckets;

        // The total number of entries in the hash table.
        private int _count;

        // The total number of collision bits set in the hashtable
        private int _occupancy;

        private int _loadsize;
        private float _loadFactor;

        private int _version;
        private bool _isWriterInProgress;

        private ICollection _keys;
        private ICollection _values;

        private IEqualityComparer? _keycomparer;
        private Object _syncRoot;

        protected IEqualityComparer EqualityComparer
        {
            get
            {
                return _keycomparer;
            }
        }

        public Hashtable(IEqualityComparer? equalityComparer = null){
            _keycomparer = equalityComparer;
			base(null, equalityComparer);
        }

        public Hashtable.WithCapacity(int capacity = 0, float loadFactor = 1.0f, IEqualityComparer? equalityComparer = null){
			this(equalityComparer);
        }

        // Constructs a new hashtable containing a copy of the entries in the given
        // dictionary. The hashtable is created with the given load factor.
        // 
        public Hashtable.WithDictionary (IDictionary d, float loadFactor = 1.0f, IEqualityComparer? equalityComparer = null){
			this(equalityComparer);
            IDictionaryEnumerator e = d.GetEnumerator();
            while (e.MoveNext()) Add(e.Key, e.Value);
        }

        // ‘InitHash’ is basically an implementation of classic DoubleHashing (see http://en.wikipedia.org/wiki/Double_hashing)  
        //
        // 1) The only ‘correctness’ requirement is that the ‘increment’ used to probe 
        //    a. Be non-zero
        //    b. Be relatively prime to the table size ‘hashSize’. (This is needed to insure you probe all entries in the table before you ‘wrap’ and visit entries already probed)
        // 2) Because we choose table sizes to be primes, we just need to insure that the increment is 0 < incr < hashSize
        //
        // Thus this function would work: Incr = 1 + (seed % (hashSize-1))
        // 
        // While this works well for ‘uniformly distributed’ keys, in practice, non-uniformity is common. 
        // In particular in practice we can see ‘mostly sequential’ where you get long clusters of keys that ‘pack’. 
        // To avoid bad behavior you want it to be the case that the increment is ‘large’ even for ‘small’ values (because small 
        // values tend to happen more in practice). Thus we multiply ‘seed’ by a number that will make these small values
        // bigger (and not hurt large values). We picked HashPrime (101) because it was prime, and if ‘hashSize-1’ is not a multiple of HashPrime
        // (enforced in GetPrime), then incr has the potential of being every value from 1 to hashSize-1. The choice was largely arbitrary.
        // 
        // Computes the hash function:  H(key, i) = h1(key) + i*h2(key, hashSize).
        // The out parameter seed is h1(key), while the out parameter 
        // incr is h2(key, hashSize).  Callers of this function should 
        // add incr each time through a loop.
        private uint InitHash(Object key, int hashsize, out uint seed, out uint incr)
        {
            // Hashcode must be positive.  Also, we must not use the sign bit, since
            // that is used for the collision bit.
            uint hashcode = (uint)GetHash(key) & 0x7FFFFFFF;
            seed = (uint)hashcode;
            // Restriction: incr MUST be between 1 and hashsize - 1, inclusive for
            // the modular arithmetic to work correctly.  This guarantees you'll
            // visit every bucket in the table exactly once within hashsize 
            // iterations.  Violate this and it'll cause obscure bugs forever.
            // If you change this calculation for h2(key), update putEntry too!
            incr = (uint)(1 + ((seed * HashPrime) % ((uint)hashsize - 1)));
            return hashcode;
        }

        // Adds an entry with the given key and value to this hashtable. An
        // ArgumentException is thrown if the key is null or if the key is already
        // present in the hashtable.
        // 
        public virtual void Add(Object key, Object value)
        {
            Insert(key, value, true);
        }

        // Removes all entries from this hashtable.
        public virtual void Clear()
        {
			clear ();
        }

        // Clone returns a virtually identical copy of this hash table.  This does
        // a shallow copy - the Objects in the table aren't cloned, only the references
        // to those Objects.
        public virtual Object Clone()
        {

        }

        // Checks if this hashtable contains the given key.
        public virtual bool Contains(Object key)
        {
            return ContainsKey(key);
        }

        // Checks if this hashtable contains an entry with the given key.  This is
        // an O(1) operation.
        // 
        public virtual bool ContainsKey(Object key)
        {
			return has_key (key);
        }

        // Checks if this hashtable contains an entry with the given value. The
        // values of the entries of the hashtable are compared to the given value
        // using the Object.Equals method. This method performs a linear
        // search and is thus be substantially slower than the ContainsKey
        // method.
        // 
        public virtual bool ContainsValue(Object value)
        {
            return (value in values);
        }

        // Copies the keys of this hashtable to a given array starting at a given
        // index. This method is used by the implementation of the CopyTo method in
        // the KeyCollection class.
        private void CopyKeys(Array array, int arrayIndex)
        {
            foreach (var key in keys)
            {
				array.SetValue(key, arrayIndex++);
            }
        }

        // Copies the keys of this hashtable to a given array starting at a given
        // index. This method is used by the implementation of the CopyTo method in
        // the KeyCollection class.
        private void CopyEntries(Array array, int arrayIndex)
        {
            foreach (var ent in entries)
            {
				DictionaryEntry entry = new DictionaryEntry(ent.key, ent.value);
				array.SetValue(entry, arrayIndex++);
            }
        }

        // Copies the values in this hash table to an array at
        // a given index.  Note that this only copies values, and not keys.
        public virtual void CopyTo(Array array, int arrayIndex)
        {
            if (array.Rank != 1)
                throw ArgumentException(SR.Arg_RankMultiDimNotSupported);
            if (arrayIndex < 0)
                throw ArgumentOutOfRangeException("arrayIndex", SR.ArgumentOutOfRange_NeedNonNegNum);
            if (array.Length - arrayIndex < Count)
                throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
            CopyEntries(array, arrayIndex);
        }

        // Copies the values in this Hashtable to an KeyValuePairs array.
        // KeyValuePairs is different from Dictionary Entry in that it has special
        // debugger attributes on its fields.

        internal virtual KeyValuePairs[] ToKeyValuePairsArray()
        {
            KeyValuePairs[] array = new KeyValuePairs[size];
            int index = 0;
            
            foreach (var ent in entries)
            {
				array[index++] = new KeyValuePairs(ent.key, ent.value);
            }

            return array;
        }


        // Copies the values of this hashtable to a given array starting at a given
        // index. This method is used by the implementation of the CopyTo method in
        // the ValueCollection class.
        private void CopyValues(Array array, int arrayIndex)
        {
            foreach (var value in values)
            {
				array.SetValue(value, arrayIndex++);
            }
        }

        // Returns the value associated with the given key. If an entry with the
        // given key is not found, the returned value is null.
        // 
        public virtual Object get(Object key)
        {
			base.get (key);
        }

        public virtual void set(Object key) {
               Insert(key, value, false);
        }

        private void rehash(int newsize, bool forceNewHashCode)
        {
        }

        // Returns an enumerator for this hashtable.
        // If modifications made to the hashtable while an enumeration is
        // in progress, the MoveNext and Current methods of the
        // enumerator will throw an exception.
        //
        IEnumerator IEnumerable.GetEnumerator()
        {
            return new HashtableEnumerator(this, HashtableEnumerator.DictEntry);
        }

        // Returns a dictionary enumerator for this hashtable.
        // If modifications made to the hashtable while an enumeration is
        // in progress, the MoveNext and Current methods of the
        // enumerator will throw an exception.
        //
        public virtual IDictionaryEnumerator GetEnumerator()
        {
            return new HashtableEnumerator(this, HashtableEnumerator.DictEntry);
        }

        // Internal method to get the hash code for an Object.  This will call
        // GetHashCode() on eachObjectif you haven't provided an IHashCodeProvider
        // instance.  Otherwise, it calls hcp.GetHashCode(obj).
        protected virtual int GetHash(Object key)
        {
            if (_keycomparer != null)
                return _keycomparer.GetHashCode(key);
            return key.GetHashCode();
        }

        // Is this Hashtable read-only?
        public virtual bool IsReadOnly
        {
            get { return false; }
        }

        public virtual bool IsFixedSize
        {
            get { return false; }
        }

        // Is this Hashtable synchronized?  See SyncRoot property
        public virtual bool IsSynchronized
        {
            get { return false; }
        }

        // Returns a collection representing the keys of this hashtable. The order
        // in which the returned collection represents the keys is unspecified, but
        // it is guaranteed to be          buckets = newBuckets; the same order in which a collection returned by
        // GetValues represents the values of the hashtable.
        // 
        // The returned collection is live in the sense that any changes
        // to the hash table are reflected in this collection.  It is not
        // a static copy of all the keys in the hash table.
        // 
        public virtual ICollection Keys
        {
            get
            {
                if (_keys == null) _keys = new KeyCollection(this);
                return _keys;
            }
        }

        // Returns a collection representing the values of this hashtable. The
        // order in which the returned collection represents the values is
        // unspecified, but it is guaranteed to be the same order in which a
        // collection returned by GetKeys represents the keys of the
        // hashtable.
        // 
        // The returned collection is live in the sense that any changes
        // to the hash table are reflected in this collection.  It is not
        // a static copy of all the keys in the hash table.
        // 
        public virtual ICollection Values
        {
            get
            {
                if (_values == null) _values = new ValueCollection(this);
                return _values;
            }
        }

        // Inserts an entry into this hashtable. This method is called from the Set
        // and Add methods. If the add parameter is true and the given key already
        // exists in the hashtable, an exception is thrown.
        private void Insert(Object key, Object nvalue, bool add = true)
        {
			set (key, nvalue);
        }

        private void putEntry(bucket[] newBuckets, Object key, Object nvalue, int hashcode)
        {
            Debug.Assert(hashcode >= 0, "hashcode >= 0");  // make sure collision bit (sign bit) wasn't set.

            uint seed = (uint)hashcode;
            uint incr = (uint)(1 + ((seed * HashPrime) % ((uint)newBuckets.Length - 1)));
            int bucketNumber = (int)(seed % (uint)newBuckets.Length);
            do
            {
                if ((newBuckets[bucketNumber].key == null) || (newBuckets[bucketNumber].key == _buckets))
                {
                    newBuckets[bucketNumber].val = nvalue;
                    newBuckets[bucketNumber].key = key;
                    newBuckets[bucketNumber].hash_coll |= hashcode;
                    return;
                }

                if (newBuckets[bucketNumber].hash_coll >= 0)
                {
                    newBuckets[bucketNumber].hash_coll |= unchecked((int)0x80000000);
                    _occupancy++;
                }
                bucketNumber = (int)(((long)bucketNumber + incr) % (uint)newBuckets.Length);
            } while (true);
        }

        // Removes an entry from this hashtable. If an entry with the specified
        // key exists in the hashtable, it is removed. An ArgumentException is
        // thrown if the key is null.
        // 
        public virtual void Remove(Object key)
        {
			remove (key);
        }

        // Returns theObjectto synchronize on for this hash table.
        public virtual Object SyncRoot
        {
            get
            {
                if (_syncRoot == null)
                {
                    System.Threading.Interlocked.CompareExchange<Object>(ref _syncRoot, new Object(), null);
                }
                return _syncRoot;
            }
        }

        // Returns the number of associations in this hashtable.
        // 
        public virtual int Count
        {
            get { return size; }
        }

        // Returns a thread-safe wrapper for a Hashtable.
        //
        public static Hashtable Synchronized(Hashtable table)
        {
            return new SyncHashtable(table);
        }

        // Implements a Collection for the keys of a hashtable. An instance of this
        // class is created by the GetKeys method of a hashtable.
        private class KeyCollection : Gee.Set, ICollection
        {
            private Hashtable _hashtable;

            internal KeyCollection(Hashtable hashtable)
            {
                _hashtable = hashtable;
            }

            public virtual void CopyTo(Array array, int arrayIndex)
            {
                if (array == null)
                    throw ArgumentNullException("array");
                if (array.Rank != 1)
                    throw ArgumentException(SR.Arg_RankMultiDimNotSupported);
                if (arrayIndex < 0)
                    throw ArgumentOutOfRangeException("arrayIndex", SR.ArgumentOutOfRange_NeedNonNegNum);
                Contract.EndContractBlock();
                if (array.Length - arrayIndex < _hashtable._count)
                    throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
                _hashtable.CopyKeys(array, arrayIndex);
            }

            public virtual IEnumerator GetEnumerator()
            {
                return new HashtableEnumerator(_hashtable, HashtableEnumerator.Keys);
            }

            public virtual bool IsSynchronized
            {
                get { return _hashtable.IsSynchronized; }
            }

            public virtual Object SyncRoot
            {
                get { return _hashtable.SyncRoot; }
            }

            public virtual int Count
            {
                get { return _hashtable.size; }
            }
        }

        // Implements a Collection for the values of a hashtable. An instance of
        // this class is created by the GetValues method of a hashtable.
        private class ValueCollection : Gee.Collection, ICollection
        {
            private Hashtable _hashtable;

            internal ValueCollection(Hashtable hashtable)
            {
                _hashtable = hashtable;
            }

            public virtual void CopyTo(Array array, int arrayIndex)
            {
                if (array == null)
                    throw ArgumentNullException("array");
                if (array.Rank != 1)
                    throw ArgumentException(SR.Arg_RankMultiDimNotSupported);
                if (arrayIndex < 0)
                    throw ArgumentOutOfRangeException("arrayIndex", SR.ArgumentOutOfRange_NeedNonNegNum);
                Contract.EndContractBlock();
                if (array.Length - arrayIndex < _hashtable._count)
                    throw ArgumentException(SR.Arg_ArrayPlusOffTooSmall);
                _hashtable.CopyValues(array, arrayIndex);
            }

            public virtual IEnumerator GetEnumerator()
            {
                return new HashtableEnumerator(_hashtable, HashtableEnumerator.Values);
            }

            public virtual bool IsSynchronized
            {
                get { return _hashtable.IsSynchronized; }
            }

            public virtual Object SyncRoot
            {
                get { return _hashtable.SyncRoot; }
            }

            public virtual int Count
            {
                get { return _hashtable._count; }
            }
        }

        // Synchronized wrapper for hashtable
        private class SyncHashtable : Hashtable, IEnumerable
        {
            protected Hashtable _table;

            internal SyncHashtable(Hashtable table){
			base(false);
                _table = table;
            }

            public override int Count
            {
                get { return _table.Count; }
            }

            public override bool IsReadOnly
            {
                get { return _table.IsReadOnly; }
            }

            public override bool IsFixedSize
            {
                get { return _table.IsFixedSize; }
            }

            public override bool IsSynchronized
            {
                get { return true; }
            }

            public override Object get(Object key)
            {
				return _table[key];
             }
             
            public override void set(Object key)
			{
				lock (_table.SyncRoot)
				{
					_table[key] = value;
				}
            }

            public override Object SyncRoot
            {
                get { return _table.SyncRoot; }
            }

            public override void Add(Object key, Object value)
            {
                lock (_table.SyncRoot)
                {
                    _table.Add(key, value);
                }
            }

            public override void Clear()
            {
                lock (_table.SyncRoot)
                {
                    _table.Clear();
                }
            }

            public override bool Contains(Object key)
            {
                return _table.Contains(key);
            }

            public override bool ContainsKey(Object key)
            {
                if (key == null)
                {
                    throw ArgumentNullException("key", SR.ArgumentNull_Key);
                }
                Contract.EndContractBlock();
                return _table.ContainsKey(key);
            }

            public override bool ContainsValue(Object key)
            {
                lock (_table.SyncRoot)
                {
                    return _table.ContainsValue(key);
                }
            }

            public override void CopyTo(Array array, int arrayIndex)
            {
                lock (_table.SyncRoot)
                {
                    _table.CopyTo(array, arrayIndex);
                }
            }

            public override Object Clone()
            {
                lock (_table.SyncRoot)
                {
                    return Hashtable.Synchronized((Hashtable)_table.Clone());
                }
            }

            IEnumerator IEnumerable.GetEnumerator()
            {
                return _table.GetEnumerator();
            }

            public override IDictionaryEnumerator GetEnumerator()
            {
                return _table.GetEnumerator();
            }

            public override ICollection Keys
            {
                get
                {
                    lock (_table.SyncRoot)
                    {
                        return _table.Keys;
                    }
                }
            }

            public override ICollection Values
            {
                get
                {
                    lock (_table.SyncRoot)
                    {
                        return _table.Values;
                    }
                }
            }

            public override void Remove(Object key)
            {
                lock (_table.SyncRoot)
                {
                    _table.Remove(key);
                }
            }

            internal override KeyValuePairs[] ToKeyValuePairsArray()
            {
                return _table.ToKeyValuePairsArray();
            }
        }


        // Implements an enumerator for a hashtable. The enumerator uses the
        // internal version number of the hashtable to ensure that no modifications
        // are made to the hashtable while an enumeration is in progress.
        private class HashtableEnumerator : IDictionaryEnumerator
        {
            private Hashtable _hashtable;
            private int _bucket;
            private int _version;
            private bool _current;
            private int _getObjectRetType;   // What should GetObject return?
            private Object _currentKey;
            private Object _currentValue;

            internal const int Keys = 1;
            internal const int Values = 2;
            internal const int DictEntry = 3;

            internal HashtableEnumerator(Hashtable hashtable, int getObjRetType)
            {
                _hashtable = hashtable;
                _bucket = hashtable._buckets.Length;
                _version = hashtable._version;
                _current = false;
                _getObjectRetType = getObjRetType;
            }

            public virtual Object Key
            {
                get
                {
                    if (_current == false) throw InvalidOperationException(SR.InvalidOperation_EnumNotStarted);
                    return _currentKey;
                }
            }

            public virtual bool MoveNext()
            {
                if (_version != _hashtable._version) throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion);
                while (_bucket > 0)
                {
                    _bucket--;
                    Object keyv = _hashtable._buckets[_bucket].key;
                    if ((keyv != null) && (keyv != _hashtable._buckets))
                    {
                        _currentKey = keyv;
                        _currentValue = _hashtable._buckets[_bucket].val;
                        _current = true;
                        return true;
                    }
                }
                _current = false;
                return false;
            }

            public virtual DictionaryEntry Entry
            {
                get
                {
                    if (_current == false) throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    return new DictionaryEntry(_currentKey, _currentValue);
                }
            }


            public virtual Object Current
            {
                get
                {
                    if (_current == false) throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);

                    if (_getObjectRetType == Keys)
                        return _currentKey;
                    else if (_getObjectRetType == Values)
                        return _currentValue;
                    else
                        return new DictionaryEntry(_currentKey, _currentValue);
                }
            }

            public virtual Object Value
            {
                get
                {
                    if (_current == false) throw InvalidOperationException(SR.InvalidOperation_EnumOpCantHappen);
                    return _currentValue;
                }
            }

            public virtual void Reset()
            {
                if (_version != _hashtable._version) throw InvalidOperationException(SR.InvalidOperation_EnumFailedVersion);
                _current = false;
                _bucket = _hashtable._buckets.Length;
                _currentKey = null;
                _currentValue = null;
            }
        }

        // internal debug view class for hashtable
        internal class HashtableDebugView
        {
            private Hashtable _hashtable;

            public HashtableDebugView(Hashtable hashtable)
            {
                if (hashtable == null)
                {
                    throw ArgumentNullException("hashtable");
                }
                Contract.EndContractBlock();

                _hashtable = hashtable;
            }
// [DebuggerBrowsable(DebuggerBrowsableState.RootHidden)]

            public KeyValuePairs[] Items
            {
                get
                {
                    return _hashtable.ToKeyValuePairsArray();
                }
            }
        }
    }

    internal class HashHelpers
    {
#if FEATURE_RANDOMIZED_STRING_HASHING
        public const int HashCollisionThreshold = 100;
        public static bool s_UseRandomizedstringHashing = string.UseRandomizedHashing();
#endif
        // Table of prime numbers to use as hash table sizes. 
        // A typical resize algorithm would pick the smallest prime number in this array
        // that is larger than twice the previous capacity. 
        // Suppose our Hashtable currently has capacity x and enough elements are added 
        // such that a resize needs to occur. Resizing first computes 2x then finds the 
        // first prime in the table greater than 2x, i.e. if primes are ordered 
        // p_1, p_2, ..., p_i, ..., it finds p_n such that p_n-1 < 2x < p_n. 
        // Doubling is important for preserving the asymptotic complexity of the 
        // hashtable operations such as add.  Having a prime guarantees that double 
        // hashing does not lead to infinite loops.  IE, your hash function will be 
        // h1(key) + i*h2(key), 0 <= i < size.  h2 and the size must be relatively prime.
        public static   int[] primes = {
            3, 7, 11, 17, 23, 29, 37, 47, 59, 71, 89, 107, 131, 163, 197, 239, 293, 353, 431, 521, 631, 761, 919,
            1103, 1327, 1597, 1931, 2333, 2801, 3371, 4049, 4861, 5839, 7013, 8419, 10103, 12143, 14591,
            17519, 21023, 25229, 30293, 36353, 43627, 52361, 62851, 75431, 90523, 108631, 130363, 156437,
            187751, 225307, 270371, 324449, 389357, 467237, 560689, 672827, 807403, 968897, 1162687, 1395263,
            1674319, 2009191, 2411033, 2893249, 3471899, 4166287, 4999559, 5999471, 7199369};

        public static bool IsPrime(int candidate)
        {
            if ((candidate & 1) != 0)
            {
                int limit = (int)Math.Sqrt(candidate);
                for (int divisor = 3; divisor <= limit; divisor += 2)
                {
                    if ((candidate % divisor) == 0)
                        return false;
                }
                return true;
            }
            return (candidate == 2);
        }

        public static int GetPrime(int min)
        {
            if (min < 0)
                throw ArgumentException(SR.Arg_HTCapacityOverflow);
            Contract.EndContractBlock();

            for (int i = 0; i < primes.Length; i++)
            {
                int prime = primes[i];
                if (prime >= min) return prime;
            }

            //outside of our predefined table. 
            //compute the hard way. 
            for (int i = (min | 1); i < int32.MaxValue; i += 2)
            {
                if (IsPrime(i) && ((i - 1) % Hashtable.HashPrime != 0))
                    return i;
            }
            return min;
        }

        // Returns size of hashtable to grow to.
        public static int ExpandPrime(int oldSize)
        {
            int newSize = 2 * oldSize;

            // Allow the hashtables to grow to maximum possible size (~2G elements) before encountering capacity overflow.
            // Note that this check works even when _items.Length overflowed thanks to the (uint) cast
            if ((uint)newSize > MaxPrimeArrayLength && MaxPrimeArrayLength > oldSize)
            {
                Debug.Assert(MaxPrimeArrayLength == GetPrime(MaxPrimeArrayLength), "Invalid MaxPrimeArrayLength");
                return MaxPrimeArrayLength;
            }

            return GetPrime(newSize);
        }


        // This is the maximum prime smaller than Array.MaxArrayLength
        public const int MaxPrimeArrayLength = 0x7FEFFFFD;

#if FEATURE_RANDOMIZED_STRING_HASHING
        public static bool IsWellKnownEqualityComparer(Objectcomparer)
        {
            return (comparer == null || comparer == System.Collections.Generic.EqualityComparer<string>.Default || comparer is IWellKnownstringEqualityComparer);
        }

        public static IEqualityComparer GetRandomizedEqualityComparer(Objectcomparer)
        {
            Debug.Assert(comparer == null || comparer == System.Collections.Generic.EqualityComparer<string>.Default || comparer is IWellKnownstringEqualityComparer);

            if (comparer == null)
            {
                return new System.Collections.Generic.RandomizedObjectEqualityComparer();
            }

            if (comparer == System.Collections.Generic.EqualityComparer<string>.Default)
            {
                return new System.Collections.Generic.RandomizedstringEqualityComparer();
            }

            IWellKnownstringEqualityComparer cmp = comparer as IWellKnownstringEqualityComparer;

            if (cmp != null)
            {
                return cmp.GetRandomizedEqualityComparer();
            }

            Debug.Fail("Missing case in GetRandomizedEqualityComparer!");

            return null;
        }

        public staticObjectGetEqualityComparerForSerialization(Objectcomparer)
        {
            if (comparer == null)
            {
                return null;
            }

            IWellKnownstringEqualityComparer cmp = comparer as IWellKnownstringEqualityComparer;

            if (cmp != null)
            {
                return cmp.GetEqualityComparerForSerialization();
            }

            return comparer;
        }

        private const int bufferSize = 1024;
        private static RandomNumberGenerator rng;
        private static byte[] data;
        private static int currentIndex = bufferSize;
        private staticObjectlockObj = new Object();

        internal static long GetEntropy()
        {
            lock (lockObj)
            {
                long ret;

                if (currentIndex == bufferSize)
                {
                    if (null == rng)
                    {
                        rng = RandomNumberGenerator.Create();
                        data = new byte[bufferSize];
                        Debug.Assert(bufferSize % 8 == 0, "We increment our current index by 8, so our buffer size must be a multiple of 8");
                    }

                    rng.GetBytes(data);
                    currentIndex = 0;
                }

                ret = BitConverter.ToInt64(data, currentIndex);
                currentIndex += 8;

                return ret;
            }
        }
#endif // FEATURE_RANDOMIZED_STRING_HASHING
    }
}
