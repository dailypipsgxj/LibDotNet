// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// Match is the result class for a regex search.
// It returns the location, length, and substring for
// the entire match as well as every captured group.

// Match is also used during the search to keep track of each capture for each group.  This is
// done using the "_matches" array.  _matches[x] represents an array of the captures for group x.
// This array consists of start and length pairs, and may have empty entries at the end.  _matchcount[x]
// stores how many captures a group has.  Note that _matchcount[x]*2 is the length of all the valid
// values in _matches.  _matchcount[x]*2-2 is the Start of the last capture, and _matchcount[x]*2-1 is the
// Length of the last capture
//
// For example, if group 2 has one capture starting at position 4 with length 6,
// _matchcount[2] == 1
// _matches[2][0] == 4
// _matches[2][1] == 6
//
// Values in the _matches array can also be negative.  This happens when using the balanced match
// construct, "(?<start-end>...)".  When the "end" group matches, a capture is added for both the "start"
// and "end" groups.  The capture added for "start" receives the negative values, and these values point to
// the next capture to be balanced.  They do NOT point to the capture that "end" just balanced out.  The negative
// values are indices into the _matches array transformed by the formula -3-x.  This formula also untransforms.
//

using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents the results from a single regular expression match.
    /// </summary>
    public class Match : Group
    {
        //internal static Match s_empty = new Match(null, 1, "", 0, 0, 0);
        internal GroupCollection _groupcoll;
		internal GLib.MatchInfo _matchinfo;

        /// <summary>
        /// Returns an empty Match object.
        /// </summary>
        public static Match Empty
        {
            get
            {
            }
        }

        public Match(GLib.MatchInfo matchinfo){
			_matchinfo = matchinfo;
			base();
			//base(text, new int[2], 0);
        }

        /*
         * Nonpublic set-text method
         */
        internal virtual void Reset(Regex regex, string text, int textbeg, int textend, int textstart)
        {
        }

        public virtual GroupCollection Groups
        {
            get
            {
                if (_groupcoll == null)
                    _groupcoll = new GroupCollection(this);

                return _groupcoll;
            }
        }

        /// <summary>
        /// Returns a new Match with the results for the next match, starting
        /// at the position at which the last match ended (at the character beyond the last
        /// matched character).
        /// </summary>
        public Match NextMatch()
        {
            //return _regex.Run(false, _length, _text, _textbeg, _textend - _textbeg, _textpos);
        }

        /// <summary>
        /// Returns the expansion of the passed replacement pattern. For
        /// example, if the replacement pattern is ?$1$2?, Result returns the concatenation
        /// of Group(1).Tostring() and Group(2).Tostring().
        /// </summary>
        public virtual string Result(string replacement)
        {

            return replacement;
        }


        /*
         * Convert to a thread-safeObjectby precomputing cache contents
         */
        /// <summary>
        /// Returns a Match instance equivalent to the one supplied that is safe to share
        /// between multiple threads.
        /// </summary>

        static Match Synchronized (Match inner)
        {
            return inner;
        }


    }


    /*
     * MatchSparse is for handling the case where slots are
     * sparsely arranged (e.g., if somebody says use slot 100000)
     */
    internal class MatchSparse : Match
    {
		public MatchSparse (GLib.MatchInfo matchinfo) {
			base(matchinfo);
		}
    }
}
