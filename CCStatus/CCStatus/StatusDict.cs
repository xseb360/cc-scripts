using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using System.Xml.Serialization;

namespace CCStatus
{

	[Serializable]
	public class StatusItem
	{

		private string statusText;

		public string Key { get; set; }

		public string StatusText 
		{
			get
			{
				return statusText;
			}

			set
			{
				statusText = value;
				TimeStamp = DateTime.Now;
			}
		}
		public DateTime TimeStamp { get; set; }

		public StatusItem()
		{
		}


		public string ToHtml()
		{
			return Key.PadRight(8) + ": " + TimeStamp.ToString("HH:mm:ss") + " " + StatusText;
		}
	}


	[Serializable]
	public class StatusDict
	{

		Dictionary<string, StatusItem> statuses = new Dictionary<string, StatusItem>();

		public StatusItem[] StatusArray
		{
			get
			{
				List<StatusItem> statusList = new List<StatusItem>();

				foreach (string key in statuses.Keys)
				{
					statusList.Add(statuses[key]);
				}

				return statusList.ToArray();
			}

			set
			{
				foreach (StatusItem item in value)
				{
					statuses.Add(item.Key, item);
				}
			}
		}



		public StatusDict()
		{
		}


		public void Set(string name, string status)
		{
			if (!statuses.ContainsKey(name))
			{
				StatusItem item = new StatusItem();
				item.Key = name;
				item.StatusText = status;

				statuses.Add(name, item);
			}
			else
			{
				statuses[name].StatusText = status;
			}
		}


		public string ToHtml()
		{
			string s = "";

			s += "<br/>";
			s += "ONLINE Turtles";
			s += "<br/>";

			foreach (string key in statuses.Keys.OrderBy(key => key))
			{
				if (DateTime.Now - statuses[key].TimeStamp < new TimeSpan(0, 15, 0))
					s += statuses[key].ToHtml() + "<br/>";
			}

			s += "<br/>";
			s += "<br/>";
			s += "OFFLINE Turtles";
			s += "<br/>";

			foreach (string key in statuses.Keys.OrderBy(key => key))
			{
				if (DateTime.Now - statuses[key].TimeStamp >= new TimeSpan(0, 15, 0))
					s += statuses[key].ToHtml() + "<br/>";
			}

			return s;
		}

	
		static public StatusDict LoadFromFolder(string folder)
		{
			return LoadFromFile(folder.TrimEnd('\\') + "\\" + "StatusDict.xml");
		}


		static public StatusDict LoadFromFile(string filename)
		{
			//File.Delete(filename);

			if (!File.Exists(filename))
				return null;
			
						
			StreamReader sr = new StreamReader(filename);

			//string temp = sr.ReadToEnd();

			XmlSerializer xs = new XmlSerializer(typeof(StatusDict));
			StatusDict destSettings = (StatusDict)xs.Deserialize(sr);
			sr.Close();
			return destSettings;
		}

		public void SaveToFolder(string folder)
		{
			SaveToFile(folder + "\\" + "StatusDict.xml");
		}

		public void SaveToFile(string filename)
		{
			if (File.Exists(filename))
			{
				File.Delete(filename);
			}

			StreamWriter sw = new StreamWriter(filename);

			XmlSerializer xs = new XmlSerializer(this.GetType());
			xs.Serialize(sw, this);
			sw.Flush();
			sw.Close();
		}

		public void Clear()
		{
			statuses.Clear();
		}
	}
}