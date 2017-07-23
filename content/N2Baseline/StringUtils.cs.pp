using System;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;

namespace $rootnamespace$.N2Baseline
{
	/// <summary>
	/// String utility class that provides a host of string related operations
	/// </summary>
	public partial class StringUtils
	{
		/// <summary>
		/// Replaces and  and Quote characters to HTML safe equivalents.
		/// </summary>
		/// <param name="html">HTML to convert</param>
		/// <returns>Returns an HTML string of the converted text</returns>
		public static string FixHTMLForDisplay(string html)
		{
			html = html.Replace("<", "&lt;");
			html = html.Replace(">", "&gt;");
			html = html.Replace("\"", "&quot;");
			return html;
		}

		/// <summary>
		/// Strips HTML tags out of an HTML string and returns just the text.
		/// </summary>
		/// <param name="html">Html String</param>
		/// <returns></returns>
		public static string StripHtml(string html)
		{
			html = Regex.Replace(html, @"<(.|\n)*?>", string.Empty);
			html = html.Replace("\t", " ");
			html = html.Replace("\r\n", string.Empty);
			html = html.Replace("   ", " ");
			return html.Replace("  ", " ");
		}

		/// <summary>
		/// Fixes a plain text field for display as HTML by replacing carriage returns 
		/// with the appropriate br and p tags for breaks.
		/// </summary>
		/// <param name="String Text">Input string</param>
		/// <returns>Fixed up string</returns>
		public static string DisplayMemo(string htmlText)
		{
			if (htmlText == null)
				return string.Empty;

			htmlText = htmlText.Replace("\r\n", "\r");
			htmlText = htmlText.Replace("\n", "\r");
			//HtmlText = HtmlText.Replace("\r\r","<p>");
			htmlText = htmlText.Replace("\r", "<br />");
			return htmlText;
		}

		/// <summary>
		/// Method that handles handles display of text by breaking text.
		/// Unlike the non-encoded version it encodes any embedded HTML text
		/// </summary>
		/// <param name="text"></param>
		/// <returns></returns>
		public static string DisplayMemoEncoded(string text)
		{
			if (text == null)
				return string.Empty;

			bool PreTag = false;
			if (text.IndexOf("<pre>") > -1)
			{
				text = text.Replace("<pre>", "__pre__");
				text = text.Replace("</pre>", "__/pre__");
				PreTag = true;
			}


			// fix up line breaks into <br><p>
			text = DisplayMemo(HtmlEncode(text)); //HttpUtility.HtmlEncode(Text));

			if (PreTag)
			{
				text = text.Replace("__pre__", "<pre>");
				text = text.Replace("__/pre__", "</pre>");
			}

			return text;
		}

		/// <summary>
		/// HTML-encodes a string and returns the encoded string.
		/// </summary>
		/// <param name="text">The text string to encode. </param>
		/// <returns>The HTML-encoded text.</returns>
		public static string HtmlEncode(string text)
		{
			if (text == null)
				return string.Empty;

			StringBuilder sb = new StringBuilder(text.Length);

			int len = text.Length;
			for (int i = 0; i < len; i++)
			{
				switch (text[i])
				{

					case '<':
						sb.Append("&lt;");
						break;
					case '>':
						sb.Append("&gt;");
						break;
					case '"':
						sb.Append("&quot;");
						break;
					case '&':
						sb.Append("&amp;");
						break;
					default:
						if (text[i] > 159)
						{
							// decimal numeric entity
							sb.Append("&#");
							sb.Append(((int)text[i]).ToString(CultureInfo.InvariantCulture));
							sb.Append(";");
						}
						else
							sb.Append(text[i]);
						break;
				}
			}
			return sb.ToString();
		}

