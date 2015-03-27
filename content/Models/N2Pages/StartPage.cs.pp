
namespace $rootnamespace$.Models.N2Pages
{
	using System.Globalization;

	using N2;
	using N2.Definitions;
	using N2.Details;
	using N2.Engine.Globalization;
	using N2.Integrity;
	using N2.Security;
	using N2.Web.UI;

	using $rootnamespace$.N2Baseline;
	using $rootnamespace$.N2Baseline.Models;

	[PageDefinition(
		Title = "Start Page",
		Description = "The topmost node of a site. This can be placed below a language intersection to also represent a language",
		IconClass = "icon-globe",
		InstallerVisibility = N2.Installation.InstallerHint.PreferredStartPage)]
	[RestrictParents(typeof(IRootPage), typeof(LanguageIntersection))]
	[RecursiveContainer(RecursiveContainers.Settings.Name, 1000)]
	[RecursiveContainer(RecursiveContainers.Site.Name, 1010, RequiredPermission = Permission.Administer)]

	public class StartPage : PublicPageModelBase, IStartPage, IStructuralPage, ILanguage
	{
		#region Tab : Content



		#endregion

		#region ILanguage Members

		public string FlagUrl
		{
			get
			{
				if (string.IsNullOrEmpty(this.LanguageCode))
					return "";

				string[] parts = this.LanguageCode.Split('-');
				return N2.Web.Url.ResolveTokens(string.Format("~/N2/Resources/Img/Flags/{0}.png", parts[parts.Length - 1].ToLower()));
			}
		}

		[EditableLanguagesDropDown("Language", 100, ContainerName = RecursiveContainers.Settings.Name)]
		public virtual string LanguageCode { get; set; }

		[EditableTextBox(Title = "Native Language Name", SortOrder = 101, DefaultValue = "", ContainerName = RecursiveContainers.Settings.Name)]
		public virtual string LanguageNativeName { get; set; }

		public string LanguageTitle
		{
			get
			{
				if (string.IsNullOrEmpty(this.LanguageCode))
					return "";
				else
					return new CultureInfo(this.LanguageCode).DisplayName;
			}
		}

		#endregion
	}
}