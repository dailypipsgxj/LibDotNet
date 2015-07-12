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
	
	public abstract class StaticRegex : GLib.Regex {
		
        //internal string _pattern;                   // The string pattern provided
        //internal RegexOptions _roptions;            // the top-level options from the options string

        // DefaultMatchTimeout specifies the match timeout to use if no other timeout was specified
        // by one means or another. Typically, it is set to InfiniteMatchTimeout.
        internal const TimeSpan DefaultMatchTimeout = -1;
		
		public StaticRegex()
        {
			try {
				base("");
			} catch (RegexError e) {
			
			}
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
			GLib.MatchInfo matchinfo;
			RegexCompileFlags flags = ConvertOptions (options);
			bool matched = false;

			re = new Regex (pattern);
			try {
				matched = re.match(input, 0, out matchinfo);
			} catch (RegexError e) {
				
			}
			return new System.Text.RegularExpressions.Match (matchinfo);

        }

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
        /// Splits the <paramref name="input "/>string at the position defined by <paramref name="pattern"/>.
        /// </summary>
        public static string[] Split(string input, string pattern, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout)
        {
			GLib.Regex re;
			RegexCompileFlags flags = ConvertOptions (options);
			re = new Regex (pattern, flags);
			return re.split_simple (pattern, input, flags);
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

		
		static RegexCompileFlags ConvertOptions (RegexOptions options)
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
		
	}
	
    /// <summary>
    /// Represents an immutable, compiled regular expression. Also
    /// contains static methods that allow use of regular expressions without instantiating
    /// a Regex  ly.
    /// </summary>
    public class Regex : StaticRegex
    {
        internal string _pattern;                   // The string pattern provided
        internal RegexOptions _roptions;            // the top-level options from the options string

        // *********** Match timeout fields { ***********

        // We need this because time is queried using Environment.TickCount for performance reasons
        // (Environment.TickCount returns milliseconds as an int and cycles):
        private static TimeSpan MaximumMatchTimeout = (int32.MAX-1)/1000; //TimeSpan.FromMilliseconds(int32.MaxValue - 1);

        // InfiniteMatchTimeout specifies that match timeout is switched OFF. It allows for faster code paths
        // compared to simply having a very large timeout.
        // We do not want to ask users to use System.Threading.Timeout.InfiniteTimeSpan as a parameter because:
        //   (1) We do not want to imply any relation between having using a RegEx timeout and using multi-threading.
        //   (2) We do not want to require users to take ref to a contract assembly for threading just to use RegEx.
        //       There may in theory be a SKU that has RegEx, but no multithreading.
        // We create a public Regex.InfiniteMatchTimeout constant, which for consistency uses the save underlying
        // value as Timeout.InfiniteTimeSpan creating an implementation detail dependency only.
        public static TimeSpan InfiniteMatchTimeout = -1;

        internal TimeSpan _internalMatchTimeout;   // timeout for the execution of this regex


        // *********** } match timeout fields ***********


        //internal Dictionary<int32, int32> _caps;            // if captures are sparse, this is the hashtable capnum->index
        //internal Dictionary<string, int32> _capnames;       // if named captures are used, this maps names->index

        //internal string[] _capslist;                        // if captures are sparse or named captures are used, this is the sorted list of names
        internal int _capsize;                              // the size of the capture array

        //internal ExclusiveReference _runnerref;             // cached runner
        //internal SharedReference _replref;                  // cached parsed replacement pattern
        //internal RegexCode _code;                           // if interpreted, this is the code for RegexInterpreter
        //internal bool _refsInitialized = false;

        //internal static LinkedList<CachedCodeEntry> s_livecode = new LinkedList<CachedCodeEntry>();// the cache of code and factories that are currently loaded
        //internal static int s_cacheSize = 15;

        //internal const int MaxOptionShift = 10;


        /// <summary>
        /// Creates and compiles a regular expressionObjectfor the
        /// specified regular expression with options that modify the pattern.
        /// </summary>

        public Regex(string pattern, RegexOptions options = RegexOptions.None, TimeSpan matchTimeout = DefaultMatchTimeout, bool useCache = false)
        {

			RegexCompileFlags flags = ConvertOptions (options);
			
            _pattern = pattern;
            _roptions = options;
            _internalMatchTimeout = matchTimeout;
			
			base(pattern, flags);
			
			_capsize = get_capture_count ();
			
		}

        public static int CacheSize
        {
            get
            {
                return s_cacheSize;
            }
            set
            {
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
        public string ToString()
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
         * Returns true if the regex finds a match after the specified position
         * (proceeding leftward if the regex is leftward and rightward otherwise)
         */
        /// <summary>
        /// Searches the input string for one or more matches using the previous pattern and options,
        /// with a new starting position.
        /// </summary>
        /*
        public bool IsMatch(string input)
        */
        
        public bool IsMatch(string input, int startat)
        {
            return match_full(input, input.length, startat);
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
        public Match Match(string input, int startat)
        */
        public Match Match(string input, int beginning = 0, int length = -1)
        {
			GLib.MatchInfo matchinfo;
			bool matched = false;
			try {
				matched = match_full (input, length, beginning, _roptions, matchinfo);
			} catch (RegexError e) {
				
			}
			return new Match (matchinfo);
        }
        
        /*
         * Finds the first match, starting at the specified position
         */
        /// <summary>
        /// Returns all the successful matches as if Match was called iteratively numerous times.
        /// </summary>
        public MatchCollection Matches(string input, int startat = 0)
        {
            return new MatchCollection(this, input, 0, input.length, startat);
        }

        /// <summary>
        /// Replaces all occurrences of the previously defined pattern with the
        /// <paramref name="replacement"/> pattern, starting at the character position
        /// <paramref name="startat"/>.
        /// </summary>
        public string Replace(string input, string replacement, int count = -1, int startat = 0)
        {
			return replace (input, input.length, startat, replacement, _roptions);
        }
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
        /// Splits the <paramref name="input"/> string at the position defined by a
        /// previous pattern.
        /// </summary>
        public string[] Split(string input, int count = -1, int startat = 0)
        {
			return split_full (input, count, startat);
        }

        

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

    }


    /*
     * Callback class
     */
    public delegate string MatchEvaluator(Match match);

}