		/// <summary>
		/// Expands links into HTML hyperlinks inside of text or HTML.
		/// </summary>
		/// <param name="text">The text to expand</param>
		/// <param name="target">Target frame where links are displayed</param>
		/// <param name="parseFormattedLinks">Allows parsing of links in the following format [text|www.site.com]</param>
		/// <returns></returns>
		public static string ExpandUrls(string text, string target, bool parseFormattedLinks)
		{
			if (target == null)
				target = string.Empty;

			ExpandUrlsParser Parser = new ExpandUrlsParser();
			Parser.Target = target;
			Parser.ParseFormattedLinks = parseFormattedLinks;
			return Parser.ExpandUrls(text);
		}
		/// <summary>
		/// Expands links into HTML hyperlinks inside of text or HTML.
		/// </summary>
		/// <param name="text">The text to expand</param>
		/// <param name="target">Target frame where links are displayed</param>
		public static string ExpandUrls(string text, string target)
		{
			return ExpandUrls(text, null, false);
		}
		/// <summary>
		/// Expands links into HTML hyperlinks inside of text or HTML.
		/// </summary>
		/// <param name="text">The text to expand</param>
		public static string ExpandUrls(string text)
		{
			return ExpandUrls(text, null, false);
		}

		/// <summary>
		/// Create an Href HTML link
		/// </summary>
		/// <param name="text"></param>
		/// <param name="url"></param>
		/// <param name="target"></param>
		/// <param name="additionalMarkup"></param>
		/// <returns></returns>
		public static string Href(string text, string url, string target, string additionalMarkup)
		{
			return "<a href=\"" + ResolveUrl(url) + "\" " +
				(string.IsNullOrEmpty(target) ? string.Empty : "target=\"" + target + "\" ") +
				(string.IsNullOrEmpty(additionalMarkup) ? string.Empty : additionalMarkup) +
				">" + text + "</a>";
		}

		/// <summary>
		/// Created an Href HTML link
		/// </summary>
		/// <param name="text"></param>
		/// <param name="url"></param>
		/// <returns></returns>
		public static string Href(string text, string url)
		{
			return Href(text, url, null, null);
		}

		/// <summary>
		/// Creates an HREF HTML Link
		/// </summary>
		/// <param name="url"></param>
		public static string Href(string url)
		{
			return Href(url, url, null, null);
		}

		/// <summary>
		/// Returns an IMG link as a string. If the image is null
		/// or empty a blank string is returned.
		/// </summary>
		/// <param name="imageUrl"></param>
		/// <param name="additionalMarkup"></param>
		/// <returns></returns>
		public static string ImgRef(string imageUrl, string additionalMarkup)
		{
			if (string.IsNullOrEmpty(imageUrl))
				return string.Empty;

			string img = "<img src=\"" + ResolveUrl(imageUrl) + "\" ";

			if (!string.IsNullOrEmpty("additionalMarkup"))
				img += additionalMarkup + " ";

			img += "/>";
			return img;
		}

		/// <summary>
		/// Returns an img link as a string. If the image is null
		/// or empty an empty string is returned.
		/// </summary>
		/// <param name="imageUrl"></param>
		/// <returns></returns>
		public static string ImgRef(string imageUrl)
		{
			return ImgRef(imageUrl, null);
		}

		/// <summary>
		/// Resolves a URL based on the current HTTPContext
		/// </summary>
		/// <param name="originalUrl"></param>
		/// <returns></returns>
		internal static string ResolveUrl(string originalUrl)
		{
			if (string.IsNullOrEmpty(originalUrl))
				return string.Empty;

			// Absolute path - just return
			if (originalUrl.IndexOf("://") != -1)
				return originalUrl;

			// Fix up image path for ~ root app dir directory
			if (originalUrl.StartsWith("~"))
			{
				//return VirtualPathUtility.ToAbsolute(originalUrl);
				string newUrl = "";
				if (HttpContext.Current != null)
				{
					newUrl = HttpContext.Current.Request.ApplicationPath +
						  originalUrl.Substring(1);
					newUrl = newUrl.Replace("//", "/"); // must fix up for root path
				}
				else
					// Not context: assume current directory is the base directory
					throw new ArgumentException("Invalid URL: Relative URL not allowed.");

				// Just to be sure fix up any double slashes
				return newUrl;
			}

			return originalUrl;
		}

