# Exercises to practice Apex

## Exercise:
Implement the below challenges with apex only (i.e. without leveraging any standard functionality of Salesforce such as Roll-Up Summary Field, Process Builder or Flows).

### Challenge # 1:
Create a "Counter" field on the Case standard sObject that will count and display its number of related children Cases. 
When a new child Case is added to the a parent Case, the "Counter" field should automatically be updated (same behaviour when a child case is removed from that parent).

### Challenge # 2:
When the standad Status field on the parent Case is changed to 'Closed', then all its children Cases should also be automatically closed .

### Challenge # 3 (pending to implement):
- Implement Email-2-Case;
- Implement Web-2-Case;
- When a new Case is inserted in Salesforce, automatically search for specific keywords in the Subject and Body/Description of the Case and assign a Type (standard Case.Type field) to the Case.
(List of Keywords: .....<decide yourself>);
  Allow a System Admin to add as Keywords in a Custom Metadata Type;

### Challenge # 4 (pending to implement):
When a Case with Origin = Email-2-Case or Web-2-Case is inserted in Salesforce, automatically respond the sender with an email based on a Lightning Email Template on the following deadlines:
- If the Case.Type = abc ==> fire the respond email immediately AND 2 Business Days after the Case.CreatedDate;
- If the Case.Type = xyz ==> fire the respond email immediately AND 5 Business Days after the Case.CreatedDate;


