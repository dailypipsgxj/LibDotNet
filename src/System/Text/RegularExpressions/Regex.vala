// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The Regex class represents a single compiled instance of a regular
// expression.

using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Globalization;
using System.Threading;

namespace System.Text.RegularExpressions
{
    /// <summary>
    /// Represents an immutable, compiled regular expression. Also
    /// contains static methods that allow use of regular expressions without instantiating
    /// a Regex  ly.
    /// </summary>
    public class Regex : GLib.Regex
    {
        internal string _pattern;                   // The string pattern provided
        internal RegexOptions _roptions;            // the top-level options from the options string

        // *********** Match timeout fields { ***********

        // We need this because time is queried using Environment.TickCount for performance reasons
        // (Environment.TickCount returns milliseconds as an int and cycles):
        private static   TimeSpan MaximumMatchTimeout = TimeSpan.FromMilliseconds(int32.MaxValue - 1);

        // InfiniteMatchTimeout specifies that match timeout is switched OFF. It allows for faster code paths
        // compared to simply having a very large timeout.
        // We do not want to ask users to use System.Threading.Timeout.InfiniteTimeSpan as a parameter because:
        //   (1) We do not want to imply any relation between having using a RegEx timeout and using multi-threading.
        //   (2) We do not want to require users to take ref to a contract assembly for threading just to use RegEx.
        //       There may in theory be a SKU that has RegEx, but no multithreading.
        // We create a public Regex.InfiniteMatchTimeout constant, which for consistency uses the save underlying
        // value as Timeout.InfiniteTimeSpan creating an implementation detail dependency only.
        public static   TimeSpan InfiniteMatchTimeout = Timeout.InfiniteTimeSpan;

        internal TimeSpan _internalMatchTimeout;   // timeout for the execution of this regex

        // DefaultMatchTimeout specifies the match timeout to use if no other timeout was specified
        // by one means or another. Typically, it is set to InfiniteMatchTimeout.
        internal static   TimeSpan DefaultMatchTimeout = InfiniteMatchTimeout;

        // *********** } match timeout fields ***********


        internal Dictionary<int32, int32> _caps;            // if captures are sparse, this is the hashtable capnum->index
        internal Dictionary<string, int32> _capnames;       // if named captures are used, this maps names->index

        internal string[] _capslist;                        // if captures are sparse or named captures are used, this is the sorted list of names
        internal int _capsize;                              // the size of the capture array

        //internal ExclusiveReference _runnerref;             // cached runner
        //internal SharedReference _replref;                  // cached parsed replacement pattern
        //internal RegexCode _code;                           // if interpreted, this is the code for RegexInterpreter
        internal bool _refsInitialized = false;

        //internal static LinkedList<CachedCodeEntry> s_livecode = new LinkedList<CachedCodeEntry>();// the cache of code and factories that are currently loaded
        internal static int s_cacheSize = 15;

        internal const int MaxOptionShift = 10;


        /// <summary>
        /// Creates and compiles a regular expressionObjectfor the
        /// specified regular expression with options that modify the pattern.
        /// </summary>

        public Regex(string pattern, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout, bool useCache = false)
        {
            if (options < RegexOptions.None || (((int)options) >> MaxOptionShift) != 0)
                throw ArgumentOutOfRangeException("options");

            ValidateMatchTimeout(matchTimeout);

			RegexCompileFlags flags = ConvertOptions (options);
			
            _pattern = pattern;
            _roptions = options;
            _internalMatchTimeout = matchTimeout;
			
			//public Regex (string pattern, RegexCompileFlags compile_options = 0, RegexMatchFlags match_options = 0) throws RegexError
			base(pattern, flags);
			
			_capsize = get_capture_count ();
			
		}


