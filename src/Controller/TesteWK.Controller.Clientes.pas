unit TesteWK.Controller.Clientes;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.DApt,
  FireDac.Comp.DataSet,
  FireDac.Comp.Client,
  FireDAC.Stan.Param,
  Data.DB,
  TesteWK.Model.Clientes,
  TesteWK.Controller.Base;

type
  TClienteController = class(TControllerBase)
  private
    const
      cSQLGetClienteByCodigo : String = 'select codigo, nome, cidade, uf from clientes where codigo = :codigo';
      cSQLGetAllClientes : String = 'select codigo, nome, cidade, uf from clientes';
  public
    function GetClienteByCodigo(ACodigo : Integer) : TCliente;
    function GetAllClientes : TObjectList<TCliente>;
  end;

implementation

{ TClienteController }

function TClienteController.GetAllClientes: TObjectList<TCliente>;
var
  Cliente : TCliente;
begin
  Result := TObjectList<TCliente>.Create;
  try
    QueryConsulta.Close;
    QueryConsulta.SQL.Clear;
    QueryConsulta.SQL.Add(cSQLGetAllClientes);
    QueryConsulta.Open;

    QueryConsulta.First;
    while not QueryConsulta.Eof do begin
      Cliente := TCliente.Create;

      Cliente.Codigo := QueryConsulta.FieldByName('codigo').AsInteger;
      Cliente.Nome := QueryConsulta.FieldByName('nome').AsString;
      Cliente.Cidade := QueryConsulta.FieldByName('cidade').AsString;
      Cliente.UF := QueryConsulta.FieldByName('uf').AsString;

      Result.Add(Cliente);

      QueryConsulta.Next;
    end;

  except on E: Exception do
    Result := nil;
  end;
end;

function TClienteController.GetClienteByCodigo(ACodigo: Integer): TCliente;
begin
  Result := TCliente.Create;
  try
    if not ConnectionConsulta.Connected then
      ConnectionConsulta.Connected := True;

    QueryConsulta.Close;
    QueryConsulta.SQL.Clear;
    QueryConsulta.SQL.Add(cSQLGetClienteByCodigo);
    QueryConsulta.ParamByName('codigo').AsInteger := ACodigo;
    QueryConsulta.Open;

    if not QueryConsulta.IsEmpty then begin
      Result.Codigo := QueryConsulta.FieldByName('codigo').AsInteger;
      Result.Nome := QueryConsulta.FieldByName('nome').AsString;
      Result.Cidade := QueryConsulta.FieldByName('cidade').AsString;
      Result.UF := QueryConsulta.FieldByName('uf').AsString;
    end;

  except on E: Exception do
    Result := nil;
  end;
end;

end.
