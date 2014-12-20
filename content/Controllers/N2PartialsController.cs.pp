
namespace $rootnamespace$.Controllers
{
	using System.Collections.Generic;
	using System.Web.Mvc;

	using $rootnamespace$.N2Baseline;
	using Models.N2DTO;
	using Models.N2Pages;

	public class N2PartialsController : Controller
	{
		public ActionResult TopNavigation()
		{
			Navigation navigation = new Navigation();

			var startPage = Fetch.Closest<StartPage>();

			if (startPage == null)
			{
				navigation.StartPage = new StartPage();
			}
			else
			{
				navigation.MenuItems = N2Utils.GetMenuItems(startPage, Fetch.CurrentPage, levels: 2, includeStartPage: false);
			}

			return this.PartialView("N2Partials/TopNavigation", navigation);
		}
	}
}