		/// <summary>
		/// Extracts a string from between a pair of delimiters. Only the first 
		/// instance is found.
		/// </summary>
		/// <param name="source">Input String to work on</param>
		/// <param name="StartDelim">Beginning delimiter</param>
		/// <param name="endDelim">ending delimiter</param>
		/// <param name="CaseInsensitive">Determines whether the search for delimiters is case sensitive</param>
		/// <returns>Extracted string or ""</returns>
		public static string ExtractString(string source, string beginDelim,
										   string endDelim, bool caseSensitive,
										   bool allowMissingEndDelimiter)
		{
			int at1, at2;

			if (string.IsNullOrEmpty(source))
				return string.Empty;

			if (caseSensitive)
			{
				at1 = source.IndexOf(beginDelim);
				if (at1 == -1)
					return string.Empty;

				at2 = source.IndexOf(endDelim, at1 + beginDelim.Length);
			}
			else
			{
				//string Lower = source.ToLower();
				at1 = source.IndexOf(beginDelim, 0, source.Length, StringComparison.OrdinalIgnoreCase);
				if (at1 == -1)
					return string.Empty;

				at2 = source.IndexOf(endDelim, at1 + beginDelim.Length, StringComparison.OrdinalIgnoreCase);
			}

			if (allowMissingEndDelimiter && at2 == -1)
				return source.Substring(at1 + beginDelim.Length);

			if (at1 > -1 && at2 > 1)
				return source.Substring(at1 + beginDelim.Length, at2 - at1 - beginDelim.Length);

			return string.Empty;
		}

		/// <summary>
		/// Extracts a string from between a pair of delimiters. Only the first
		/// instance is found.
		/// <seealso>Class wwUtils</seealso>
		/// </summary>
		/// <param name="source">
		/// Input String to work on
		/// </param>
		/// <param name="beginDelim"></param>
		/// <param name="endDelim">
		/// ending delimiter
		/// </param>
		/// <param name="CaseInSensitive"></param>
		/// <returns>String</returns>
		public static string ExtractString(string source, string beginDelim, string endDelim, bool caseSensitive)
		{
			return ExtractString(source, beginDelim, endDelim, caseSensitive, false);
		}

		/// <summary>
		/// Extracts a string from between a pair of delimiters. Only the first 
		/// instance is found. Search is case insensitive.
		/// </summary>
		/// <param name="source">
		/// Input String to work on
		/// </param>
		/// <param name="StartDelim">
		/// Beginning delimiter
		/// </param>
		/// <param name="endDelim">
		/// ending delimiter
		/// </param>
		/// <returns>Extracted string or string.Empty</returns>
		public static string ExtractString(string source, string beginDelim, string endDelim)
		{
			return ExtractString(source, beginDelim, endDelim, false, false);
		}


		/// <summary>
		/// String replace function that support
		/// </summary>
		/// <param name="origString">Original input string</param>
		/// <param name="findString">The string that is to be replaced</param>
		/// <param name="replaceWith">The replacement string</param>
		/// <param name="instance">Instance of the FindString that is to be found. if Instance = -1 all are replaced</param>
		/// <param name="caseInsensitive">Case insensitivity flag</param>
		/// <returns>updated string or original string if no matches</returns>
		public static string ReplaceStringInstance(string origString, string findString,
												   string replaceWith, int instance,
												   bool caseInsensitive)
		{
			if (instance == -1)
				return ReplaceString(origString, findString, replaceWith, caseInsensitive);

			int at1 = 0;
			for (int x = 0; x < instance; x++)
			{

				if (caseInsensitive)
					at1 = origString.IndexOf(findString, at1, origString.Length - at1, StringComparison.OrdinalIgnoreCase);
				else
					at1 = origString.IndexOf(findString, at1);

				if (at1 == -1)
					return origString;

				if (x < instance - 1)
					at1 += findString.Length;
			}

			return origString.Substring(0, at1) + replaceWith + origString.Substring(at1 + findString.Length);
		}

