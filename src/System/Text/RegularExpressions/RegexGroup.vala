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
        internal static Group _emptygroup = new Group("", new int[], 0);

        internal int[] _caps;
        internal int _capcount;
        internal CaptureCollection _capcoll;

        internal Group(string text, int[] caps, int capcount) {
			base (
				text,
				capcount == 0 ? 0 : caps[(capcount - 1) * 2],
				capcount == 0 ? 0 : caps[(capcount * 2) - 1]
			);
            _caps = caps;
            _capcount = capcount;
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
            CaptureCollection capcoll;
            Capture dummy;

            capcoll = inner.Captures;

            if (inner._capcount > 0)
                dummy = capcoll[0];

            return inner;
        }
        
        
        
    }
}
