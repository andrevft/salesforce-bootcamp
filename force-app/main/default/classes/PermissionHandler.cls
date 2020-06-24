public class PermissionHandler { 
	public static Boolean temPermissaoEspecifica(String nomePermissao){
    	return FeatureManagement.checkPermission(nomePermissao); 
} 
    public static Boolean temPermissaoGerente(){ 
        return FeatureManagement.checkPermission('deleteResultadoAvaliacao'); 
} 
    
}