		/// <summary>
		/// Replaces a substring within a string with another substring with optional case sensitivity turned off.
		/// </summary>
		/// <param name="origString">String to do replacements on</param>
		/// <param name="findString">The string to find</param>
		/// <param name="replaceString">The string to replace found string wiht</param>
		/// <param name="caseInsensitive">If true case insensitive search is performed</param>
		/// <returns>updated string or original string if no matches</returns>
		public static string ReplaceString(string origString, string findString,
										   string replaceString, bool caseInsensitive)
		{
			int at1 = 0;
			while (true)
			{
				if (caseInsensitive)
					at1 = origString.IndexOf(findString, at1, origString.Length - at1, StringComparison.OrdinalIgnoreCase);
				else
					at1 = origString.IndexOf(findString, at1);

				if (at1 == -1)
					break;

				origString = origString.Substring(0, at1) + replaceString + origString.Substring(at1 + findString.Length);

				at1 += replaceString.Length;
			}

			return origString;
		}


		/// <summary>
		/// Determines whether a string is empty (null or zero length)
		/// </summary>
		/// <param name="text">Input string</param>
		/// <returns>true or false</returns>
		public static bool Empty(string text)
		{
			return (text == null || text.Trim().Length == 0);
		}

		/// <summary>
		/// Determines wheter a string is empty (null or zero length)
		/// </summary>
		/// <param name="text">Input string (in object format)</param>
		/// <returns>true or false/returns>
		public static bool Empty(object text)
		{
			return Empty(text as string);
		}

		/// <summary>
		/// Trims a sub string from a string
		/// </summary>
		/// <param name="text"></param>
		/// <param name="textToTrim"></param>
		/// <returns></returns>
		public static string TrimStart(string text, string textToTrim, bool caseInsensitive)
		{
			while (true)
			{

				string match = text.Substring(0, textToTrim.Length);

				if (match == textToTrim ||
					(caseInsensitive && match.ToLower() == textToTrim.ToLower()))
				{
					if (text.Length <= match.Length)
						text = "";
					else
						text = text.Substring(textToTrim.Length);
				}
				else
					break;
			}
			return text;
		}

		/// <summary>
		/// Return a string in proper Case format
		/// </summary>
		/// <param name="Input"></param>
		/// <returns></returns>
		public static string ProperCase(string Input)
		{
			return Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(Input);
		}

		/// <summary>
		/// Takes a phrase and turns it into CamelCase text.
		/// White Space, punctuation and separators are stripped
		/// </summary>
		/// <param name="?"></param>
		public static string ToCamelCase(string phrase)
		{
			if (phrase == null)
				return string.Empty;

			StringBuilder sb = new StringBuilder(phrase.Length);

			// First letter is always upper case
			bool nextUpper = true;

			foreach (char ch in phrase)
			{
				if (char.IsWhiteSpace(ch) || char.IsPunctuation(ch) || char.IsSeparator(ch))
				{
					nextUpper = true;
					continue;
				}

				if (nextUpper)
					sb.Append(char.ToUpper(ch));
				else
					sb.Append(char.ToLower(ch));

				nextUpper = false;
			}

			return sb.ToString();
		}

		/// <summary>
		/// Tries to create a phrase string from CamelCase text.
		/// Will place spaces before capitalized letters.
		/// 
		/// Note that this method may not work for round tripping 
		/// ToCamelCase calls, since ToCamelCase strips more characters
		/// than just spaces.
		/// </summary>
		/// <param name="camelCase"></param>
		/// <returns></returns>
		public static string FromCamelCase(string camelCase)
		{
			if (camelCase == null)
				throw new ArgumentException("Null is not allowed for StringUtils.FromCamelCase");

			StringBuilder sb = new StringBuilder(camelCase.Length + 10);
			bool first = true;
			char lastChar = '\0';

			foreach (char ch in camelCase)
			{
				if (!first &&
					 (char.IsUpper(ch) ||
					   char.IsDigit(ch) && !char.IsDigit(lastChar)))
					sb.Append(' ');

				sb.Append(ch);
				first = false;
				lastChar = ch;
			}

			return sb.ToString(); ;
		}

