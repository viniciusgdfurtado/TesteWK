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
    FQueryConsulta: TFDQuery;
    FConnectionConsulta: TFDConnection;
    FIniConnection : TIniFile;
    FDriverLink : TFDPhysMySQLDriverLink;
    FWaitCursor : TFDGUIxWaitCursor;
  public
    property QueryConsulta: TFDQuery read FQueryConsulta write FQueryConsulta;
    property ConnectionConsulta: TFDConnection read FConnectionConsulta write FConnectionConsulta;
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
begin

  lCaminhoIni := ExtractFilePath(ParamStr(0)) + 'config.ini';

  FIniConnection := TIniFile.Create(lCaminhoIni);
  if Assigned(FIniConnection) then begin
    lServer :=  FIniConnection.ReadString('Database', 'Server', '127.0.0.1');
    lPort := FIniConnection.ReadString('Database', 'Port', '3306');
    lDataBase := FIniConnection.ReadString('Database', 'Database', 'wk');
    lUserName := FIniConnection.ReadString('Database', 'Username', 'root');
    lPassword := FIniConnection.ReadString('Database', 'Password', '44980366899@');
  end;

  FDriverLink := TFDPhysMySQLDriverLink.Create(nil);
  FDriverLink.VendorLib := 'libmysql.dll';
  FDriverLink.VendorHome := ExtractFilePath(ParamStr(0));

  FWaitCursor := TFDGUIxWaitCursor.Create(nil);

  FConnectionConsulta := TFDConnection.Create(nil);
  try
    FConnectionConsulta.Params.DriverID := 'MySQL';
    FConnectionConsulta.Params.Add('Server=' + lServer);
    FConnectionConsulta.Params.Add('Port=' + lPort);
    FConnectionConsulta.Params.Database := lDataBase;
    FConnectionConsulta.Params.UserName := lUserName;
    FConnectionConsulta.Params.Password := lPassword;
  except on E: Exception do
    raise Exception.Create(Format(msErroConexao, [lCaminhoIni]));
  end;

  FQueryConsulta := TFDQuery.Create(FConnectionConsulta);
  FQueryConsulta.Connection := FConnectionConsulta;

end;

destructor TControllerBase.Destroy;
begin
  if Assigned(QueryConsulta) then begin
    if QueryConsulta.Active then
      QueryConsulta.Close;

    FreeAndNil(FQueryConsulta);
  end;

  if Assigned(FConnectionConsulta) then begin
    if FConnectionConsulta.Connected then
      FConnectionConsulta.Close;

    FreeAndNil(FConnectionConsulta);
  end;

  if Assigned(FIniConnection) then
    FreeAndNil(FIniConnection);

  inherited;
end;

end.
