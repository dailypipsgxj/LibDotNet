// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The GroupCollection lists the captured Capture numbers
// contained in a compiled Regex.

using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents a sequence of capture substrings. TheObjectis used
    /// to return the set of captures done by a single capturing group.
    /// </summary>
    public class GroupCollection : System.Collections.ICollection
    {
        private Match _match;
        private Dictionary<int, int> _captureMap;

        // cache of Group objects fed to the user
        private Group[] _groups;

        public GroupCollection(Match match, Dictionary<int, int> caps)
        {
            _match = match;
            _captureMap = caps;
        }

        /// <summary>
        /// Returns the number of groups.
        /// </summary>
        public int Count
        {
            get { return _match._matchcount.Length; }
        }

        public Group get(int groupnum)
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
        public System.Collections.IEnumerator GetEnumerator()
        {
            return new Enumerator(this);
        }

        private Group GetGroup(int groupnum)
        {
            if (_captureMap != null)
            {
                int groupNumImpl;
                if (_captureMap.TryGetValue(groupnum, out groupNumImpl))
                {
                    return GetGroupImpl(groupNumImpl);
                }
            }
            else if (groupnum < _match._matchcount.Length && groupnum >= 0)
            {
                return GetGroupImpl(groupnum);
            }

            return Group._emptygroup;
        }

        /// <summary>
        /// Caches the group objects
        /// </summary>
        private Group GetGroupImpl(int groupnum)
        {
            if (groupnum == 0)
                return _match;

            // Construct all the Group objects the first time GetGroup is called

            if (_groups == null)
            {
                _groups = new Group[_match._matchcount.Length - 1];
                for (int i = 0; i < _groups.Length; i++)
                {
                    _groups[i] = new Group(_match._text, _match._matches[i + 1], _match._matchcount[i + 1]);
                }
            }

            return _groups[groupnum - 1];
        }

        bool IsSynchronized
        {
            get { return false; }
        }
        
        Object SyncRoot
        {
            get { return _match; }
        }

        void CopyTo(Array array, int arrayIndex)
        {
            if (array == null)
                throw ArgumentNullException("array");

            for (int i = arrayIndex, j = 0; j < Count; i++, j++)
            {
                array.SetValue(this[j], i);
            }
        }

        private class Enumerator : System.Collections.IEnumerator
        {
            private   GroupCollection _collection;
            private int _index;

            internal Enumerator(GroupCollection collection)
            {
                Debug.Assert(collection != null, "collection cannot be null.");

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

            public Group Current
            {
                get
                {
                    if (_index < 0 || _index >= _collection.Count)
                        throw InvalidOperationException(SR.EnumNotStarted);

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