		/// <summary>
		/// Terminates a string with the given end string/character, but only if the
		/// value specified doesn't already exist and the string is not empty.
		/// </summary>
		/// <param name="?"></param>
		/// <returns></returns>
		public static string TerminateString(string value, string terminator)
		{
			if (string.IsNullOrEmpty(value) || value.EndsWith(terminator))
				return value;

			return value + terminator;
		}

		/// <summary>
		/// Trims a string to a specific number of max characters
		/// </summary>
		/// <param name="value"></param>
		/// <param name="charCount"></param>
		/// <returns></returns>
		public static string TrimTo(string value, int charCount)
		{
			if (value == null)
				return string.Empty;

			if (value.Length > charCount)
				return value.Substring(0, charCount);

			return value;
		}

		/// <summary>
		/// Strips any common white space from all lines of text that have the same
		/// common white space text. Effectively removes common code indentation from
		/// code blocks for example so you can get a left aligned code snippet.
		/// </summary>
		/// <param name="code"></param>
		/// <returns></returns>
		public static string NormalizeIndentation(string code)
		{
			// normalize tabs to 3 spaces
			string text = code.Replace("\t", "   ");

			string[] lines = text.Split(new string[3] { "\r\n", "\r", "\n" }, StringSplitOptions.None);

			// keep track of the smallest indent
			int minPadding = 1000;

			foreach (var line in lines)
			{
				if (line.Length == 0)  // ignore blank lines
					continue;

				int count = 0;
				foreach (char chr in line)
				{
					if (chr == ' ' && count < minPadding)
						count++;
					else
						break;
				}
				if (count == 0)
					return code;

				minPadding = count;
			}

			string strip = new String(' ', minPadding);

			StringBuilder sb = new StringBuilder();
			foreach (var line in lines)
			{
				sb.AppendLine(StringUtils.ReplaceStringInstance(line, strip, "", 1, false));
			}

			return sb.ToString();
		}

		/// <summary>
		/// Returns an abstract of the provided text by returning up to Length characters
		/// of a text string. If the text is truncated a ... is appended.
		/// </summary>
		/// <param name="text">Text to abstract</param>
		/// <param name="length">Number of characters to abstract to</param>
		/// <returns>string</returns>
		public static string TextAbstract(string text, int length)
		{
			if (text == null)
				return string.Empty;

			if (text.Length <= length)
				return text;

			text = text.Substring(0, length);

			text = text.Substring(0, text.LastIndexOf(" "));
			return text + "...";
		}

		/// <summary>
		/// Creates an Abstract from an HTML document. Strips the 
		/// HTML into plain text, then creates an abstract.
		/// </summary>
		/// <param name="html"></param>
		/// <returns></returns>
		public static string HtmlAbstract(string html, int length)
		{
			return TextAbstract(StripHtml(html), length);
		}

		/// <summary>
		/// Simple Logging method that allows quickly writing a string to a file
		/// </summary>
		/// <param name="output"></param>
		/// <param name="filename"></param>
		public static void LogString(string output, string filename)
		{
			StreamWriter Writer = new StreamWriter(filename, true);
			Writer.WriteLine(DateTime.Now.ToString() + " - " + output);
			Writer.Close();
		}

		/// <summary>
		/// Creates short string id based on a GUID hashcode.
		/// Not guaranteed to be unique across machines, but unlikely
		/// to duplicate in medium volume situations.
		/// </summary>
		/// <returns></returns>
		public static string NewStringId()
		{
			return Guid.NewGuid().ToString().GetHashCode().ToString("x");
		}


