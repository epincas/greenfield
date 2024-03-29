# EXERCISES TO PRACTICE APEX:

Implement the below challenges with apex only (i.e. without leveraging any Point & Clic / Configuration functionality of Salesforce such as Roll-Up Summary Field, Flows).

## Challenge # 1:
Create a "Counter" field on the Case standard Object that will count and display the number of its related children Cases.
When a new child Case is added to the a parent Case, the "Counter" field should automatically be updated (same behaviour when a child case is removed from that parent).

## Challenge # 2:
When the Status (standard) field on the parent Case is changed to 'Closed', then all its children Cases should also be automatically closed.

## Challenge # 3 (pending to develop):
- Implement an Email-2-Case (Configuration);
- Implement a Web-2-Case (Configuration);

Challenge: when a new Case is inserted in Salesforce (either through Email-to-Case or Web-to-Case), automatically search for specific keywords in the Subject and Body/Description of the new Case AND assign a specific Type (standard Case.Type field) to the Case depending on the keywords found.

Allow a System Admin to predefine a dictionary of as many Keywords=Case.Type as needed in a Custom Metadata Type. Example:
If Keyword = 'question' --> Case.Type = Inquiry;
If keyword = 'problem' --> Case.Type = Complaint;

## Challenge # 4 (pending to implement):
When a Case with Origin = Email-2-Case or Web-2-Case is inserted in Salesforce, automatically respond the sender with an email based on a Lightning Email Template on the following deadlines:
- If the Case.Type = Inquiry ==> fire a response email message immediately with a specific note including the word "Inquiry" (like "thank you for your Inquiry";
  If Case.Status != Responded OR Closed, send another scheduled email message 2 Business Days after the Case.CreatedDate;
- If the Case.Type = Complaint ==> fire a response email message immediately; If Case.Status != Responded OR Closed, send another scheduled email message 5 Business Days after the Case.CreatedDate;


