// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// Capture is just a location/length pair that indicates the
// location of a regular expression match. A single regexp
// search may return multiple Capture within each capturing
// RegexGroup.

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents the results from a single subexpression capture. TheObjectrepresents
    /// one substring for a single successful capture.
    /// </summary>
    public class Capture
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

        /*
         * The index of the beginning of the matched capture
         */
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

        /*
         * The length of the matched capture
         */
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
        //[ CCode ( returns_floating_reference = true ) ]
        public string Value
        {
            owned get
            {
				return _text.substring(_index, _length);
            }
        }

        /*
         * The capture as a string
         */
        /// <summary>
        /// Returns the substring that was matched.
        /// </summary>
        public string ToString()
        {
            return Value;
        }

        /*
         * The original string
         */
        internal string GetOriginalString()
        {
            return _text;
        }

        /*
         * The substring to the left of the capture
         */
        internal string GetLeftSubString()
        {
            return _text.substring(0, _index);
        }

        /*
         * The substring to the right of the capture
         */
        internal string GetRightSubString()
        {
            return _text.substring(_index + _length, _text.length - _index - _length);
        }

    }
}