		internal RegexCompileFlags ConvertOptions (RegexOptions options)
		{
			RegexCompileFlags flags = 0;

			if ((options & RegexOptions.None) !=  RegexOptions.None)
			{
				if ((options & RegexOptions.IgnoreCase) ==  RegexOptions.IgnoreCase)
					flags |=  RegexCompileFlags.CASELESS;
				if ((options & RegexOptions.Multiline) ==  RegexOptions.Multiline)
					flags |=  RegexCompileFlags.MULTILINE;
					
				if ((options & RegexOptions.ExplicitCapture) ==  RegexOptions.ExplicitCapture)
					//flags |=  0;
					
				if ((options & RegexOptions.Compiled) ==  RegexOptions.Compiled)
					flags |=  RegexCompileFlags.OPTIMIZE;
					
				if ((options & RegexOptions.Singleline) ==  RegexOptions.Singleline)
					flags |=  RegexCompileFlags.DOTALL;
				
				if ((options & RegexOptions.IgnorePatternWhitespace) ==  RegexOptions.IgnorePatternWhitespace)
					flags |=  RegexCompileFlags.EXTENDED;
					
				if ((options & RegexOptions.RightToLeft) ==  RegexOptions.RightToLeft)
					//flags |=  0;
					
				if ((options & RegexOptions.ECMAScript) ==  RegexOptions.ECMAScript)
					flags |=  RegexCompileFlags.JAVASCRIPT_COMPAT;

				if ((options & RegexOptions.CultureInvariant) ==  RegexOptions.CultureInvariant)
					//flags |=  0;
					
				return flags;
			}
			
		}

        // Note: "&lt;" is the XML entity for smaller ("<").
        /// <summary>
        /// Validates that the specified match timeout value is valid.
        /// The valid range is <code>TimeSpan.Zero &lt; matchTimeout &lt;= Regex.MaximumMatchTimeout</code>.
        /// </summary>
        /// <param name="matchTimeout">The timeout value to validate.</param>
        /// <exception cref="System.ArgumentOutOfRangeException">If the specified timeout is not within a valid range.
        /// </exception>
        internal static void ValidateMatchTimeout(TimeSpan matchTimeout)
        {
            if (InfiniteMatchTimeout == matchTimeout)
                return;

            // Change this to make sure timeout is not longer then Environment.Ticks cycle length:
            if (TimeSpan.Zero < matchTimeout && matchTimeout <= MaximumMatchTimeout)
                return;

            throw ArgumentOutOfRangeException("matchTimeout");
        }

        /// <summary>
        /// Escapes a minimal set of metacharacters (\, *, +, ?, |, {, [, (, ), ^, $, ., #, and
        /// whitespace) by replacing them with their \ codes. This converts a string so that
        /// it can be used as a constant within a regular expression safely. (Note that the
        /// reason # and whitespace must be escaped is so the string can be used safely
        /// within an expression parsed with x mode. If future Regex features add
        /// additional metacharacters, developers should depend on Escape to escape those
        /// characters as well.)
        /// </summary>
        public static string Escape(string str)
        {
            return escape_string(str);
        }

        /// <summary>
        /// Unescapes any escaped characters in the input string.
        /// </summary>
        public static string Unescape(string str)
        {
            return Uri.unescape_string (str);
        }

        public static int CacheSize
        {
            get
            {
                return s_cacheSize;
            }
            set
            {
                if (value < 0)
                    throw ArgumentOutOfRangeException("value");

                s_cacheSize = value;
            }
        }

        /// <summary>
        /// Returns the options passed into the constructor
        /// </summary>
        public RegexOptions Options
        {
            get { return _roptions; }
        }


        /// <summary>
        /// The match timeout used by this Regex instance.
        /// </summary>
        public TimeSpan MatchTimeout
        {
            get { return _internalMatchTimeout; }
        }

        /// <summary>
        /// Indicates whether the regular expression matches from right to left.
        /// </summary>
        public bool RightToLeft
        {
            get
            {
                return UseOptionR();
            }
        }

        /// <summary>
        /// Returns the regular expression pattern passed into the constructor
        /// </summary>
        public override string ToString()
        {
            return _pattern;
        }

        /*
         * Returns an array of the group names that are used to capture groups
         * in the regular expression. Only needed if the regex is not known until
         * runtime, and one wants to extract captured groups. (Probably unusual,
         * but supplied for completeness.)
         */
        /// <summary>
        /// Returns the GroupNameCollection for the regular expression. This collection contains the
        /// set of strings used to name capturing groups in the expression.
        /// </summary>
        public string[] GetGroupNames()
        {
            string[] result;
			return result;
        }

