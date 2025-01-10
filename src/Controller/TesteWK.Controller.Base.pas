unit TesteWK.Controller.Base;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  System.IniFiles,
  FireDAC.DApt,
  FireDac.Comp.DataSet,
  FireDac.Comp.Client,
  FireDAC.Stan.Param,
  FireDac.Stan.Def,
  FireDac.Stan.Async,
  FireDac.Phys.MySQL,
  FireDac.Phys.MySQLDef,
  FireDAC.VCLUI.Wait,
  FireDAc.Comp.UI,
  Data.DB;

resourcestring
  msErroConexao = 'Falha ao configurar e se conectar ao Db, verifique o arquivo de configuração: %s';

type
  TControllerBase = class
  private
    FQueryController: TFDQuery;
    FConnectionController: TFDConnection;
    FIniConnection : TIniFile;
    FDriverLink : TFDPhysMySQLDriverLink;
    FWaitCursor : TFDGUIxWaitCursor;
  public
    property QueryController: TFDQuery read FQueryController write FQueryController;
    property ConnectionController: TFDConnection read FConnectionController write FConnectionController;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TControllerBase }

constructor TControllerBase.Create;
var
  lCaminhoIni : String;
  lServer : String;
  lPort : String;
  lDataBase : String;
  lUserName : String;
  lPassword : String;
  lVendorLib : String;
begin
  lCaminhoIni := ExtractFilePath(ParamStr(0)) + 'config.ini';

  FIniConnection := TIniFile.Create(lCaminhoIni);
  if Assigned(FIniConnection) then begin
    lServer :=  FIniConnection.ReadString('Database', 'Server', '127.0.0.1');
    lPort := FIniConnection.ReadString('Database', 'Port', '3306');
    lDataBase := FIniConnection.ReadString('Database', 'Database', 'wk');
    lUserName := FIniConnection.ReadString('Database', 'Username', 'root');
    lPassword := FIniConnection.ReadString('Database', 'Password', '44980366899@');
    lVendorLib := FIniConnection.ReadString('Database', 'VendorLib', ExtractFilePath(ParamStr(0)) +  'lib\libmysql.dll');
    FIniConnection.UpdateFile;
  end;

  FDriverLink := TFDPhysMySQLDriverLink.Create(nil);
  FDriverLink.VendorLib := lVendorLib;

  FWaitCursor := TFDGUIxWaitCursor.Create(nil);

  FConnectionController := TFDConnection.Create(nil);
  try
    FConnectionController.Params.DriverID := 'MySQL';
    FConnectionController.Params.Add('Server=' + lServer);
    FConnectionController.Params.Add('Port=' + lPort);
    FConnectionController.Params.Database := lDataBase;
    FConnectionController.Params.UserName := lUserName;
    FConnectionController.Params.Password := lPassword;
  except on E: Exception do
    raise Exception.Create(Format(msErroConexao, [lCaminhoIni]));
  end;

  FQueryController := TFDQuery.Create(FConnectionController);
  FQueryController.Connection := FConnectionController;

end;

destructor TControllerBase.Destroy;
begin
  if Assigned(FQueryController) then begin
    if FQueryController.Active then
      FQueryController.Close;

    FreeAndNil(FQueryController);
  end;

  if Assigned(FConnectionController) then begin
    if FConnectionController.Connected then
      FConnectionController.Close;

    FreeAndNil(FConnectionController);
  end;

  if Assigned(FIniConnection) then
    FreeAndNil(FIniConnection);

  inherited;
end;

end.
