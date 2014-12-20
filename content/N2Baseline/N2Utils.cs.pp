
namespace $rootnamespace$.N2Baseline
{
	using System.Collections.Generic;
	using System.Linq;
	using $rootnamespace$.Models.N2DTO;
	using N2;

	public class N2Utils
	{
		public static List<MenuItem> GetMenuItems(
			ContentItem startPage = null,
			ContentItem page = null,
			int levels = 1,
			bool includeStartPage = true)
		{
			if (page == null) page = Fetch.CurrentPage;
			if (startPage == null) startPage = Fetch.StartPage;

			List<MenuItem> items = new List<MenuItem>();

			List<ContentItem> ancestors = Fetch.Ancestors(page).ToList();
			var firstLevelChildren = Fetch.Children(parent: startPage, onlyVisible: true);

			items.AddRange(firstLevelChildren.Select(firstLevelChild =>
				new MenuItem
				{
					Title = firstLevelChild.Title,
					Url = firstLevelChild.Url,
					Active = ancestors.Contains(firstLevelChild),
					Children = (levels > 1) ? Fetch.Children(parent: firstLevelChild, onlyVisible: true).Select(secondLevelChild =>
						new MenuItem
						{
							Title = secondLevelChild.Title,
							Url = secondLevelChild.Url,
							Active = ancestors.Contains(secondLevelChild),
							Children = (levels > 2) ? Fetch.Children(parent: secondLevelChild, onlyVisible: true).Select(thirdLevelChild =>
								new MenuItem()
								{
									Title = thirdLevelChild.Title,
									Url = thirdLevelChild.Url,
									Active = ancestors.Contains(thirdLevelChild),
									Children = new List<MenuItem>()
								}
							).ToList()
							:
							new List<MenuItem>()
						}
					).ToList()
					:
					new List<MenuItem>()
				}));

			if (includeStartPage)
			{
				items.Insert(0, new MenuItem { Title = startPage.Title, Url = startPage.Url, Active = (page.Url == startPage.Url), Children = new List<MenuItem>() });
			}

			return items;
		}
	}
}