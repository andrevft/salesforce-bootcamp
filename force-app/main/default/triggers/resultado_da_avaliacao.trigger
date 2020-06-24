trigger resultado_da_avaliacao on Resultado_da_avalia_o__c (before insert, before delete) {
  
    if(Trigger.isDelete){
       
        Boolean temPermissaoDeletar = PermissionHandler.temPermissaoGerente();

        if(!tempermissaoDeletar){
             for(Resultado_da_avalia_o__c r : Trigger.Old){
                r.addError( 'Usuário sem permissão para excluir o registro. ');
        
             }
         }
    }
        
    
        
    if(Trigger.isInsert){

        // criação do mapa de avaliação

        Set<Id> ResultIds = new Set<Id>();

        for(Resultado_da_avalia_o__c resultAvaliacao : Trigger.New){
             ResultIds.add(resultAvaliacao.Avalia_o__c);
        }

        Map<Id, Avalia_o__c> avaliacoesExistentes = new Map<Id, Avalia_o__c>([Select Id, Name, Total_de_pontos__c from Avalia_o__c where Id in : ResultIds]);
        

        // utilização do mapa 
        
        for(Resultado_da_avalia_o__c resultAvaliacao : Trigger.New){
             Decimal pontosMaxAvaliacao = avaliacoesExistentes.get(resultAvaliacao.Avalia_o__c).Total_de_pontos__c;
        
            if(resultAvaliacao.Nota__c > pontosMaxAvaliacao){
                resultAvaliacao.addError('A nota não pode ser maior que o valor da Avaliação, por favor coloque um valor válido.');
        
            }
        }
    }
        
}