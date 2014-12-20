
namespace $rootnamespace$.Models.N2DTO
{
	using System.Collections.Generic;

	using N2Pages;

	public class Navigation
	{
		public Navigation() 
		{
			this.MenuItems = new List<MenuItem>();
		}

		public StartPage StartPage { get; set; }
		public List<MenuItem> MenuItems { get; set; }
	}

	public class MenuItem
	{
		public MenuItem()
		{
			this.Children = new List<MenuItem>();
		}

		public string Title { get; set; }
		public string Url { get; set; }
		public bool Active { get; set; }

		public List<MenuItem> Children { get; set; }		
	}
}