// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The CaptureCollection lists the captured Capture numbers
// contained in a compiled Regex.

using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

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
    public class CaptureCollection : Enumerable<Capture>, ICollection<Capture>, IEnumerable<Capture>
    {
        private Group _group;
        private int _capcount;
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

        public int size
        {
            get { return _capcount; }
        }
		

        /// <summary>
        /// Returns a specific capture, by index, in this collection.
        /// </summary>
        public new Capture get (int i) {
		{ 
			return GetCapture(i); }
        }

        /// <summary>
        /// Provides an enumerator in the same order as Item[].
        /// </summary>
        public IEnumerator<Capture> GetEnumerator()
        {
            return new Enumerator<Capture>(this);
        }

        /// <summary>
        /// Returns the set of captures for the group
        /// </summary>
        private Capture GetCapture(int i)
        {
            return _captures[i];
        }

		public IEnumerator<Capture> iterator() {
			return GetEnumerator();
		}

        bool IsSynchronized
        {
            get { return false; }
        }
        
        public Object SyncRoot
        {
            get { return (Object)_group; }
        }

        public void CopyTo(Capture[] array, int arrayIndex) {
			
		}

        private class Enumerator<Capture> : Enumerable<Capture>, IEnumerator<Capture>
        {
            private   CaptureCollection _collection;
            private int _index;


            internal Enumerator(CaptureCollection collection)
            {
                _collection = collection;
                _index = -1;
            }

			public bool next () {
				return MoveNext();
			}

			
			public new Capture get () {
				return Current;
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
                    return _collection.get(_index);
                }
            }
            
            void Reset()
            {
                _index = -1;
            }
        }
    }
}
