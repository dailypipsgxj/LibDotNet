// ==++==
// 
//   API Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Class:  Dictionary
** 
** Purpose: Generic hash table implementation
**
===========================================================*/

namespace System.Collections.Generic {

    using System;
    //using System.Collections;
    using System.Diagnostics;
    using System.Diagnostics.Contracts;
    using System.Runtime.Serialization;
    using System.Security.Permissions;


	public abstract class AbstractDictionary<TKey,TValue> : 
		GLib.Object,
		IEnumerable<KeyValuePair<TKey, TValue>>,
		IDictionary<TKey,TValue>,
		ICollection<KeyValuePair<TKey, TValue>>,
		IReadOnlyCollection<KeyValuePair<TKey, TValue>>,
		IReadOnlyDictionary<TKey, TValue>
	{

        //public abstract IEqualityComparer<TKey> Comparer { get; }
        public abstract int Count { get; }
        public abstract bool IsFixedSize { get; }
        public abstract bool IsReadOnly { get; }
        public abstract bool IsSynchronized { get; }
        public abstract ICollection<TKey> Keys { owned get; private set;}
        public abstract int size { get; }
		public abstract GLib.Object SyncRoot { get; }
        public abstract ICollection<TValue> Values { owned get; }

		public abstract new abstract TValue get (TKey key) ;
		public abstract new abstract void set (TKey key, TValue item);
		public abstract GLib.Type get_element_type ();

        public abstract void Add(TKey key, TValue value);
		public abstract void Clear();
        public new abstract bool Contains(KeyValuePair<TKey, TValue> keyValuePair, IEqualityComparer<KeyValuePair>? comparer = null);
        public abstract bool contains (KeyValuePair<TKey, TValue> item);

		public abstract bool ContainsKey(TKey key);
        public abstract bool ContainsValue(TValue value);
        public abstract void CopyTo(KeyValuePair<TKey,TValue>[] array, int index = 0);
		public abstract IEnumerator<KeyValuePair<TKey, TValue>> iterator ();
		public abstract IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator();
        //public abstract void GetObjectData(SerializationInfo info, StreamingContext context);
		public abstract void OnDeserialization(GLib.Object sender);
		public new abstract bool Remove(TKey key, TValue? value = null);
		public abstract bool TryGetValue(TKey key, out TValue value);
	}

    public class Dictionary<TKey,TValue>: AbstractDictionary<TKey,TValue>
	{

        private struct Entry<TKey,TValue> {
            public int hashCode;    // Lower 31 bits of hash code, -1 if unused
            public int next;        // Index of next entry, -1 if last
            public TKey key;           // Key of entry
            public TValue value;         // Value of entry
        }

        internal int[] buckets;
        private Entry<TKey,TValue>[] entries;
        internal int count;
        internal int version;
        internal int freeList;
        internal int freeCount;
        internal GLib.Object _syncRoot;
        
		private EqualityComparer<TKey> comparer;
        private KeyCollection<TKey>  _keys;
        private ValueCollection<TValue, TValue>  _values;
        
        public Dictionary(IEqualityComparer<TKey>? comparer = null) {
            //this.comparer = comparer ?? EqualityComparer<TKey>.Default();
        }

        public Dictionary.WithDictionary(IDictionary<TKey,TValue> dictionary, IEqualityComparer<TKey>? comparer = null) {
			this(comparer);
            
            foreach (var key in dictionary.Keys) {
                Add(key, dictionary[key]);
            }
            
        }
		
		/*
        public override IEqualityComparer<TKey> Comparer {
            get {
                return comparer;      
            }               
        }
        */
        
        public override int Count {
            get { return count; }
        }

		public override int size {
			get { return count; }
		}

        public override bool IsFixedSize {
            get { return false; }
        }

        public override bool IsReadOnly {
            get { return false; }
        }

        public override bool IsSynchronized {
            get { return false; }
        }

