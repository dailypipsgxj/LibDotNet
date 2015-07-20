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
        public abstract int size { get; }
        //public abstract IEqualityComparer<TKey> Comparer { get; }
        public abstract int Count { get; }
        public abstract bool IsFixedSize { get; }
        public abstract bool IsReadOnly { get; }
        public abstract bool IsSynchronized { get; }
        public abstract ICollection<TKey> Keys { owned get;}
		public abstract GLib.Object SyncRoot { get; }
        public abstract ICollection<TValue> Values { owned get; }

		public abstract new abstract TValue get (TKey key) ;
		public abstract new abstract void set (TKey key, TValue item);
		public abstract GLib.Type get_element_type ();

        public abstract void Add(TKey key, TValue value);
		public abstract void Clear();
        //public new abstract bool Contains(KeyValuePair<TKey, TValue> keyValuePair, IEqualityComparer<KeyValuePair>? comparer = null);
        public new abstract bool Contains(KeyValuePair<TKey, TValue> keyValuePair);
        public abstract bool contains (KeyValuePair<TKey, TValue>keyValuePair);

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
		/*
        public override IEqualityComparer<TKey> Comparer {
            get {
                return _key_equal_func;
            }               
        }
        * */
		/**
		 * The keys' hash function.
		 */

		[CCode (notify = false)]
		internal HashDataFunc<TKey> key_hash_func {
			private set {}
			get {
				return _key_hash_func.GetHashCode;
			}
		}
		/**
		 * The keys' equality testing function.
		 */
		[CCode (notify = false)]
		internal EqualDataFunc<TKey> key_equal_func {
			private set {}
			get {
				return _key_equal_func.Equals;
			}
		}
		/**
		 * The values' equality testing function.
		 */
		[CCode (notify = false)]
		internal EqualDataFunc<TKey> value_equal_func {
			private set {}
			get {
				return _value_equal_func.Equals;
			}
		}

        
        public override int Count {
            get { return _nnodes; }
        }

		public override int size {
			get { return _nnodes; }
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
				ICollection<TKey> keys = _keys;
				if (_keys == null) {
					keys = new KeyCollection<TKey,TValue> (this);
					_keys = keys;
					keys.add_weak_pointer ((void**) (&_keys));
				}
				return keys;
			}
        }
        
        public override GLib.Object SyncRoot { 
            get { 
                return this as GLib.Object; 
            }
        }

        public override ICollection<TValue> Values {
			owned get {
				ICollection<TKey> values = _values;
				if (_values == null) {
					values = new ValueCollection<TKey,TValue> (this);
					_values = values;
					values.add_weak_pointer ((void**) (&_values));
				}
				return values;
			}
        }

		private const int MIN_SIZE = 11;
		private const int MAX_SIZE = 13845163;
		internal int _array_size;
		internal int _nnodes;
		internal Node<TKey,TValue>[] _nodes;
		internal int _stamp = 0;
        private weak ICollection<TKey>  _keys;
        private weak ICollection<TValue>  _values;

		private IEqualityComparer<TKey> _key_hash_func;
		private IEqualityComparer<TKey> _key_equal_func;
		private IEqualityComparer<TKey> _value_equal_func;

		internal GLib.Object _syncRoot;

       
        public Dictionary(IEqualityComparer<TKey>? key_equal_func = null) {
			_key_hash_func = EqualityComparer<TValue>.Default();
			_key_equal_func = (EqualityComparer<TKey>)key_equal_func ?? EqualityComparer<TKey>.Default<TKey>();
			_value_equal_func = EqualityComparer<TValue>.Default();

			_array_size = MIN_SIZE;
			_nodes = new Node<TKey,TValue>[_array_size];
        }

        public Dictionary.WithDictionary(IDictionary<TKey,TValue> dictionary, IEqualityComparer<TKey>? comparer = null) {
			this(comparer);
            
            foreach (var key in dictionary.Keys) {
                Add(key, dictionary[key]);
            }
            
        }
		
        public override TValue? get (TKey key) {
			Node<TKey,TValue>* node = (*lookup_node (key));
			if (node != null) {
				return node->value;
			} else {
				return null;
			}
		}

        public override void set (TKey key, TValue value) {
			Node<TKey,TValue>** node = lookup_node (key);
			if (*node != null) {
				(*node)->value = value;
			} else {
				uint hash_value = key_hash_func (key);
				*node = new Node<TKey,TValue> (key, value, hash_value);
				_nnodes++;
				resize ();
			}
			_stamp++;
        }


        public override void Add(TKey key, TValue value) {
            set(key, value);
        }

		public override void Clear() {
			for (int i = 0; i < _array_size; i++) {
				Node<TKey,TValue> node = (owned) _nodes[i];
				while (node != null) {
					Node next = (owned) node.next;
					node.key = null;
					node.value = null;
					node = (owned) next;
				}
			}
			_nnodes = 0;
			resize ();
		}

        public override bool contains (KeyValuePair<TKey, TValue> keyValuePair) {
			return Contains(keyValuePair);
		}

        public override bool Contains(KeyValuePair<TKey, TValue> keyValuePair) {
			Node<TKey,TValue>** node = lookup_node (keyValuePair.Key);
			return (*node != null && (bool)value_equal_func ((*node)->value, keyValuePair.Value));
        }

        public override bool ContainsKey(TKey key) {
			Node<TKey,TValue>** node = lookup_node (key);
			return (*node != null);
        }

        public override bool ContainsValue(TValue value) {
			Node<TKey,TValue>** node = &_nodes[_nnodes-1];
			while ((*node) != null && (!value_equal_func ((*node)->value, value))) {
				node = &((*node)->next);
			}
			return (*node != null);

        }

        public override void CopyTo(KeyValuePair<TKey,TValue>[] array, int index) {

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


        public override void OnDeserialization(GLib.Object sender) {
			//TODO
		}

        public override bool Remove(TKey key, TValue? value = null) {
			Node<TKey,TValue>** node = lookup_node (key);
			if (*node != null) {
				Node<TKey,TValue> next = (owned) (*node)->next;

				(*node)->key = null;
				(*node)->value = null;
				delete *node;

				*node = (owned) next;

				_nnodes--;
				resize ();
				_stamp++;
				return true;
			}
			return false;
        }
		
        public override bool TryGetValue(TKey key, out TValue value) {
			value = get(key);
			return (value == null) ? false : true; 
        }


		private Node<TKey,TValue>** lookup_node (TKey key) {
			uint hash_value = key_hash_func (key);
			Node<TKey,TValue>** node = &_nodes[hash_value % _array_size];
			while ((*node) != null && (hash_value != (*node)->key_hash || !(bool)key_equal_func ((*node)->key, key))) {
				node = &((*node)->next);
			}
			return node;
		}


		private void resize () {
			if ((_array_size >= 3 * _nnodes && _array_size >= MIN_SIZE) ||
				(3 * _array_size <= _nnodes && _array_size < MAX_SIZE)) {
				int new_array_size = (int) GLib.SpacedPrimes.closest (_nnodes);
				new_array_size = new_array_size.clamp (MIN_SIZE, MAX_SIZE);

				Node<TKey,TValue>[] new_nodes = new Node<TKey,TValue>[new_array_size];

				for (int i = 0; i < _array_size; i++) {
					Node<TKey,TValue> node;
					Node<TKey,TValue> next = null;
					for (node = (owned) _nodes[i]; node != null; node = (owned) next) {
						next = (owned) node.next;
						uint hash_val = node.key_hash % new_array_size;
						node.next = (owned) new_nodes[hash_val];
						new_nodes[hash_val] = (owned) node;
					}
				}
				_nodes = (owned) new_nodes;
				_array_size = new_array_size;
			}
		}

		private inline bool unset_helper (TKey key, out TValue? value = null) {
			Node<TKey,TValue>** node = lookup_node (key);
			if (*node != null) {
				Node<TKey,TValue> next = (owned) (*node)->next;

				value = (owned) (*node)->value;

				(*node)->key = null;
				(*node)->value = null;
				delete *node;

				*node = (owned) next;

				_nnodes--;
				_stamp++;
				return true;
			} else {
				value = null;
			}
			return false;
		}

		~Dictionary () {
			Clear ();
		}

   
		//[Compact]
        private class Enumerator<TKey,TValue>: NodeEnumerator<TKey,TValue>, IEnumerator<KeyValuePair<TKey,TValue>*>, IDictionaryEnumerator<TKey, TValue>
        {
            public Enumerator(Dictionary<TKey,TValue> dictionary) {
                base(dictionary);
            }

            public KeyValuePair<TKey,TValue>* Current {
                owned get {
					GLib.assert (_stamp == _dictionary._stamp);
					GLib.assert (_node != null);
					return new KeyValuePair<TKey,TValue>(_node.key, _node.value);
				}
            }

        
            void Reset() {
				GLib.assert (_stamp == _dictionary._stamp);
				GLib.assert (_node != null);
				has_next ();
				_dictionary.unset_helper (_node.key);
				_node = null;
				_stamp = _dictionary._stamp;
            }

            DictionaryEntry<TKey,TValue> Entry {
                owned get {
                    return new DictionaryEntry<TKey,TValue>(_node.key, _node.value); 
                }
            }
            
            public TKey Key {
                owned get { 
					GLib.assert (_stamp == _dictionary._stamp);
					GLib.assert (_node != null);
					return _node.key;
                }
            }
            
            public TValue Value {
                owned get { 
					GLib.assert (_stamp == _dictionary._stamp);
					GLib.assert (_node != null);
					return _node.value;
                }
            }
        }

        private class KeyCollection<TKey,TValue>: GLib.Object, IEnumerable<TKey>, ICollection<TKey>, IReadOnlyCollection<TKey>
        {
            private Dictionary<TKey,TValue> dictionary;

            public KeyCollection(Dictionary<TKey,TValue> dictionary) {
                this.dictionary = dictionary;
            }

            public IEnumerator<TKey> GetEnumerator() {
                return new Enumerator<TKey, TValue>(dictionary);
            }

			public IEnumerator<TKey> iterator () {
				return GetEnumerator();
			}

            public void CopyTo(TKey[] array, int index) {
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
				GLib.assert_not_reached ();
            }
            
            public void Clear(){
				GLib.assert_not_reached ();
            }

            public bool Contains(TKey key){
                return dictionary.ContainsKey(key);
            }

            public bool contains(TKey key){
                return Contains(key);
            }

            public bool Remove(TKey item){
				GLib.assert_not_reached ();
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
            private class Enumerator<TKey,TValue> : NodeEnumerator<TKey,TValue>, IEnumerator<TKey>
            {
         
                public Enumerator(Dictionary<TKey,TValue> dictionary) {
                    base(dictionary);
                }

                
                public TKey Current {
                    owned get {                        
						GLib.assert (_stamp == _dictionary._stamp);
						GLib.assert (_node != null);
						return _node.key;
                    }
                }
               
               public new TKey get () {
					GLib.assert (_stamp == _dictionary._stamp);
					GLib.assert (_node != null);
					return _node.key;
				}

                void Reset() {
					GLib.assert (_stamp == _dictionary._stamp);
					GLib.assert (_node != null);
					has_next ();
					_dictionary.unset_helper (_node.key);
					_node = null;
					_stamp = _dictionary._stamp;
                }
            }                        
        }

        private class ValueCollection<TKey,TValue>: GLib.Object, IEnumerable<TValue>, ICollection<TValue>
        {
            private Dictionary<TKey,TValue> dictionary;

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
				GLib.assert_not_reached ();
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

            public void Add(TValue item){
				GLib.assert_not_reached ();
            }

            public bool Remove(TValue item){
				GLib.assert_not_reached ();
            }

            public void Clear(){
				GLib.assert_not_reached ();
            }

            public bool Contains(TValue item){
				return contains(item);
            }

            public bool contains(TValue item){
				var it = iterator ();
				while (it.next ()) {
					if ((bool)dictionary.value_equal_func (it.get (), item)) {
						return true;
					}
				}
				return false;
            }

			public GLib.Type get_element_type () {
				return typeof (TValue);
			}


            public bool IsSynchronized {
                get { return false; }
            }

            public GLib.Object SyncRoot { 
                get { return dictionary.SyncRoot; }
            }

			//[Compact]
            private class Enumerator<TKey,TValue> : NodeEnumerator<TKey,TValue>, IEnumerator<TValue>
            {
           
                public Enumerator(Dictionary<TKey, TValue> dictionary) {
                    base(dictionary);
                }

				public new TValue get () {
					GLib.assert (_stamp == _dictionary._stamp);
					GLib.assert (_node != null);
					return _node.value;
				}

                public TValue Current {
                    owned get {                        
						GLib.assert (_stamp == _dictionary._stamp);
						GLib.assert (_node != null);
						return _node.value;
                    }
                }

                void Reset() {

                }
            }
        }
    }

	[Compact]
	internal class Node<TKey,TValue> {
		public TKey key;
		public TValue value;
		public Node<TKey,TValue> next;
		public uint key_hash;

		public Node (owned TKey k, owned TValue v, uint hash) {
			key = (owned) k;
			value = (owned) v;
			key_hash = hash;
		}
	}

	internal abstract class NodeEnumerator<TKey,TValue> : GLib.Object {
		public NodeEnumerator (Dictionary dictionary) {
			_dictionary = dictionary;
			_stamp = _dictionary._stamp;
		}

		public NodeEnumerator.from_iterator (NodeEnumerator<TKey,TValue> iter) {
			_dictionary = iter._dictionary;
			_index = iter._index;
			_node = iter._node;
			_next = iter._next;
			_stamp = iter._stamp;
		}

		public bool MoveNext() {
			return next();
		}


		public bool next () {
			GLib.assert (_stamp == _dictionary._stamp);
			if (!has_next ()) {
				return false;
			}
			_node = _next;
			_next = null;
			return (_node != null);
		}

		public bool has_next () {
			GLib.assert (_stamp == _dictionary._stamp);
			if (_next == null) {
				_next = _node;
				if (_next != null) {
					_next = _next.next;
				}
				while (_next == null && _index + 1 < _dictionary._array_size) {
					_index++;
					_next = _dictionary._nodes[_index];
				}
			}
			return (_next != null);
		}
		
		public virtual bool read_only {
			get {
				return true;
			}
		}
		
		public bool valid {
			get {
				return _node != null;
			}
		}

		protected Dictionary<TKey,TValue> _dictionary;
		protected int _index = -1;
		protected weak Node<TKey,TValue> _node;
		protected weak Node<TKey,TValue> _next;
		protected int _stamp;
	}
}
