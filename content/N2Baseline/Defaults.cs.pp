
namespace $rootnamespace$.N2Baseline
{
	using System.Collections.Generic;
	using System.Linq;
	using System.Web;

	using N2;
	using N2.Definitions;

	using $rootnamespace$.Models.N2Pages;

	public static class Defaults
	{
		/// <summary>
		/// Picks the translation best matching the browser-language or the first translation in the list
		/// </summary>
		/// <param name="request"></param>
		/// <param name="currentPage"></param>
		/// <returns></returns>
		public static ContentItem SelectLanguage(this HttpRequestBase request, ContentItem currentPage)
		{
			var start = Find.ClosestOf<IStartPage>(currentPage) ?? N2.Find.StartPage;
			if (start == null) return null;

			if (start is LanguageIntersection)
			{
				var translations = GetTranslations(currentPage).ToList();

				if (request.UserLanguages == null)
					return translations.FirstOrDefault();
				
				var selectedlanguage = request.UserLanguages.Select(ul => translations.FirstOrDefault(t => t.LanguageCode == ul))
					.Where(t => t != null)
					.FirstOrDefault();
				return selectedlanguage ?? translations.FirstOrDefault();
			}

			return start;
		}

		private static IEnumerable<StartPage> GetTranslations(ContentItem currentPage)
		{
			return currentPage.GetChildren().OfType<StartPage>();
		}
	}
}