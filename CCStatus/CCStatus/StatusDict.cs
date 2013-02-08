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
		public StatusItem()
		{
		}
		

		public StatusItem(string k, string v)
		{
			Key = k;
			Value = v;
		}

		public string Key { get; set; }
		public string Value { get; set; }
	}


	[Serializable]
	public class StatusDict
	{
		
		Dictionary<string, string> statuses = new Dictionary<string, string>();

		public StatusItem[] StatusArray
		{
			get
			{
				List<StatusItem> statusList = new List<StatusItem>();

				foreach (string key in statuses.Keys)
				{
					statusList.Add(new StatusItem(key, statuses[key]));
				}

				return statusList.ToArray();
			}

			set
			{
				foreach (StatusItem item in value)
				{
					statuses.Add(item.Key, item.Value);
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
				statuses.Add(name, status);
			}
			else
			{
				statuses[name] = status;
			}
		}


		public string ToHtml()
		{
			string s = "";

			foreach (string key in statuses.Keys.OrderBy(key => key))
			{
				s += key.PadRight(8) + ": " + statuses[key] + "<br/>";
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
			{
				return null;
			}
						
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