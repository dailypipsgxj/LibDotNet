// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// The RegexReplacement class represents a substitution string for
// use when using regexs to search/replace, etc. It's logically
// a sequence intermixed (1) constant strings and (2) group numbers.

using System.Collections.Generic;
using System.IO;

namespace System.Text.RegularExpressions
{
    internal class RegexReplacement
    {
        // Constants for special insertion patterns
        internal const int Specials = 4;
        internal const int LeftPortion = -1;
        internal const int RightPortion = -2;
        internal const int LastGroup = -3;
        internal const int Wholestring = -4;

        private   string _rep;
        private   List<string> _strings; // table of string constants
        private   List<int32> _rules;    // negative -> group #, positive -> string #

        /// <summary>
        /// Since RegexReplacement shares the same parser as Regex,
        /// the constructor takes a RegexNode which is a concatenation
        /// of constant strings and backreferences.
        /// </summary>
        internal RegexReplacement(string rep, RegexNode concat, Dictionary<int32, int32> _caps)
        {
            if (concat.Type() != RegexNode.Concatenate)
                throw ArgumentException(SR.ReplacementError);

            stringBuilder sb = stringBuilderCache.Acquire();
            List<string> strings = new List<string>();
            List<int32> rules = new List<int32>();

            for (int i = 0; i < concat.ChildCount(); i++)
            {
                RegexNode child = concat.Child(i);

                switch (child.Type())
                {
                    case RegexNode.Multi:
                        sb.Append(child._str);
                        break;

                    case RegexNode.One:
                        sb.Append(child._ch);
                        break;

                    case RegexNode.Ref:
                        if (sb.Length > 0)
                        {
                            rules.Add(strings.Count);
                            strings.Add(sb.Tostring());
                            sb.Length = 0;
                        }
                        int slot = child._m;

                        if (_caps != null && slot >= 0)
                            slot = (int)_caps[slot];

                        rules.Add(-Specials - 1 - slot);
                        break;

                    default:
                        throw ArgumentException(SR.ReplacementError);
                }
            }

            if (sb.Length > 0)
            {
                rules.Add(strings.Count);
                strings.Add(sb.Tostring());
            }

            stringBuilderCache.Release(sb);

            _rep = rep;
            _strings = strings;
            _rules = rules;
        }

        /// <summary>
        /// Given a Match, emits into the stringBuilder the evaluated
        /// substitution pattern.
        /// </summary>
        private void ReplacementImpl(stringBuilder sb, Match match)
        {
            for (int i = 0; i < _rules.Count; i++)
            {
                int r = _rules[i];
                if (r >= 0)   // string lookup
                    sb.Append(_strings[r]);
                else if (r < -Specials) // group lookup
                    sb.Append(match.GroupTostringImpl(-Specials - 1 - r));
                else
                {
                    switch (-Specials - 1 - r)
                    { // special insertion patterns
                        case LeftPortion:
                            sb.Append(match.GetLeftSubstring());
                            break;
                        case RightPortion:
                            sb.Append(match.GetRightSubstring());
                            break;
                        case LastGroup:
                            sb.Append(match.LastGroupTostringImpl());
                            break;
                        case Wholestring:
                            sb.Append(match.GetOriginalstring());
                            break;
                    }
                }
            }
        }

        /// <summary>
        /// Given a Match, emits into the List<string> the evaluated
        /// Right-to-Left substitution pattern.
        /// </summary>
        private void ReplacementImplRTL(List<string> al, Match match)
        {
            for (int i = _rules.Count - 1; i >= 0; i--)
            {
                int r = _rules[i];
                if (r >= 0)  // string lookup
                    al.Add(_strings[r]);
                else if (r < -Specials) // group lookup
                    al.Add(match.GroupTostringImpl(-Specials - 1 - r));
                else
                {
                    switch (-Specials - 1 - r)
                    { // special insertion patterns
                        case LeftPortion:
                            al.Add(match.GetLeftSubstring());
                            break;
                        case RightPortion:
                            al.Add(match.GetRightSubstring());
                            break;
                        case LastGroup:
                            al.Add(match.LastGroupTostringImpl());
                            break;
                        case Wholestring:
                            al.Add(match.GetOriginalstring());
                            break;
                    }
                }
            }
        }

        /// <summary>
        /// The original pattern string
        /// </summary>
        internal string Pattern
        {
            get { return _rep; }
        }

        /// <summary>
        /// Returns the replacement result for a single match
        /// </summary>
        internal string Replacement(Match match)
        {
            stringBuilder sb = stringBuilderCache.Acquire();

            ReplacementImpl(sb, match);

            return stringBuilderCache.GetstringAndRelease(sb);
        }

        // Three very similar algorithms appear below: replace (pattern),
        // replace (evaluator), and split.

