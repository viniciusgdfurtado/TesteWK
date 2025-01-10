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

resourcestring
  msFalhaAoRecuperarClienteCodigo = 'Ocorreu um erro ao recuperar o cliente %s, por favor tente novamente.';
  msClienteInexistente = 'Não encontramos o registro do cliente %s, por favor tente novamente ou informe um novo código.';
  msNenhumClienteNaBase = 'Não há registros de cliente para exibição.';

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
begin
  Result := nil;
  try

    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(cSQLGetAllClientes);
    QueryController.Open;

    if QueryController.IsEmpty then
      raise Exception.Create(msNenhumClienteNaBase);

    Result := TObjectList<TCliente>.Create;

    QueryController.First;
    while not QueryController.Eof do begin

      var Cliente := TCliente.Create;
      Cliente.Codigo := QueryController.FieldByName('codigo').AsInteger;
      Cliente.Nome := QueryController.FieldByName('nome').AsString;
      Cliente.Cidade := QueryController.FieldByName('cidade').AsString;
      Cliente.UF := QueryController.FieldByName('uf').AsString;
      Result.Add(Cliente);

      QueryController.Next;
    end;

  except on E: Exception do
    raise;
  end;
end;

function TClienteController.GetClienteByCodigo(ACodigo: Integer): TCliente;
begin
  Result := nil;
  try
    if ACodigo <= 0 then
      raise Exception.Create(Format(msFalhaAoRecuperarClienteCodigo, [ACodigo.ToString]));

    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(cSQLGetClienteByCodigo);
    QueryController.ParamByName('codigo').AsInteger := ACodigo;
    QueryController.Open;

    if QueryController.IsEmpty then
      raise Exception.Create(Format(msClienteInexistente, [ACodigo.ToString]));

    Result := TCliente.Create;
    Result.Codigo := QueryController.FieldByName('codigo').AsInteger;
    Result.Nome := QueryController.FieldByName('nome').AsString;
    Result.Cidade := QueryController.FieldByName('cidade').AsString;
    Result.UF := QueryController.FieldByName('uf').AsString;

  except on E: Exception do
    raise;
  end;
end;

end.
