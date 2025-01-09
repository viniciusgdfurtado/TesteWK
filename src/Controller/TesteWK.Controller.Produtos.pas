unit TesteWK.Controller.Produtos;

interface
uses
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.DApt,
  FireDac.Comp.DataSet,
  FireDac.Comp.Client,
  FireDAC.Stan.Param,
  Data.DB,
  TesteWK.Model.Produtos,
  TesteWK.Controller.Base;

type
  TProdutoController = class(TControllerBase)
  private
    const
      cSQLGetProdutoByCodigo : String = 'select codigo, descricao, preco_venda from produtos where codigo = :codigo';
      cSQLGetAllProdutos : String = 'select codigo, descricao, preco_venda from produtos';
  public
    function GetProdutoByCodigo(ACodigo : Integer) : TProduto;
    function GetAllProdutos : TObjectList<TProduto>;
  end;

implementation

{ TProdutoController }

function TProdutoController.GetAllProdutos: TObjectList<TProduto>;
var
  Produto : TProduto;
begin
  Result := TObjectList<TProduto>.Create;
  try
    QueryConsulta.Close;
    QueryConsulta.SQL.Clear;
    QueryConsulta.SQL.Add(cSQLGetAllProdutos);
    QueryConsulta.Open;

    QueryConsulta.First;
    while not QueryConsulta.Eof do begin
      Produto := TProduto.Create;

      Produto.Codigo := QueryConsulta.FieldByName('codigo').AsInteger;
      Produto.Descricao := QueryConsulta.FieldByName('descricao').AsString;
      Produto.PrecoVenda := QueryConsulta.FieldByName('preco_venda').AsCurrency;

      Result.Add(Produto);

      QueryConsulta.Next;
    end;

  except on E: Exception do
    Result := nil;
  end;
end;

function TProdutoController.GetProdutoByCodigo(ACodigo: Integer): TProduto;
begin
  Result := TProduto.Create;
  try
    if not ConnectionConsulta.Connected then
      ConnectionConsulta.Connected := True;

    QueryConsulta.Close;
    QueryConsulta.SQL.Clear;
    QueryConsulta.SQL.Add(cSQLGetProdutoByCodigo);
    QueryConsulta.ParamByName('codigo').AsInteger := ACodigo;
    QueryConsulta.Open;

    if not QueryConsulta.IsEmpty then begin
      Result.Codigo := QueryConsulta.FieldByName('codigo').AsInteger;
      Result.Descricao := QueryConsulta.FieldByName('descricao').AsString;
      Result.PrecoVenda := QueryConsulta.FieldByName('preco_venda').AsCurrency;
    end;

  except on E: Exception do
    Result := nil;
  end;
end;

end.
