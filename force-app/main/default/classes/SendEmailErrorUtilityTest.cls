/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Test class for SendEmailErrorUtility
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Sumit        <sumit.mishra@coacto.co.uk>
* @modifiedBy     Sumit        <sumit.mishra@coacto.co.uk>
* @maintainedBy   Sumit        <sumit.mishra@coacto.co.uk>
* @version        1.0
* @created        2020-03-31
* @modified       2020-03-31
* ────────────────────────────────────────────────────────────────────────────────────────────────── 
*/
@isTest
public class SendEmailErrorUtilityTest {
	@isTest
    public static void testSendEmail(){
        SendEmailErrorUtility.sendEmail(14 , 'Error' , 'Invalid Component');
    }
}