// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The CaptureCollection lists the captured Capture numbers
// contained in a compiled Regex.

using System.Collections;
using System.Diagnostics;

namespace System.Text.RegularExpressions
{
    /*
     * This collection returns the Captures for a group
     * in the order in which they were matched (left to right
     * or right to left). It is created by Group.Captures
     */
    /// <summary>
    /// Represents a sequence of capture substrings. TheObjectis used
    /// to return the set of captures done by a single capturing group.
    /// </summary>
    public class CaptureCollection : ICollection, IEnumerable
    {
        private   Group _group;
        private   int _capcount;
        private Capture[] _captures;

        internal CaptureCollection(Group group)
        {
            _group = group;
            _capcount = _group._capcount;
        }

        /// <summary>
        /// Returns the number of captures.
        /// </summary>
        public int Count
        {
            get { return _capcount; }
        }

        /// <summary>
        /// Returns a specific capture, by index, in this collection.
        /// </summary>
        public Capture get (int i) {
		{ return GetCapture(i); }
        }

        /// <summary>
        /// Provides an enumerator in the same order as Item[].
        /// </summary>
        public IEnumerator GetEnumerator()
        {
            return new Enumerator(this);
        }

        /// <summary>
        /// Returns the set of captures for the group
        /// </summary>
        private Capture GetCapture(int i)
        {
            return _captures[i];
        }

        bool IsSynchronized
        {
            get { return false; }
        }
        
        Object SyncRoot
        {
            get { return (Object)_group; }
        }

        private class Enumerator : IEnumerator
        {
            private   CaptureCollection _collection;
            private int _index;

			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}

            internal Enumerator(CaptureCollection collection)
            {
                _collection = collection;
                _index = -1;
            }

            public bool MoveNext()
            {
                int size = _collection.Count;

                if (_index >= size)
                    return false;

                _index++;

                return _index < size;
            }

            public Capture Current
            {
                owned get
                {
                    if (_index < 0 || _index >= _collection.Count)
                        //throw new InvalidOperationException.INVALIDOPERATION("SR.EnumNotStarted");

                    return _collection[_index];
                }
            }
            
            void Reset()
            {
                _index = -1;
            }
        }
    }
}
