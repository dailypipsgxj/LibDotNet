// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The MatchCollection lists the successful matches that
// result when searching a string for a regular expression.

//using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

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
    public class MatchCollection : ICollection<Match>, IEnumerable<Match>
    {
        private Regex _regex;
        private List<Match> _matches;
        private bool _done;
        private string _input;
        private int _beginning;
        private int _length;
        private int _startat;
        private int _prevlen;

        public MatchCollection(Regex regex, string input, int beginning, int length, int startat)
			requires (startat >= 0 || startat < input.length)
        {
            _regex = regex;
            _input = input;
            _beginning = beginning;
            _length = length;
            _startat = startat;
            _prevlen = -1;
            _matches = new List<Match>();
            _done = false;
        }

        /// <summary>
        /// Returns the number of captures.
        /// </summary>
        public int Count
        {
            get
            {
                EnsureInitialized();
                return _matches.Count;
            }
        }

        public int size
        {
            get
            {
                return Count;//_matches.Count;
            }
        }

        /// <summary>
        /// Returns the ith Match in the collection.
        /// </summary>
        public new Match get (int i)
			requires (i >= 0)
			ensures (result != null)
        {
			Match match = GetMatch(i);
			return match;
        }

        /// <summary>
        /// Provides an enumerator in the same order as Item[i].
        /// </summary>
        public IEnumerator<Match> GetEnumerator()
        {
            return new Enumerator(this);
        }

        public IEnumerator<Match> iterator()
        {
            return GetEnumerator();
        }

        private Match? GetMatch(int i)
			requires (i >= 0)
        {
            if (_matches.Count > i)
                return _matches[i];

            if (_done)
                return null;

            Match match;

            do {
                match = _regex.Run(false, _prevlen, _input, _beginning, _length, _startat);

                if (!match.Success)
                {
                    _done = true;
                    return null;
                }

                _matches.Add(match);

                _prevlen = match._length;
                _startat = match._textpos;
            } while (_matches.Count <= i);

            return match;
        }

        private void EnsureInitialized()
        {
            if (!_done)
            {
                GetMatch(int.MAX);
            }
        }

        bool IsSynchronized
        {
            get { return false; }
        }

        public Object SyncRoot
        {
            get { return this as Object; }
        }

        private class Enumerator : IEnumerator<Match>
        {
            private  MatchCollection _collection;
            private int _index;

            internal Enumerator(MatchCollection collection)
            {
                _collection = collection;
                _index = -1;
            }

			public Object get () {
				return Current;
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

            public bool next()
            {
				return MoveNext();
			}

            public Object Current {
                owned get {
				if (_index < 0)
					throw new InvalidOperationException(SR.EnumNotStarted);
					
                    return _collection.GetMatch(_index);
                }
            }

            void Reset()
            {
                _index = -1;
            }
        }
    }
}
