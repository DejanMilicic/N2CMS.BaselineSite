
namespace $rootnamespace$.N2Baseline.Models
{
	using N2.Definitions;
	using N2.Details;
	using N2.Integrity;
	using N2.Web.UI;

	/// <summary>
	/// Base implementation for pages on a site.
	/// </summary>
	[WithEditableTitle("Title", 4, Focus = false, ContainerName = "")]

	[SidebarContainer(Sidebars.Metadata.Name, SortOrder = 100, HeadingText = Sidebars.Metadata.Description)]
	[WithEditableVisibility(Title = "Display in navigation", SortOrder = 13, ContainerName = Sidebars.Metadata.Name)]
	[WithEditableName(Title = "URL segment", SortOrder = 14, ContainerName = Sidebars.Metadata.Name)]
	[Separator("TitleSeparator", 16, ContainerName = Sidebars.Metadata.Name)]
	[WithEditablePublishedRange(Title = "Published Between", BetweenText = " and ", SortOrder = 30, ContainerName = Sidebars.Metadata.Name)]
	
	[TabContainer(Tabs.Content.Name, Tabs.Content.Description, 100)]
	[RestrictParents(typeof(IPage))]

	public abstract class PageModelBase : N2.ContentItem, IPage
	{
	}
}