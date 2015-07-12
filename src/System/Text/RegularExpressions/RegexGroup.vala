// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// Group represents the substring or substrings that
// are captured by a single capturing group after one
// regular expression match.

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents the results from a single capturing group. A capturing group can
    /// capture zero, one, or more strings in a single match because of quantifiers, so
    /// Group supplies a collection of Capture objects.
    /// </summary>
    public class Group : Capture
    {
        internal int _capcount;
        internal CaptureCollection _capcoll;

        internal Group() {
			base("",0,0);
        }

        /// <summary>
        /// Indicates whether the match is successful.
        /// </summary>
        public bool Success
        {
            get
            {
                return _capcount != 0;
            }
        }

        /*
         * The collection of all captures for this group
         */
        /// <summary>
        /// Returns a collection of all the captures matched by the capturing
        /// group, in innermost-leftmost-first order (or innermost-rightmost-first order if
        /// compiled with the "r" option). The collection may have zero or more items.
        /// </summary>
        public CaptureCollection Captures
        {
            get
            {
                if (_capcoll == null)
                    _capcoll = new CaptureCollection(this);
                return _capcoll;
            }
        }

        /*
         * Convert to a thread-safeObjectby precomputing cache contents
         */
        /// <summary>
        /// Returns a GroupObjectequivalent to the one supplied that is safe to share between
        /// multiple threads.
        /// </summary>
        static Group Synchronized(Group inner)
        {
            return inner;
        }
    }
}
