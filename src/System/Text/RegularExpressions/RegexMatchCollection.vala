// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The MatchCollection lists the successful matches that
// result when searching a string for a regular expression.

using System.Collections;
//using System.Collections.Generic;
using System.Diagnostics;

namespace System.Text.RegularExpressions
{
    /*
     * This collection returns a sequence of successful match results, either
     * from GetMatchCollection() or GetExecuteCollection(). It stops when the
     * first failure is encountered (it does not return the failed match).
     */
    /// <summary>
    /// Represents the set of names appearing as capturing group
    /// names in a regular expression.
    /// </summary>
    public class MatchCollection : Object, ICollection, IEnumerable
    {
        private   GLib.Regex _regex;
        private   string _input;
        private   int _beginning;
        private   int _length;
        private int _startat;

        public MatchCollection(GLib.Regex regex, string input, int beginning, int length, int startat)
        {
            _regex = regex;
            _input = input;
            _beginning = beginning;
            _length = length;
            _startat = startat;
        }

        /// <summary>
        /// Returns the number of captures.
        /// </summary>
        public int Count
        {
            get
            {
                return -1;//_matches.Count;
            }
        }

        /// <summary>
        /// Returns the ith Match in the collection.
        /// </summary>
        new Match get (int i)
        {
			Match match = GetMatch(i);
			return match;
        }

        /// <summary>
        /// Provides an enumerator in the same order as Item[i].
        /// </summary>
        public IEnumerator GetEnumerator()
        {
            return new Enumerator(this);
        }

        private Match GetMatch(int i)
        {
            return this as Match;
        }

        private void EnsureInitialized()
        {
			GetMatch(int.MAX);
        }

        bool IsSynchronized
        {
            get { return false; }
        }

        Object SyncRoot
        {
            get { return this as Object; }
        }


        public class Enumerator : Object, IEnumerator
        {
            private   MatchCollection _collection;
            private int _index;

			private Object _currentElement { get; set;}
			private Gee.Iterator<Object> _iterator { get; set;}


            internal Enumerator(MatchCollection collection)
            {
                _collection = collection;
                _index = -1;
            }

            public bool MoveNext()
            {
                if (_index == -2)
                    return false;

                _index++;
                Match match = _collection.GetMatch(_index);

                if (match == null)
                {
                    _index = -2;
                    return false;
                }

                return true;
            }

            public Object Current
            {
                owned get
                {
                    return _currentElement;
                }
            }


            void IEnumerator.Reset()
            {
                _index = -1;
            }
        }
    }
}
