// ==++==
// 
//   Copyright (c) Microsoft Corporation.  All rights reserved.
// 
// ==--==
// 

namespace System.Collections.ObjectModel
{
    using System;
    using System.Collections;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Runtime;
    
    public class ReadOnlyCollection<T>: GLib.Object, IEnumerable<T>, IList<T>, IReadOnlyCollection<T>, IReadOnlyList<T>
    {
        IList<T> list;
        private GLib.Object _syncRoot;

        public ReadOnlyCollection(IList<T> list) {
            this.list = list;
        }

        public int Count {
            get { return ((ICollection)list).Count; }
        }

        public int size {
            get { return ((ICollection)list).size; }
        }

        public new T? get (int index) {
            return list[index];
        }

        public new void set (int index, T value) { 
			throw new NotSupportedException.READONLYCOLLECTION("ExceptionResource.NotSupported_ReadOnlyCollection");
        }

        public bool Contains(T value) {
            return ((ICollection<T>)list).Contains(value);
        }

        public void CopyTo(T[] array, int index) {
            ((ICollection<T>)list).CopyTo(array, index);
        }

        public IEnumerator<T> GetEnumerator() {
            return ((IEnumerable<T>)list).GetEnumerator();
        }

        public IEnumerator<T> iterator() {
            return ((IEnumerable<T>)list).GetEnumerator();
        }

        public int IndexOf(T value, int index = 0) {
            return list.IndexOf(value);
        }

        protected IList<T> Items { 
            get {
                return list;
            }
        }

        public bool IsReadOnly {
            get { return true; }
        }
        
		public GLib.Type get_element_type () {
			return typeof (T);
		}

        public void Add(T value) {
            throw new NotSupportedException.READONLYCOLLECTION("ExceptionResource.NotSupported_ReadOnlyCollection");
        }
        
        public void Clear() {
            throw new NotSupportedException.READONLYCOLLECTION("ExceptionResource.NotSupported_ReadOnlyCollection");
        }

        public void Insert(int index, T value) {
            throw new NotSupportedException.READONLYCOLLECTION("ExceptionResource.NotSupported_ReadOnlyCollection");
        }

        public bool Remove(T value) {
            throw new NotSupportedException.READONLYCOLLECTION("ExceptionResource.NotSupported_ReadOnlyCollection");
            return false;
        }

        public void RemoveAt(int index) {
            throw new NotSupportedException.READONLYCOLLECTION("ExceptionResource.NotSupported_ReadOnlyCollection");
        }

        public bool IsSynchronized {
            get { return false; }
        }
        
        /*
         * GLib.Object SyncRoot { 
            get { 
                if( _syncRoot == null) {
                    ICollection c = list as ICollection;
                    if( c != null) {
                        _syncRoot = c.SyncRoot;
                    }
                }
                return _syncRoot;                
            }
        }*/


        public bool IsFixedSize {
            get { return true; }
        }

    }
}