        public override ICollection<TKey> Keys {
            owned get {
                if (_keys == null) _keys = new KeyCollection<TKey> (this);
                return _keys;
            }
            private set {
				;
			}
        }
        

        public override GLib.Object SyncRoot { 
            get { 
                return _syncRoot; 
            }
        }

        public override ICollection<TValue> Values {
            owned get {
                if (_values == null) _values = new ValueCollection<TKey,TValue> (this);
                return _values;
            }
        }

        public override TValue? get (TKey key) {
			int i = FindEntry(key);
			if (i >= 0) return entries[i].value;
			return null;
		}

        public override void set (TKey key, TValue value) {
            Insert(key, value, true);
        }


        public override void Add(TKey key, TValue value) {
            Insert(key, value, true);
        }

		public override void Clear() {
            if (count > 0) {
                for (int i = 0; i < buckets.length; i++) buckets[i] = -1;

                //Array.Clear(entries, 0, count);

                freeList = -1;
                count = 0;
                freeCount = 0;
                version++;
            }
		}

        public override bool contains (KeyValuePair<TKey, TValue> item) {
			return Contains(item);
		}

        public override bool Contains(KeyValuePair<TKey, TValue> keyValuePair, IEqualityComparer<KeyValuePair>? comparer = null) {
            int i = FindEntry(keyValuePair.Key);
            if( i >= 0 && EqualityComparer<TValue>.Default<TValue>().Equals(entries[i].value, keyValuePair.Value)) {
                return true;
            }
            return false;
        }

        public override bool ContainsKey(TKey key) {
            return FindEntry(key) >= 0;
        }

        public override bool ContainsValue(TValue value) {
            if (value == null) {
                for (int i = 0; i < count; i++) {
                    if (entries[i].hashCode >= 0 && entries[i].value == null) return true;
                }
            }
            else {
                EqualityComparer<TValue> c = EqualityComparer<TValue>.Default();
                for (int i = 0; i < count; i++) {
                    if (entries[i].hashCode >= 0 && c.Equals(entries[i].value, value)) return true;
                }
            }
            return false;
        }

        public override void CopyTo(KeyValuePair<TKey,TValue>[] array, int index) {
            if (index < 0 || index > array.length ) {
                //ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.index, ExceptionResource.ArgumentOutOfRange_NeedNonNegNum);
            }

            if (array.length - index < Count) {
                //ThrowHelper.ThrowArgumentException(ExceptionResource.Arg_ArrayPlusOffTooSmall);
            }

            int count = this.count;
            Entry<TKey,TValue>[] entries = this.entries;
            for (int i = 0; i < count; i++) {
                if (entries[i].hashCode >= 0) {
                    array[index++] = new KeyValuePair<TKey,TValue>(entries[i].key, entries[i].value);
                }
            }
        }

		public override GLib.Type get_element_type () {
			return typeof (TValue);
		}

		public override IEnumerator<KeyValuePair<TKey, TValue>> iterator () {
			return GetEnumerator();
		}

        public override IEnumerator<KeyValuePair<TKey, TValue>> GetEnumerator() {
            return new Enumerator<TKey, TValue>(this);
        }


/*
        public override virtual void GetObjectData(SerializationInfo info, StreamingContext context) {
            if (info==null) {
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.info);
            }
            info.AddValue(VersionName, version);

            info.AddValue(ComparerName, comparer, typeof(IEqualityComparer<TKey>));

            info.AddValue(HashSizeName, buckets == null ? 0 : buckets.Length); //This is the length of the bucket array.
            if( buckets != null) {
                KeyValuePair<TKey, TValue>[] array = new KeyValuePair<TKey, TValue>[Count];
                CopyTo(array, 0);
                info.AddValue(KeyValuePairsName, array, typeof(KeyValuePair<TKey, TValue>[]));
            }
        }
*/

        public override void OnDeserialization(GLib.Object sender) {
			//TODO
		}