		/// <summary>
		/// Parses an string into an integer. If the value can't be parsed
		/// a default value is returned instead
		/// </summary>
		/// <param name="input"></param>
		/// <param name="defaultValue"></param>
		/// <param name="formatProvider"></param>
		/// <returns></returns>
		public static int ParseInt(string input, int defaultValue, IFormatProvider numberFormat)
		{
			int val = defaultValue;
			int.TryParse(input, NumberStyles.Any, numberFormat, out val);
			return val;
		}

		/// <summary>
		/// Parses an string into an integer. If the value can't be parsed
		/// a default value is returned instead
		/// </summary>
		/// <param name="input"></param>
		/// <param name="defaultValue"></param>
		/// <returns></returns>
		public static int ParseInt(string input, int defaultValue)
		{
			return ParseInt(input, defaultValue, CultureInfo.CurrentCulture.NumberFormat);
		}

		/// <summary>
		/// Parses an string into an decimal. If the value can't be parsed
		/// a default value is returned instead
		/// </summary>
		/// <param name="input"></param>
		/// <param name="defaultValue"></param>
		/// <returns></returns>
		public static decimal ParseDecimal(string input, decimal defaultValue, IFormatProvider numberFormat)
		{
			decimal val = defaultValue;
			decimal.TryParse(input, NumberStyles.Any, numberFormat, out val);
			return val;
		}

		/// <summary>
		/// Creates a Stream from a string. Internally creates
		/// a memory stream and returns that.
		/// </summary>
		/// <param name="text"></param>
		/// <param name="encoding"></param>
		/// <returns></returns>
		public Stream StringToStream(string text, Encoding encoding)
		{
			MemoryStream ms = new MemoryStream(text.Length * 2);
			byte[] data = encoding.GetBytes(text);
			ms.Write(data, 0, data.Length);
			ms.Position = 0;
			return ms;
		}

		/// <summary>
		/// Creates a Stream from a string. Internally creates
		/// a memory stream and returns that.
		/// </summary>
		/// <param name="text"></param>
		/// <returns></returns>
		public Stream StringToStream(string text)
		{
			return StringToStream(text, Encoding.Default);
		}


		/// <summary>
		/// Retrieves a value from 
		/// </summary>
		/// <param name="propertyString"></param>
		/// <param name="key"></param>
		/// <returns></returns>
		public string GetProperty(string propertyString, string key)
		{
			return StringUtils.ExtractString(propertyString, "<" + key + ">", "</" + key + ">");
		}

		/// <summary>
		/// 
		/// </summary>
		/// <param name="propertyString"></param>
		/// <param name="key"></param>
		/// <param name="value"></param>
		/// <returns></returns>
		public string SetProperty(string propertyString, string key, string value)
		{
			string extract = StringUtils.ExtractString(propertyString, "<" + key + ">", "</" + key + ">");

			if (string.IsNullOrEmpty(value) && extract != string.Empty)
			{
				return propertyString.Replace(extract, "");
			}

			string xmlLine = "<" + key + ">" + value + "</" + key + ">";

			// replace existing
			if (extract != string.Empty)
				return propertyString.Replace(extract, xmlLine);

			// add new
			return propertyString + xmlLine + "\r\n";
		}

		#region UrlEncoding and UrlDecoding without System.Web
		/// <summary>
		/// UrlEncodes a string without the requirement for System.Web
		/// </summary>
		/// <param name="String"></param>
		/// <returns></returns>
		// [Obsolete("Use System.Uri.EscapeDataString instead")]
		public static string UrlEncode(string text)
		{
			if (string.IsNullOrEmpty(text))
				return string.Empty;

			// Sytem.Uri provides reliable parsing
			return System.Uri.EscapeDataString(text);
		}

