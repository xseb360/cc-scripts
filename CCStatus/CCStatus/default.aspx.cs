using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace CCStatus
{
	public partial class _default : System.Web.UI.Page
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
			Response.Write("<BR/>");
			lblOutput.Text = TheStatusDict.ToHtml() + "<BR/>";
		}

		protected void btnClear_Click(object sender, EventArgs e)
		{
			TheStatusDict.Clear();
			TheStatusDict.SaveToFolder(Server.MapPath("~"));

			lblOutput.Text = TheStatusDict.ToHtml() + "<BR/>";
		}

	}
}