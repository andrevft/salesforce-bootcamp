// Controller para a página de geração de certificados.
public with sharing class GerarCertificadoController {

    private final CertificadoConclusao__c certificate;

    public GerarCertificadoController(ApexPages.StandardController stdController) {
        this.certificate = (CertificadoConclusao__c) stdController.getRecord();
    }

    public CertificadoConclusao__c getCertificate() {
        return this.certificate;
    }

    // Override no método padrão de salvar o registro
    public PageReference save() {

        // Verificamos se o certificado tem o curso informado.
        if (this.certificate.Product__c == null) {
        // Se não tiver, adicionamos um erro na página para o usuário corrigir as informações
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'É necessário informar o curso! '));
        // E não retornamos uma referência de página válida. O "null" fará com que à página
        // seja simplesmente recarregada.
        return null;
        }
        // Inserimos o certificado no banco de dados
        insert this.certificate;
        // Criamos a referência para a página de registro do certificado criado
        // uma vez que agora temos seu identificador.
        PageReference pr = new PageReference('/' + this.certificate.Id);


        // mandamos a referência de página fazer um redirecionamento do lado de cliente
        // ao invês ce usar umbredirecionamento server -side
        pr.setRedirect(true);

        return pr;

    }

}
