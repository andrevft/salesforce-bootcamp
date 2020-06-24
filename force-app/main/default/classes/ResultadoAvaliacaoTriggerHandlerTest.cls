@IsTest
Private class ResultadoAvaliacaoTriggerHandlerTest {

    @TestSetup
    static void makeData() {
        Account studentAccount = new Account (Name = 'John Doh');
        Insert studentAccount;

        Contact studentContact = new Contact(
            FirstName = 'John',
            LastName = 'Doh',
            AccountId = studentAccount.Id
        );
        insert studentContact;

        Product2 course = new Product2(Name='Course 1');
        insert course;

        Disciplina__c disciplina = new Disciplina__c(
            Name = 'Salesforce Essentials 101',
            Produto__c = course.Id
        );
        insert disciplina;

        Avalia_o__c avaliacao = new Avalia_o__c(
            Disciplina__c = disciplina.Id,
            Total_de_pontos__c = 100,
            RecordTypeId = Schema.Avalia_o__c.getSObjectType().getDescribe().getRecordTypeInfosByDeveloperName().get('TrabalhoPratico').getRecordTypeId()
        );
        insert avaliacao;

        Resultado_da_avalia_o__c resultado = new Resultado_da_avalia_o__c(
            Avalia_o__c = avaliacao.Id,
            Aluno__c = studentContact.Id,
            Nota__c = 100
        );
        insert resultado;
    }

    @IsTest
    static void run_with_current_user() {

        User u = new User(
            Alias = 'alias',
            Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Permissionsi',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey='America/Los_Angeles',
            UserName='user' + System.now().getTime() + '@testorg.com'
        );
        insert u;

        List<String> permissionSetsNames = new List<String>{ 'GerenciamentoUniCRM' };
        List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();

        for (PermissionSet ps : [SELECT Id FROM PermissionSet WHERE Name IN :permissionSetsNames]) {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            assignments.add(psa);
        }
        insert assignments;

        List<Resultado_da_avalia_o__c> resultado = new List<Resultado_da_avalia_o__c>();
        resultado = [SELECT Id FROM Resultado_da_avalia_o__c LIMIT 1];

        Test.startTest();

        System.runAs(u) {
            if(resultado != null){
            delete resultado;
            }
        }
        Test.stopTest();

        System.assertEquals(1, resultado.size());
    }

     @IsTest
    static void run_with_permissionless_user() {
        Resultado_da_avalia_o__c resultado = [SELECT Id FROM Resultado_da_avalia_o__c LIMIT 1];

        User u = new User(
            Alias = 'alias',
            Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8',
            LastName='Doh',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = UserInfo.getProfileId(),
            TimeZoneSidKey='America/Los_Angeles',
            UserName='user' + System.now().getTime() + '@testorg.com'
        );

        Test.startTest();
        System.runAs(u) {
            try {
                delete resultado;
                System.assert(false, '');
            } catch (Exception e) {
                System.assert(true, '');
            }
        }
        Test.stopTest();
    }

}