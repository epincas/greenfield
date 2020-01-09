@isTest
public class DummyDataFactory {
    // METHOD CREATING RECORDS FOR TESTS
    @testSetup static void insertRecord(){
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<1;i++){
            testAccts.add(new Account(Name = 'Testxyz009'));
        }
        insert testAccts;
        List<Account> acctsInserted = [SELECT Id, Name FROM Account WHERE Name ='Testxyz009'];
        System.debug('Account inserted from the testSetup method: '+acctsInserted);
    }
    // FIRST TEST METHOD DELETING RECORD [Test]
    @isTest static void deleteRecords(){
        List<Account> AcctsToDelete = [SELECT Id, Name FROM Account WHERE Name ='Testxyz009'];
        System.debug('Queried Acc from first test method (before deleting)'+AcctsToDelete);
        delete AcctsToDelete;
        List<Account> deteledAccounts = [SELECT Id FROM Account WHERE Name ='Testxyz009'];
        System.debug('Queried Acc from first test method (before deleting) '+deteledAccounts);
    }
    // SECOND TEST METHOD NEEDING THE CREATED RECORDS
    @isTest static void displayRecord(){
        List<Account> qryMethod = [SELECT Id, Name FROM Account];  
        System.debug('Query from a third method: '+qryMethod);
    }
}