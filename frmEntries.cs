﻿using CsvHelper;
using CsvHelper.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Validation;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Newtonsoft.Json.Linq;
using System.Xml;
using System.Xml.Linq;
using System.Collections;
//using System.Xml.Serialization;

namespace h24
{

    public partial class frmEntries : Form
    {
        klc01 db;
        public frmEntries(FrmMain owner)
        {
            InitializeComponent();
            //_owner = owner;
            RefreshEntry_xml();
        }


        private void RefreshEntry_xml()
        {
            using (var db = new klc01())
            {
                var query = (from e in db.entry_xml
                             select new
                             {
                                 id = e.id,
                                 oris_team_id = e.oris_team_id,
                                 class_name = e.class_name,
                                 team_name = e.team_name,
                                 team_short_name = e.team_short_name,
                                 leg = e.leg,
                                 family = e.family,
                                 given = e.given,
                                 gender = e.gender,
                                 country = e.country,
                                 birth_date = e.birth_date,
                                 si_chip = e.si_chip,
                                 note = e.note
                             }
                             ).Distinct().OrderBy(x => x.id).ToList();
                dgEntry_xml.DataSource = query.ToList();
                dgEntry_xml.Refresh();
            }
        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog1 = new OpenFileDialog
            {
                Title = "Browse Entries File - ; csv",

                CheckFileExists = true,
                CheckPathExists = true,

                DefaultExt = "csv",
                Filter = "csv files (*.csv)|*.csv|All files (*.*)|*.*",
                FilterIndex = 2,
                RestoreDirectory = true,

                ReadOnlyChecked = true,
                ShowReadOnly = true
            };

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                tbEntriesFile.Text = openFileDialog1.FileName;
            }
        }