        public override bool Remove(TKey key, TValue? value = null) {
            if (buckets != null) {
                int hashCode = (int)comparer.GetHashCode(key);// & 0x7FFFFFFF;
                int bucket = hashCode % buckets.length;
                int last = -1;
                for (int i = buckets[bucket]; i >= 0; last = i, i = entries[i].next) {
                    if (entries[i].hashCode == hashCode && comparer.Equals(entries[i].key, key)) {
                        if (last < 0) {
                            buckets[bucket] = entries[i].next;
                        }
                        else {
                            entries[last].next = entries[i].next;
                        }
                        entries[i].hashCode = -1;
                        entries[i].next = freeList;
                        entries[i].key = null;// default(TKey);
                        entries[i].value = null;//default(TValue);
                        freeList = i;
                        freeCount++;
                        version++;
                        return true;
                    }
                }
            }
            return false;
        }
		
        public override bool TryGetValue(TKey key, out TValue value) {
            int i = FindEntry(key);
            if (i >= 0) {
                value = entries[i].value;
                return true;
            }
            value = null; //default(TValue);
            return false;
        }


        private int FindEntry(TKey key) {
            if (buckets != null) {
                int hashCode = (int)comparer.GetHashCode(key); // & 0x7FFFFFFF;
                for (int i = buckets[hashCode % buckets.length]; i >= 0; i = entries[i].next) {
                    if (entries[i].hashCode == hashCode && comparer.Equals(entries[i].key, key)) return i;
                }
            }
            return -1;
        }


        private void Initialize(int capacity) {
            int size = HashHelpers.GetPrime(capacity);
            buckets = new int[size];
            for (int i = 0; i < buckets.length; i++) buckets[i] = -1;
            entries = new Entry[size];
            freeList = -1;
        }

        private void Insert(TKey key, TValue? value = null, bool add) {
            if (buckets == null) Initialize(0);
            int hashCode = comparer.GetHashCode(key) & 0x7FFFFFFF;
            int targetBucket = hashCode % buckets.Length;

            for (int i = buckets[targetBucket]; i >= 0; i = entries[i].next) {
                if (entries[i].hashCode == hashCode && comparer.Equals(entries[i].key, key)) {
                    if (add) { 
                        //ThrowHelper.ThrowArgumentException(ExceptionResource.Argument_AddingDuplicate);
                    }
                    entries[i].value = value;
                    version++;
                    return;
                } 

            }
            int index;
            if (freeCount > 0) {
                index = freeList;
                freeList = entries[index].next;
                freeCount--;
            }
            else {
                if (count == entries.length)
                {
                    Resize();
                    targetBucket = hashCode % buckets.Length;
                }
                index = count;
                count++;
            }

            entries[index].hashCode = hashCode;
            entries[index].next = buckets[targetBucket];
            entries[index].key = key;
            entries[index].value = value;
            buckets[targetBucket] = index;
            version++;
        }


        private void Resize(int newSize, bool forceNewHashCodes) {
            int[] newBuckets = new int[newSize];
            for (int i = 0; i < newBuckets.length; i++) newBuckets[i] = -1;
            Entry[] newEntries = new Entry[newSize];

            Array.Copy(entries, 0, newEntries, 0, count);

            if(forceNewHashCodes) {
                for (int i = 0; i < count; i++) {
                    if(newEntries[i].hashCode != -1) {
                        newEntries[i].hashCode = (comparer.GetHashCode(newEntries[i].key) & 0x7FFFFFFF);
                    }
                }
            }
            for (int i = 0; i < count; i++) {
                if (newEntries[i].hashCode >= 0) {
                    int bucket = newEntries[i].hashCode % newSize;
                    newEntries[i].next = newBuckets[bucket];
                    newBuckets[bucket] = i;
                }
            }
            buckets = newBuckets;
            entries = newEntries;
        }


        // This is a convenience method for the internal callers that were converted from using Hashtable.
        // Many were combining key doesn't exist and key exists but null value (for non-value types) checks.
        // This allows them to continue getting that behavior with minimal code delta. This is basically
        // TryGetValue without the out param
        internal TValue GetValueOrDefault(TKey key) {
            return null; // default(TValue);
        }

  
   
