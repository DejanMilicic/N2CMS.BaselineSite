using System;
using System.Net.Mail;
using System.Text.RegularExpressions;

namespace $rootnamespace$.N2Baseline
{
	public static class MailUtils
	{
		public static bool IsValidEmail(string emailAddress)
		{
			if (String.IsNullOrWhiteSpace(emailAddress)) return false;

			return Regex.IsMatch(emailAddress,
				@"^(?("")(""[^""]+?""@)|(([0-9a-z]((\.(?!\.))|[-!#\$%&'\*\+/=\?\^`\{\}\|~\w])*)(?<=[0-9a-z])@))" +
				@"(?(\[)(\[(\d{1,3}\.){3}\d{1,3}\])|(([0-9a-z][-\w]*[0-9a-z]*\.)+[a-z0-9]{2,17}))$"
				);
		}

		public static void SendMail(MailAddress from, MailAddress to, string subject, string body, MailAddress cc = null)
		{
			const string newline = "<br/>";

			if (String.IsNullOrWhiteSpace(@from?.Address))
				return;

			if (String.IsNullOrWhiteSpace(to?.Address))
				return;

			try
			{
				MailMessage mail = new MailMessage();
				mail.From = from;
				mail.To.Add(to);

				if (!String.IsNullOrWhiteSpace(cc?.Address))
					mail.CC.Add(cc);

				mail.Subject = subject;
				mail.Body = body.Replace("\r\n", newline).Replace("\r", newline).Replace("\n", newline);
				mail.IsBodyHtml = true;

				SmtpClient smtp = new SmtpClient();
				smtp.Send(mail);
			}
			catch (Exception ex)
			{
			}
		}
	}
}