        private void btnShow_Click(object sender, EventArgs e)
        {
            string textFile = tbEntriesFile.Text;

            try
            {
                if (File.Exists(textFile))
                {
                    // Read a text file line by line.  
                    string[] lines = File.ReadAllLines(textFile);

                    foreach (string line in lines)
                    {
                        tbEntries.Text += line;
                        tbEntries.Text += "\n";
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message, ex.Message);
            }

        }

        private void btnUpload_Click(object sender, EventArgs e)
        {
            string textFile = tbEntriesFile.Text;
            try
            {

                if (File.Exists(textFile))
                {
                    var config = new CsvConfiguration(CultureInfo.InvariantCulture)
                    {
                        PrepareHeaderForMatch = args => args.Header.ToLower(),
                        Delimiter = ";",
                        Encoding = Encoding.UTF8,
                        HeaderValidated = null,
                        MissingFieldFound = null,
                    };

                    using (var reader = new StreamReader(textFile))
                    using (var csv = new CsvReader(reader, config))
                    {
                        var records = csv.GetRecords<Entries>();
                        using (var db = new klc01())
                        {
                            foreach (var record in records)
                            {
                                var category = db.categories.Where(b => b.cat_name == record.kat).FirstOrDefault();
                                //DateTime race_end;
                                if (category == null)
                                {
                                    var start_time = db.settings.Where(b => b.config_name == "start_time").FirstOrDefault();
                                    var time_limit = db.settings.Where(b => b.config_name == "default_time_limit").FirstOrDefault();

                                    var newCategory = new categories
                                    {
                                        cat_name = record.kat,
                                        cat_start_time = DateTime.ParseExact(start_time.config_value, "yyyy-MM-dd HH:mm:ss.fff", null),
                                        cat_time_limit = int.Parse(time_limit.config_value)
                                    };

                                    db.categories.Add(newCategory);
                                    db.SaveChanges();
                                    category = db.categories.Where(b => b.cat_name == record.kat).FirstOrDefault();
                                }

                                int cat_id = category.cat_id;
                                DateTime team_start_time = (DateTime)category.cat_start_time;
                                int team_time_limit = category.cat_time_limit ?? 0;

                                List<competitors> Competitor = new List<competitors>();
                                competitors comp1 = new competitors();
                                comp1.bib = record.id.ToString() + "A";
                                comp1.comp_name = record.jmeno1 + " " + record.prijmeni1;
                                comp1.comp_chip_id = record.chip1;
                                comp1.rented_chip = record.rented1;
                                comp1.rank_order = 1;
                                comp1.comp_country = record.country1;
                                comp1.comp_birthday = DateTime.ParseExact(record.nar1, "d.M.yyyy", null);
                                comp1.comp_valid_flag = true;
                                comp1.as_of_date = DateTime.Now;
                                Competitor.Add(comp1);

                                competitors comp2 = new competitors();
                                comp2.bib = record.id.ToString() + "B";
                                comp2.comp_name = record.jmeno2 + " " + record.prijmeni2;
                                comp2.comp_chip_id = record.chip2;
                                comp2.rented_chip = record.rented2;
                                comp2.rank_order = 2;
                                comp2.comp_country = record.country2;
                                if (!String.IsNullOrEmpty(record.nar2))
                                    comp2.comp_birthday = DateTime.ParseExact(record.nar2, "d.M.yyyy", null);
                                comp2.comp_valid_flag = true;
                                comp2.as_of_date = DateTime.Now;
                                Competitor.Add(comp2);

                                competitors comp3 = new competitors();
                                comp3.bib = record.id.ToString() + "C";
                                comp3.comp_name = record.jmeno3 + " " + record.prijmeni3;
                                comp3.comp_chip_id = record.chip3;
                                comp3.rented_chip = record.rented3;
                                comp3.rank_order = 3;
                                comp3.comp_country = record.country3;
                                if (!String.IsNullOrEmpty(record.nar3))
                                    comp3.comp_birthday = DateTime.ParseExact(record.nar3, "d.M.yyyy", null);
                                comp3.comp_valid_flag = true;
                                comp3.as_of_date = DateTime.Now;
                                Competitor.Add(comp3);

                                if (record.prijmeni4 != "0")
                                {
                                    competitors comp4 = new competitors();
                                    comp4.bib = record.id.ToString() + "D";
                                    comp4.comp_name = record.jmeno4 + " " + record.prijmeni4;
                                    comp4.comp_chip_id = record.chip4;
                                    comp4.rented_chip = record.rented4;
                                    comp4.rank_order = 4;
                                    comp4.comp_country = record.country4;
                                    if (!String.IsNullOrEmpty(record.nar4))
                                        comp4.comp_birthday = DateTime.ParseExact(record.nar4, "d.M.yyyy", null);
                                    comp4.comp_valid_flag = true;
                                    comp4.as_of_date = DateTime.Now;
                                    Competitor.Add(comp4);
                                }

                                if (record.prijmeni5 != "0")
                                {
                                    competitors comp5 = new competitors();
                                    comp5.bib = record.id.ToString() + "E";
                                    comp5.comp_name = record.jmeno5 + " " + record.prijmeni5;
                                    comp5.comp_chip_id = record.chip5;
                                    comp5.rented_chip = record.rented5;
                                    comp5.rank_order = 5;
                                    comp5.comp_country = record.country5;
                                    comp5.comp_birthday = DateTime.ParseExact(record.nar5, "d.M.yyyy", null);
                                    comp5.comp_valid_flag = true;
                                    comp5.as_of_date = DateTime.Now;
                                    Competitor.Add(comp5);
                                }

                                if (record.prijmeni6 != "0")
                                {
                                    competitors comp6 = new competitors();
                                    comp6.bib = record.id.ToString() + "F";
                                    comp6.comp_name = record.jmeno6 + " " + record.prijmeni6;
                                    comp6.comp_chip_id = record.chip6;
                                    comp6.rented_chip = record.rented6;
                                    comp6.rank_order = 6;
                                    comp6.comp_country = record.country6;
                                    comp6.comp_birthday = DateTime.ParseExact(record.nar6, "d.M.yyyy", null);
                                    comp6.comp_valid_flag = true;
                                    comp6.as_of_date = DateTime.Now;
                                    Competitor.Add(comp6);
                                }

                                var newTeam = new teams
                                {
                                    team_nr = record.id,
                                    team_name = record.team,
                                    team_did_start = true,
                                    cat_id = cat_id,
                                    competitors = Competitor,
                                    race_end = team_start_time.AddMinutes(team_time_limit),
                                    as_of_date = DateTime.Now
                                };

                                db.teams.Add(newTeam);
                                db.SaveChanges();
                            }
                        }
                    }
                }
                dgEntries.DataSource = db.competitors.ToList();
                dgEntries.Refresh();
                MessageBox.Show("Entries uploaded");
                MessageBox.Show("Don't forgett to assign Farsta legs!");

            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message, ex.Message);
            }
        }