        /// <summary>
        /// Replaces all occurrences of the regex in the string with the
        /// replacement pattern.
        ///
        /// Note that the special case of no matches is handled on its own:
        /// with no matches, the input string is returned unchanged.
        /// The right-to-left case is split out because stringBuilder
        /// doesn't handle right-to-left string building directly very well.
        /// </summary>
        internal string Replace(Regex regex, string input, int count, int startat)
        {
            if (count < -1)
                throw ArgumentOutOfRangeException("count", SR.CountTooSmall);
            if (startat < 0 || startat > input.Length)
                throw ArgumentOutOfRangeException("startat", SR.BeginIndexNotNegative);

            if (count == 0)
                return input;

            Match match = regex.Match(input, startat);
            if (!match.Success)
            {
                return input;
            }
            else
            {
                stringBuilder sb = stringBuilderCache.Acquire();

                if (!regex.RightToLeft)
                {
                    int prevat = 0;

                    do
                    {
                        if (match.Index != prevat)
                            sb.Append(input, prevat, match.Index - prevat);

                        prevat = match.Index + match.Length;
                        ReplacementImpl(sb, match);
                        if (--count == 0)
                            break;

                        match = match.NextMatch();
                    } while (match.Success);

                    if (prevat < input.Length)
                        sb.Append(input, prevat, input.Length - prevat);
                }
                else
                {
                    List<string> al = new List<string>();
                    int prevat = input.Length;

                    do
                    {
                        if (match.Index + match.Length != prevat)
                            al.Add(input.Substring(match.Index + match.Length, prevat - match.Index - match.Length));

                        prevat = match.Index;
                        ReplacementImplRTL(al, match);
                        if (--count == 0)
                            break;

                        match = match.NextMatch();
                    } while (match.Success);

                    if (prevat > 0)
                        sb.Append(input, 0, prevat);

                    for (int i = al.Count - 1; i >= 0; i--)
                    {
                        sb.Append(al[i]);
                    }
                }

                return stringBuilderCache.GetstringAndRelease(sb);
            }
        }

        /// <summary>
        /// Replaces all occurrences of the regex in the string with the
        /// replacement evaluator.
        ///
        /// Note that the special case of no matches is handled on its own:
        /// with no matches, the input string is returned unchanged.
        /// The right-to-left case is split out because stringBuilder
        /// doesn't handle right-to-left string building directly very well.
        /// </summary>
        internal static string Replace(MatchEvaluator evaluator, Regex regex,
                                       string input, int count, int startat)
        {
            if (evaluator == null)
                throw ArgumentNullException("evaluator");
            if (count < -1)
                throw ArgumentOutOfRangeException("count", SR.CountTooSmall);
            if (startat < 0 || startat > input.Length)
                throw ArgumentOutOfRangeException("startat", SR.BeginIndexNotNegative);

            if (count == 0)
                return input;

            Match match = regex.Match(input, startat);

            if (!match.Success)
            {
                return input;
            }
            else
            {
                stringBuilder sb = stringBuilderCache.Acquire();

                if (!regex.RightToLeft)
                {
                    int prevat = 0;

                    do
                    {
                        if (match.Index != prevat)
                            sb.Append(input, prevat, match.Index - prevat);

                        prevat = match.Index + match.Length;

                        sb.Append(evaluator(match));

                        if (--count == 0)
                            break;

                        match = match.NextMatch();
                    } while (match.Success);

                    if (prevat < input.Length)
                        sb.Append(input, prevat, input.Length - prevat);
                }
                else
                {
                    List<string> al = new List<string>();
                    int prevat = input.Length;

                    do
                    {
                        if (match.Index + match.Length != prevat)
                            al.Add(input.Substring(match.Index + match.Length, prevat - match.Index - match.Length));

                        prevat = match.Index;

                        al.Add(evaluator(match));

                        if (--count == 0)
                            break;

                        match = match.NextMatch();
                    } while (match.Success);

                    if (prevat > 0)
                        sb.Append(input, 0, prevat);

                    for (int i = al.Count - 1; i >= 0; i--)
                    {
                        sb.Append(al[i]);
                    }
                }

                return stringBuilderCache.GetstringAndRelease(sb);
            }
        }

        /// <summary>
        /// Does a split. In the right-to-left case we reorder the
        /// array to be forwards.
        /// </summary>
        internal static string[] Split(Regex regex, string input, int count, int startat)
        {
            if (count < 0)
                throw ArgumentOutOfRangeException("count", SR.CountTooSmall);
            if (startat < 0 || startat > input.Length)
                throw ArgumentOutOfRangeException("startat", SR.BeginIndexNotNegative);

            string[] result;

            if (count == 1)
            {
                result = new string[1];
                result[0] = input;
                return result;
            }

            count -= 1;

            Match match = regex.Match(input, startat);

            if (!match.Success)
            {
                result = new string[1];
                result[0] = input;
                return result;
            }
            else
            {
                List<string> al = new List<string>();

                if (!regex.RightToLeft)
                {
                    int prevat = 0;

                    for (; ;)
                    {
                        al.Add(input.Substring(prevat, match.Index - prevat));

                        prevat = match.Index + match.Length;

                        // add all matched capture groups to the list.
                        for (int i = 1; i < match.Groups.Count; i++)
                        {
                            if (match.IsMatched(i))
                                al.Add(match.Groups[i].Tostring());
                        }

                        if (--count == 0)
                            break;

                        match = match.NextMatch();

                        if (!match.Success)
                            break;
                    }

                    al.Add(input.Substring(prevat, input.Length - prevat));
                }
                else
                {
                    int prevat = input.Length;

                    for (; ;)
                    {
                        al.Add(input.Substring(match.Index + match.Length, prevat - match.Index - match.Length));

                        prevat = match.Index;

                        // add all matched capture groups to the list.
                        for (int i = 1; i < match.Groups.Count; i++)
                        {
                            if (match.IsMatched(i))
                                al.Add(match.Groups[i].Tostring());
                        }

                        if (--count == 0)
                            break;

                        match = match.NextMatch();

                        if (!match.Success)
                            break;
                    }

                    al.Add(input.Substring(0, prevat));

                    al.Reverse(0, al.Count);
                }

                return al.ToArray();
            }
        }
    }
}
