
namespace $rootnamespace$.Models.N2Pages
{
	using System.Collections.Generic;
	using System.Linq;

	using N2;
	using N2.Definitions;
	using N2.Details;
	using N2.Integrity;
	using N2.Security;
	using N2.Web;
	using N2.Web.UI;

	using $rootnamespace$.N2Baseline;
	using $rootnamespace$.N2Baseline.Models;

	[PageDefinition(
		Title = "Language Intersection",
		IconClass = "n2-icon-globe n2-gold",
		InstallerVisibility = N2.Installation.InstallerHint.PreferredStartPage)]
	[RestrictParents(typeof(IRootPage))]
	[RestrictCardinality]
	[TabContainer(RecursiveContainers.Settings.Name, RecursiveContainers.Settings.Description, 1000, ContainerName = "LanguagesContainer")]
	[RecursiveContainer("LanguagesContainer", 1000, RequiredPermission = Permission.Administer)]

	public class LanguageIntersection : PageModelBase, IRedirect, ISitesSource
	{
		#region IRedirect Members

		public string RedirectUrl
		{
			get { return this.Children.OfType<StartPage>().Select(sp => sp.Url).FirstOrDefault() ?? this.Url; }
		}

		public ContentItem RedirectTo
		{
			get { return this.Children.OfType<StartPage>().FirstOrDefault(); }
		}

		#endregion

		#region ISitesSource Members

		[EditableText(Title = "Site collection host name (DNS)",
			ContainerName = RecursiveContainers.Site.Name,
			HelpTitle = "Sets a shared host name for all languages on a site. The web server must be configured to accept this host name for this to work.")]
		public virtual string HostName { get; set; }

		public IEnumerable<Site> GetSites()
		{
			if (!string.IsNullOrEmpty(HostName))
				yield return new Site(Find.EnumerateParents(this, null, true).Last().ID, ID, HostName) { Wildcards = true };
		}

		#endregion
	}
}