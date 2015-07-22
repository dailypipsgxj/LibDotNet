// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// Capture is just a location/length pair that indicates the
// location of a regular expression match. A single regexp
// search may return multiple Capture within each capturing
// RegexGroup.

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents the results from a single subexpression capture. The Object represents
    /// one substring for a single successful capture.
    /// </summary>
    public class Capture : Object
    {
        internal string _text;
        internal int _index;
        internal int _length;

        internal Capture(string text, int i, int l)
        {
            _text = text;
            _index = i;
            _length = l;
        }
        /// <summary>
        /// Returns the position in the original string where the first character of
        /// captured substring was found.
        /// </summary>
        public int Index
        {
            get
            {
                return _index;
            }
        }
        /// <summary>
        /// Returns the length of the captured substring.
        /// </summary>
        public int Length
        {
            get
            {
                return _length;
            }
        }

        /// <summary>
        /// Returns the value of this Regex Capture.
        /// </summary>
        public string Value
        {
            owned get
            {
				return _text.substring(_index, _length);
            }
        }

        /// <summary>
        /// Returns the substring that was matched.
        /// </summary>
        public string ToString()
        {
            return Value;
        }

    }
}