        private void cbAllowDeletion_CheckedChanged(object sender, EventArgs e)
        {
            if (cbAllowDeletion.Checked)
                btnClearCompetitors.Enabled = true;
            else
                btnClearCompetitors.Enabled = false;
        }

        private void frmEntries_Load(object sender, EventArgs e)
        {
            this.dgEntries_refresh();
        }

        private void dgEntries_refresh()
        {
            db = new klc01();

            var query = (from t in db.teams
                         join c in db.competitors on t.team_id equals c.team_id
                         join ca in db.categories on t.cat_id equals ca.cat_id
                         select new
                         {
                             t.team_id,
                             t.team_nr,
                             t.team_name,
                             t.team_did_start,
                             t.team_status,
                             t.race_end,
                             c.comp_name,
                             c.bib,
                             c.rented_chip,
                             c.rank_order,
                             c.comp_withdrawn,
                             c.comp_status,
                             c.comp_country,
                             c.comp_birthday,
                             ca.cat_name,
                             ca.cat_start_time,
                             ca.cat_time_limit
                         }).OrderBy(x => x.team_id).ToList();

            dgEntries.DataSource = db.v_comp_teams.ToList();
            dgEntries.Refresh();

        }
        private void btnClearCompetitors_Click(object sender, EventArgs e)
        {
            db = new klc01();

            try
            {
                List<legs> AllLegs = db.legs.ToList();
                db.legs.RemoveRange(AllLegs);

                List<competitors> AllCompetitors = db.competitors.ToList();
                db.competitors.RemoveRange(AllCompetitors);

                db.SaveChanges();

                List<teams> AllTeams = db.teams.ToList();
                db.teams.RemoveRange(AllTeams);

                db.SaveChanges();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message);
            }