        /*
         * Returns an array of the group numbers that are used to capture groups
         * in the regular expression. Only needed if the regex is not known until
         * runtime, and one wants to extract captured groups. (Probably unusual,
         * but supplied for completeness.)
         */
        /// <summary>
        /// Returns the integer group number corresponding to a group name.
        /// </summary>
        public int[] GetGroupNumbers()
        {
            int[] result;
            return result;
        }

        /*
         * Given a group number, maps it to a group name. Note that numbered
         * groups automatically get a group name that is the decimal string
         * equivalent of its number.
         *
         * Returns null if the number is not a recognized group number.
         */
        /// <summary>
        /// Retrieves a group name that corresponds to a group number.
        /// </summary>
        public string GroupNameFromNumber(int i)
        {
            return "";
        }

        /*
         * Given a group name, maps it to a group number. Note that numbered
         * groups automatically get a group name that is the decimal string
         * equivalent of its number.
         *
         * Returns -1 if the name is not a recognized group name.
         */
        /// <summary>
        /// Returns a group number that corresponds to a group name.
        /// </summary>
        public int GroupNumberFromName(string name)
        {
			return get_string_number (name);
        }

        /*
         * Static version of simple IsMatch call
         */
        /// <summary>
        /// Searches the input string for one or more occurrences of the text
        /// supplied in the pattern parameter with matching options supplied in the options
        /// parameter.
        /// </summary>
		public static bool IsMatch(	string input,
									string pattern,
									RegexOptions options = RegexOptions.None,
									TimeSpan matchTimeout = DefaultMatchTimeout)
		{
			RegexCompileFlags flags = ConvertOptions (options);
			return match_simple (pattern, input, flags);
		}
        /*
         * Returns true if the regex finds a match after the specified position
         * (proceeding leftward if the regex is leftward and rightward otherwise)
         */
        /// <summary>
        /// Searches the input string for one or more matches using the previous pattern and options,
        /// with a new starting position.
        /// </summary>
        /*
        public bool IsMatch(string input)
        public bool IsMatch(string input, int startat)
        {
            return (null == Run(true, -1, input, 0, input.Length, startat));
        }
        */

        /*
         * Static version of simple Match call
         */
        /// <summary>
        /// Searches the input string for one or more occurrences of the text
        /// supplied in the pattern parameter. Matching is modified with an option
        /// string.
        /// </summary>

        public static Match Match(string input, string pattern, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout)
        {
            GLib.Regex re;
			RegexCompileFlags flags = ConvertOptions (options);
			re = new Regex (pattern, flags);
			return new Match (re, 0, input);
        }
        /*
         * Finds the first match, restricting the search to the specified interval of
         * the char array.
         */
        /// <summary>
        /// Matches a regular expression with a string and returns the precise result as a
        /// RegexMatch object.
        /// </summary>
        /*
        public Match Match(string input)
        public Match Match(string input, int startat)
        public Match Match(string input, int beginning, int length)
        {
            if (input == null)
                throw ArgumentNullException("input");

            return Run(false, -1, input, beginning, length, UseOptionR() ? beginning + length : beginning);
        }
        */
        /*
         * Static version of simple Matches call
         */
        /// <summary>
        /// Returns all the successful matches as if Match were called iteratively numerous times.
        /// </summary>
        public static MatchCollection Matches(string input, string pattern, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout)
        {
            GLib.Regex re;
			RegexCompileFlags flags = ConvertOptions (options);
			re = new Regex (pattern, flags);
			return new MatchCollection(re, input, 0, input.length);
		}
        /*
         * Finds the first match, starting at the specified position
         */
        /// <summary>
        /// Returns all the successful matches as if Match was called iteratively numerous times.
        /// </summary>
        /*
        public MatchCollection Matches(string input)
        public MatchCollection Matches(string input, int startat)
        {
            if (input == null)
                throw ArgumentNullException("input");

            return new MatchCollection(this, input, 0, input.Length, startat);
        }
        */
        /// <summary>
        /// Replaces all occurrences of
        /// the <paramref name="pattern "/>with the <paramref name="replacement "/>
        /// pattern, starting at the first character in the input string.
        /// </summary>

