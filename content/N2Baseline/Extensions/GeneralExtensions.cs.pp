using System;

namespace $rootnamespace$.N2Baseline.Extensions
{
	public static class GeneralExtensions
	{
		public static int Int(this string stringValue, int defaultValue = 0)
		{
			if (stringValue == null) return defaultValue;
			int integer = Int32.TryParse(stringValue, out integer) ? integer : defaultValue;
			return integer;
		}
	}
}