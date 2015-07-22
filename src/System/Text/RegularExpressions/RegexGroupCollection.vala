// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The GroupCollection lists the captured Capture numbers
// contained in a compiled Regex.

//using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents a sequence of capture substrings. TheObjectis used
    /// to return the set of captures done by a single capturing group.
    /// </summary>
    public class GroupCollection : ICollection<Group>, IEnumerable<Group> 
    {
        private Match _match;

        // cache of Group objects fed to the user
        private Group[] _groups;

        public GroupCollection(Match match)
        {
            _match = match;
        }

        /// <summary>
        /// Returns the number of groups.
        /// </summary>
        public int size
        {
            get { return Count; }
        }

        public int Count
        {
            get { return _match._matchinfo.get_match_count(); }
        }

        public new Group get(int groupnum)
        {
            return GetGroup(groupnum);
        }

		/*
        public Group get (string groupname) {
		{
                if (_match._regex == null)
                    return Group._emptygroup;

                return GetGroup(_match._regex.GroupNumberFromName(groupname));
            }
        }
        */

        /// <summary>
        /// Provides an enumerator in the same order as Item[].
        /// </summary>
        public IEnumerator<Group> GetEnumerator()
        {
            return new Enumerator(this);
        }

        public IEnumerator<Group> iterator()
        {
            return GetEnumerator();
        }

        private Group GetGroup(int groupnum)
        {

            return new Group();
        }

        /// <summary>
        /// Caches the group objects
        /// </summary>
        private Group GetGroupImpl(int groupnum)
        {
            return _groups[groupnum - 1];
        }

        bool IsSynchronized
        {
            get { return false; }
        }
        
        public Object SyncRoot
        {
            get { return _match as Object; }
        }

        public void CopyTo(Object[] array, int arrayIndex) {
			
		}

        private class Enumerator<Group> : IEnumerator<Group>
        {
            private GroupCollection _collection;
            private int _index;
			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}

            public Enumerator(GroupCollection collection)
            {
                _collection = collection;
                _index = -1;
            }

			public new Group get() {
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

            public bool next() {
				return MoveNext();
            }

            new Object Current
            {
                owned get
                {
                    return _currentElement;
                }
            }
            
            void Reset()
            {
                _index = -1;
            }
        }
    }
}
