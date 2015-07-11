// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
/*============================================================
**
** Class:  Dictionary
** 
** <OWNER>[....]</OWNER>
**
** Purpose: Generic hash table implementation
**
** #DictionaryVersusHashtableThreadSafety
** Hashtable has multiple reader/single writer (MR/SW) thread safety built into 
** certain methods and properties, whereas Dictionary doesn't. If you're 
** converting framework code that formerly used Hashtable to Dictionary, it's
** important to consider whether callers may have taken a dependence on MR/SW
** thread safety. If a reader writer lock is available, then that may be used
** with a Dictionary to get the same thread safety guarantee. 
** 
** Reader writer locks don't exist in silverlight, so we do the following as a
** result of removing non-generic collections from silverlight: 
** 1. If the Hashtable was fully synchronized, then we replace it with a 
**    Dictionary with full locks around reads/writes (same thread safety
**    guarantee).
** 2. Otherwise, the Hashtable has the default MR/SW thread safety behavior, 
**    so we do one of the following on a case-by-case basis:
**    a. If the ---- can be addressed by rearranging the code and using a temp
**       variable (for example, it's only populated immediately after created)
**       then we address the ---- this way and use Dictionary.
**    b. If there's concern about degrading performance with the increased 
**       locking, we ifdef with FEATURE_NONGENERIC_COLLECTIONS so we can at 
**       least use Hashtable in the desktop build, but Dictionary with full 
**       locks in silverlight builds. Note that this is heavier locking than 
**       MR/SW, but this is the only option without rewriting (or adding back)
**       the reader writer lock. 
**    c. If there's no performance concern (e.g. debug-only code) we 
**       consistently replace Hashtable with Dictionary plus full locks to 
**       reduce complexity.
**    d. Most of serialization is dead code in silverlight. Instead of updating
**       those Hashtable occurences in serialization, we carved out references 
**       to serialization such that this code doesn't need to build in 
**       silverlight. 
===========================================================*/
namespace System.Collections.Generic {

    using System;
    using System.Collections;
    using System.Diagnostics;
    using System.Diagnostics.Contracts;
    using System.Runtime.Serialization;
    using System.Security.Permissions;