		/// <summary>
		/// UrlDecodes a string without requiring System.Web
		/// </summary>
		/// <param name="text">String to decode.</param>
		/// <returns>decoded string</returns>
		public static string UrlDecode(string text)
		{
			// pre-process for + sign space formatting since System.Uri doesn't handle it
			// plus literals are encoded as %2b normally so this should be safe
			text = text.Replace("+", " ");
			string decoded = System.Uri.UnescapeDataString(text);
			return decoded;
		}

		/// <summary>
		/// Retrieves a value by key from a UrlEncoded string.
		/// </summary>
		/// <param name="urlEncoded">UrlEncoded String</param>
		/// <param name="key">Key to retrieve value for</param>
		/// <returns>returns the value or "" if the key is not found or the value is blank</returns>
		public static string GetUrlEncodedKey(string urlEncoded, string key)
		{
			urlEncoded = "&" + urlEncoded + "&";

			int Index = urlEncoded.IndexOf("&" + key + "=", StringComparison.OrdinalIgnoreCase);
			if (Index < 0)
				return string.Empty;

			int lnStart = Index + 2 + key.Length;

			int Index2 = urlEncoded.IndexOf("&", lnStart);
			if (Index2 < 0)
				return string.Empty;

			return UrlDecode(urlEncoded.Substring(lnStart, Index2 - lnStart));
		}

		/// <summary>
		/// Allows setting of a value in a UrlEncoded string. If the key doesn't exist
		/// a new one is set, if it exists it's replaced with the new value.
		/// </summary>
		/// <param name="urlEncoded">A UrlEncoded string of key value pairs</param>
		/// <param name="key"></param>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string SetUrlEncodedKey(string urlEncoded, string key, string value)
		{
			/*
			if (!urlEncoded.EndsWith("?") && !urlEncoded.EndsWith("&"))
				urlEncoded += "&";
			*/

			if (!urlEncoded.Contains("?"))
				urlEncoded += "?";
			else
				urlEncoded += "&";


			Match match = Regex.Match(urlEncoded, "[?|&]" + key + "=.*?&");

			if (match == null || string.IsNullOrEmpty(match.Value))
				urlEncoded = urlEncoded + key + "=" + UrlEncode(value) + "&";
			else
				urlEncoded = urlEncoded.Replace(match.Value, match.Value.Substring(0, 1) + key + "=" + UrlEncode(value) + "&");

			return urlEncoded.TrimEnd('&');
		}



		static char[] base36CharArray = "0123456789abcdefghijklmnopqrstuvwxyz".ToCharArray();
		static string base36Chars = "0123456789abcdefghijklmnopqrstuvwxyz";

		/// <summary>
		/// Encodes an integer into a string by mapping to alpha and digits (36 chars)
		/// chars are embedded as lower case
		/// 
		/// Example: 4zx12ss
		/// </summary>
		/// <param name="value"></param>
		/// <returns></returns>
		public static string Base36Encode(long value)
		{
			string returnValue = "";
			bool isNegative = value < 0;
			if (isNegative)
				value = value * -1;

			do
			{
				returnValue = base36CharArray[value % base36CharArray.Length] + returnValue;
				value /= 36;
			} while (value != 0);

			return isNegative ? returnValue + "-" : returnValue;
		}

		/// <summary>
		/// Decodes a base36 encoded string to an integer
		/// </summary>
		/// <param name="input"></param>
		/// <returns></returns>
		public static long Base36Decode(string input)
		{
			bool isNegative = false;
			if (input.EndsWith("-"))
			{
				isNegative = true;
				input = input.Substring(0, input.Length - 1);
			}

			char[] arrInput = input.ToCharArray();
			Array.Reverse(arrInput);
			long returnValue = 0;
			for (long i = 0; i < arrInput.Length; i++)
			{
				long valueindex = base36Chars.IndexOf(arrInput[i]);
				returnValue += Convert.ToInt64(valueindex * Math.Pow(36, i));
			}
			return isNegative ? returnValue * -1 : returnValue;
		}


		#endregion
	}
}