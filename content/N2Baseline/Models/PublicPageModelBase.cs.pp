
namespace $rootnamespace$.N2Baseline.Models
{
	using N2.Details;
	using N2.Web.UI;

	[SidebarContainer(Sidebars.Seo.Name, SortOrder = 7, HeadingText = Sidebars.Seo.Description)]
	public abstract class PublicPageModelBase : PageModelBase
	{
		#region Sidebar : Seo

		[EditableText(Title = "Meta Title", DefaultValue = "", SortOrder = 100, ContainerName = Sidebars.Seo.Name)]
		public virtual string MetaTitle
		{
			get { return GetDetail("MetaTitle", this.Title); }
			set { SetDetail("MetaTitle", value, this.Title); }
		}

		[EditableText(Title = "Meta Description", DefaultValue = "", SortOrder = 110, ContainerName = Sidebars.Seo.Name)]
		public virtual string MetaDescription { get; set; }

		#endregion
	}
}