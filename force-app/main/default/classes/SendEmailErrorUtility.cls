/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class is used to send error email
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-30
* @modified       2020-03-30
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
public class SendEmailErrorUtility {
    public static void sendEmail(Integer lineNumber, String Error , String ErrorComponent){
        String emailAddress = Label.Error_Email;
        list<string> emailSet = Label.Error_Email.split(',');
                
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.toAddresses = new list<string>( emailSet );
        message.subject = 'Error in ' + ErrorComponent;
        message.htmlBody = 'Line Number - ' + lineNumber +  '<br/>' + 'Error - ' + Error;
        
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
}