    public class Dictionary<TKey,TValue>:
		Gee.HashMap<TKey,TValue>,
		IDictionary<TKey,TValue>,
		ICollection<KeyValuePair<TKey, TValue>>,
		IReadOnlyDictionary<TKey, TValue>,
		ISerializable,
		IDeserializationCallback  {
    
        private IEqualityComparer<TKey> comparer;
        private KeyCollection _keys;
        private ValueCollection _values;
        private Object _syncRoot;
        
        public Dictionary(int capacity = 0, IEqualityComparer<TKey>? comparer = null) {
            this.comparer = comparer ?? EqualityComparer<TKey>.Default;
            base (null, comparer.Equals);
        }

        public Dictionary.FromDictionary(IDictionary<TKey,TValue> dictionary, IEqualityComparer<TKey>? comparer = null) {
		
			this(dictionary.Count, comparer);

            foreach (KeyValuePair<TKey,TValue> pair in dictionary) {
                Add(pair.Key, pair.Value);
            }
        }

        public IEqualityComparer<TKey> Comparer {
            get {
                return comparer;      
            }               
        }
        
        public int Count {
            get { return size; }
        }

        public KeyCollection Keys {
            get {
                if (_keys == null) _keys = new KeyCollection(this);
                return _keys;
            }
        }

        public ValueCollection Values {
            get {
                if (_values == null) _values = new ValueCollection(this);
                return _values;
            }
        }


        public TValue get (TKey key) {
			if (has_key(key)) {
				return base.get(key);
			}
			return default(TValue);
		}

        public void set (TKey key) {
            Insert(key, value, false);
        }

        public void Add(TKey key, TValue value) {
            Insert(key, value, true);
        }


        bool Contains(KeyValuePair<TKey, TValue> keyValuePair, IEqualityComparer<KeyValuePair>? comparer = null) {
			
            /*
            int i = FindEntry(keyValuePair.Key);
            if( i >= 0 && EqualityComparer<TValue>.Default.Equals(entries[i].value, keyValuePair.Value)) {
                return true;
            }
            return false;
            */
        }

        bool Remove(TKey key, TValue? value = null) {
			unset(key, value);
        }

        public bool ContainsValue(TValue value) {
            return (value in values);
        }
		
		/*
        public void CopyTo(KeyValuePair<TKey,TValue>[] array, int index) {
            if (array == null) {
                ThrowHelper.ThrowArgumentNullException(ExceptionArgument.array);
            }
            
            if (index < 0 || index > array.Length ) {
                ThrowHelper.ThrowArgumentOutOfRangeException(ExceptionArgument.index, ExceptionResource.ArgumentOutOfRange_NeedNonNegNum);
            }

            if (array.Length - index < Count) {
                ThrowHelper.ThrowArgumentException(ExceptionResource.Arg_ArrayPlusOffTooSmall);
            }

            int count = this.count;
            Entry[] entries = this.entries;
            for (int i = 0; i < count; i++) {
                if (entries[i].hashCode >= 0) {
                    array[index++] = new KeyValuePair<TKey,TValue>(entries[i].key, entries[i].value);
                }
            }
        }
		*/
		
        public Enumerator GetEnumerator() {
            return new Enumerator(this, Enumerator.KeyValuePair);
        }

/*
        public virtual void GetObjectData(SerializationInfo info, StreamingContext context) {
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
        private void Insert(TKey key, TValue value, bool add) {
			base.set (key, value);
        }

        public virtual void OnDeserialization(Object sender) {

        }

        private void Resize(int newSize, bool forceNewHashCodes) {
        }


        // This is a convenience method for the internal callers that were converted from using Hashtable.
        // Many were combining key doesn't exist and key exists but null value (for non-value types) checks.
        // This allows them to continue getting that behavior with minimal code delta. This is basically
        // TryGetValue without the out param
        internal TValue GetValueOrDefault(TKey key) {
            if (has_key(key)) {
                return base.get(key);
            }
            return default(TValue);
        }

        bool IsReadOnly {
            get { return false; }
        }

  
        bool IsSynchronized {
            get { return false; }
        }
        
        Object SyncRoot { 
            get { 
                return _syncRoot; 
            }
        }

        bool IsFixedSize {
            get { return false; }
        }

  
        private static bool IsCompatibleKey(Object key) {
            return (key is TKey); 
        }
  
    
		[Compact]
        public class Enumerator: IEnumerator<KeyValuePair<TKey,TValue>>, IDictionaryEnumerator
        {
            private Dictionary<TKey,TValue> dictionary;
            private Gee.MapIterator _iterator;
            private KeyValuePair<TKey,TValue> current;

            internal Enumerator(Dictionary<TKey,TValue> dictionary, int getEnumeratorRetType) {
                this.dictionary = dictionary;
                index = 0;
                current = new KeyValuePair<TKey, TValue>();
            }

            public bool MoveNext() {
				if (iterator.next()) {
					current = new KeyValuePair<TKey, TValue>(iterator.get_key(), iterator.get_value());
					return true;
				}
				current = new KeyValuePair<TKey, TValue>();
                return false;
            }

            public KeyValuePair<TKey,TValue> Current {
                get { return current; }
            }

            public void Dispose() {
            }
            

            void Reset() {
				iterator.unset();
                current = new KeyValuePair<TKey, TValue>();    
            }

            DictionaryEntry Entry {
                get { 
                    return new DictionaryEntry(iterator.get_key(), iterator.get_value()); 
                }
            }
            
            Object Key {
                get { 
                    return iterator.get_key(); 
                }
            }
            
            Object Value {
                get { 
                    return iterator.get_value(); 
                }
            }
        }

        public class KeyCollection: ICollection<TKey>
        {
            private Dictionary<TKey,TValue> dictionary;

            public KeyCollection(Dictionary<TKey,TValue> dictionary) {
                this.dictionary = dictionary;
            }

            public Enumerator GetEnumerator() {
                return new Enumerator(dictionary);
            }

            public void CopyTo(TKey[] array, int index) {
                foreach (var entry in dictionary.entries) {
                    array[index++] = entry.key;
                }
            }

            public int Count {
                get { return dictionary.Count; }
            }

            bool IsReadOnly {
                get { return true; }
            }

            void Add(TKey item){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_KeyCollectionSet);
            }
            
            void Clear(){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_KeyCollectionSet);
            }

            bool Contains(TKey item){
                return dictionary.ContainsKey(item);
            }

            bool Remove(TKey item){
                //ThrowHelper.ThrowNotSupportedException(ExceptionResource.NotSupported_KeyCollectionSet);
                return false;
            }
            
            bool IsSynchronized {
                get { return false; }
            }

            Object SyncRoot { 
                get { return ((ICollection)dictionary).SyncRoot; }
            }

			[Compact]
            public class Enumerator : IEnumerator<TKey>, System.Collections.IEnumerator
            {
                private Dictionary<TKey, TValue> dictionary;
                private int index;
                private TKey currentKey;
            
                internal Enumerator(Dictionary<TKey, TValue> dictionary) {
                    this.dictionary = dictionary;
                    index = 0;
                    currentKey = default(TKey);                    
                }

                public void Dispose() {
                }

                public bool MoveNext() {
                    if (index < dictionary.Count) {
						currentKey = dictionary.entries[index].key;
                        index++;
                        return true;
                    }
                    currentKey = default(TKey);
                    return false;
                }
                
                public TKey Current {
                    get {                        
                        return currentKey;
                    }
                }

               
                void Reset() {
                    index = 0;                    
                    currentKey = default(TKey);
                }
            }                        
        }

        public class ValueCollection: ICollection<TValue>, ICollection
        {
            private Dictionary<TKey,TValue> dictionary;

            public ValueCollection(Dictionary<TKey,TValue> dictionary) {
                this.dictionary = dictionary;
            }

            public Enumerator GetEnumerator() {
                return new Enumerator(dictionary);                
            }

            public void CopyTo(TValue[] array, int index) {
                foreach (var entry in dictionary.entries) {
                    array[index++] = entry.value;
                }
            }

            public int Count {
                get { return dictionary.Count; }
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


            bool IsSynchronized {
                get { return false; }
            }

            Object SyncRoot { 
                get { return ((ICollection)dictionary).SyncRoot; }
            }

			[Compact]
            public class Enumerator : IEnumerator<TValue>, System.Collections.IEnumerator
            {
                private Dictionary<TKey, TValue> dictionary;
                private int index;
                private int version;
                private TValue currentValue;
            
                internal Enumerator(Dictionary<TKey, TValue> dictionary) {
                    this.dictionary = dictionary;
                    version = dictionary.version;
                    index = 0;
                    currentValue = default(TValue);
                }

                public void Dispose() {
                }

                public bool MoveNext() {                    
                    if (index < dictionary.Count) {
						currentValue = dictionary.entries[index].value;
                        index++;
                        return true;
                    }
                    currentValue = default(TValue);
                    return false;
                }
                
                public TValue Current {
                    get {                        
                        return currentValue;
                    }
                }

                void Reset() {
                    index = 0;                    
                    currentValue = default(TValue);
                }
            }
        }
    }
}