        public static string Replace(string input, string pattern, string replacement, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout)
        {
			GLib.Regex re;
			RegexCompileFlags flags = ConvertOptions (options);
			re = new Regex (pattern, flags);
			return re.replace (input, input.length, 0, replacement);
        }

        /// <summary>
        /// Replaces all occurrences of the previously defined pattern with the
        /// <paramref name="replacement"/> pattern, starting at the character position
        /// <paramref name="startat"/>.
        /// </summary>
        /*
        public string Replace(string input, string replacement)
        public string Replace(string input, string replacement, int count)
        public string Replace(string input, string replacement, int count, int startat)
        {
            if (input == null)
                throw ArgumentNullException("input");

            if (replacement == null)
                throw ArgumentNullException("replacement");

            // a little code to grab a cached parsed replacementObjectRegexReplacement repl = (RegexReplacement)_replref.Get();

            if (repl == null || !repl.Pattern.Equals(replacement))
            {
                repl = RegexParser.ParseReplacement(replacement, _caps, _capsize, _capnames, _roptions);
                _replref.Cache(repl);
            }

            return repl.Replace(this, input, count, startat);
        }
        */
        /// <summary>
        /// Replaces all occurrences of the <paramref name="pattern"/> with the recent
        /// replacement pattern, starting at the first character.
        /// </summary>
		/*
        public static string ReplaceWithEval(string input, string pattern, MatchEvaluator evaluator, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout)
        {
            return new Regex(pattern, options, matchTimeout, true).Replace(input, evaluator);
        }
        */

        /// <summary>
        /// Replaces all occurrences of the previously defined pattern with the recent
        /// replacement pattern, starting at the character position
        /// <paramref name="startat"/>.
        /// </summary>
        /*
        public string Replace(string input, MatchEvaluator evaluator, int count = 0, int startat = 0)
        {
            if (input == null)
                throw ArgumentNullException("input");

            return RegexReplacement.Replace(evaluator, this, input, count, startat);
        }
        */

        /// <summary>
        /// Splits the <paramref name="input "/>string at the position defined by <paramref name="pattern"/>.
        /// </summary>
        public static string[] Split(string input, string pattern, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout)
        {
			RegexCompileFlags flags = ConvertOptions (options);
			return split_simple (pattern, input, flags);
        }

        /// <summary>
        /// Splits the <paramref name="input"/> string at the position defined by a
        /// previous pattern.
        /// </summary>
        public string[] SplitFull(string input, int count = -1, int startat = 0)
        {
			return split_full (input, count, startat);
        }


        /*
         * Internal worker called by all the public APIs
         */
         /*
        internal Match Run(bool quick, int prevlen, string input, int beginning, int length, int startat)
        {
            Match match;
            RegexRunner runner = null;

            if (startat < 0 || startat > input.Length)
                throw ArgumentOutOfRangeException("start", SR.BeginIndexNotNegative);

            if (length < 0 || length > input.Length)
                throw ArgumentOutOfRangeException("length", SR.LengthNotNegative);

            // There may be a cached runner; grab ownership of it if we can.

            runner = (RegexRunner)_runnerref.Get();

            // Create a RegexRunner instance if we need to

            if (runner == null)
            {
                runner = new RegexInterpreter(_code, UseOptionInvariant() ? CultureInfo.InvariantCulture : CultureInfo.CurrentCulture);
            }

            try
            {
                // Do the scan starting at the requested position
                match = runner.Scan(this, input, beginning, beginning + length, startat, prevlen, quick, _internalMatchTimeout);
            }
            finally
            {
                // Release or fill the cache slot
                _runnerref.Release(runner);
            }

#if DEBUG
            if (Debug && match != null)
                match.Dump();
#endif
            return match;
        }
        */




        /*
         * True if the L option was set
         */
        internal bool UseOptionR()
        {
            return (_roptions & RegexOptions.RightToLeft) != 0;
        }

        internal bool UseOptionInvariant()
        {
            return (_roptions & RegexOptions.CultureInvariant) != 0;
        }

#if DEBUG
        /*
         * True if the regex has debugging enabled
         */
        internal bool Debug
        {
            get
            {
                return (_roptions & RegexOptions.Debug) != 0;
            }
        }
#endif
    }


    /*
     * Callback class
     */
    public delegate string MatchEvaluator(Match match);

}