            this.dgEntries_refresh();
            /*            db = new klc01();

                        string q = "SELECT" +
                            "   t.team_id," +
                            "   t.team_nr," +
                            "	t.team_name, " +
                            "	t.team_did_start, " +
                            "	t.team_status, " +
                            "	t.race_end, " +
                            "   c.comp_id, " +
                            "	c.comp_name," +
                            "	c.bib," +
                            "	c.rented_chip," +
                            "	c.rank_order," +
                            "	c.comp_withdrawn," +
                            "	c.comp_status," +
                            "	c.comp_country," +
                            "	c.comp_birthday," +
                            "	ca.cat_name," +
                            "	ca.cat_start_time," +
                            "	ca.cat_time_limit " +
                            "FROM teams AS t " +
                            "INNER JOIN competitors AS c ON t.team_id = c.team_id " +
                            "INNER JOIN categories AS ca ON t.cat_id = ca.cat_id ";
                        var tms = db.competitors.SqlQuery(q).ToList();

                        dgEntries.DataSource = tms;
                        dgEntries.Refresh();*/

        }

        private void btClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private async void BtnPost_Click(object sender, EventArgs e)
        {
            /*
            Task<string> getAccessToken = NewCard.LoginClient();
            string token = await getAccessToken;
            MessageBox.Show("response:" + token);
            */
            if(this.ChbTruncate.Checked)
                _ = NewCard.TruncateEntries();
            _ = NewCard.PostEntries();
        }

        private void BtnRegisterClient_Click(object sender, EventArgs e)
        {
            _ = NewCard.RegisterClient();
        }

        private void BtnStarListXml_Click(object sender, EventArgs e)
        {
            XmlWriterSettings settings = new XmlWriterSettings();
            settings.Indent = true;
            settings.IndentChars = "\t";
            settings.NewLineOnAttributes = true;

            using (XmlWriter writer = XmlWriter.Create("StartList.xml", settings))
            {
                writer.WriteStartElement("StartList", "http://www.orienteering.org/datastandard/3.0");
                writer.WriteAttributeString("xmlns", "", null, "http://www.orienteering.org/datastandard/3.0");
                writer.WriteAttributeString("xmlns", "xsi", null, "http://www.w3.org/2001/XMLSchema-instance");
                writer.WriteAttributeString("iofVersion", "3.0");
                writer.WriteAttributeString("createTime", DateTime.Now.ToString("yyyy-MM-ddTHH:mm:sszzz"));
                writer.WriteAttributeString("creator", "h24");

                writer.WriteStartElement("Event");
                writer.WriteStartElement("Name");
                writer.WriteString("h24");
                writer.WriteEndElement();

                writer.WriteStartElement("StartTime");
                writer.WriteStartElement("Date");
                writer.WriteString("2022-12-13");
                writer.WriteEndElement();//Date
                writer.WriteStartElement("Time");
                writer.WriteString("8:00:00+01:00");
                writer.WriteEndElement();//Time
                writer.WriteEndElement();//StartTime
                writer.WriteStartElement("EndTime");
                writer.WriteStartElement("Date");
                writer.WriteString("2022-12-14");
                writer.WriteEndElement();//Date
                writer.WriteStartElement("Time");
                writer.WriteString("8:00:00+01:00");
                writer.WriteEndElement();//Time
                writer.WriteEndElement();//EndTime
                writer.WriteEndElement();//Event

                db = new klc01();
                List<v_comp_teams> AllCompetitors = db.v_comp_teams.ToList();
                string cat_name_prev = "";

                writer.WriteStartElement("ClassStart");
                foreach (var comp in AllCompetitors)
                {

                    if (comp.cat_name != cat_name_prev)
                    {
                        writer.WriteStartElement("ClassStart");
                        writer.WriteStartElement("Class");
                    }


                    cat_name_prev = comp.cat_name;
                }

                writer.WriteEndElement();
                writer.Flush();
            }

        }

        private static void RemoveAllNamespaces(XDocument xDoc)
        {
            foreach (var node in xDoc.Root.DescendantsAndSelf())
            {
                node.Name = node.Name.LocalName;
            }
        }

        private async void BtnUploadXML_Click(object sender, EventArgs e)
        {

            var finalResult = await NewCard.OrisGetEntries();

            tbEntries.Text = NewCard.FormatXml(finalResult);
            //string textFile = tbEntriesFile.Text;
            try
            {

                XDocument xDoc = XDocument.Parse(finalResult);
                //XDocument xDoc = XDocument.Load(@"c:\k\oris_entries_20230319_182259.xml");
                RemoveAllNamespaces(xDoc);

                using (var db = new klc01())
                {
                    db.Database.ExecuteSqlCommand("TRUNCATE TABLE entry_xml");

                    var items = from item in xDoc.Descendants("EntryList").Elements("TeamEntry")
                                select new
                                {
                                    id = Int32.Parse(item.Element("Id").Value),
                                    name = item.Element("Name").Value,
                                    organization = item.Element("Organisation").Element("Name").Value,
                                    class_name = item.Element("Class").Element("Name").Value,
                                    note = item.Element("Extensions")?.Element("Note")?.Value ?? "",
                                    TeamEntryPerson = item.Descendants("TeamEntryPerson"),
                                };

                    int id;
                    string team_name;
                    string team_short_name;
                    string class_name;
                    int leg;
                    string family;
                    string given;
                    string gender;
                    string country;
                    string birth_date;
                    int si_chip;
                    string note;

                    foreach (var team_person in items)
                    {
                        id = team_person.id;
                        team_name = team_person.name;
                        team_short_name = team_person.organization;
                        class_name = team_person.class_name;
                        note = team_person.note;

                        foreach (var TeamEntryPerson in team_person.TeamEntryPerson)
                        {
                            leg = Int32.Parse(TeamEntryPerson.Element("Leg").Value);
                            family = TeamEntryPerson.Element("Person")?.Element("Name")?.Element("Family")?.Value ?? "";
                            given = TeamEntryPerson.Element("Person")?.Element("Name")?.Element("Given")?.Value ?? "";
                            gender = TeamEntryPerson.Element("Person")?.Attribute("sex")?.Value ?? "";
                            country = TeamEntryPerson.Element("Person")?.Element("Nationality")?.Attribute("code")?.Value ?? "";
                            birth_date = TeamEntryPerson.Element("Person")?.Element("BirthDate")?.Value ?? "";
                            if (TeamEntryPerson.Element("ControlCard")?.Value != null)
                                si_chip = Int32.Parse(TeamEntryPerson.Element("ControlCard").Value);
                            else
                                si_chip = 0;

                            //save                    
                            var newEntry = new entry_xml
                            {
                                oris_team_id = id,
                                class_name = class_name,
                                team_name = team_name,
                                team_short_name = team_short_name,
                                leg = leg,
                                family = family,
                                given = given,
                                gender = gender,
                                country = country,
                                birth_date = birth_date,
                                si_chip = si_chip,
                                note = note
                            };
                            db.entry_xml.Add(newEntry);
                            db.SaveChanges();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error: " + ex.Message, ex.Message);
            }

            RefreshEntry_xml();
        }

        private void BtInsertXmlEntries_Click(object sender, EventArgs e)
        {
            var a = db.sp_ins_xml_entries();
            MessageBox.Show("Inserted: " + a.ToString());

            db.Database.ExecuteSqlCommand("TRUNCATE TABLE entry_xml");
        }

        private void BtInsertCatagories_Click(object sender, EventArgs e)
        {

            using (var db = new klc01())
            {
                var clasesToInsert = db.entry_xml
                          .Where(q => !db.categories.Select(r => r.cat_name).Contains(q.class_name))
                          .Select(g => new { g.class_name })
                          .Distinct()
                          .OrderBy(f => f.class_name)
                          .ToList();

                foreach (var oneClass in clasesToInsert)
                {
                    var start_time = db.settings.Where(b => b.config_name == "start_time").FirstOrDefault();

                    string digits = new string(oneClass.class_name.ToString().TakeWhile(c => !Char.IsLetter(c)).ToArray());
                    int time_limit;
                    if (Int16.Parse(digits) > 0)
                        time_limit = Int16.Parse(digits) * 60;
                    else
                        time_limit = Int16.Parse(db.settings.Where(b => b.config_name == "default_time_limit").FirstOrDefault().config_value.ToString());

                    var newClass = new categories
                    {
                        cat_name = oneClass.class_name.ToString(),
                        as_of_date = DateTime.Now,
                        cat_start_time = DateTime.ParseExact(start_time.config_value, "yyyy-MM-dd HH:mm:ss.fff", null),
                        cat_time_limit = time_limit,
                        valid = true,
                    };
                    db.categories.Add(newClass);
                    db.SaveChanges();
                }
            }
        }

        private void BtEntryRefresh_Click(object sender, EventArgs e)
        {
            RefreshEntry_xml();
        }

        private void dgEntry_xml_CellEndEdit(object sender, DataGridViewCellEventArgs e)
        {
            db.SaveChanges();
        }
    }
}
