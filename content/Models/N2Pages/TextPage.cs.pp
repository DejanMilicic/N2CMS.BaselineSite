
namespace $rootnamespace$.Models.N2Pages
{
	using N2;
	using N2.Details;
	using N2.Integrity;

	using $rootnamespace$.N2Baseline;
	using $rootnamespace$.N2Baseline.Models;

	[PageDefinition(Title = "TextPage", IconClass = "icon-align-justify")]

	[RestrictParents(typeof(StartPage), typeof(TextPage))]
	//[AvailableZone("Content", "Content")]
	public class TextPage : PublicPageModelBase
	{
		#region Tab : Content

		[EditableText(Title = "Heading", DefaultValue = "", SortOrder = 100, ContainerName = Tabs.Content.Name)]
		public virtual string Heading { get; set; }

		[EditableFreeTextArea(Title = "Text", DefaultValue = "", SortOrder = 110, ContainerName = Tabs.Content.Name)]
		public virtual string Text { get; set; }

		#endregion
	}
}