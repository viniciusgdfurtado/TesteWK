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

resourcestring
  msFalhaAoRecuperarProdutoCodigo = 'Ocorreu um erro ao recuperar o produto %s, por favor tente novamente.';
  msProdutoInexistente = 'Não encontramos o registro do produto %s, por favor tente novamente ou informe um novo código.';
  msNenhumProdutoNaBase = 'Não há registros de produtos para exibição.';

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
begin
  Result := nil;
  try

    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(cSQLGetAllProdutos);
    QueryController.Open;

    if QueryController.IsEmpty then
      raise Exception.Create(msNenhumProdutoNaBase);

    Result := TObjectList<TProduto>.Create;

    QueryController.First;
    while not QueryController.Eof do begin

      var Produto := TProduto.Create;
      Produto.Codigo := QueryController.FieldByName('codigo').AsInteger;
      Produto.Descricao := QueryController.FieldByName('descricao').AsString;
      Produto.PrecoVenda := QueryController.FieldByName('preco_venda').AsCurrency;
      Result.Add(Produto);

      QueryController.Next;
    end;

  except on E: Exception do
    raise;
  end;
end;

function TProdutoController.GetProdutoByCodigo(ACodigo: Integer): TProduto;
begin
  Result := nil;
  try
    if ACodigo <= 0 then
      raise Exception.Create(Format(msFalhaAoRecuperarProdutoCodigo, [ACodigo.ToString]));

    QueryController.Close;
    QueryController.SQL.Clear;
    QueryController.SQL.Add(cSQLGetProdutoByCodigo);
    QueryController.ParamByName('codigo').AsInteger := ACodigo;
    QueryController.Open;

    if QueryController.IsEmpty then
      raise Exception.Create(msProdutoInexistente);

    Result := TProduto.Create;
    Result.Codigo := QueryController.FieldByName('codigo').AsInteger;
    Result.Descricao := QueryController.FieldByName('descricao').AsString;
    Result.PrecoVenda := QueryController.FieldByName('preco_venda').AsCurrency;

  except on E: Exception do
    raise;
  end;
end;

end.