		//[Compact]
        private class Enumerator<TKey,TValue>: GLib.Object, IEnumerator<KeyValuePair<TKey,TValue>>, IDictionaryEnumerator<TKey, TValue>
        {
            private int version;
            private int index;
            private Dictionary<TKey,TValue> dictionary;
            private KeyValuePair<TKey,TValue> current;

            public Enumerator(Dictionary<TKey,TValue> dictionary) {
                this.dictionary = dictionary;
                version = dictionary.version;
                index = 0;
                current = null; // new KeyValuePair<TKey, TValue>();
            }

            public bool MoveNext() {
                if (version != dictionary.version) {
                    //ThrowHelper.ThrowInvalidOperationException(ExceptionResource.InvalidOperation_EnumFailedVersion);
                }

                // Use unsigned comparison since we set index to dictionary.count+1 when the enumeration ends.
                // dictionary.count+1 could be negative if dictionary.count is int32.MaxValue
                while ((uint)index < (uint)dictionary.count) {
                    if (dictionary.entries[index].hashCode >= 0) {
                        current = new KeyValuePair<TKey, TValue>(dictionary.entries[index].key, dictionary.entries[index].value);
                        index++;
                        return true;
                    }
                    index++;
                }

                index = dictionary.count + 1;
                current = null; //new KeyValuePair<TKey, TValue>();
                return false;
            }

            public KeyValuePair<TKey,TValue> Current {
                owned get { return current; }
            }

            public void Dispose() {
            }
            

            void Reset() {
                if (version != dictionary.version) {
                    //ThrowHelper.ThrowInvalidOperationException(ExceptionResource.InvalidOperation_EnumFailedVersion);
                }
                index = 0;
                current = null; //new KeyValuePair<TKey, TValue>();    
            }

            DictionaryEntry<TKey,TValue> Entry {
                owned get {
                    return new DictionaryEntry<TKey,TValue>(current.Key, current.Value); 
                }
            }
            
            public TKey Key {
                owned get { 
                    return current.Key; 
                }
            }
            
            public TValue Value {
                owned get { 
                    return current.Value; 
                }
            }
        }

        public class KeyCollection<TKey>: GLib.Object, IEnumerable<TKey>, ICollection<TKey>, IReadOnlyCollection<TKey>
        {
            private Dictionary dictionary;

            public KeyCollection(Dictionary dictionary) {
                this.dictionary = dictionary;
            }

            public IEnumerator<TKey> GetEnumerator() {
                return new Enumerator<TKey>(dictionary);
            }

			public IEnumerator<TKey> iterator () {
				return GetEnumerator();
			}

            public void CopyTo(TKey[] array, int index) {
                int count = dictionary.count;
                var entries = dictionary.entries;
                for (int i = 0; i < count; i++) {
                    if (entries[i].hashCode >= 0) array[index++] = entries[i].key;
                }
            }

            public int Count {
                get { return dictionary.Count; }
            }

            public int size {
                get { return dictionary.size; }
            }

            public bool IsReadOnly {
                get { return true; }
            }

            public void Add(TKey item){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_KeyCollectionSet);
            }
            
            public void Clear(){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_KeyCollectionSet);
            }

            public bool Contains(TKey item){
                //var contains = dictionary.ContainsKey(item);
                return false;
            }

            public bool contains(TKey item){
                return Contains(item);
            }

