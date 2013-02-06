using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCStatus
{
	public partial class report : System.Web.UI.Page
	{


		StatusDict TheStatusDict
		{
			get
			{
				if (Application["StatusDict"] == null)
				{
					Application["StatusDict"] = StatusDict.LoadFromFolder(Server.MapPath("~"));
				}

				if (Application["StatusDict"] == null)
				{
					Application["StatusDict"] = new StatusDict();
				}

				return (StatusDict)Application["StatusDict"];
			}
		}



		protected void Page_Load(object sender, EventArgs e)
		{
			if (Request.QueryString["name"] != null && Request.QueryString["status"] != null)
			{
				TheStatusDict.Set(Request.QueryString["name"], DateTime.Now.ToString("HH:mm:ss") + " " + Request.QueryString["status"]);
				TheStatusDict.SaveToFolder(Server.MapPath("~"));
			}
		}
	}
}