            public bool Remove(TKey item){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_KeyCollectionSet);
                return false;
            }
            
            public bool IsSynchronized {
                get { return false; }
            }

            public GLib.Object SyncRoot { 
                get { return dictionary.SyncRoot; }
            }
            
			public GLib.Type get_element_type () {
				return typeof (TKey);
			}


			//[Compact]
            public class Enumerator<TKey> : GLib.Object, IEnumerator<TKey>
            {
                private Dictionary dictionary;
                private int index;
                private int version;
                private TKey currentKey;
            
                public Enumerator(Dictionary dictionary) {
                    this.dictionary = dictionary;
                    version = dictionary.version;
                    index = 0;
                    currentKey = null; //default(TKey);                    
                }

                public void Dispose() {
                }

                public bool MoveNext() {
                    if (version != dictionary.version) {
                        //ThrowHelper.ThrowInvalidOperationException(ExceptionResource.InvalidOperation_EnumFailedVersion);
                    }

                    while ((uint)index < (uint)dictionary.count) {
                        if (dictionary.entries[index].hashCode >= 0) {
                            currentKey = dictionary.entries[index].key;
                            index++;
                            return true;
                        }
                        index++;
                    }

                    index = dictionary.count + 1;
                    currentKey = null; //default(TKey);
                    return false;
                }
                
                public TKey? Current {
                    owned get {                        
                        return currentKey;
                    }
                }

               
                void Reset() {
                    index = 0;                    
                    currentKey = null; //default(TKey);
                }
            }                        
        }

        public class ValueCollection<TKey,TValue>: GLib.Object, IEnumerable<TKey>, ICollection<TValue>
        {
            public Dictionary<TKey,TValue> dictionary;

            public ValueCollection(Dictionary<TKey,TValue> dictionary) {
                this.dictionary = dictionary;
            }

            public IEnumerator<TValue> GetEnumerator() {
                return new Enumerator<TKey,TValue>(dictionary);                
            }

            public IEnumerator<TValue> iterator() {
                return GetEnumerator();                
            }

            public void CopyTo(TValue[] array, int index) {
                int count = dictionary.count;
                Entry<TKey,TValue>[] entries = dictionary.entries;
                for (int i = 0; i < count; i++) {
                    if (entries[i].hashCode >= 0) array[index++] = entries[i].value;
                }
            }

            public int Count {
                get { return dictionary.Count; }
            }

            public int size {
                get { return dictionary.size; }
            }


            bool IsReadOnly {
                get { return true; }
            }

            void Add(TValue item){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_ValueCollectionSet);
            }

            bool Remove(TValue item){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_ValueCollectionSet);
                return false;
            }

            void Clear(){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_ValueCollectionSet);
            }

            bool Contains(TValue item){
                return dictionary.ContainsValue(item);
            }

            bool contains(TValue item){
                return dictionary.ContainsValue(item);
            }

			public GLib.Type get_element_type () {
				return typeof (TValue);
			}


            bool IsSynchronized {
                get { return false; }
            }

            GLib.Object SyncRoot { 
                get { return dictionary.SyncRoot; }
            }

			//[Compact]
            public class Enumerator<TKey,TValue> : GLib.Object, IEnumerator<TValue>
            {
                public Dictionary<TKey, TValue> dictionary;
                private int index;
                private int version;
                private TValue currentValue;
            
                public Enumerator(Dictionary<TKey, TValue> dictionary) {
                    this.dictionary = dictionary;
                    version = dictionary.version;
                    index = 0;
                    currentValue = null; //default(TValue);
                }

                public void Dispose() {
                }

                public bool MoveNext() {
                    if (version != dictionary.version) {
                        //ThrowHelper.ThrowInvalidOperationException(ExceptionResource.InvalidOperation_EnumFailedVersion);
                    }
                    
                    while ((uint)index < (uint)dictionary.count) {
                        if (dictionary.entries[index].hashCode >= 0) {
                            currentValue = dictionary.entries[index].value;
                            index++;
                            return true;
                        }
                        index++;
                    }
                    index = dictionary.count + 1;
                    currentValue = null; //default(TValue);
                    return false;
                }
                
                public TValue Current {
                    owned get {                        
                        return currentValue;
                    }
                }

                void Reset() {
                    index = 0;
					currentValue = null; //default(TValue);
                }
            }
        }
    }
}
